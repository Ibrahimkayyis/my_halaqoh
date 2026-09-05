import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../guru_hafalan/domain/models/hafalan_santri_model.dart';
import '../../../master_data/domain/models/santri_model.dart';
import '../../domain/models/laporan_absensi_config.dart'; // for ReportRange
import '../../domain/models/laporan_hafalan_halaqoh_config.dart';

class _Group {
  final DateTime tanggal;
  final String jenis;
  final int nilaiKelancaran;
  final int nilaiTajwid;
  final List<HafalanSantriModel> records;
  _Group({
    required this.tanggal,
    required this.jenis,
    required this.nilaiKelancaran,
    required this.nilaiTajwid,
    required this.records,
  });
  int get avg => ((nilaiKelancaran + nilaiTajwid) / 2).round();
}

/// PDF Builder for whole-halaqoh Hafalan reports with minimalist, modern editorial layout.
///
/// Features:
/// - Global Halaqoh letterhead & info block only at the top of the report (using `my_halaqoh_logo_new.png`).
/// - Compact, clean per-santri header (Name & NIS only, zero redundant bloat).
/// - Dynamic stats cards with dedicated palette (Purple for Average Score, preventing confusion with Jayyid).
/// - Direct "Ziyadah" & "Muraja'ah" badges in detail tables and legend.
class HafalanHalaqohPdfBuilder {
  HafalanHalaqohPdfBuilder._();

  static PdfColor _pc(Color c) => PdfColor.fromInt(c.toARGB32());

  // ── Palette (Minimalist, High Contrast, Institutional) ─────────────────────
  static final _primary = _pc(AppColors.light.primary); // #115D69
  static final _primaryDark = PdfColor.fromHex('#0C424B');
  static final _primaryLight = PdfColor.fromHex('#E8F4F6');

  // Green (Ziyadah & Mumtaz)
  static final _green = _pc(AppColors.light.green); // #10B981
  static final _greenBg = PdfColor.fromHex('#ECFDF5');

  // Blue (Muraja'ah)
  static final _blue = _pc(AppColors.light.blue); // #3B82F6
  static final _blueBg = PdfColor.fromHex('#EFF6FF');

  // Yellow (Jayyid grade only)
  static final _yellow = PdfColor.fromHex('#D97706');
  static final _yellowBg = PdfColor.fromHex('#FFFBEB');

  // Orange (Maqbul grade only)
  static final _orange = PdfColor.fromHex('#EA580C');
  static final _orangeBg = PdfColor.fromHex('#FFF7ED');

  static final _textPri = PdfColor.fromHex('#0F172A'); // Slate 900
  static final _textSec = PdfColor.fromHex('#64748B'); // Slate 500
  static final _textMuted = PdfColor.fromHex('#94A3B8'); // Slate 400
  static final _border = PdfColor.fromHex('#E2E8F0'); // Slate 200
  static final _surface = PdfColor.fromHex('#F8FAFC'); // Slate 50
  static final _white = PdfColors.white;

  static String _predikat(int score) {
    if (score >= 85) return t.laporanConfig.pdf.predikat.mumtaz;
    if (score >= 70) return t.laporanConfig.pdf.predikat.jayyid;
    return t.laporanConfig.pdf.predikat.maqbul;
  }

  static PdfColor _predikatColor(int score) {
    if (score >= 85) return _green;
    if (score >= 70) return _yellow;
    return _orange;
  }

  static PdfColor _predikatBg(int score) {
    if (score >= 85) return _greenBg;
    if (score >= 70) return _yellowBg;
    return _orangeBg;
  }

  static List<_Group> _group(List<HafalanSantriModel> recs) {
    final map = <String, List<HafalanSantriModel>>{};
    for (final r in recs) {
      final k =
          '${r.tanggalSetoran.toIso8601String()}_${r.jenis}_${r.nilaiKelancaran}_${r.nilaiTajwid}';
      map.putIfAbsent(k, () => []).add(r);
    }
    final groups = map.entries.map((e) {
      final l = e.value;
      return _Group(
        tanggal: l.first.tanggalSetoran,
        jenis: l.first.jenis,
        nilaiKelancaran: l.first.nilaiKelancaran,
        nilaiTajwid: l.first.nilaiTajwid,
        records: l,
      );
    }).toList()..sort((a, b) => a.tanggal.compareTo(b.tanggal));
    return groups;
  }

  static DateTime _mid(DateTime d) => DateTime(d.year, d.month, d.day);

  static String _juzStr(List<HafalanSantriModel> recs) {
    final juzSet = recs.map((r) => r.juz).toSet().toList()..sort();
    return juzSet.join(', ');
  }

  static String _surahDisplay(List<HafalanSantriModel> recs) {
    if (recs.length == 1) {
      return '${recs.first.surahName} (${recs.first.ayatMulai}-${recs.first.ayatSelesai})';
    }
    final sorted = [...recs]..sort((a, b) => a.surahId.compareTo(b.surahId));
    return '${sorted.first.surahName} — ${sorted.last.surahName}';
  }

  static final _fmtDate = DateFormat('dd/MM/yy');

  /// Builds a combined, minimalist PDF for all santri in [santriList].
  static Future<Uint8List> build(
    LaporanHafalanHalaqohConfig config,
    List<SantriModel> santriList,
    Map<String, List<HafalanSantriModel>> recordsBySantriId,
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

    final sD = _mid(config.startDate);
    final eD = _mid(config.endDate);

    final fmtFull = DateFormat('dd MMMM yyyy', t.$meta.locale.languageCode);
    final fmtMon = DateFormat('MMMM yyyy', t.$meta.locale.languageCode);
    final period = config.range == ReportRange.monthly
        ? fmtMon.format(config.startDate)
        : '${fmtFull.format(config.startDate)} – ${fmtFull.format(config.endDate)}';
    final printedOn = fmtFull.format(DateTime.now());

    final doc = pw.Document(
      title:
          '${t.laporanConfig.pdf.titleHafalanHalaqohRecap} – ${config.halaqohName}',
      author: 'MyHalaqoh',
    );

    // Build document content list
    final contentWidgets = <pw.Widget>[];

    // 1. Global Document Header (Page 1 top)
    contentWidgets.add(_buildGlobalHeader(logo, bold, semiBold, regular, period, printedOn));
    contentWidgets.add(pw.SizedBox(height: 12));

    // 2. Global Halaqoh Information Card (Page 1 only)
    contentWidgets.add(_buildHalaqohInfoCard(config, santriList.length, bold, semiBold, regular));
    contentWidgets.add(pw.SizedBox(height: 16));

    // 3. Render each Santri
    for (int i = 0; i < santriList.length; i++) {
      final santri = santriList[i];

      // Page break for subsequent students so each student starts on fresh page
      if (i > 0) {
        contentWidgets.add(pw.NewPage());
      }

      final allRecords = recordsBySantriId[santri.id] ?? [];
      final filtered = allRecords.where((r) {
        final d = _mid(r.tanggalSetoran);
        return d.compareTo(sD) >= 0 && d.compareTo(eD) <= 0;
      }).toList();

      final groups = _group(filtered);
      final ziyadah = groups.where((g) => g.jenis.toLowerCase() == 'ziyadah').toList();
      final murajaah = groups.where((g) => g.jenis.toLowerCase() == 'murajaah').toList();
      final allAvg = groups.isEmpty
          ? 0
          : groups.map((g) => g.avg).reduce((a, b) => a + b) ~/ groups.length;

      final total = groups.length;

      // Compact Student Header (Name & NIS only, no sequence number)
      contentWidgets.add(_buildCompactStudentHeader(santri, bold, semiBold, regular));
      contentWidgets.add(pw.SizedBox(height: 10));

      // Summary Stats (Active dynamic counters per santri)
      contentWidgets.add(_buildSummaryStats(
        ziyadah.length,
        murajaah.length,
        allAvg,
        total,
        bold,
        semiBold,
        regular,
      ));
      contentWidgets.add(pw.SizedBox(height: 12));

      // Section Title: Rincian Setoran
      contentWidgets.add(_buildSectionTitle(t.laporanConfig.pdf.setoranDetailTitle, bold));
      contentWidgets.add(pw.SizedBox(height: 6));

      // Detail Table
      contentWidgets.add(_buildDetailTable(groups, semiBold, regular));
      contentWidgets.add(pw.SizedBox(height: 10));

      // Legend
      contentWidgets.add(_buildLegend(regular, semiBold));
      contentWidgets.add(pw.SizedBox(height: 16));
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (ctx) => contentWidgets,
        footer: (ctx) => _buildFooter(config.halaqohName, regular, semiBold, ctx),
      ),
    );

    return doc.save();
  }

  // ── Global Header (Minimalist & Modern Letterhead) ─────────────────────────

  static pw.Widget _buildGlobalHeader(
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
                  t.laporanConfig.pdf.titleHafalanHalaqohRecap,
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

  // ── Global Halaqoh Information Card (Page 1 Only) ─────────────────────────

  static pw.Widget _buildHalaqohInfoCard(
    LaporanHafalanHalaqohConfig config,
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
            label: t.laporanConfig.pdf.pembimbing,
            value: config.guruNama,
            bold: semiBold,
            regular: regular,
          ),
          _infoDivider(),
          _infoField(
            label: 'Kelas',
            value: config.kelas,
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

  // ── Compact Student Header (Nama & NIS Saja) ───────────────────────────────

  static pw.Widget _buildCompactStudentHeader(
    SantriModel santri,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: _border, width: 0.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Nama Santri with left accent bar
          pw.Expanded(
            child: pw.Row(
              children: [
                pw.Container(
                  width: 3,
                  height: 12,
                  decoration: pw.BoxDecoration(
                    color: _primary,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(1.5),
                    ),
                  ),
                ),
                pw.SizedBox(width: 6),
                pw.Text(
                  santri.nama,
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 10.5,
                    color: _textPri,
                  ),
                ),
              ],
            ),
          ),

          // NIS Santri
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: pw.BoxDecoration(
              color: _white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
              border: pw.Border.all(color: _border, width: 0.5),
            ),
            child: pw.Text(
              'NIS: ${santri.nis}',
              style: pw.TextStyle(
                font: semiBold,
                fontSize: 7.5,
                color: _textSec,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Stats (Minimalist 4-Column Metric Grid) ────────────────────────

  static pw.Widget _buildSummaryStats(
    int ziyadahCount,
    int murajaahCount,
    int avgScore,
    int total,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final bool hasData = total > 0;
    final String avgDisplay = hasData ? '$avgScore' : '-';
    final String predikatLabel = hasData ? _predikat(avgScore) : '-';
    final PdfColor gradeColor = hasData ? _predikatColor(avgScore) : _textSec;
    final PdfColor gradeBg = hasData ? _predikatBg(avgScore) : _surface;

    return pw.Row(
      children: [
        _statMetricCard(
          value: '$ziyadahCount',
          label: 'Ziyadah',
          color: _green,
          bgColor: _greenBg,
          bold: bold,
          regular: regular,
        ),
        pw.SizedBox(width: 8),
        _statMetricCard(
          value: '$murajaahCount',
          label: "Muraja'ah",
          color: _blue,
          bgColor: _blueBg,
          bold: bold,
          regular: regular,
        ),
        pw.SizedBox(width: 8),
        _statMetricCard(
          value: avgDisplay,
          label: t.laporanConfig.pdf.avgScore,
          color: gradeColor,
          bgColor: gradeBg,
          bold: bold,
          regular: regular,
        ),
        pw.SizedBox(width: 8),
        _statMetricCard(
          value: predikatLabel,
          label: t.laporanConfig.pdf.predikatHeader,
          color: gradeColor,
          bgColor: gradeBg,
          bold: bold,
          regular: regular,
        ),
      ],
    );
  }

  static pw.Widget _statMetricCard({
    required String value,
    required String label,
    required PdfColor color,
    required PdfColor bgColor,
    required pw.Font bold,
    required pw.Font regular,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
                fontSize: value.length > 6 ? 8.5 : 15,
                color: color,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              label,
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
    List<_Group> groups,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(color: _primary),
      children: [
        _th(t.laporanConfig.pdf.dateShort, semiBold),
        _th(t.laporanConfig.pdf.dayHeader, semiBold),
        _th(t.laporanConfig.pdf.typeHeader, semiBold),
        _th(
          t.laporanConfig.pdf.surahAyatHeader,
          semiBold,
          align: pw.TextAlign.left,
        ),
        _th(t.laporanConfig.pdf.juzHeader, semiBold),
        _th(t.laporanConfig.pdf.kelancaranHeader, semiBold, fontSize: 6),
        _th(t.laporanConfig.pdf.tajwidHeader, semiBold, fontSize: 6),
        _th(t.laporanConfig.pdf.predikatHeader, semiBold),
      ],
    );

    if (groups.isEmpty) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 14),
        decoration: pw.BoxDecoration(
          color: _surface,
          border: pw.Border.all(color: _border, width: 0.5),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Center(
          child: pw.Text(
            t.laporanConfig.pdf.noSetoranInPeriod,
            style: pw.TextStyle(
              font: regular,
              fontSize: 8,
              color: _textSec,
            ),
          ),
        ),
      );
    }

    final dataRows = groups.asMap().entries.expand((entry) {
      final idx = entry.key;
      final g = entry.value;
      final isEven = idx % 2 == 0;
      final bg = isEven ? _white : _surface;
      final avg = g.avg;
      final pColor = _predikatColor(avg);
      final pBg = _predikatBg(avg);
      final isZiyadah = g.jenis.toLowerCase() == 'ziyadah';

      final mainRow = pw.TableRow(
        decoration: pw.BoxDecoration(color: bg),
        children: [
          _td(_fmtDate.format(g.tanggal), regular, align: pw.TextAlign.center),
          _td(
            t.calendar.daysAbbr[(g.tanggal.weekday - 1) % 7],
            regular,
            align: pw.TextAlign.center,
          ),
          _tdBadge(
            isZiyadah ? 'Ziyadah' : "Muraja'ah",
            semiBold,
            isZiyadah ? _green : _blue,
            isZiyadah ? _greenBg : _blueBg,
          ),
          _td(_surahDisplay(g.records), regular),
          _td(_juzStr(g.records), regular, align: pw.TextAlign.center),
          _tdScore('${g.nilaiKelancaran}', semiBold, g.nilaiKelancaran),
          _tdScore('${g.nilaiTajwid}', semiBold, g.nilaiTajwid),
          _tdBadge(_predikat(avg), semiBold, pColor, pBg),
        ],
      );

      // Expand sub-rows for multi-surah groups
      if (g.records.length <= 1) return [mainRow];
      final sorted = [...g.records]
        ..sort((a, b) => a.surahId.compareTo(b.surahId));
      final subRows = sorted
          .skip(1)
          .map(
            (r) => pw.TableRow(
              decoration: pw.BoxDecoration(color: bg),
              children: [
                _td('', regular),
                _td('', regular),
                _td('', regular),
                _td(
                  '${r.surahName} (${r.ayatMulai}-${r.ayatSelesai})',
                  regular,
                ),
                _td('${r.juz}', regular, align: pw.TextAlign.center),
                _td('', regular),
                _td('', regular),
                _td('', regular),
              ],
            ),
          );
      return [mainRow, ...subRows];
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(44),
        1: const pw.FixedColumnWidth(26),
        2: const pw.FixedColumnWidth(54),
        3: const pw.FlexColumnWidth(),
        4: const pw.FixedColumnWidth(24),
        5: const pw.FixedColumnWidth(52),
        6: const pw.FixedColumnWidth(52),
        7: const pw.FixedColumnWidth(48),
      },
      children: [headerRow, ...dataRows],
    );
  }

  // ── Legend ────────────────────────────────────────────────────────────────

  static pw.Widget _buildLegend(pw.Font regular, pw.Font semiBold) {
    final items = [
      ('Ziyadah', _green, _greenBg),
      ("Muraja'ah", _blue, _blueBg),
      (t.laporanConfig.pdf.predikat.mumtaz, _green, _greenBg),
      (t.laporanConfig.pdf.predikat.jayyid, _yellow, _yellowBg),
      (t.laporanConfig.pdf.predikat.maqbul, _orange, _orangeBg),
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
                      padding: const pw.EdgeInsets.only(right: 8),
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                            alignment: pw.Alignment.center,
                            decoration: pw.BoxDecoration(
                              color: item.$3,
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(2),
                              ),
                              border: pw.Border.all(color: item.$2, width: 0.5),
                            ),
                            child: pw.Text(
                              item.$1,
                              style: pw.TextStyle(
                                font: semiBold,
                                fontSize: 6,
                                color: item.$2,
                              ),
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

  // ── Cell Helpers ──────────────────────────────────────────────────────────

  static pw.Widget _th(
    String text,
    pw.Font font, {
    pw.TextAlign align = pw.TextAlign.center,
    double fontSize = 6.5,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: fontSize, color: _white),
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

  static pw.Widget _tdScore(String text, pw.Font font, int score) {
    final color = _predikatColor(score);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 2),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Container(
          width: 24,
          height: 16,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: _predikatBg(score),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            border: pw.Border.all(color: color, width: 0.5),
          ),
          child: pw.Text(
            text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 7, color: color),
          ),
        ),
      ),
    );
  }

  static pw.Widget _tdBadge(
    String text,
    pw.Font font,
    PdfColor color,
    PdfColor bg,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 2),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
          decoration: pw.BoxDecoration(
            color: bg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            border: pw.Border.all(color: color, width: 0.5),
          ),
          child: pw.Text(
            text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 6.5, color: color),
          ),
        ),
      ),
    );
  }
}
