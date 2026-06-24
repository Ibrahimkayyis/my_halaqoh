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

/// Pure static helper that builds a [pw.Document] for halaqoh-wide attendance
/// and returns its bytes.
///
/// Table header layout (matches design reference):
/// ```
/// +-----+------------------+--------------------------------------------+
/// | No. |      Nama        |               Kehadiran                    |
/// |     |                  +-----------------------+--------------------+
/// |     |                  |       Halaqoh         |    Keterangan      |
/// |     |                  +-----------+-----------+-------+------+-----+
/// |     |                  |    Max    |    Hdr    | Sakit | Izin | Alpa|
/// +-----+------------------+-----------+-----------+-------+------+-----+
/// ```
///
/// Max = schedule-aware total sessions for the block (see ScheduleHelper).
/// Zero values in Sakit / Izin / Alpa are displayed as empty cells.
class AbsensiHalaqohPdfBuilder {
  AbsensiHalaqohPdfBuilder._();

  // ─── Colour helpers ───────────────────────────────────────────────────────
  static PdfColor _toPdfColor(Color c) => PdfColor.fromInt(c.toARGB32());

  static final _primary = _toPdfColor(AppColors.light.primary);
  static final _green = _toPdfColor(AppColors.light.green);
  static final _yellow = _toPdfColor(AppColors.light.yellow);
  static final _blue = _toPdfColor(AppColors.light.blue);
  static final _red = _toPdfColor(AppColors.light.red);
  static final _background = _toPdfColor(AppColors.light.background);
  static final _textPrimary = _toPdfColor(AppColors.light.textPrimary);
  static final _textSecondary = _toPdfColor(AppColors.light.textSecondary);
  static final _border = _toPdfColor(AppColors.light.border);
  static final _borderLight = _toPdfColor(AppColors.light.borderLight);
  static final _surface = _toPdfColor(AppColors.light.surface);
  static final _white = PdfColors.white;

  // ─── Session keys ─────────────────────────────────────────────────────────
  static List<String> _sessionKeys(String programType) =>
      programType == 'takhassus'
      ? ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib']
      : ['shubuh', 'maghrib'];

  // ─── Date utilities ───────────────────────────────────────────────────────
  static DateTime _midnight(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Returns [weekStart, weekEnd] pairs clipped to [start, end].
  static List<(DateTime, DateTime)> _weeksIn(DateTime start, DateTime end) {
    final s = _midnight(start);
    final e = _midnight(end);
    var mon = s.subtract(Duration(days: s.weekday - 1));
    final result = <(DateTime, DateTime)>[];
    while (!mon.isAfter(e)) {
      final sun = mon.add(const Duration(days: 6));
      final blockStart = mon.isBefore(s) ? s : mon;
      final blockEnd = sun.isAfter(e) ? e : sun;
      result.add((blockStart, blockEnd));
      mon = mon.add(const Duration(days: 7));
    }
    return result;
  }

  /// Returns [monthStart, monthEnd] pairs clipped to [start, end].
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

  // ─── Max computation ──────────────────────────────────────────────────────

  /// Computes the theoretical maximum number of sessions for a block
  /// using the **real per-weekday schedule** for [programType] (Reguler /
  /// Takhassus), rather than the naïve `sessionsPerDay × days` formula
  /// that overcounted weekend sessions.
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

  // ─── Aggregation ──────────────────────────────────────────────────────────

  /// Counts hadir / sakit / izin / alpa per santri within [blockStart, blockEnd].
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

  // ─── Main entry ───────────────────────────────────────────────────────────

  static Future<Uint8List> build(
    LaporanAbsensiHalaqohConfig config,
    List<AbsensiModel> allRecords,
    List<SantriModel> santriList,
  ) async {
    // 1. Load fonts & logo
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
        'assets/images/my_halaqoh_logo.png',
      )).buffer.asUint8List(),
    );

    // 2. Sort santri alphabetically
    final sorted = List<SantriModel>.from(santriList)
      ..sort((a, b) => a.nama.compareTo(b.nama));

    // 3. Session keys for program type
    final sessionKeys = _sessionKeys(config.programType);

    // 4. Compute time blocks based on report range
    final List<(DateTime, DateTime)> blocks;
    if (config.range == ReportRange.semester) {
      blocks = _monthsIn(config.startDate, config.endDate);
    } else {
      blocks = _weeksIn(config.startDate, config.endDate);
    }

    // 5. Period label for document header
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

    // 6. Page orientation: landscape for takhassus (more session columns)
    final pageFormat = config.programType == 'takhassus'
        ? PdfPageFormat.a4.landscape
        : PdfPageFormat.a4;

    // 7. Build document
    final doc = pw.Document(
      title: '${t.laporanConfig.recapAttendance} – ${config.halaqohName}',
      author: 'MyHalaqoh',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 30),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (ctx) => [
          _buildHeader(logo, bold, semiBold, regular, period, printedOn),
          pw.SizedBox(height: 12),
          _buildHalaqohInfo(config, semiBold, regular, bold),
          pw.SizedBox(height: 16),
          for (int i = 0; i < blocks.length; i++) ...[
            if ((config.range == ReportRange.monthly || config.range == ReportRange.semester) && i > 0) pw.NewPage(),
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
        ],
        footer: (ctx) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                t.laporanConfig.pdf.systemName,
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7,
                  color: _textSecondary,
                ),
              ),
              pw.Text(
                t.laporanConfig.pdf.pageLabel(page: '${ctx.pageNumber}', total: '${ctx.pagesCount}'),
                style: pw.TextStyle(
                  font: semiBold,
                  fontSize: 7,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return doc.save();
  }

  // ─── Section builders ─────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
    pw.MemoryImage logo,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
    String period,
    String printedOn,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: pw.BoxDecoration(
        color: _background,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: _border, width: 0.5),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 48,
            height: 48,
            decoration: pw.BoxDecoration(
              color: _primary,
              shape: pw.BoxShape.circle,
            ),
            padding: const pw.EdgeInsets.all(6),
            child: pw.Image(logo),
          ),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'MyHalaqoh',
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 15,
                    color: _primary,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  t.laporanConfig.pdf.titleHalaqohRecap,
                  style: pw.TextStyle(
                    font: regular,
                    fontSize: 8.5,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: pw.BoxDecoration(
                  color: _surface,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Text(
                  period,
                  style: pw.TextStyle(
                    font: semiBold,
                    fontSize: 7.5,
                    color: _primary,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                t.laporanConfig.pdf.printedAt(date: printedOn),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7,
                  color: _primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHalaqohInfo(
    LaporanAbsensiHalaqohConfig config,
    pw.Font semiBold,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: pw.BoxDecoration(
              color: _borderLight,
              border: pw.Border.all(color: _border, width: 0.5),
            ),
            child: pw.Text(
              t.laporanConfig.pdf.halaqohInfo,
              style: pw.TextStyle(font: bold, fontSize: 9, color: _textPrimary),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Table(
              columnWidths: const {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    _infoCell(t.laporanConfig.pdf.halaqoh, config.halaqohName, semiBold, regular),
                    _infoCell(t.laporanConfig.pdf.musyrif, config.guruNama, semiBold, regular),
                  ],
                ),
                pw.TableRow(
                  children: [pw.SizedBox(height: 8), pw.SizedBox(height: 8)],
                ),
                pw.TableRow(
                  children: [
                    _infoCell(
                      t.laporanConfig.pdf.program,
                      config.programType == 'takhassus'
                          ? 'Takhassus'
                          : 'Reguler',
                      semiBold,
                      regular,
                    ),
                    _infoCell(
                      t.laporanConfig.pdf.reportType,
                      _rangeLabel(config.range),
                      semiBold,
                      regular,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _rangeLabel(ReportRange r) {
    switch (r) {
      case ReportRange.weekly:
        return t.laporanConfig.weekly;
      case ReportRange.monthly:
        return t.laporanConfig.monthly;
      case ReportRange.semester:
        return t.laporanConfig.custom;
    }
  }

  /// Builds one attendance block (one week or one month depending on range).
  ///
  /// Uses [pw.LayoutBuilder] to compute the flexible Nama column width so that
  /// the manually-drawn multi-level header and the data [pw.Table] share
  /// identical column boundaries.
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
    // Block title label
    final fmtFull = DateFormat('dd MMM', t.$meta.locale.languageCode);
    final fmtMonth = DateFormat('MMMM yyyy', t.$meta.locale.languageCode);
    final String blockTitle = isSemester
        ? fmtMonth.format(blockStart)
        : '${t.laporanConfig.pdf.pekanShort(index: blockIndex + 1)}  (${fmtFull.format(blockStart)} – ${fmtFull.format(blockEnd)})';

    // Max sessions: uses the real per-weekday schedule (see ScheduleHelper)
    final maxSessions = _computeMax(config.programType, blockStart, blockEnd);

    // Per-santri attendance counts for this block
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
        // Fixed widths (pt)
        const noWidth = 28.0;
        const colW = 36.0; // each stat column: Max, Hdr, Sakit, Izin, Alpa
        const statCols = 5;
        final namaWidth = constraints!.maxWidth - noWidth - colW * statCols;

        final borderSide = pw.BorderSide(color: _border, width: 0.5);

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ── Title bar ────────────────────────────────────────────────
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _primary,
                borderRadius: const pw.BorderRadius.only(
                  topLeft: pw.Radius.circular(6),
                  topRight: pw.Radius.circular(6),
                ),
              ),
              child: pw.Text(
                blockTitle,
                style: pw.TextStyle(font: bold, fontSize: 8.5, color: _white),
              ),
            ),

            // ── Multi-level merged header ─────────────────────────────────
            _buildMultiLevelHeader(
              noWidth: noWidth,
              namaWidth: namaWidth,
              colWidth: colW,
              bold: bold,
              semiBold: semiBold,
            ),

            // ── Data rows (pw.Table, top border omitted to avoid doubling) ─
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

  // ─── Multi-level header ───────────────────────────────────────────────────

  /// Renders the 3-row merged header that matches the design reference:
  ///
  /// Row 1 — "No." + "Nama" (full height) + "Kehadiran" (1/3 height)
  /// Row 2 — "Halaqoh" (2 cols) + "Keterangan" (3 cols)
  /// Row 3 — Max | Hdr | Sakit | Izin | Alpa
  ///
  /// "No." and "Nama" are drawn as tall containers that span all three
  /// sub-rows; the stat columns are stacked inside a [pw.Column].
  static pw.Widget _buildMultiLevelHeader({
    required double noWidth,
    required double namaWidth,
    required double colWidth,
    required pw.Font bold,
    required pw.Font semiBold,
  }) {
    // Row heights (pt)
    const double h1 = 15.0; // "Kehadiran"
    const double h2 = 13.0; // "Halaqoh" / "Keterangan"
    const double h3 = 14.0; // "Max", "Hdr", "Sakit", "Izin", "Alpa"
    final totalH = h1 + h2 + h3;

    // ── helper: single bordered header cell ─────────────────────────────
    pw.Widget hCell({
      required double width,
      required double height,
      required String text,
      required pw.Font font,
      double fontSize = 7.5,
      PdfColor? textColor,
      PdfColor? bgColor,
    }) {
      return pw.Container(
        width: width,
        height: height,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: pw.BoxDecoration(
          color: bgColor ?? _textPrimary,
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
        // ── "No." — spans all 3 header rows ──────────────────────────────
        hCell(width: noWidth, height: totalH, text: t.laporanConfig.pdf.no, font: semiBold),

        // ── "Nama" — spans all 3 header rows ─────────────────────────────
        hCell(width: namaWidth, height: totalH, text: t.laporanConfig.pdf.nameHeader, font: semiBold),

        // ── "Kehadiran" group — 3 stacked sub-rows ────────────────────────
        pw.SizedBox(
          width: colWidth * 5,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Level 1 — "Kehadiran" spanning all 5 stat columns
              hCell(
                width: colWidth * 5,
                height: h1,
                text: t.laporanConfig.pdf.kehadiranHeader,
                font: bold,
                fontSize: 8,
              ),

              // Level 2 — "Halaqoh" (Max + Hdr) | "Keterangan" (Sakit + Izin + Alpa)
              pw.Row(
                children: [
                  hCell(
                    width: colWidth * 2,
                    height: h2,
                    text: t.laporanConfig.pdf.halaqoh,
                    font: semiBold,
                    fontSize: 7,
                  ),
                  hCell(
                    width: colWidth * 3,
                    height: h2,
                    text: t.laporanConfig.pdf.keteranganLabel,
                    font: semiBold,
                    fontSize: 7,
                  ),
                ],
              ),

              // Level 3 — individual column labels
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

  // ─── Data row ─────────────────────────────────────────────────────────────

  /// Builds one alternating-colour data row.
  ///
  /// Sakit / Izin / Alpa cells show an empty string when the value is zero,
  /// matching the design reference.
  static pw.TableRow _buildDataRow({
    required int index,
    required SantriModel santri,
    required _BlockStats stats,
    required pw.Font regular,
    required pw.Font semiBold,
  }) {
    final bg = index % 2 == 0 ? _white : _surface;

    // Zero → blank for absence-type columns
    String blankIfZero(int v) => v == 0 ? '' : '$v';

    return pw.TableRow(
      decoration: pw.BoxDecoration(color: bg),
      children: [
        // No.
        _padCell(
          pw.Text(
            '${index + 1}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: regular,
              fontSize: 7.5,
              color: _textSecondary,
            ),
          ),
          center: true,
        ),
        // Nama — left-aligned
        _padCell(
          pw.Text(
            santri.nama,
            style: pw.TextStyle(
              font: regular,
              fontSize: 8,
              color: _textPrimary,
            ),
          ),
          left: true,
        ),
        // Max
        _padCell(
          pw.Text(
            '${stats.max}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 7.5,
              color: _textPrimary,
            ),
          ),
          center: true,
        ),
        // Hdr (Hadir)
        _padCell(
          pw.Text(
            '${stats.hadir}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: semiBold, fontSize: 8, color: _green),
          ),
          center: true,
        ),
        // Sakit — blank when zero
        _padCell(
          pw.Text(
            blankIfZero(stats.sakit),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: semiBold, fontSize: 8, color: _yellow),
          ),
          center: true,
        ),
        // Izin — blank when zero
        _padCell(
          pw.Text(
            blankIfZero(stats.izin),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: semiBold, fontSize: 8, color: _blue),
          ),
          center: true,
        ),
        // Alpa — blank when zero
        _padCell(
          pw.Text(
            blankIfZero(stats.alpa),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: semiBold, fontSize: 8, color: _red),
          ),
          center: true,
        ),
      ],
    );
  }

  // ─── Padding helpers ─────────────────────────────────────────────────────

  static pw.Widget _padCell(
    pw.Widget child, {
    bool center = false,
    bool left = false,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: left ? 6 : 4),
      child: child,
    );
  }

  // ─── Info cell (used in _buildHalaqohInfo) ────────────────────────────────

  static pw.Widget _infoCell(
    String label,
    String value,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(right: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: regular,
              fontSize: 7.5,
              color: _textSecondary,
            ),
          ),
          pw.SizedBox(height: 1),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 9,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Internal aggregation model ───────────────────────────────────────────────

class _BlockStats {
  final int max;
  int hadir = 0;
  int sakit = 0;
  int izin = 0;
  int alpa = 0;

  _BlockStats({required this.max});
}
