import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

/// All data is persisted via the Node.js / MySQL backend.
/// Change [_baseUrl] to point to your server if it runs on a different host/port.
class DatabaseHelper {
  static const String _baseUrl = 'http://localhost:3000/api/expenses';

  // ── No-op lifecycle methods (kept for API compatibility) ──────────────────
  static Future<void> init() async {}
  static Future<void> close() async {}

  // ── Helper ────────────────────────────────────────────────────────────────
  static Uri _uri(String path, [Map<String, String>? params]) {
    final base = Uri.parse('$_baseUrl$path');
    return params != null ? base.replace(queryParameters: params) : base;
  }

  static const _headers = {'Content-Type': 'application/json'};

  // ── CRUD ──────────────────────────────────────────────────────────────────

  static Future<int> insert(Expense expense) async {
    final response = await http.post(
      _uri(''),
      headers: _headers,
      body: jsonEncode(expense.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Insert failed (${response.statusCode}): ${response.body}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['id'] as int;
  }

  static Future<int> update(Expense expense) async {
    final response = await http.put(
      _uri('/${expense.id}'),
      headers: _headers,
      body: jsonEncode(expense.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Update failed (${response.statusCode}): ${response.body}');
    }
    return 1;
  }

  static Future<int> delete(int id) async {
    final response = await http.delete(_uri('/$id'));
    if (response.statusCode != 200) {
      throw Exception('Delete failed (${response.statusCode}): ${response.body}');
    }
    return 1;
  }

  // ── Queries ───────────────────────────────────────────────────────────────

  static Future<List<Expense>> getAll() async {
    final response = await http.get(_uri(''));
    if (response.statusCode != 200) {
      throw Exception('getAll failed (${response.statusCode}): ${response.body}');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Expense.fromMap(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Expense>> getByMonth(int year, int month) async {
    final response = await http.get(_uri('', {
      'year': '$year',
      'month': '$month',
    }));
    if (response.statusCode != 200) {
      throw Exception('getByMonth failed (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Expense.fromMap(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Expense>> getByDateRange(DateTime from, DateTime to) async {
    final response = await http.get(_uri('', {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    }));
    if (response.statusCode != 200) {
      throw Exception('getByDateRange failed (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Expense.fromMap(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Map<String, dynamic>>> getCategoryTotals({
    required String type,
    DateTime? from,
    DateTime? to,
  }) async {
    final params = <String, String>{'type': type};
    if (from != null) params['from'] = from.toIso8601String();
    if (to != null) params['to'] = to.toIso8601String();
    final response = await http.get(_uri('/analytics/category-totals', params));
    if (response.statusCode != 200) {
      throw Exception('getCategoryTotals failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getMonthlyTotals(int months) async {
    final response =
        await http.get(_uri('/analytics/monthly-totals', {'months': '$months'}));
    if (response.statusCode != 200) {
      throw Exception('getMonthlyTotals failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getDailyTotals(int days) async {
    final response =
        await http.get(_uri('/analytics/daily-totals', {'days': '$days'}));
    if (response.statusCode != 200) {
      throw Exception('getDailyTotals failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<double> getTotalByType(String type) async {
    final response = await http.get(_uri('/total', {'type': type}));
    if (response.statusCode != 200) {
      throw Exception('getTotalByType failed (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['total'] as num?)?.toDouble() ?? 0.0;
  }
}
