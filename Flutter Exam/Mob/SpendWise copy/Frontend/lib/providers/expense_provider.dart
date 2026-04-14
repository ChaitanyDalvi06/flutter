import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/expense.dart';

enum FilterType { all, income, expense }

enum SortType { dateDesc, dateAsc, amountDesc, amountAsc }

class ExpenseProvider extends ChangeNotifier {
  // ── State ────────────────────────────────────────────────────────────────────
  List<Expense> _allExpenses = [];
  bool _isLoading = false;
  FilterType _filterType = FilterType.all;
  SortType _sortType = SortType.dateDesc;
  String _searchQuery = '';
  DateTime _selectedMonth = DateTime.now();

  // ── Getters ──────────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  FilterType get filterType => _filterType;
  SortType get sortType => _sortType;
  String get searchQuery => _searchQuery;
  DateTime get selectedMonth => _selectedMonth;

  List<Expense> get allExpenses => _allExpenses;

  List<Expense> get filteredExpenses {
    var list = _allExpenses.where((e) {
      // filter by month
      final sameMonth = e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month;
      if (!sameMonth) return false;
      // filter by type
      if (_filterType == FilterType.expense && e.type != 'expense') return false;
      if (_filterType == FilterType.income && e.type != 'income') return false;
      // search
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return e.title.toLowerCase().contains(q) ||
            e.category.toLowerCase().contains(q) ||
            (e.notes?.toLowerCase().contains(q) ?? false);
      }
      return true;
    }).toList();

    switch (_sortType) {
      case SortType.dateDesc:
        list.sort((a, b) => b.date.compareTo(a.date));
      case SortType.dateAsc:
        list.sort((a, b) => a.date.compareTo(b.date));
      case SortType.amountDesc:
        list.sort((a, b) => b.amount.compareTo(a.amount));
      case SortType.amountAsc:
        list.sort((a, b) => a.amount.compareTo(b.amount));
    }
    return list;
  }

  /// Recent 5 expense/income entries across all months (for dashboard).
  List<Expense> get recentExpenses {
    final sorted = [..._allExpenses]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  // ── Monthly aggregates ───────────────────────────────────────────────────────
  double get monthlyIncome => _allExpenses
      .where((e) =>
          e.type == 'income' &&
          e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month)
      .fold(0.0, (s, e) => s + e.amount);

  double get monthlyExpense => _allExpenses
      .where((e) =>
          e.type == 'expense' &&
          e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month)
      .fold(0.0, (s, e) => s + e.amount);

  double get monthlyBalance => monthlyIncome - monthlyExpense;

  double get totalIncome => _allExpenses
      .where((e) => e.type == 'income')
      .fold(0.0, (s, e) => s + e.amount);

  double get totalExpense => _allExpenses
      .where((e) => e.type == 'expense')
      .fold(0.0, (s, e) => s + e.amount);

  /// Category totals for the selected month (expenses only).
  Map<String, double> get monthlyCategoryTotals {
    final map = <String, double>{};
    for (final e in filteredExpenses.where((e) => e.type == 'expense')) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  /// Last 6 months data for bar/line charts.
  List<Map<String, dynamic>> get last6MonthsData {
    final result = <Map<String, dynamic>>[];
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final income = _allExpenses
          .where((e) =>
              e.type == 'income' &&
              e.date.year == month.year &&
              e.date.month == month.month)
          .fold(0.0, (s, e) => s + e.amount);
      final expense = _allExpenses
          .where((e) =>
              e.type == 'expense' &&
              e.date.year == month.year &&
              e.date.month == month.month)
          .fold(0.0, (s, e) => s + e.amount);
      result.add({'month': month, 'income': income, 'expense': expense});
    }
    return result;
  }

  // ── DB Operations ────────────────────────────────────────────────────────────
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allExpenses = await DatabaseHelper.getAll();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseHelper.insert(expense);
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseHelper.update(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.delete(id);
    await loadExpenses();
  }

  // ── UI State Mutations ───────────────────────────────────────────────────────
  void setFilter(FilterType type) {
    _filterType = type;
    notifyListeners();
  }

  void setSort(SortType type) {
    _sortType = type;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  // ── JSON Export ──────────────────────────────────────────────────────────────
  String exportToJson({DateTime? from, DateTime? to}) {
    final List<Expense> toExport;
    if (from != null && to != null) {
      toExport = _allExpenses
          .where((e) =>
              e.date.isAfter(from.subtract(const Duration(days: 1))) &&
              e.date.isBefore(to.add(const Duration(days: 1))))
          .toList();
    } else {
      toExport = _allExpenses;
    }

    final payload = {
      'exported_at': DateTime.now().toIso8601String(),
      'total_records': toExport.length,
      'summary': {
        'total_income':
            toExport.where((e) => e.type == 'income').fold(0.0, (s, e) => s + e.amount),
        'total_expense':
            toExport.where((e) => e.type == 'expense').fold(0.0, (s, e) => s + e.amount),
      },
      'expenses': toExport.map((e) => e.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }
}
