import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../guru_absensi/domain/models/absensi_model.dart';
import '../../domain/helpers/schedule_helper.dart';
import '../../domain/models/laporan_absensi_config.dart';

/// PDF Builder for individual student Attendance reports with unified minimalist, modern editorial layout.
class AbsensiPdfBuilder {
  AbsensiPdfBuilder._();

  static PdfColor _pc(Color c) => PdfColor.fromInt(c.toARGB32());

  // ── Palette (Minimalist, High Contrast, Institutional) ─────────────────────
  static final _primary = _pc(AppColors.light.primary); // #115D69
  static final _primaryDark = PdfColor.fromHex('#0C424B');
  static final _primaryLight = PdfColor.fromHex('#E8F4F6');

  // Status colors
  static final _green = _pc(AppColors.light.green); // Hadir (#10B981)
  static final _greenBg = PdfColor.fromHex('#ECFDF5');

  static final _yellow = PdfColor.fromHex('#D97706'); // Sakit (#D97706)
  static final _yellowBg = PdfColor.fromHex('#FFFBEB');

  static final _blue = _pc(AppColors.light.blue); // Izin (#3B82F6)
  static final _blueBg = PdfColor.fromHex('#EFF6FF');

  static final _red = PdfColor.fromHex('#EF4444'); // Alpa (#EF4444)
  static final _redBg = PdfColor.fromHex('#FEF2F2');

  static final _textPri = PdfColor.fromHex('#0F172A'); // Slate 900
  static final _textSec = PdfColor.fromHex('#64748B'); // Slate 500
  static final _textMuted = PdfColor.fromHex('#94A3B8'); // Slate 400
  static final _border = PdfColor.fromHex('#E2E8F0'); // Slate 200
  static final _surface = PdfColor.fromHex('#F8FAFC'); // Slate 50
  static final _white = PdfColors.white;

  // ── Session definitions ───────────────────────────────────────────────────
  static List<String> _sessionKeys(String programType) =>
      programType == 'takhassus'
      ? ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib']
      : ['shubuh', 'maghrib'];

  static List<String> _sessionLabels(String programType) =>
      programType == 'takhassus'
      ? [
          t.laporanConfig.pdf.shubuh,
          t.laporanConfig.pdf.dhuha,
          t.laporanConfig.pdf.siang,
          t.laporanConfig.pdf.ashar,
          t.laporanConfig.pdf.maghrib
        ]
      : [
          t.laporanConfig.pdf.shubuh,
          t.laporanConfig.pdf.maghrib
        ];

  // ── Status helpers ────────────────────────────────────────────────────────
  static String _statusCode(String status) {
    switch (status.trim().toLowerCase()) {
      case 'hadir':
      case 'hadir_barcode':
      case 'hadir_manual':
      case 'terlambat':
        return t.laporanConfig.pdf.presentCode;
      case 'sakit':
        return t.laporanConfig.pdf.sickCode;
      case 'izin':
        return t.laporanConfig.pdf.permitCode;
      case 'alfa':
        return t.laporanConfig.pdf.absentCode;
      default:
        return '-';
    }
  }

  static PdfColor _codeColor(String code) {
    if (code == t.laporanConfig.pdf.presentCode) return _green;
    if (code == t.laporanConfig.pdf.sickCode) return _yellow;
    if (code == t.laporanConfig.pdf.permitCode) return _blue;
    if (code == t.laporanConfig.pdf.absentCode) return _red;
    return _textSec;
  }

  static PdfColor _codeBg(String code) {
    if (code == t.laporanConfig.pdf.presentCode) return _greenBg;
    if (code == t.laporanConfig.pdf.sickCode) return _yellowBg;
    if (code == t.laporanConfig.pdf.permitCode) return _blueBg;
    if (code == t.laporanConfig.pdf.absentCode) return _redBg;
    return _surface;
  }

  static DateTime _midnight(DateTime d) => DateTime(d.year, d.month, d.day);
  static final _fmtKey = DateFormat('yyyy-MM-dd');
  static final _fmtDate = DateFormat('dd/MM/yy');

  // ── Main entry ────────────────────────────────────────────────────────────
  static Future<Uint8List> build(
    LaporanAbsensiConfig config,
    List<AbsensiModel> allRecords,
  ) async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Poppins/Poppins-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Poppins/Poppins-Bold.ttf'),
    );
    final semiBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Poppins/Poppins-SemiBold.ttf'),
    );
    final logo = pw.MemoryImage(
      (await rootBundle.load(
        'assets/images/my_halaqoh_logo_new.png',
      )).buffer.asUint8List(),
    );

    final sD = _midnight(config.startDate);
    final eD = _midnight(config.endDate);
    final filtered = allRecords.where((r) {
      final d = _midnight(r.tanggal);
      return !d.isBefore(sD) && !d.isAfter(eD);
    }).toList();

    final keys = _sessionKeys(config.programType);
    final Map<String, Map<String, String>> byDay = {};
    for (final rec in filtered) {
      final sesiKey = rec.sesi.trim().toLowerCase();
      if (!keys.contains(sesiKey)) continue;
      final dateKey = _fmtKey.format(rec.tanggal);
      final entry = rec.records
          .where((r) => r.nis == config.santriNis)
          .firstOrNull;
      if (entry == null) continue;
      byDay.putIfAbsent(dateKey, () => {})[sesiKey] = _statusCode(entry.status);
    }

    int hadir = 0, sakit = 0, izin = 0, alfa = 0;
    for (final day in byDay.values) {
      for (final code in day.values) {
        if (code == t.laporanConfig.pdf.presentCode) {
          hadir++;
        } else if (code == t.laporanConfig.pdf.sickCode) {
          sakit++;
        } else if (code == t.laporanConfig.pdf.permitCode) {
          izin++;
        } else if (code == t.laporanConfig.pdf.absentCode) {
          alfa++;
        }
      }
    }

    final dayCount = eD.difference(sD).inDays + 1;
    final days = List.generate(
      dayCount,
      (i) => DateTime(sD.year, sD.month, sD.day + i),
    );

    final totalScheduled = ScheduleHelper.totalScheduledSessions(
      sD,
      eD,
      config.programType,
    );
    final rate = totalScheduled > 0 ? hadir / totalScheduled : 0.0;

    final fmtFull = DateFormat('dd MMMM yyyy', t.$meta.locale.languageCode);
    final fmtMonth = DateFormat('MMMM yyyy', t.$meta.locale.languageCode);
    final period = config.range == ReportRange.monthly
        ? fmtMonth.format(config.startDate)
        : '${fmtFull.format(config.startDate)} – ${fmtFull.format(config.endDate)}';
    final printedOn = fmtFull.format(DateTime.now());

    final sLabels = _sessionLabels(config.programType);

    final doc = pw.Document(
      title: '${t.laporanConfig.attendanceReport} – ${config.santriName}',
      author: 'MyHalaqoh',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (ctx) => [
          _buildHeader(logo, bold, semiBold, regular, period, printedOn),
          pw.SizedBox(height: 12),
          _buildStudentInfoCard(config, bold, semiBold, regular),
          pw.SizedBox(height: 14),
          _buildSummarySection(
            hadir,
            sakit,
            izin,
            alfa,
            rate,
            totalScheduled,
            bold,
            semiBold,
            regular,
          ),
          pw.SizedBox(height: 14),
          _buildSectionTitle(t.laporanConfig.pdf.dailyDetailTitle, bold),
          pw.SizedBox(height: 6),
          _buildDetailTable(days, byDay, keys, sLabels, semiBold, regular),
          pw.SizedBox(height: 10),
          _buildLegend(regular, semiBold),
        ],
        footer: (ctx) => _buildFooter(config.santriName, regular, semiBold, ctx),
      ),
    );

    return doc.save();
  }

  // ── Global Header (Minimalist & Modern Letterhead) ─────────────────────────

  static pw.Widget _buildHeader(
    pw.MemoryImage logo,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    String period,
    String printedOn,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: _border, width: 1.2),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Logo (my_halaqoh_logo_new.png)
          pw.Container(
            width: 38,
            height: 38,
            child: pw.Image(logo, fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(width: 12),

          // Title & Subtitle
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'MyHalaqoh',
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 14,
                    color: _primary,
                    letterSpacing: 0.3,
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Text(
                  t.laporanConfig.pdf.titleAttendance,
                  style: pw.TextStyle(
                    font: semiBold,
                    fontSize: 9,
                    color: _textPri,
                  ),
                ),
              ],
            ),
          ),

          // Meta Pill (Period & Print Date)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: pw.BoxDecoration(
                  color: _primaryLight,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Text(
                  period,
                  style: pw.TextStyle(
                    font: semiBold,
                    fontSize: 8,
                    color: _primaryDark,
                  ),
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                t.laporanConfig.pdf.printedAt(date: printedOn),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7,
                  color: _textSec,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Student Information Card (Horizontal 4-Column Strip) ───────────────────

  static pw.Widget _buildStudentInfoCard(
    LaporanAbsensiConfig config,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: _border, width: 0.8),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _infoField(
            label: t.laporanConfig.pdf.studentName,
            value: config.santriName,
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: t.laporanConfig.pdf.nis,
            value: config.santriNis,
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: t.laporanConfig.pdf.halaqoh,
            value: config.halaqohName,
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: t.laporanConfig.pdf.pembimbing,
            value: config.guruNama,
            bold: semiBold,
            regular: regular,
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoDivider() {
    return pw.Container(
      width: 1,
      height: 22,
      color: _border,
      margin: const pw.EdgeInsets.symmetric(horizontal: 8),
    );
  }

  static pw.Widget _infoField({
    required String label,
    required String value,
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label.toUpperCase(),
            style: pw.TextStyle(
              font: regular,
              fontSize: 6.5,
              color: _textMuted,
              letterSpacing: 0.3,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            maxLines: 1,
            style: pw.TextStyle(
              font: bold,
              fontSize: 8.5,
              color: _textPri,
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Section ───────────────────────────────────────────────────────

  static pw.Widget _buildSummarySection(
    int hadir,
    int sakit,
    int izin,
    int alfa,
    double rate,
    int totalScheduled,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final pct = '${(rate * 100).toStringAsFixed(1)}%';
    final rateColor = rate >= 0.85 ? _green : (rate >= 0.70 ? _yellow : _red);
    final rateBg = rate >= 0.85 ? _greenBg : (rate >= 0.70 ? _yellowBg : _redBg);

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: _border, width: 0.8),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              _statMetricCard(
                value: '$hadir',
                label: t.laporanConfig.pdf.present,
                code: t.laporanConfig.pdf.presentCode,
                color: _green,
                bgColor: _greenBg,
                bold: bold,
                regular: regular,
              ),
              pw.SizedBox(width: 6),
              _statMetricCard(
                value: '$sakit',
                label: t.laporanConfig.pdf.sick,
                code: t.laporanConfig.pdf.sickCode,
                color: _yellow,
                bgColor: _yellowBg,
                bold: bold,
                regular: regular,
              ),
              pw.SizedBox(width: 6),
              _statMetricCard(
                value: '$izin',
                label: t.laporanConfig.pdf.permit,
                code: t.laporanConfig.pdf.permitCode,
                color: _blue,
                bgColor: _blueBg,
                bold: bold,
                regular: regular,
              ),
              pw.SizedBox(width: 6),
              _statMetricCard(
                value: '$alfa',
                label: t.laporanConfig.pdf.absent,
                code: t.laporanConfig.pdf.absentCode,
                color: _red,
                bgColor: _redBg,
                bold: bold,
                regular: regular,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: pw.BoxDecoration(
              color: rateBg,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              border: pw.Border.all(color: rateColor, width: 0.5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    pw.Text(
                      '${t.laporanConfig.pdf.attendanceRate}: ',
                      style: pw.TextStyle(font: regular, fontSize: 8, color: _textPri),
                    ),
                    pw.Text(
                      pct,
                      style: pw.TextStyle(font: bold, fontSize: 10, color: rateColor),
                    ),
                  ],
                ),
                pw.Text(
                  t.laporanConfig.pdf.totalScheduled(hadir: '$hadir', total: '$totalScheduled'),
                  style: pw.TextStyle(font: regular, fontSize: 7.5, color: _textSec),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _statMetricCard({
    required String value,
    required String label,
    required String code,
    required PdfColor color,
    required PdfColor bgColor,
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          border: pw.Border.all(color: color, width: 0.5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(
                font: bold,
                fontSize: 14,
                color: color,
              ),
            ),
            pw.SizedBox(height: 1),
            pw.Text(
              '$label ($code)',
              style: pw.TextStyle(
                font: regular,
                fontSize: 6.5,
                color: _textSec,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Title ─────────────────────────────────────────────────────────

  static pw.Widget _buildSectionTitle(String title, pw.Font bold) {
    return pw.Text(
      title,
      style: pw.TextStyle(font: bold, fontSize: 8.5, color: _textPri),
    );
  }

  // ── Detail Table ──────────────────────────────────────────────────────────

  static pw.Widget _buildDetailTable(
    List<DateTime> days,
    Map<String, Map<String, String>> byDay,
    List<String> keys,
    List<String> sLabels,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final sessionCount = keys.length;
    final double sessionColW = sessionCount <= 2 ? 52.0 : 42.0;

    final Map<int, pw.TableColumnWidth> colWidths = {
      0: const pw.FixedColumnWidth(48), // Tanggal
      1: const pw.FixedColumnWidth(30), // Hari
    };
    for (int i = 0; i < sessionCount; i++) {
      colWidths[i + 2] = pw.FixedColumnWidth(sessionColW);
    }
    colWidths[sessionCount + 2] = const pw.FlexColumnWidth();

    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(color: _primary),
      children: [
        _th(t.laporanConfig.pdf.dateShort, semiBold),
        _th(t.laporanConfig.pdf.dayHeader, semiBold),
        for (final lbl in sLabels) _th(lbl, semiBold),
        _th(t.laporanConfig.pdf.keteranganLabel, semiBold),
      ],
    );

    final dataRows = days.asMap().entries.map((entry) {
      final idx = entry.key;
      final d = entry.value;
      final isEven = idx % 2 == 0;
      final bg = isEven ? _white : _surface;
      final dateKey = _fmtKey.format(d);
      final dayMap = byDay[dateKey] ?? {};

      // Determine overall day status
      final codes = dayMap.values.toList();
      final String overallStatus;
      final PdfColor overallColor;
      final PdfColor overallBg;

      if (codes.isEmpty) {
        overallStatus = '-';
        overallColor = _textSec;
        overallBg = _surface;
      } else if (codes.every((c) => c == t.laporanConfig.pdf.presentCode)) {
        overallStatus = t.laporanConfig.pdf.present;
        overallColor = _green;
        overallBg = _greenBg;
      } else if (codes.any((c) => c == t.laporanConfig.pdf.absentCode)) {
        overallStatus = t.laporanConfig.pdf.absent;
        overallColor = _red;
        overallBg = _redBg;
      } else if (codes.any((c) => c == t.laporanConfig.pdf.sickCode)) {
        overallStatus = t.laporanConfig.pdf.sick;
        overallColor = _yellow;
        overallBg = _yellowBg;
      } else if (codes.any((c) => c == t.laporanConfig.pdf.permitCode)) {
        overallStatus = t.laporanConfig.pdf.permit;
        overallColor = _blue;
        overallBg = _blueBg;
      } else {
        overallStatus = t.laporanConfig.pdf.present;
        overallColor = _yellow;
        overallBg = _yellowBg;
      }

      return pw.TableRow(
        decoration: pw.BoxDecoration(color: bg),
        children: [
          _td(_fmtDate.format(d), regular, align: pw.TextAlign.center),
          _td(
            t.calendar.daysAbbr[(d.weekday - 1) % 7],
            regular,
            align: pw.TextAlign.center,
          ),
          for (final k in keys)
            _tdSessionBadge(dayMap[k] ?? '-', semiBold),
          _tdStatusBadge(overallStatus, semiBold, overallColor, overallBg),
        ],
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.5),
      columnWidths: colWidths,
      children: [headerRow, ...dataRows],
    );
  }

  // ── Legend ────────────────────────────────────────────────────────────────

  static pw.Widget _buildLegend(pw.Font regular, pw.Font semiBold) {
    final items = [
      (
        t.laporanConfig.pdf.presentCode,
        t.laporanConfig.pdf.present,
        _green,
        _greenBg,
      ),
      (
        t.laporanConfig.pdf.sickCode,
        t.laporanConfig.pdf.sick,
        _yellow,
        _yellowBg,
      ),
      (
        t.laporanConfig.pdf.permitCode,
        t.laporanConfig.pdf.permit,
        _blue,
        _blueBg,
      ),
      (
        t.laporanConfig.pdf.absentCode,
        t.laporanConfig.pdf.absent,
        _red,
        _redBg,
      ),
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        color: _surface,
        border: pw.Border.all(color: _border, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Row(
        children: [
          pw.Text(
            '${t.laporanConfig.pdf.keteranganLabel}:',
            style: pw.TextStyle(font: semiBold, fontSize: 6.5, color: _textSec),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Row(
              children: items
                  .map(
                    (item) => pw.Padding(
                      padding: const pw.EdgeInsets.only(right: 10),
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 18,
                            height: 12,
                            alignment: pw.Alignment.center,
                            decoration: pw.BoxDecoration(
                              color: item.$4,
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(2),
                              ),
                              border: pw.Border.all(color: item.$3, width: 0.5),
                            ),
                            child: pw.Text(
                              item.$1,
                              style: pw.TextStyle(
                                font: semiBold,
                                fontSize: 6,
                                color: item.$3,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 3),
                          pw.Text(
                            item.$2,
                            style: pw.TextStyle(
                              font: regular,
                              fontSize: 6.5,
                              color: _textSec,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  static pw.Widget _buildFooter(
    String santriName,
    pw.Font regular,
    pw.Font semiBold,
    pw.Context ctx,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: _border, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'MyHalaqoh • $santriName',
            style: pw.TextStyle(
              font: regular,
              fontSize: 6.5,
              color: _textMuted,
            ),
          ),
          pw.Text(
            t.laporanConfig.pdf.pageLabel(
              page: '${ctx.pageNumber}',
              total: '${ctx.pagesCount}',
            ),
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 6.5,
              color: _textSec,
            ),
          ),
        ],
      ),
    );
  }

  // ── Cell Helpers ──────────────────────────────────────────────────────────

  static pw.Widget _th(
    String text,
    pw.Font font, {
    pw.TextAlign align = pw.TextAlign.center,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 6.5, color: _white),
      ),
    );
  }

  static pw.Widget _td(
    String text,
    pw.Font font, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 7, color: _textPri),
      ),
    );
  }

  static pw.Widget _tdSessionBadge(String code, pw.Font font) {
    final color = _codeColor(code);
    final bg = _codeBg(code);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Container(
          width: 18,
          height: 14,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: bg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            border: pw.Border.all(color: color, width: 0.5),
          ),
          child: pw.Text(
            code,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 6.5, color: color),
          ),
        ),
      ),
    );
  }

  static pw.Widget _tdStatusBadge(
    String text,
    pw.Font font,
    PdfColor color,
    PdfColor bg,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 4),
      child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
          decoration: pw.BoxDecoration(
            color: bg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            border: pw.Border.all(color: color, width: 0.5),
          ),
          child: pw.Text(
            text,
            style: pw.TextStyle(font: font, fontSize: 6.5, color: color),
          ),
        ),
      ),
    );
  }
}
