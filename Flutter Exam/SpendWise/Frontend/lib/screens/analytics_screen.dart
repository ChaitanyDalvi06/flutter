import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/expense_provider.dart';
import '../widgets/chart_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final monthlyData = provider.last6MonthsData;
        final categoryTotals = provider.monthlyCategoryTotals;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Analytics'),
            bottom: TabBar(
              controller: _tabCtrl,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Categories'),
                Tab(text: 'Trends'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabCtrl,
            children: [
              // ── Overview Tab ────────────────────────────────────────────
              _OverviewTab(provider: provider, monthlyData: monthlyData),

              // ── Categories Tab ──────────────────────────────────────────
              _CategoriesTab(categoryTotals: categoryTotals, provider: provider),

              // ── Trends Tab ──────────────────────────────────────────────
              _TrendsTab(monthlyData: monthlyData),
            ],
          ),
        );
      },
    );
  }
}

// ── Overview Tab ──────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final ExpenseProvider provider;
  final List<Map<String, dynamic>> monthlyData;

  const _OverviewTab({required this.provider, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;
    final savings = totalIncome - totalExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All-time summary cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'All-time Income',
                  value: '₹${NumberFormat('#,##0').format(totalIncome)}',
                  color: AppTheme.incomeColor,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'All-time Spent',
                  value: '₹${NumberFormat('#,##0').format(totalExpense)}',
                  color: AppTheme.expenseColor,
                  icon: Icons.trending_down_rounded,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Net Savings',
            value: '${savings >= 0 ? '+' : ''}₹${NumberFormat('#,##0.00').format(savings)}',
            color: savings >= 0 ? AppTheme.primaryColor : AppTheme.expenseColor,
            icon: Icons.savings_rounded,
            fullWidth: true,
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 28),

          Text(
            '6-Month Bar Chart',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Income vs Expenses per month',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            child: Column(
              children: [
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Legend(color: AppTheme.incomeColor, label: 'Income'),
                    const SizedBox(width: 16),
                    _Legend(color: AppTheme.expenseColor, label: 'Expense'),
                  ],
                ),
                const SizedBox(height: 16),
                MonthlyBarChart(monthlyData: monthlyData),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}

// ── Categories Tab ────────────────────────────────────────────────────────────

class _CategoriesTab extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final ExpenseProvider provider;

  const _CategoriesTab({required this.categoryTotals, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalExpense = provider.monthlyExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart
          Text(
            'Expense Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Category distribution for ${DateFormat('MMMM yyyy').format(provider.selectedMonth)}',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            child: ExpensePieChart(categoryTotals: categoryTotals),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          Text(
            'Category Progress',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            child: CategoryProgressList(
              categoryTotals: categoryTotals,
              maxItems: 10,
            ),
          ).animate().fadeIn(delay: 200.ms),

          if (categoryTotals.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Category Details',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...categoryTotals.entries.map((entry) {
              final pct = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;
              return _CategoryDetailRow(
                name: entry.key,
                amount: entry.value,
                percentage: pct.toDouble(),
              );
            }),
          ],
        ],
      ),
    );
  }
}

// ── Trends Tab ────────────────────────────────────────────────────────────────

class _TrendsTab extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  const _TrendsTab({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Compute month-over-month change
    double? incomeChange;
    double? expenseChange;
    if (monthlyData.length >= 2) {
      final prev = monthlyData[monthlyData.length - 2];
      final curr = monthlyData[monthlyData.length - 1];
      final prevInc = prev['income'] as double;
      final currInc = curr['income'] as double;
      final prevExp = prev['expense'] as double;
      final currExp = curr['expense'] as double;
      incomeChange = prevInc > 0 ? ((currInc - prevInc) / prevInc * 100) : null;
      expenseChange = prevExp > 0 ? ((currExp - prevExp) / prevExp * 100) : null;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month-over-month change cards
          if (incomeChange != null || expenseChange != null)
            Row(
              children: [
                if (incomeChange != null)
                  Expanded(
                    child: _ChangeCard(
                      label: 'Income MoM',
                      change: incomeChange,
                      positive: incomeChange >= 0,
                    ),
                  ),
                if (incomeChange != null && expenseChange != null)
                  const SizedBox(width: 12),
                if (expenseChange != null)
                  Expanded(
                    child: _ChangeCard(
                      label: 'Expense MoM',
                      change: expenseChange,
                      // For expenses, lower is better (positive outcome when negative change)
                      positive: expenseChange <= 0,
                    ),
                  ),
              ],
            ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),
          Text(
            'Spending Trend',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Income vs Expenses over 6 months',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Legend(color: AppTheme.incomeColor, label: 'Income'),
                    const SizedBox(width: 16),
                    _Legend(color: AppTheme.expenseColor, label: 'Expense'),
                  ],
                ),
                const SizedBox(height: 16),
                SpendingLineChart(monthlyData: monthlyData),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 24),
          Text(
            'Monthly Summary Table',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _ChartCard(
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                  ),
                  children: ['Month', 'Income', 'Expense', 'Net']
                      .map(
                        (h) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            h,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                ...monthlyData.map((d) {
                  final inc = d['income'] as double;
                  final exp = d['expense'] as double;
                  final net = inc - exp;
                  return TableRow(
                    children: [
                      _TableCell(
                        text: DateFormat('MMM yy').format(d['month'] as DateTime),
                      ),
                      _TableCell(
                        text: '₹${NumberFormat('#,##0').format(inc)}',
                        color: AppTheme.incomeColor,
                      ),
                      _TableCell(
                        text: '₹${NumberFormat('#,##0').format(exp)}',
                        color: AppTheme.expenseColor,
                      ),
                      _TableCell(
                        text: '${net >= 0 ? '+' : ''}₹${NumberFormat('#,##0').format(net)}',
                        color: net >= 0 ? AppTheme.primaryColor : AppTheme.expenseColor,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final bool fullWidth;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChangeCard extends StatelessWidget {
  final String label;
  final double change;
  final bool positive;

  const _ChangeCard({
    required this.label,
    required this.change,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppTheme.incomeColor : AppTheme.expenseColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                change >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '${change.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(
            'vs last month',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailRow extends StatelessWidget {
  final String name;
  final double amount;
  final double percentage;

  const _CategoryDetailRow({
    required this.name,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: theme.textTheme.bodyMedium),
          Row(
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '₹${NumberFormat('#,##0.00').format(amount)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.expenseColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final Color? color;
  const _TableCell({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: color != null ? FontWeight.w600 : null,
            ),
      ),
    );
  }
}
