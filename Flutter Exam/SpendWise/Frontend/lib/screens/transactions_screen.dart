import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../widgets/transaction_tile.dart';
import 'add_expense_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final grouped = _groupByDate(provider.filteredExpenses);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Transactions'),
            actions: [
              // Sort
              PopupMenuButton<SortType>(
                icon: const Icon(Icons.sort_rounded),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onSelected: provider.setSort,
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: SortType.dateDesc,
                    child: Text('Date (newest)'),
                  ),
                  const PopupMenuItem(
                    value: SortType.dateAsc,
                    child: Text('Date (oldest)'),
                  ),
                  const PopupMenuItem(
                    value: SortType.amountDesc,
                    child: Text('Amount (high→low)'),
                  ),
                  const PopupMenuItem(
                    value: SortType.amountAsc,
                    child: Text('Amount (low→high)'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // ── Search + Filter ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: provider.setSearch,
                      decoration: InputDecoration(
                        hintText: 'Search transactions…',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: provider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.setSearch('');
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            selected: provider.filterType == FilterType.all,
                            onTap: () => provider.setFilter(FilterType.all),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Income',
                            selected: provider.filterType == FilterType.income,
                            color: AppTheme.incomeColor,
                            onTap: () => provider.setFilter(FilterType.income),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Expense',
                            selected: provider.filterType == FilterType.expense,
                            color: AppTheme.expenseColor,
                            onTap: () => provider.setFilter(FilterType.expense),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Summary strip ─────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.12),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StripStat(
                      label: 'Transactions',
                      value: '${provider.filteredExpenses.length}',
                    ),
                    _StripStat(
                      label: 'Total Spent',
                      value: '₹${NumberFormat('#,##0').format(provider.monthlyExpense)}',
                    ),
                    _StripStat(
                      label: 'Total Earned',
                      value: '₹${NumberFormat('#,##0').format(provider.monthlyIncome)}',
                    ),
                  ],
                ),
              ),

              // ── Transaction list ──────────────────────────────────────────
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : grouped.isEmpty
                        ? _EmptyTransactions()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: grouped.length,
                            itemBuilder: (context, index) {
                              final section = grouped[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      section['label'] as String,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  ...(section['items'] as List<Expense>).map(
                                    (e) => TransactionTile(
                                      expense: e,
                                      onDelete: () =>
                                          provider.deleteExpense(e.id!),
                                      onTap: () => _openEdit(context, e),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openAdd(context),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _groupByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> map = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final e in expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      final String label;
      if (day == today) {
        label = 'Today';
      } else if (day == yesterday) {
        label = 'Yesterday';
      } else {
        label = DateFormat('EEEE, MMM d').format(day);
      }
      map.putIfAbsent(label, () => []).add(e);
    }

    return map.entries
        .map((e) => {'label': e.key, 'items': e.value})
        .toList();
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseScreen(),
    );
  }

  void _openEdit(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExpenseScreen(expenseToEdit: expense),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppTheme.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor : activeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : activeColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _StripStat extends StatelessWidget {
  final String label;
  final String value;
  const _StripStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11),
        ),
      ],
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filter or add a new entry',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
          ),
        ],
      ),
    );
  }
}
