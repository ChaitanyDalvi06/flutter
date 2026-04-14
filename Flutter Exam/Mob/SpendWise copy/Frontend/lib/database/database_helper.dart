import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

import '../core/config.dart';

/// All data is persisted via the Node.js / Supabase backend.
/// Change [AppConfig.baseUrl] in lib/core/config.dart to point to your server.
class DatabaseHelper {
  static String get _baseUrl => '${AppConfig.baseUrl}/expenses';

  // ── Auth token (set after login via AuthProvider) ─────────────────────────
  static String? _token;
  static void setToken(String? token) => _token = token;

  // ── No-op lifecycle methods (kept for API compatibility) ──────────────────
  static Future<void> init() async {}
  static Future<void> close() async {}

  // ── Helper ────────────────────────────────────────────────────────────────
  static Uri _uri(String path, [Map<String, String>? params]) {
    final base = Uri.parse('$_baseUrl$path');
    return params != null ? base.replace(queryParameters: params) : base;
  }

  // Headers always include Content-Type; Authorization added when logged in.
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

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
    final response = await http.delete(_uri('/$id'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Delete failed (${response.statusCode}): ${response.body}');
    }
    return 1;
  }

  // ── Queries ───────────────────────────────────────────────────────────────

  static Future<List<Expense>> getAll() async {
    final response = await http.get(_uri(''), headers: _headers);
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
    }), headers: _headers);
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
    }), headers: _headers);
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
    final response = await http.get(_uri('/analytics/category-totals', params), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('getCategoryTotals failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getMonthlyTotals(int months) async {
    final response =
        await http.get(_uri('/analytics/monthly-totals', {'months': '$months'}), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('getMonthlyTotals failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getDailyTotals(int days) async {
    final response =
        await http.get(_uri('/analytics/daily-totals', {'days': '$days'}), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('getDailyTotals failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<double> getTotalByType(String type) async {
    final response = await http.get(_uri('/total', {'type': type}), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('getTotalByType failed (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['total'] as num?)?.toDouble() ?? 0.0;
  }
}
