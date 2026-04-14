import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'SpendWise';

  // ---------- Category definitions ----------
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Food & Dining', 'icon': Icons.restaurant_rounded, 'color': 0xFFFF6B6B},
    {'name': 'Transportation', 'icon': Icons.directions_car_rounded, 'color': 0xFF4ECDC4},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_rounded, 'color': 0xFF45B7D1},
    {'name': 'Entertainment', 'icon': Icons.movie_rounded, 'color': 0xFFB39DDB},
    {'name': 'Health', 'icon': Icons.favorite_rounded, 'color': 0xFF81C784},
    {'name': 'Bills & Utilities', 'icon': Icons.receipt_long_rounded, 'color': 0xFFFFB74D},
    {'name': 'Education', 'icon': Icons.school_rounded, 'color': 0xFF4FC3F7},
    {'name': 'Travel', 'icon': Icons.flight_rounded, 'color': 0xFF9575CD},
    {'name': 'Salary', 'icon': Icons.account_balance_wallet_rounded, 'color': 0xFF66BB6A},
    {'name': 'Freelance', 'icon': Icons.work_rounded, 'color': 0xFF26A69A},
    {'name': 'Investment', 'icon': Icons.trending_up_rounded, 'color': 0xFF42A5F5},
    {'name': 'Others', 'icon': Icons.category_rounded, 'color': 0xFF90A4AE},
  ];

  static Color getCategoryColor(String category) {
    final cat = categories.firstWhere(
      (c) => c['name'] == category,
      orElse: () => categories.last,
    );
    return Color(cat['color'] as int);
  }

  static IconData getCategoryIcon(String category) {
    final cat = categories.firstWhere(
      (c) => c['name'] == category,
      orElse: () => categories.last,
    );
    return cat['icon'] as IconData;
  }

  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Health',
    'Bills & Utilities',
    'Education',
    'Travel',
    'Others',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Others',
  ];

  // Gradient pairs (start, end) — OlympTrade neon green + black palette
  static const List<List<Color>> cardGradients = [
    [Color(0xFF34FF29), Color(0xFF1A8A16)],
    [Color(0xFF1A1A1A), Color(0xFF2C2C2C)],
    [Color(0xFFFF4444), Color(0xFFCC2222)],
    [Color(0xFF00E5FF), Color(0xFF0077AA)],
  ];
}
