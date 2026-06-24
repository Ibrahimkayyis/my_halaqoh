import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../guru_hafalan/domain/models/hafalan_santri_model.dart';
import '../../domain/models/laporan_absensi_config.dart'; // for ReportRange
import '../../domain/models/laporan_hafalan_config.dart';

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

class HafalanPdfBuilder {
  HafalanPdfBuilder._();

  static PdfColor _pc(Color c) => PdfColor.fromInt(c.toARGB32());

  static final _primary = _pc(AppColors.light.primary);
  static final _green = _pc(AppColors.light.green);
  static final _yellow = _pc(AppColors.light.yellow);
  static final _blue = _pc(AppColors.light.blue);
  static final _orange = PdfColor.fromHex('#F97316');
  static final _textPri = _pc(AppColors.light.textPrimary);
  static final _textSec = _pc(AppColors.light.textSecondary);
  static final _border = _pc(AppColors.light.border);
  static final _surface = _pc(AppColors.light.surface);
  static final _bg = _pc(AppColors.light.background);
  static final _white = PdfColors.white;
  static final _greenBg = PdfColor.fromHex('#ECFDF5');
  static final _yellowBg = PdfColor.fromHex('#FFFBEB');
  static final _blueBg = PdfColor.fromHex('#EFF6FF');
  static final _orangeBg = PdfColor.fromHex('#FFF7ED');

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

  static Future<Uint8List> build(
    LaporanHafalanConfig config,
    List<HafalanSantriModel> allRecords,
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
        'assets/images/my_halaqoh_logo.png',
      )).buffer.asUint8List(),
    );

    final sD = _mid(config.startDate);
    final eD = _mid(config.endDate);
    final filtered = allRecords.where((r) {
      final d = _mid(r.tanggalSetoran);
      return d.compareTo(sD) >= 0 && d.compareTo(eD) <= 0;
    }).toList();

    final groups = _group(filtered);
    final ziyadah = groups.where((g) => g.jenis == 'Ziyadah').toList();
    final murajaah = groups.where((g) => g.jenis == 'Murajaah').toList();
    final allAvg = groups.isEmpty
        ? 0
        : groups.map((g) => g.avg).reduce((a, b) => a + b) ~/ groups.length;

    int mumtaz = 0, jayyid = 0, maqbul = 0;
    for (final g in groups) {
      final s = g.avg;
      if (s >= 85) {
        mumtaz++;
      } else if (s >= 70) {
        jayyid++;
      } else {
        maqbul++;
      }
    }
    final total = groups.length;

    final fmtFull = DateFormat('dd MMMM yyyy', t.$meta.locale.languageCode);
    final fmtMon = DateFormat('MMMM yyyy', t.$meta.locale.languageCode);
    final period = config.range == ReportRange.monthly
        ? fmtMon.format(config.startDate)
        : '${fmtFull.format(config.startDate)} – ${fmtFull.format(config.endDate)}';
    final printedOn = fmtFull.format(DateTime.now());

    final doc = pw.Document(
      title: '${t.laporanConfig.memorizationReport} – ${config.santriName}',
      author: 'MyHalaqoh',
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 30),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (ctx) => [
          _header(logo, bold, semiBold, regular, period, printedOn),
          pw.SizedBox(height: 14),
          _studentInfo(config, semiBold, regular, bold),
          pw.SizedBox(height: 14),
          _summary(
            ziyadah.length,
            murajaah.length,
            allAvg,
            mumtaz,
            jayyid,
            maqbul,
            total,
            bold,
            semiBold,
            regular,
          ),
          pw.SizedBox(height: 16),
          _sectionTitle(t.laporanConfig.pdf.setoranDetailTitle, bold),
          pw.SizedBox(height: 6),
          _detailTable(groups, semiBold, regular),
          pw.SizedBox(height: 10),
          _legend(regular, semiBold),
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
                  color: _textSec,
                ),
              ),
              pw.Text(
                t.laporanConfig.pdf.pageLabel(page: '${ctx.pageNumber}', total: '${ctx.pagesCount}'),
                style: pw.TextStyle(
                  font: semiBold,
                  fontSize: 7,
                  color: _textSec,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return doc.save();
  }

  static pw.Widget _header(
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
        color: _bg,
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
                  t.laporanConfig.pdf.titleMemorization,
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

  static pw.Widget _studentInfo(
    LaporanHafalanConfig config,
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
              color: _surface,
              border: pw.Border.all(color: _border, width: 0.5),
            ),
            child: pw.Text(
              t.laporanConfig.pdf.studentInfo,
              style: pw.TextStyle(font: bold, fontSize: 9, color: _textPri),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    _infoCell(
                      t.laporanConfig.pdf.studentName,
                      config.santriName,
                      semiBold,
                      regular,
                    ),
                    _infoCell(t.laporanConfig.pdf.nis, config.santriNis, semiBold, regular),
                  ],
                ),
                pw.TableRow(
                  children: [pw.SizedBox(height: 8), pw.SizedBox(height: 8)],
                ),
                pw.TableRow(
                  children: [
                    _infoCell(t.laporanConfig.pdf.halaqoh, config.halaqohName, semiBold, regular),
                    _infoCell(t.laporanConfig.pdf.pembimbing, config.guruNama, semiBold, regular),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _summary(
    int baru,
    int ulang,
    int avgScore,
    int mumtaz,
    int jayyid,
    int maqbul,
    int total,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final predikatLabel = avgScore >= 85
        ? t.laporanConfig.pdf.predikat.mumtaz
        : (avgScore >= 70 ? t.laporanConfig.pdf.predikat.jayyid : t.laporanConfig.pdf.predikat.maqbul);
    final predikatColor = _predikatColor(avgScore);

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
              color: _surface,
              border: pw.Border(
                bottom: pw.BorderSide(color: _border, width: 0.5),
              ),
            ),
            child: pw.Text(
              t.laporanConfig.pdf.summaryMemorization,
              style: pw.TextStyle(font: bold, fontSize: 9, color: _textPri),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        _statCard(
                          '$baru',
                          t.laporanConfig.pdf.ziyadah,
                          _green,
                          _greenBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                        _statCard(
                          '$ulang',
                          t.laporanConfig.pdf.murajaah,
                          _blue,
                          _blueBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                        _statCard(
                          '$avgScore',
                          t.laporanConfig.pdf.avgScore,
                          _yellow,
                          _yellowBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                        _statCard(
                          predikatLabel,
                          t.laporanConfig.pdf.predikatHeader,
                          predikatColor,
                          _predikatBg(avgScore),
                          bold,
                          semiBold,
                          regular,
                        ),
                      ],
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

  static pw.Widget _sectionTitle(String title, pw.Font bold) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 3,
          height: 14,
          decoration: pw.BoxDecoration(
            color: _primary,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Text(
          title,
          style: pw.TextStyle(font: bold, fontSize: 10, color: _textPri),
        ),
      ],
    );
  }

  static pw.Widget _detailTable(
    List<_Group> groups,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(color: _textPri),
      children: [
        _th(t.laporanConfig.pdf.dateShort, semiBold),
        _th(t.laporanConfig.pdf.dayHeader, semiBold),
        _th(t.laporanConfig.pdf.typeHeader, semiBold),
        _th(t.laporanConfig.pdf.surahAyatHeader, semiBold, align: pw.TextAlign.left),
        _th(t.laporanConfig.pdf.juzHeader, semiBold),
        _th(t.laporanConfig.pdf.kelancaranHeader, semiBold, fontSize: 6),
        _th(t.laporanConfig.pdf.tajwidHeader, semiBold, fontSize: 6),
        _th(t.laporanConfig.pdf.predikatHeader, semiBold),
      ],
    );

    final dataRows = groups.asMap().entries.expand((entry) {
      final idx = entry.key;
      final g = entry.value;
      final isEven = idx % 2 == 0;
      final bg = isEven ? _white : _surface;
      final avg = g.avg;
      final pColor = _predikatColor(avg);
      final pBg = _predikatBg(avg);
      final isZiyadah = g.jenis == 'Ziyadah';

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
            isZiyadah ? t.laporanConfig.pdf.baruCode : t.laporanConfig.pdf.ulangCode,
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
        0: const pw.FixedColumnWidth(46),
        1: const pw.FixedColumnWidth(26),
        2: const pw.FixedColumnWidth(36),
        3: const pw.FlexColumnWidth(),
        4: const pw.FixedColumnWidth(22),
        5: const pw.FixedColumnWidth(54),
        6: const pw.FixedColumnWidth(54),
        7: const pw.FixedColumnWidth(46),
      },
      children: [headerRow, ...dataRows],
    );
  }

  static pw.Widget _legend(pw.Font regular, pw.Font semiBold) {
    final items = [
      (t.laporanConfig.pdf.baruCode, t.laporanConfig.pdf.ziyadahLabel, _green, _greenBg),
      (t.laporanConfig.pdf.ulangCode, t.laporanConfig.pdf.murajaahLabel, _blue, _blueBg),
      (t.laporanConfig.pdf.predikat.mumtaz, '≥ 85', _green, _greenBg),
      (t.laporanConfig.pdf.predikat.jayyid, '≥ 70', _yellow, _yellowBg),
      (t.laporanConfig.pdf.predikat.maqbul, '< 70', _orange, _orangeBg),
    ];
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: pw.BoxDecoration(
        color: _surface,
        border: pw.Border.all(color: _border, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t.laporanConfig.pdf.keteranganLabel,
            style: pw.TextStyle(font: semiBold, fontSize: 7.5, color: _textSec),
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: items
                .map(
                  (item) => pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 10),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 32,
                          height: 14,
                          alignment: pw.Alignment.center,
                          decoration: pw.BoxDecoration(
                            color: item.$4,
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(3),
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
                            fontSize: 7,
                            color: _textSec,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── Atomic helpers ──────────────────────────────────────────────────────────

  static pw.Widget _statCard(
    String value,
    String label,
    PdfColor accent,
    PdfColor bg,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(horizontal: 3),
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: accent, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            value,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: bold,
              fontSize: value.length > 6 ? 9 : 20,
              color: accent,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            label,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: regular, fontSize: 7, color: _textSec),
          ),
        ],
      ),
    );
  }

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
            style: pw.TextStyle(font: regular, fontSize: 7.5, color: _textSec),
          ),
          pw.SizedBox(height: 1),
          pw.Text(
            value,
            style: pw.TextStyle(font: semiBold, fontSize: 9, color: _textPri),
          ),
        ],
      ),
    );
  }

  static pw.Widget _th(
    String text,
    pw.Font font, {
    pw.TextAlign align = pw.TextAlign.center,
    double fontSize = 7,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(font: font, fontSize: 7.5, color: _textSec),
      ),
    );
  }

  static pw.Widget _tdScore(String text, pw.Font font, int score) {
    final color = _predikatColor(score);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Container(
          width: 26,
          height: 18,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: _predikatBg(score),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
            border: pw.Border.all(color: color, width: 0.5),
          ),
          child: pw.Text(
            text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 7.5, color: color),
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
      padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: pw.BoxDecoration(
            color: bg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
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
}
