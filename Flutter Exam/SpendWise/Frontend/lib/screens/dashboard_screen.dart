// dashboard_screen.dart — replaced with new design
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'transactions_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DashboardScreen — redesigned to match the Dashboard screenshot
// ─────────────────────────────────────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showWeekly = true;
  final _fmt = NumberFormat('#,##0.00', 'en_IN');

  static const _green = Color(0xFF34FF29);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<ExpenseProvider>();

    final weeklySpots = _computeSpots(provider, days: 7);
    final monthlySpots = _computeSpots(provider, days: 30);
    final trendSpots = _showWeekly ? weeklySpots : monthlySpots;
    final trendTotal = trendSpots.fold(0.0, (s, sp) => s + sp.y);
    final pct = _percentageChange(provider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: RefreshIndicator(
        color: _green,
        backgroundColor: const Color(0xFF111111),
        onRefresh: provider.loadExpenses,
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Welcome back, ${auth.userName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.45),
                            ),
                          ),
                        ],
                      ),
                      _NotifButton(),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Total Balance Card ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _BalanceCard(
                  balance: provider.monthlyIncome - provider.monthlyExpense,
                  income: provider.monthlyIncome,
                  expense: provider.monthlyExpense,
                  pct: pct,
                  fmt: _fmt,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Spending Trend ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Spending Trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        _TogglePill(
                          showA: _showWeekly,
                          onToggle: () =>
                              setState(() => _showWeekly = !_showWeekly),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _TrendCard(
                      spots: trendSpots,
                      total: trendTotal,
                      showWeekly: _showWeekly,
                      fmt: _fmt,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Recent Transactions header ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TransactionsScreen()),
                      ),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          color: _green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // ── Transaction list ───────────────────────────────────────────────
            if (provider.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                        color: _green, strokeWidth: 2),
                  ),
                ),
              )
            else if (provider.recentExpenses.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _EmptyTransactions(),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final e = provider.recentExpenses[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                      child:
                          _TxnRow(expense: e, fmt: _fmt, provider: provider),
                    );
                  },
                  childCount: provider.recentExpenses.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }// dummy line intentionally blank

  List<FlSpot> _computeSpots(ExpenseProvider provider, {required int days}) {
    final now = DateTime.now();
    return List.generate(days, (i) {
      final day = now.subtract(Duration(days: days - 1 - i));
      final total = provider.allExpenses
          .where((e) =>
              e.type == 'expense' &&
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day)
          .fold(0.0, (s, e) => s + e.amount);
      return FlSpot(i.toDouble(), total);
    });
  }

  double _percentageChange(ExpenseProvider provider) {
    final now = DateTime.now();
    double sum(int year, int month) => provider.allExpenses
        .where((e) => e.date.year == year && e.date.month == month)
        .fold(0.0, (s, e) => e.type == 'income' ? s + e.amount : s - e.amount);
    final prev = DateTime(now.year, now.month - 1);
    final thisVal = sum(now.year, now.month);
    final lastVal = sum(prev.year, prev.month);
    if (lastVal == 0) return 0;
    return ((thisVal - lastVal) / lastVal.abs()) * 100;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Balance Card
// ─────────────────────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final double pct;
  final NumberFormat fmt;

  const _BalanceCard(
      {required this.balance,
      required this.income,
      required this.expense,
      required this.pct,
      required this.fmt});

  @override
  Widget build(BuildContext context) {
    final pos = pct >= 0;
    final pctColor = pos ? const Color(0xFF34FF29) : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF222222)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34FF29).withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '₹${fmt.format(balance)}',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF34FF29),
                    letterSpacing: -1,
                  ),
                ),
              ),
              if (pct != 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: pctColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pos
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: pctColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pos ? '+' : ''}${pct.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: pctColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF222222), height: 1),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatPair(
                  label: 'Income',
                  amount: '₹${fmt.format(income)}',
                  color: const Color(0xFF34FF29),
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
              Container(
                  width: 1, height: 36, color: const Color(0xFF2A2A2A)),
              Expanded(
                child: _StatPair(
                  label: 'Expenses',
                  amount: '₹${fmt.format(expense)}',
                  color: Colors.redAccent,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPair extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;
  const _StatPair(
      {required this.label,
      required this.amount,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withOpacity(0.4))),
          const SizedBox(height: 4),
          Text(amount,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle Pill
// ─────────────────────────────────────────────────────────────────────────────

class _TogglePill extends StatelessWidget {
  final bool showA;
  final VoidCallback onToggle;
  const _TogglePill({required this.showA, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Text(
          showA ? 'This Week' : 'This Month',
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Spending Trend Card
// ─────────────────────────────────────────────────────────────────────────────

class _TrendCard extends StatelessWidget {
  final List<FlSpot> spots;
  final double total;
  final bool showWeekly;
  final NumberFormat fmt;
  const _TrendCard(
      {required this.spots,
      required this.total,
      required this.showWeekly,
      required this.fmt});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final labels = showWeekly
        ? List.generate(
            7,
            (i) => DateFormat('E')
                .format(now.subtract(Duration(days: 6 - i)))
                .substring(0, 3))
        : <String>[];

    final maxY =
        spots.map((s) => s.y).fold(0.0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Spent',
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withOpacity(0.4))),
          const SizedBox(height: 4),
          Text(
            '₹${fmt.format(total)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 3 : 1,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.white.withOpacity(0.06),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: showWeekly,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox();
                        }
                        final isToday = idx == labels.length - 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[idx],
                            style: TextStyle(
                              fontSize: 11,
                              color: isToday
                                  ? const Color(0xFF34FF29)
                                  : Colors.white38,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (spots.length - 1).toDouble(),
                minY: 0,
                maxY: maxY > 0 ? maxY * 1.25 : 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: const Color(0xFF34FF29),
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, _) => spot.y > 0,
                      getDotPainter: (_, __, ___, ____) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFF34FF29),
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF111111),
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF34FF29).withOpacity(0.22),
                          const Color(0xFF34FF29).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Transaction Row
// ─────────────────────────────────────────────────────────────────────────────

class _TxnRow extends StatelessWidget {
  final Expense expense;
  final NumberFormat fmt;
  final ExpenseProvider provider;
  const _TxnRow(
      {required this.expense, required this.fmt, required this.provider});

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.getCategoryColor(expense.category);
    final icon = AppConstants.getCategoryIcon(expense.category);
    final isIncome = expense.type == 'income';

    final now = DateTime.now();
    final diff = now.difference(expense.date);
    final timeLabel = diff.inDays == 0
        ? 'Today, ${DateFormat('HH:mm').format(expense.date)}'
        : diff.inDays == 1
            ? 'Yesterday'
            : DateFormat('MMM d').format(expense.date);

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddExpenseScreen(expenseToEdit: expense),
      ),
      onLongPress: () => provider.deleteExpense(expense.id!),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1E1E1E)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 3),
                  Text('${expense.category} • $timeLabel',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.4))),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}₹${fmt.format(expense.amount)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isIncome ? const Color(0xFF34FF29) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification button
// ─────────────────────────────────────────────────────────────────────────────

class _NotifButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: const Icon(Icons.notifications_outlined,
          color: Colors.white70, size: 20),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 44, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 12),
          Text('No transactions yet',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('Tap + to add your first entry',
              style: TextStyle(
                  fontSize: 13, color: Colors.white.withOpacity(0.25))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER stubs removed — old helpers below are deleted
// ─────────────────────────────────────────────────────────────────────────────

// End of dashboard_screen.dart
