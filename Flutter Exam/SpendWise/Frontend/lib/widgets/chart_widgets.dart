import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../core/theme.dart';

// ── Pie Chart ────────────────────────────────────────────────────────────────

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> categoryTotals;

  const ExpensePieChart({super.key, required this.categoryTotals});

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.categoryTotals.values.fold(0.0, (a, b) => a + b);

    if (total == 0) {
      return _EmptyChart(message: 'No expenses to display');
    }

    final entries = widget.categoryTotals.entries.toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    setState(() => _touchedIndex = -1);
                    return;
                  }
                  setState(() {
                    _touchedIndex = response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: List.generate(entries.length, (i) {
                final entry = entries[i];
                final color = AppConstants.getCategoryColor(entry.key);
                final isTouched = i == _touchedIndex;
                final percentage = (entry.value / total * 100);
                return PieChartSectionData(
                  color: color,
                  value: entry.value,
                  title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
                  radius: isTouched ? 80 : 65,
                  titleStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
              centerSpaceRadius: 50,
              sectionsSpace: 3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: entries.map((entry) {
            final color = AppConstants.getCategoryColor(entry.key);
            final pct = total > 0 ? (entry.value / total * 100) : 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  '${entry.key} (${pct.toStringAsFixed(0)}%)',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Bar Chart (Monthly) ──────────────────────────────────────────────────────

class MonthlyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;

  const MonthlyBarChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (monthlyData.isEmpty) {
      return _EmptyChart(message: 'No data available');
    }

    final maxValue = monthlyData.fold(
      0.0,
      (max, e) {
        final income = (e['income'] as double);
        final expense = (e['expense'] as double);
        final bigger = income > expense ? income : expense;
        return bigger > max ? bigger : max;
      },
    );

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue * 1.25,
          barGroups: List.generate(monthlyData.length, (i) {
            final d = monthlyData[i];
            return BarChartGroupData(
              x: i,
              groupVertically: false,
              barRods: [
                BarChartRodData(
                  toY: (d['income'] as double),
                  color: AppTheme.incomeColor,
                  width: 10,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
                BarChartRodData(
                  toY: (d['expense'] as double),
                  color: AppTheme.expenseColor,
                  width: 10,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, meta) => Text(
                  '₹${NumberFormat.compact().format(value)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= monthlyData.length) return const SizedBox();
                  final d = monthlyData[idx]['month'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('MMM').format(d),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) =>
                  isDark ? const Color(0xFF1E1E1E) : Colors.white,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = rodIndex == 0 ? 'Income' : 'Expense';
                return BarTooltipItem(
                  '$label\n₹${NumberFormat('#,##0.00').format(rod.toY)}',
                  TextStyle(
                    color: rod.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Line Chart (Daily trend) ─────────────────────────────────────────────────

class SpendingLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;

  const SpendingLineChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (monthlyData.isEmpty) {
      return _EmptyChart(message: 'No data available');
    }

    final expenseSpots = <FlSpot>[];
    final incomeSpots = <FlSpot>[];

    for (int i = 0; i < monthlyData.length; i++) {
      expenseSpots.add(FlSpot(i.toDouble(), (monthlyData[i]['expense'] as double)));
      incomeSpots.add(FlSpot(i.toDouble(), (monthlyData[i]['income'] as double)));
    }

    final maxY = monthlyData.fold(
          0.0,
          (max, e) {
            final v = (e['income'] as double) > (e['expense'] as double)
                ? (e['income'] as double)
                : (e['expense'] as double);
            return v > max ? v : max;
          },
        ) *
        1.25;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          maxY: maxY,
          minY: 0,
          lineBarsData: [
            _lineData(incomeSpots, AppTheme.incomeColor),
            _lineData(expenseSpots, AppTheme.expenseColor),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, meta) => Text(
                  '₹${NumberFormat.compact().format(value)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= monthlyData.length) return const SizedBox();
                  final d = monthlyData[idx]['month'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('MMM').format(d),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => isDark ? const Color(0xFF1E1E1E) : Colors.white,
              getTooltipItems: (spots) => spots.map((s) {
                final label = s.barIndex == 0 ? 'Income' : 'Expense';
                final color = s.barIndex == 0 ? AppTheme.incomeColor : AppTheme.expenseColor;
                return LineTooltipItem(
                  '$label\n₹${NumberFormat('#,##0.00').format(s.y)}',
                  TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  LineChartBarData _lineData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }
}

// ── Category Progress Bars ───────────────────────────────────────────────────

class CategoryProgressList extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final int maxItems;

  const CategoryProgressList({
    super.key,
    required this.categoryTotals,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    if (total == 0) {
      return _EmptyChart(message: 'No category data');
    }

    final entries = categoryTotals.entries.take(maxItems).toList();

    return Column(
      children: entries.map((entry) {
        final color = AppConstants.getCategoryColor(entry.key);
        final icon = AppConstants.getCategoryIcon(entry.key);
        final pct = entry.value / total;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '₹${NumberFormat('#,##0.00').format(entry.value)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: color.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyChart extends StatelessWidget {
  final String message;
  const _EmptyChart({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}
