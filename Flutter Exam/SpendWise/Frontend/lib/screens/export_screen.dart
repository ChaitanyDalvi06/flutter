import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme.dart';
import '../models/expense.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../services/pdf_bill_service.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isExporting = false;
  bool _isExportingPdf = false;
  String? _previewJson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final allExpenses = provider.allExpenses;
        final filtered = _getFiltered(allExpenses);
        final income =
            filtered.where((e) => e.type == 'income').fold(0.0, (s, e) => s + e.amount);
        final expense =
            filtered.where((e) => e.type == 'expense').fold(0.0, (s, e) => s + e.amount);

        return Scaffold(
          appBar: AppBar(title: const Text('Export Report')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Info banner ────────────────────────────────────────────
                _InfoBanner().animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // ── Date Range ─────────────────────────────────────────────
                Text(
                  'Date Range',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DateButton(
                        label: 'From',
                        date: _fromDate,
                        onTap: () => _pickDate(isFrom: true),
                        onClear:
                            _fromDate != null ? () => setState(() => _fromDate = null) : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateButton(
                        label: 'To',
                        date: _toDate,
                        onTap: () => _pickDate(isFrom: false),
                        onClear: _toDate != null ? () => setState(() => _toDate = null) : null,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 14),

                // Quick range chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickRangeChip(
                      label: 'This Month',
                      onTap: () {
                        final now = DateTime.now();
                        setState(() {
                          _fromDate = DateTime(now.year, now.month, 1);
                          _toDate = DateTime(now.year, now.month + 1, 0);
                        });
                      },
                    ),
                    _QuickRangeChip(
                      label: 'Last Month',
                      onTap: () {
                        final now = DateTime.now();
                        setState(() {
                          _fromDate = DateTime(now.year, now.month - 1, 1);
                          _toDate = DateTime(now.year, now.month, 0);
                        });
                      },
                    ),
                    _QuickRangeChip(
                      label: 'This Year',
                      onTap: () {
                        final now = DateTime.now();
                        setState(() {
                          _fromDate = DateTime(now.year, 1, 1);
                          _toDate = DateTime(now.year, 12, 31);
                        });
                      },
                    ),
                    _QuickRangeChip(
                      label: 'All Time',
                      onTap: () => setState(() {
                        _fromDate = null;
                        _toDate = null;
                      }),
                    ),
                  ],
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 24),

                // ── Summary preview ────────────────────────────────────────
                Text(
                  'Export Summary',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _SummaryCard(
                  totalRecords: filtered.length,
                  income: income,
                  expense: expense,
                  fromDate: _fromDate,
                  toDate: _toDate,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 24),

                // ── JSON Preview ───────────────────────────────────────────
                if (_previewJson != null) ...[
                  Row(
                    children: [
                      Text(
                        'JSON Preview',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => setState(() => _previewJson = null),
                        icon: const Icon(Icons.close_rounded, size: 16),
                        label: const Text('Hide'),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 240,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0A0A1A)
                          : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        _previewJson!.length > 2000
                            ? '${_previewJson!.substring(0, 2000)}\n…'
                            : _previewJson!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppTheme.incomeColor,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),
                ],

                // ── Action buttons ─────────────────────────────────────────
                // PDF Bill button (primary)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: filtered.isEmpty
                        ? null
                        : () => _downloadPdfBill(provider, filtered),
                    icon: _isExportingPdf
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ))
                        : const Icon(Icons.picture_as_pdf_rounded),
                    label: Text(
                        _isExportingPdf ? 'Generating Bill…' : 'Download PDF Bill'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ).animate().fadeIn(delay: 220.ms),

                const SizedBox(height: 12),

                // JSON export
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: filtered.isEmpty
                        ? null
                        : () => _exportAndShare(provider, filtered),
                    icon: _isExporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.share_rounded),
                    label: Text(_isExporting ? 'Exporting…' : 'Export & Share JSON'),
                  ),
                ).animate().fadeIn(delay: 250.ms),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: filtered.isEmpty
                        ? null
                        : () => setState(() {
                              _previewJson = provider.exportToJson(
                                from: _fromDate,
                                to: _toDate,
                              );
                            }),
                    icon: const Icon(Icons.preview_rounded),
                    label: const Text('Preview JSON'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: filtered.isEmpty
                        ? null
                        : () {
                            final json = provider.exportToJson(
                              from: _fromDate,
                              to: _toDate,
                            );
                            Clipboard.setData(ClipboardData(text: json));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('JSON copied to clipboard!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy JSON to Clipboard'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 350.ms),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Expense> _getFiltered(List<Expense> all) {
    if (_fromDate == null && _toDate == null) return all;
    return all.where((e) {
      if (_fromDate != null && e.date.isBefore(_fromDate!)) return false;
      if (_toDate != null) {
        final endOfDay =
            DateTime(_toDate!.year, _toDate!.month, _toDate!.day, 23, 59, 59);
        if (e.date.isAfter(endOfDay)) return false;
      }
      return true;
    }).toList();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial =
        isFrom ? (_fromDate ?? DateTime.now()) : (_toDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              Theme.of(ctx).colorScheme.copyWith(primary: AppTheme.primaryColor),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Future<void> _downloadPdfBill(
      ExpenseProvider provider, List<Expense> filtered) async {
    setState(() => _isExportingPdf = true);
    try {
      final userName = context.read<AuthProvider>().userName.isNotEmpty
          ? context.read<AuthProvider>().userName
          : 'User';
      final bytes = await PdfBillService.generateMonthlyBill(
        expenses: filtered,
        from: _fromDate,
        to: _toDate,
        userName: userName,
      );
      final now = DateTime.now();
      final filename =
          'SpendWise_Bill_${now.year}${now.month.toString().padLeft(2, '0')}.pdf';
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF generation failed: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExportingPdf = false);
    }
  }

  Future<void> _exportAndShare(
      ExpenseProvider provider, List<Expense> filtered) async {
    setState(() => _isExporting = true);
    try {
      final json = provider.exportToJson(from: _fromDate, to: _toDate);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filename = 'spendwise_export_$timestamp.json';

      if (kIsWeb) {
        await Clipboard.setData(ClipboardData(text: json));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('JSON copied to clipboard (web export)'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsString(json);
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/json')],
          subject: 'SpendWise Export – $timestamp',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, const Color(0xFF1A8A16)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Export your transactions as JSON. Use date filters to narrow your report.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: date != null
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: date != null ? AppTheme.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? DateFormat('d MMM yy').format(date!) : label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: date != null ? AppTheme.primaryColor : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child:
                    const Icon(Icons.close_rounded, size: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickRangeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickRangeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalRecords;
  final double income;
  final double expense;
  final DateTime? fromDate;
  final DateTime? toDate;

  const _SummaryCard({
    required this.totalRecords,
    required this.income,
    required this.expense,
    this.fromDate,
    this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final net = income - expense;

    String rangeText = 'All transactions';
    if (fromDate != null || toDate != null) {
      final from = fromDate != null ? DateFormat('d MMM yy').format(fromDate!) : 'Start';
      final to = toDate != null ? DateFormat('d MMM yy').format(toDate!) : 'Today';
      rangeText = '$from → $to';
    }

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.file_download_rounded,
                  size: 18, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                rangeText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryItem(
                label: 'Records',
                value: '$totalRecords',
                color: theme.colorScheme.onSurface,
              ),
              _SummaryItem(
                label: 'Income',
                value: '₹${NumberFormat('#,##0').format(income)}',
                color: AppTheme.incomeColor,
              ),
              _SummaryItem(
                label: 'Expense',
                value: '₹${NumberFormat('#,##0').format(expense)}',
                color: AppTheme.expenseColor,
              ),
              _SummaryItem(
                label: 'Net',
                value:
                    '${net >= 0 ? '+' : ''}₹${NumberFormat('#,##0').format(net)}',
                color: net >= 0 ? AppTheme.incomeColor : AppTheme.expenseColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
