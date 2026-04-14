import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/expense.dart';

class PdfBillService {
  // ── Brand colours ──────────────────────────────────────────────────────────
  static final _green = PdfColor.fromHex('#34FF29');
  static final _darkBg = PdfColor.fromHex('#0A0A0A');
  static final _cardBg = PdfColor.fromHex('#1A1A1A');
  static final _incomeClr = PdfColor.fromHex('#2ECC71');
  static final _expenseClr = PdfColor.fromHex('#E74C3C');
  static final _white = PdfColors.white;
  static final _grey = PdfColor.fromHex('#AAAAAA');
  static final _lightGrey = PdfColor.fromHex('#EEEEEE');

  static final _rupee = NumberFormat('₹#,##,##0.00', 'en_IN');
  static final _dateFmt = DateFormat('dd MMM yyyy');
  static final _monthFmt = DateFormat('MMMM yyyy');

  // ── Public entry point ─────────────────────────────────────────────────────
  static Future<Uint8List> generateMonthlyBill({
    required List<Expense> expenses,
    DateTime? from,
    DateTime? to,
    String userName = 'User',
  }) async {    // Load fonts that support the ₹ rupee glyph
    final regularFont = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final italicFont = await PdfGoogleFonts.notoSansItalic();
    final pdf = pw.Document(
      title: 'SpendWise Expense Report',
      author: 'SpendWise',
    );

    // Load logo from assets
    final logoBytes = await rootBundle.load('assets/Flutter_Logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Sort by date descending
    final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));

    // Calculations
    final income = expenses
        .where((e) => e.type == 'income')
        .fold(0.0, (s, e) => s + e.amount);
    final totalExpense = expenses
        .where((e) => e.type == 'expense')
        .fold(0.0, (s, e) => s + e.amount);
    final net = income - totalExpense;

    // Category breakdown (expenses only)
    final Map<String, double> catTotals = {};
    final Map<String, int> catCounts = {};
    for (final e in expenses.where((e) => e.type == 'expense')) {
      catTotals[e.category] = (catTotals[e.category] ?? 0) + e.amount;
      catCounts[e.category] = (catCounts[e.category] ?? 0) + 1;
    }
    final sortedCats = catTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Period string
    final period = _buildPeriodString(from, to);
    final generatedAt = _dateFmt.format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 36),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
        header: (ctx) => _buildPageHeader(logo, period, generatedAt, userName),
        footer: (ctx) => _buildPageFooter(ctx, generatedAt),
        build: (ctx) => [
          pw.SizedBox(height: 16),

          // ── Summary Cards ──────────────────────────────────────────────
          _buildSummaryRow(income, totalExpense, net, expenses.length),
          pw.SizedBox(height: 24),

          // ── Category Breakdown ─────────────────────────────────────────
          if (sortedCats.isNotEmpty) ...[
            _sectionTitle('Expenses by Category'),
            pw.SizedBox(height: 10),
            _buildCategoryTable(sortedCats, catCounts, totalExpense),
            pw.SizedBox(height: 24),
          ],

          // ── Transaction Details ────────────────────────────────────────
          _sectionTitle('Transaction Details'),
          pw.SizedBox(height: 10),
          _buildTransactionTable(sorted),

          pw.SizedBox(height: 16),
        ],
      ),
    );

    return pdf.save();
  }

  // ── Page header ─────────────────────────────────────────────────────────────
  static pw.Widget _buildPageHeader(
    pw.ImageProvider logo,
    String period,
    String generatedAt,
    String userName,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _darkBg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Logo + brand
          pw.Row(
            children: [
              pw.Container(
                width: 46,
                height: 46,
                child: pw.Image(logo),
              ),
              pw.SizedBox(width: 12),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SpendWise',
                    style: pw.TextStyle(
                      color: _green,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Expense Report',
                    style: pw.TextStyle(color: _grey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          // Meta info
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                period,
                style: pw.TextStyle(
                  color: _white,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Generated: $generatedAt',
                style: pw.TextStyle(color: _grey, fontSize: 10),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Account: $userName',
                style: pw.TextStyle(color: _grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Page footer ─────────────────────────────────────────────────────────────
  static pw.Widget _buildPageFooter(pw.Context ctx, String generatedAt) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _grey, width: 0.5)),
      ),
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'SpendWise – Track. Save. Grow.',
            style: pw.TextStyle(color: _grey, fontSize: 9),
          ),
          pw.Text(
            'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: pw.TextStyle(color: _grey, fontSize: 9),
          ),
        ],
      ),
    );
  }

  // ── Summary row (4 stat boxes) ───────────────────────────────────────────────
  static pw.Widget _buildSummaryRow(
    double income,
    double expense,
    double net,
    int total,
  ) {
    final netPositive = net >= 0;
    return pw.Row(
      children: [
        _statBox('Total Income', _rupee.format(income), _incomeClr),
        pw.SizedBox(width: 10),
        _statBox('Total Expenses', _rupee.format(expense), _expenseClr),
        pw.SizedBox(width: 10),
        _statBox(
          'Net Balance',
          '${netPositive ? '+' : ''}${_rupee.format(net)}',
          netPositive ? _incomeClr : _expenseClr,
        ),
        pw.SizedBox(width: 10),
        _statBox('Transactions', '$total', _green),
      ],
    );
  }

  static pw.Expanded _statBox(String label, String value, PdfColor valueColor) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: pw.BoxDecoration(
          color: _cardBg,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
          border: pw.Border.all(color: valueColor, width: 0.8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(color: _grey, fontSize: 9),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              value,
              style: pw.TextStyle(
                color: valueColor,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ────────────────────────────────────────────────────────────
  static pw.Widget _sectionTitle(String text) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 18,
          decoration: pw.BoxDecoration(
            color: _green,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          text,
          style: pw.TextStyle(
            color: _darkBg,
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── Category breakdown table ─────────────────────────────────────────────────
  static pw.Widget _buildCategoryTable(
    List<MapEntry<String, double>> cats,
    Map<String, int> counts,
    double totalExpense,
  ) {
    final headers = ['Category', 'Transactions', 'Amount', '% of Total'];
    final rows = cats.map((e) {
      final pct = totalExpense > 0 ? (e.value / totalExpense * 100) : 0.0;
      return [
        e.key,
        '${counts[e.key] ?? 0}',
        _rupee.format(e.value),
        '${pct.toStringAsFixed(1)}%',
      ];
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: _lightGrey, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(3),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _darkBg),
          children: headers
              .map(
                (h) => pw.Padding(
                  padding:
                      const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(
                      color: _white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Data rows
        ...rows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          final isEven = i % 2 == 0;
          return pw.TableRow(
            decoration:
                pw.BoxDecoration(color: isEven ? PdfColors.white : _lightGrey),
            children: row.asMap().entries.map((cell) {
              final isAmount = cell.key == 2;
              return pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: pw.Text(
                  cell.value,
                  style: pw.TextStyle(
                    color: isAmount ? _expenseClr : PdfColors.black,
                    fontSize: 10,
                    fontWeight: isAmount ? pw.FontWeight.bold : pw.FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  // ── Transaction detail table ─────────────────────────────────────────────────
  static pw.Widget _buildTransactionTable(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return pw.Center(
        child: pw.Text('No transactions in this period.',
            style: pw.TextStyle(color: _grey, fontSize: 11)),
      );
    }

    final headers = ['Date', 'Description', 'Category', 'Type', 'Amount'];

    return pw.Table(
      border: pw.TableBorder.all(color: _lightGrey, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(4),
        2: const pw.FlexColumnWidth(2.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(2.5),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _darkBg),
          children: headers
              .map(
                (h) => pw.Padding(
                  padding:
                      const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(
                      color: _white,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Data rows
        ...expenses.asMap().entries.map((entry) {
          final i = entry.key;
          final e = entry.value;
          final isExpense = e.type == 'expense';
          final isEven = i % 2 == 0;
          final amtColor = isExpense ? _expenseClr : _incomeClr;
          final amtPrefix = isExpense ? '- ' : '+ ';

          return pw.TableRow(
            decoration:
                pw.BoxDecoration(color: isEven ? PdfColors.white : _lightGrey),
            children: [
              _txCell(_dateFmt.format(e.date)),
              _txCell(e.title, bold: true),
              _txCell(e.category),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: isExpense
                        ? PdfColor.fromHex('#FDECEA')
                        : PdfColor.fromHex('#E8F8F1'),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text(
                    isExpense ? 'Expense' : 'Income',
                    style: pw.TextStyle(
                      color: amtColor,
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: pw.Text(
                  '$amtPrefix${_rupee.format(e.amount)}',
                  style: pw.TextStyle(
                    color: amtColor,
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }),

        // Total row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _cardBg),
          children: [
            _txCell('', bold: true, color: _white),
            _txCell('TOTAL', bold: true, color: _white),
            _txCell('', bold: true, color: _white),
            _txCell('', bold: true, color: _white),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: pw.Text(
                _rupee.format(
                  expenses.fold(
                    0.0,
                    (s, e) => e.type == 'expense' ? s + e.amount : s - e.amount,
                  ).abs(),
                ),
                style: pw.TextStyle(
                  color: _green,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _txCell(String text,
      {bool bold = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: color ?? PdfColors.black,
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  // ── Period string helper ─────────────────────────────────────────────────────
  static String _buildPeriodString(DateTime? from, DateTime? to) {
    if (from != null && to != null) {
      // If same month → show month name
      if (from.year == to.year && from.month == to.month) {
        return _monthFmt.format(from);
      }
      return '${_dateFmt.format(from)} – ${_dateFmt.format(to)}';
    } else if (from != null) {
      return 'From ${_dateFmt.format(from)}';
    } else if (to != null) {
      return 'Until ${_dateFmt.format(to)}';
    }
    return 'All Time Report';
  }
}
