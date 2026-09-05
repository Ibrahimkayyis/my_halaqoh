import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../guru_absensi/domain/models/absensi_model.dart';
import '../../../master_data/domain/models/santri_model.dart';
import '../../domain/helpers/schedule_helper.dart';
import '../../domain/models/laporan_absensi_config.dart';
import '../../domain/models/laporan_absensi_halaqoh_config.dart';

class _BlockStats {
  final int max;
  int hadir = 0;
  int sakit = 0;
  int izin = 0;
  int alpa = 0;
  _BlockStats({required this.max});
}

/// PDF Builder for halaqoh-wide attendance reports with unified minimalist, modern editorial layout.
class AbsensiHalaqohPdfBuilder {
  AbsensiHalaqohPdfBuilder._();

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

  // ── Session keys ──────────────────────────────────────────────────────────
  static List<String> _sessionKeys(String programType) =>
      programType == 'takhassus'
      ? ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib']
      : ['shubuh', 'maghrib'];

  static DateTime _midnight(DateTime d) => DateTime(d.year, d.month, d.day);

  static List<(DateTime, DateTime)> _monthsIn(DateTime start, DateTime end) {
    final result = <(DateTime, DateTime)>[];
    var y = start.year;
    var m = start.month;
    while (DateTime(y, m, 1).compareTo(_midnight(end)) <= 0) {
      final ms = DateTime(y, m, 1);
      final me = DateTime(y, m + 1, 0);
      final blockStart = ms.isBefore(start) ? _midnight(start) : ms;
      final blockEnd = me.isAfter(end) ? _midnight(end) : me;
      result.add((blockStart, blockEnd));
      m++;
      if (m > 12) {
        m = 1;
        y++;
      }
    }
    return result;
  }

  static int _computeMax(
    String programType,
    DateTime blockStart,
    DateTime blockEnd,
  ) {
    return ScheduleHelper.totalScheduledSessions(
      blockStart,
      blockEnd,
      programType,
    );
  }

  static Map<String, _BlockStats> _aggregate(
    List<AbsensiModel> records,
    List<SantriModel> santriList,
    List<String> sessionKeys,
    DateTime blockStart,
    DateTime blockEnd,
    int maxSessions,
  ) {
    final bs = _midnight(blockStart);
    final be = _midnight(blockEnd);

    final inBlock = records.where((r) {
      final d = _midnight(r.tanggal);
      return !d.isBefore(bs) && !d.isAfter(be) && sessionKeys.contains(r.sesi);
    }).toList();

    final Map<String, _BlockStats> result = {};
    for (final santri in santriList) {
      result[santri.id] = _BlockStats(max: maxSessions);
    }

    for (final r in inBlock) {
      for (final entry in r.records) {
        final santriId = santriList
            .where((s) => s.nis == entry.nis)
            .map((s) => s.id)
            .firstOrNull;
        if (santriId == null || !result.containsKey(santriId)) continue;
        final stats = result[santriId]!;
        switch (entry.status.trim().toLowerCase()) {
          case 'hadir':
          case 'hadir_barcode':
          case 'hadir_manual':
          case 'terlambat':
            stats.hadir++;
            break;
          case 'sakit':
            stats.sakit++;
            break;
          case 'izin':
            stats.izin++;
            break;
          case 'alfa':
            stats.alpa++;
            break;
        }
      }
    }
    return result;
  }

  // ── Main entry ────────────────────────────────────────────────────────────
  static Future<Uint8List> build(
    LaporanAbsensiHalaqohConfig config,
    List<AbsensiModel> allRecords,
    List<SantriModel> santriList,
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

    final sorted = List<SantriModel>.from(santriList)
      ..sort((a, b) => a.nama.compareTo(b.nama));

    final sessionKeys = _sessionKeys(config.programType);

    final List<(DateTime, DateTime)> blocks;
    if (config.range == ReportRange.semester) {
      blocks = _monthsIn(config.startDate, config.endDate);
    } else {
      // Monthly and weekly are consolidated single blocks for the period
      blocks = [(config.startDate, config.endDate)];
    }

    final fmtFull = DateFormat('dd MMMM yyyy', t.$meta.locale.languageCode);
    final fmtMonth = DateFormat('MMMM yyyy', t.$meta.locale.languageCode);
    final String period;
    if (config.range == ReportRange.monthly) {
      period = fmtMonth.format(config.startDate);
    } else if (config.range == ReportRange.weekly) {
      period =
          '${fmtFull.format(config.startDate)} – ${fmtFull.format(config.endDate)}';
    } else {
      period =
          '${fmtMonth.format(config.startDate)} – ${fmtMonth.format(config.endDate)}';
    }
    final printedOn = fmtFull.format(DateTime.now());

    final pageFormat = config.programType == 'takhassus'
        ? PdfPageFormat.a4.landscape
        : PdfPageFormat.a4;

    final doc = pw.Document(
      title: '${t.laporanConfig.recapAttendance} – ${config.halaqohName}',
      author: 'MyHalaqoh',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (ctx) => [
          _buildHeader(logo, bold, semiBold, regular, period, printedOn),
          pw.SizedBox(height: 12),
          _buildHalaqohInfoCard(config, sorted.length, bold, semiBold, regular),
          pw.SizedBox(height: 14),
          for (int i = 0; i < blocks.length; i++) ...[
            if (config.range == ReportRange.semester && i > 0) pw.NewPage(),
            _buildBlockTable(
              blockIndex: i,
              blockStart: blocks[i].$1,
              blockEnd: blocks[i].$2,
              config: config,
              santriList: sorted,
              allRecords: allRecords,
              sessionKeys: sessionKeys,
              bold: bold,
              semiBold: semiBold,
              regular: regular,
              isSemester: config.range == ReportRange.semester,
            ),
            if (i < blocks.length - 1) pw.SizedBox(height: 14),
          ],
          pw.SizedBox(height: 10),
          _buildLegend(regular, semiBold),
        ],
        footer: (ctx) => _buildFooter(config.halaqohName, regular, semiBold, ctx),
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
                  t.laporanConfig.pdf.titleHalaqohRecap,
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

  // ── Halaqoh Information Card (Horizontal 4-Column Strip) ───────────────────

  static pw.Widget _buildHalaqohInfoCard(
    LaporanAbsensiHalaqohConfig config,
    int totalSantri,
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
            label: t.laporanConfig.pdf.halaqoh,
            value: config.halaqohName,
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: t.laporanConfig.pdf.musyrif,
            value: config.guruNama,
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: t.laporanConfig.pdf.program,
            value: config.programType == 'takhassus' ? 'Takhassus' : 'Reguler',
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: 'Total Santri',
            value: '$totalSantri Santri',
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

  // ── Block Table ───────────────────────────────────────────────────────────

  static pw.Widget _buildBlockTable({
    required int blockIndex,
    required DateTime blockStart,
    required DateTime blockEnd,
    required LaporanAbsensiHalaqohConfig config,
    required List<SantriModel> santriList,
    required List<AbsensiModel> allRecords,
    required List<String> sessionKeys,
    required pw.Font bold,
    required pw.Font semiBold,
    required pw.Font regular,
    required bool isSemester,
  }) {
    final fmtFull = DateFormat('dd MMM', t.$meta.locale.languageCode);
    final fmtMonth = DateFormat('MMMM yyyy', t.$meta.locale.languageCode);
    final String blockTitle;
    if (config.range == ReportRange.monthly) {
      blockTitle = '${t.laporanConfig.monthly} — ${fmtMonth.format(blockStart)}';
    } else if (isSemester) {
      blockTitle = fmtMonth.format(blockStart);
    } else {
      blockTitle = '${t.laporanConfig.weekly} (${fmtFull.format(blockStart)} – ${fmtFull.format(blockEnd)})';
    }

    final maxSessions = _computeMax(config.programType, blockStart, blockEnd);

    final statsMap = _aggregate(
      allRecords,
      santriList,
      sessionKeys,
      blockStart,
      blockEnd,
      maxSessions,
    );

    return pw.LayoutBuilder(
      builder: (ctx, constraints) {
        const noWidth = 28.0;
        const colW = 38.0;
        const statCols = 5;
        final namaWidth = constraints!.maxWidth - noWidth - colW * statCols;

        final borderSide = pw.BorderSide(color: _border, width: 0.5);

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title bar
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _primary,
                borderRadius: const pw.BorderRadius.only(
                  topLeft: pw.Radius.circular(4),
                  topRight: pw.Radius.circular(4),
                ),
              ),
              child: pw.Text(
                blockTitle,
                style: pw.TextStyle(font: bold, fontSize: 8.5, color: _white),
              ),
            ),

            // Multi-level merged header
            _buildMultiLevelHeader(
              noWidth: noWidth,
              namaWidth: namaWidth,
              colWidth: colW,
              bold: bold,
              semiBold: semiBold,
            ),

            // Data rows
            pw.Table(
              border: pw.TableBorder(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
                horizontalInside: borderSide,
                verticalInside: borderSide,
              ),
              columnWidths: {
                0: pw.FixedColumnWidth(noWidth),
                1: pw.FixedColumnWidth(namaWidth),
                2: pw.FixedColumnWidth(colW),
                3: pw.FixedColumnWidth(colW),
                4: pw.FixedColumnWidth(colW),
                5: pw.FixedColumnWidth(colW),
                6: pw.FixedColumnWidth(colW),
              },
              children: [
                for (int i = 0; i < santriList.length; i++)
                  _buildDataRow(
                    index: i,
                    santri: santriList[i],
                    stats:
                        statsMap[santriList[i].id] ??
                        _BlockStats(max: maxSessions),
                    regular: regular,
                    semiBold: semiBold,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  static pw.Widget _buildMultiLevelHeader({
    required double noWidth,
    required double namaWidth,
    required double colWidth,
    required pw.Font bold,
    required pw.Font semiBold,
  }) {
    const double h1 = 15.0;
    const double h2 = 13.0;
    const double h3 = 14.0;
    final totalH = h1 + h2 + h3;

    pw.Widget hCell({
      required double width,
      required double height,
      required String text,
      required pw.Font font,
      double fontSize = 7,
      PdfColor? textColor,
      PdfColor? bgColor,
    }) {
      return pw.Container(
        width: width,
        height: height,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: pw.BoxDecoration(
          color: bgColor ?? _primary,
          border: pw.Border.all(color: _border, width: 0.5),
        ),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            font: font,
            fontSize: fontSize,
            color: textColor ?? _white,
          ),
        ),
      );
    }

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        hCell(width: noWidth, height: totalH, text: t.laporanConfig.pdf.no, font: semiBold),
        hCell(width: namaWidth, height: totalH, text: t.laporanConfig.pdf.nameHeader, font: semiBold),
        pw.SizedBox(
          width: colWidth * 5,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              hCell(
                width: colWidth * 5,
                height: h1,
                text: t.laporanConfig.pdf.kehadiranHeader,
                font: bold,
                fontSize: 7.5,
              ),
              pw.Row(
                children: [
                  hCell(
                    width: colWidth * 2,
                    height: h2,
                    text: t.laporanConfig.pdf.halaqoh,
                    font: semiBold,
                    fontSize: 6.5,
                  ),
                  hCell(
                    width: colWidth * 3,
                    height: h2,
                    text: t.laporanConfig.pdf.keteranganLabel,
                    font: semiBold,
                    fontSize: 6.5,
                  ),
                ],
              ),
              pw.Row(
                children: [
                  hCell(
                    width: colWidth,
                    height: h3,
                    text: t.laporanConfig.pdf.maxHeader,
                    font: semiBold,
                  ),
                  hCell(
                    width: colWidth,
                    height: h3,
                    text: t.laporanConfig.pdf.hdrHeader,
                    font: semiBold,
                    textColor: _green,
                  ),
                  hCell(
                    width: colWidth,
                    height: h3,
                    text: t.laporanConfig.pdf.sick,
                    font: semiBold,
                    textColor: _yellow,
                  ),
                  hCell(
                    width: colWidth,
                    height: h3,
                    text: t.laporanConfig.pdf.permit,
                    font: semiBold,
                    textColor: _blue,
                  ),
                  hCell(
                    width: colWidth,
                    height: h3,
                    text: t.laporanConfig.pdf.absent,
                    font: semiBold,
                    textColor: _red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.TableRow _buildDataRow({
    required int index,
    required SantriModel santri,
    required _BlockStats stats,
    required pw.Font regular,
    required pw.Font semiBold,
  }) {
    final bg = index % 2 == 0 ? _white : _surface;
    String blankIfZero(int v) => v == 0 ? '' : '$v';

    return pw.TableRow(
      decoration: pw.BoxDecoration(color: bg),
      children: [
        _padCell(
          pw.Text(
            '${index + 1}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: regular,
              fontSize: 7.5,
              color: _textSec,
            ),
          ),
        ),
        _padCell(
          pw.Text(
            santri.nama,
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 7.5,
              color: _textPri,
            ),
          ),
          align: pw.Alignment.centerLeft,
        ),
        _padCell(
          pw.Text(
            '${stats.max}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: regular,
              fontSize: 7.5,
              color: _textSec,
            ),
          ),
        ),
        _padCell(
          pw.Text(
            '${stats.hadir}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 7.5,
              color: stats.hadir > 0 ? _green : _textSec,
            ),
          ),
        ),
        _padCell(
          pw.Text(
            blankIfZero(stats.sakit),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: stats.sakit > 0 ? semiBold : regular,
              fontSize: 7.5,
              color: stats.sakit > 0 ? _yellow : _textSec,
            ),
          ),
        ),
        _padCell(
          pw.Text(
            blankIfZero(stats.izin),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: stats.izin > 0 ? semiBold : regular,
              fontSize: 7.5,
              color: stats.izin > 0 ? _blue : _textSec,
            ),
          ),
        ),
        _padCell(
          pw.Text(
            blankIfZero(stats.alpa),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: stats.alpa > 0 ? semiBold : regular,
              fontSize: 7.5,
              color: stats.alpa > 0 ? _red : _textSec,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _padCell(
    pw.Widget child, {
    pw.Alignment align = pw.Alignment.center,
  }) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3.5),
      child: child,
    );
  }

  // ── Legend ────────────────────────────────────────────────────────────────

  static pw.Widget _buildLegend(pw.Font regular, pw.Font semiBold) {
    final items = [
      (t.laporanConfig.pdf.hdrHeader, t.laporanConfig.pdf.present, _green, _greenBg),
      (t.laporanConfig.pdf.sick, t.laporanConfig.pdf.sick, _yellow, _yellowBg),
      (t.laporanConfig.pdf.permit, t.laporanConfig.pdf.permit, _blue, _blueBg),
      (t.laporanConfig.pdf.absent, t.laporanConfig.pdf.absent, _red, _redBg),
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
                            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
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
    String halaqohName,
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
            'MyHalaqoh • $halaqohName',
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
}
