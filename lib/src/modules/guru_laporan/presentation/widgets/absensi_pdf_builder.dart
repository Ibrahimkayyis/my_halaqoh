import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../guru_absensi/domain/models/absensi_model.dart';
import '../../domain/helpers/schedule_helper.dart';
import '../../domain/models/laporan_absensi_config.dart';

/// Pure static helper that builds a [pw.Document] and returns its bytes.
class AbsensiPdfBuilder {
  AbsensiPdfBuilder._();

  // ─── Helper Konversi Warna ─────────────────────────────────────────────────
  static PdfColor _toPdfColor(Color color) =>
      PdfColor.fromInt(color.toARGB32());

  // ─── Colour palette (Terhubung dengan AppColors.light) ───────────────────
  // Kita menggunakan AppColors.light karena PDF umumnya dicetak di kertas putih/terang

  // Warna Utama & Status
  static final _primary = _toPdfColor(AppColors.light.primary);

  static final _green = _toPdfColor(AppColors.light.green);
  static final _yellow = _toPdfColor(AppColors.light.yellow);
  static final _blue = _toPdfColor(AppColors.light.blue);
  static final _red = _toPdfColor(AppColors.light.red);

  // Warna Background, Teks & Border Semantik
  static final _background = _toPdfColor(
    AppColors.light.background,
  ); // Ditambahkan untuk header
  static final _textPrimary = _toPdfColor(AppColors.light.textPrimary);
  static final _textSecondary = _toPdfColor(AppColors.light.textSecondary);
  static final _border = _toPdfColor(AppColors.light.border);
  static final _borderLight = _toPdfColor(AppColors.light.borderLight);
  static final _surface = _toPdfColor(AppColors.light.surface);

  // Background Status (Tetap menggunakan Hex karena belum ada di AppColors)
  static final _greenBg = PdfColor.fromHex('#ECFDF5');
  static final _yellowBg = PdfColor.fromHex('#FFFBEB');
  static final _blueBg = PdfColor.fromHex('#EFF6FF');
  static final _redBg = PdfColor.fromHex('#FEF2F2');
  static final _white = PdfColors.white;

  // ─── Session definitions ───────────────────────────────────────────────────
  static List<String> _sessionKeys(String programType) =>
      programType == 'takhassus'
      ? ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib']
      : ['shubuh', 'maghrib'];

  static List<String> _sessionLabels(String programType) =>
      programType == 'takhassus'
      ? ['Shubuh', 'Dhuha', 'Siang', 'Ashar', 'Maghrib']
      : ['Shubuh', 'Maghrib'];

  // ─── Status helpers ────────────────────────────────────────────────────────
  static String _statusCode(String status) {
    switch (status.trim().toLowerCase()) {
      case 'hadir':
        return 'H';
      case 'sakit':
        return 'S';
      case 'izin':
        return 'I';
      case 'alfa':
        return 'A';
      default:
        return '-';
    }
  }

  static PdfColor _codeColor(String code) {
    switch (code) {
      case 'H':
        return _green;
      case 'S':
        return _yellow;
      case 'I':
        return _blue;
      case 'A':
        return _red;
      default:
        return _textSecondary;
    }
  }

  static PdfColor _codeBg(String code) {
    switch (code) {
      case 'H':
        return _greenBg;
      case 'S':
        return _yellowBg;
      case 'I':
        return _blueBg;
      case 'A':
        return _redBg;
      default:
        return _borderLight;
    }
  }

  // ─── Main entry ───────────────────────────────────────────────────────────
  static Future<Uint8List> build(
    LaporanAbsensiConfig config,
    List<AbsensiModel> allRecords,
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

    // 2. Filter records to date range
    final sD = _midnight(config.startDate);
    final eD = _midnight(config.endDate);
    final filtered = allRecords.where((r) {
      final d = _midnight(r.tanggal);
      return !d.isBefore(sD) && !d.isAfter(eD);
    }).toList();

    // 3. Build per-day map  { 'yyyy-MM-dd' → { sesiKey → statusCode } }
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

    // 4. Compute totals
    int hadir = 0, sakit = 0, izin = 0, alfa = 0;
    for (final day in byDay.values) {
      for (final code in day.values) {
        if (code == 'H') {
          hadir++;
        } else if (code == 'S') {
          sakit++;
        } else if (code == 'I') {
          izin++;
        } else if (code == 'A') {
          alfa++;
        }
      }
    }

    // 5. Build sorted day list for the full range
    final dayCount = eD.difference(sD).inDays + 1;
    final days = List.generate(
      dayCount,
      (i) => DateTime(sD.year, sD.month, sD.day + i),
    );

    // Use the real per-weekday schedule instead of a flat sessionsPerDay × dayCount.
    // Mon–Thu = full sessions; Fri/Sat/Sun = reduced sessions (see ScheduleHelper).
    final totalScheduled = ScheduleHelper.totalScheduledSessions(
      sD,
      eD,
      config.programType,
    );
    final rate = totalScheduled > 0 ? hadir / totalScheduled : 0.0;

    // 6. Period label
    final fmtFull = DateFormat('dd MMMM yyyy', 'id');
    final fmtMonth = DateFormat('MMMM yyyy', 'id');
    final period = config.range == ReportRange.monthly
        ? fmtMonth.format(config.startDate)
        : '${fmtFull.format(config.startDate)} – ${fmtFull.format(config.endDate)}';
    final printedOn = fmtFull.format(DateTime.now());

    // 7. Session labels for this programType
    final sLabels = _sessionLabels(config.programType);

    // ── Build document ────────────────────────────────────────────────────
    final doc = pw.Document(
      title: 'Laporan Absensi – ${config.santriName}',
      author: 'MyHalaqoh',
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 30),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (ctx) => [
          _buildHeader(logo, bold, semiBold, regular, period, printedOn),
          pw.SizedBox(height: 14),
          _buildStudentInfo(config, semiBold, regular, bold),
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
          pw.SizedBox(height: 16),
          _buildSectionTitle('Detail Kehadiran Harian', bold),
          pw.SizedBox(height: 6),
          _buildDetailTable(days, byDay, keys, sLabels, semiBold, regular),
          pw.SizedBox(height: 10),
          _buildLegend(regular, semiBold),
        ],
        footer: (ctx) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'MyHalaqoh — Sistem Manajemen Halaqoh',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7,
                  color: _textSecondary,
                ),
              ),
              pw.Text(
                'Halaman ${ctx.pageNumber} dari ${ctx.pagesCount}',
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
        color: _background, // Background diganti menjadi _background
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        // Ditambahkan border tipis agar header tetap terpisah jelas jika background sama dengan warna kertas
        border: pw.Border.all(color: _border, width: 0.5),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 48,
            height: 48,
            decoration: pw.BoxDecoration(
              color: _primary, // Lingkaran logo menggunakan warna _primary
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
                  ), // Text warna _primary
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Laporan Kehadiran Santri',
                  style: pw.TextStyle(
                    font: regular,
                    fontSize: 8.5,
                    color: _primary, // Text warna _primary
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
                  // Menggunakan _surface agar teks _primary tetap bisa terbaca (sebelumnya hardcode warna hijau tua)
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
                    color: _primary, // Text warna _primary
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Dicetak: $printedOn',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7,
                  color: _primary, // Text warna _primary
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStudentInfo(
    LaporanAbsensiConfig config,
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
              'Informasi Santri',
              style: pw.TextStyle(font: bold, fontSize: 9, color: _textPrimary),
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
                      'Nama Santri',
                      config.santriName,
                      semiBold,
                      regular,
                    ),
                    _infoCell('NIS', config.santriNis, semiBold, regular),
                  ],
                ),
                pw.TableRow(
                  children: [pw.SizedBox(height: 8), pw.SizedBox(height: 8)],
                ),
                pw.TableRow(
                  children: [
                    _infoCell('Halaqoh', config.halaqohName, semiBold, regular),
                    _infoCell('Pembimbing', config.guruNama, semiBold, regular),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              'Ringkasan Kehadiran',
              style: pw.TextStyle(font: bold, fontSize: 9, color: _textPrimary),
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
                          '$hadir',
                          'Hadir',
                          'H',
                          _green,
                          _greenBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                        _statCard(
                          '$sakit',
                          'Sakit',
                          'S',
                          _yellow,
                          _yellowBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                        _statCard(
                          '$izin',
                          'Izin',
                          'I',
                          _blue,
                          _blueBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                        _statCard(
                          '$alfa',
                          'Alfa',
                          'A',
                          _red,
                          _redBg,
                          bold,
                          semiBold,
                          regular,
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FixedColumnWidth(180),
                  },
                  children: [
                    pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 12),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                children: [
                                  pw.Text(
                                    'Tingkat Kehadiran  ',
                                    style: pw.TextStyle(
                                      font: regular,
                                      fontSize: 8.5,
                                      color: _textSecondary,
                                    ),
                                  ),
                                  pw.Text(
                                    pct,
                                    style: pw.TextStyle(
                                      font: bold,
                                      fontSize: 13,
                                      color: _green,
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 2),
                              pw.Text(
                                '$hadir dari $totalScheduled sesi terjadwal',
                                style: pw.TextStyle(
                                  font: regular,
                                  fontSize: 7.5,
                                  color: _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _progressBar(rate),
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

  static pw.Widget _buildSectionTitle(String title, pw.Font bold) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 3,
          height: 14,
          decoration: pw.BoxDecoration(
            color: _green,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Text(
          title,
          style: pw.TextStyle(font: bold, fontSize: 10, color: _textPrimary),
        ),
      ],
    );
  }

  static pw.Widget _buildDetailTable(
    List<DateTime> days,
    Map<String, Map<String, String>> byDay,
    List<String> keys,
    List<String> sLabels,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    final sessionCount = keys.length;
    final double sessionColW = sessionCount <= 2 ? 46.0 : 42.0;

    final Map<int, pw.TableColumnWidth> colWidths = {
      0: const pw.FixedColumnWidth(44),
      1: const pw.FixedColumnWidth(26),
      for (int i = 0; i < sessionCount; i++)
        (i + 2): pw.FixedColumnWidth(sessionColW),
      (sessionCount + 2): const pw.FlexColumnWidth(),
    };

    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(color: _textPrimary),
      children: [
        _thCell('Tanggal', semiBold, color: _white),
        _thCell('Hari', semiBold, color: _white),
        for (final label in sLabels)
          _thCell(
            label,
            semiBold,
            color: _white,
            fontSize: sessionCount > 2 ? 6.5 : 7.5,
          ),
        _thCell(
          'Keterangan',
          semiBold,
          color: _white,
          align: pw.TextAlign.left,
        ),
      ],
    );

    final dataRows = days.asMap().entries.map((entry) {
      final idx = entry.key;
      final date = entry.value;
      final dayData = byDay[_fmtKey.format(date)] ?? {};
      final note = _buildNote(dayData, keys);
      final isEven = idx % 2 == 0;
      final isFriday = date.weekday == DateTime.friday;

      return pw.TableRow(
        decoration: pw.BoxDecoration(
          color: isFriday
              ? PdfColor.fromHex('#F0FDF4')
              : (isEven ? _white : _surface),
        ),
        children: [
          _tdCell(
            DateFormat('dd/MM/yy').format(date),
            regular,
            align: pw.TextAlign.center,
          ),
          _tdCell(
            _shortDay(date.weekday),
            isFriday ? semiBold : regular,
            align: pw.TextAlign.center,
            color: isFriday ? _green : null,
          ),
          for (final key in keys) _statusCell(dayData[key] ?? '-', semiBold),
          _tdCell(note, regular),
        ],
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.5),
      columnWidths: colWidths,
      children: [headerRow, ...dataRows],
    );
  }

  static pw.Widget _buildLegend(pw.Font regular, pw.Font semiBold) {
    final items = [
      ('H', 'Hadir'),
      ('S', 'Sakit'),
      ('I', 'Izin'),
      ('A', 'Alfa'),
      ('-', 'Tidak ada sesi'),
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
            'Keterangan Status',
            style: pw.TextStyle(
              font: semiBold,
              fontSize: 7.5,
              color: _textSecondary,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: items.map((item) {
              final code = item.$1;
              final label = item.$2;
              final color = _codeColor(code);
              final bg = _codeBg(code);
              return pw.Padding(
                padding: const pw.EdgeInsets.only(right: 10),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Container(
                      width: 18,
                      height: 18,
                      alignment: pw.Alignment.center,
                      decoration: pw.BoxDecoration(
                        color: code == '-' ? _borderLight : bg,
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(
                          color: code == '-' ? _border : color,
                          width: 0.8,
                        ),
                      ),
                      child: pw.Text(
                        code,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: semiBold,
                          fontSize: 7,
                          color: code == '-' ? _textSecondary : color,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(
                      label,
                      style: pw.TextStyle(
                        font: regular,
                        fontSize: 7.5,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Atomic widget helpers ────────────────────────────────────────────────

  static pw.Widget _statCard(
    String value,
    String label,
    String code,
    PdfColor accent,
    PdfColor bgColor,
    pw.Font bold,
    pw.Font semiBold,
    pw.Font regular,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(horizontal: 3),
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: accent, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 22,
            height: 22,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              color: accent,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Text(
              code,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: bold, fontSize: 8, color: _white),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: bold, fontSize: 22, color: accent),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            label,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: regular,
              fontSize: 7.5,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _progressBar(double rate) {
    const totalW = 180.0;
    final fillFraction = rate.clamp(0.0, 1.0);
    final fillW = totalW * fillFraction;
    final barColor = fillFraction >= 0.75
        ? _green
        : (fillFraction >= 0.5 ? _yellow : _red);

    return pw.SizedBox(
      width: totalW,
      height: 10,
      child: pw.Stack(
        children: [
          pw.Container(
            width: totalW,
            height: 10,
            decoration: pw.BoxDecoration(
              color: _border,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
          ),
          if (fillW > 0)
            pw.Container(
              width: fillW,
              height: 10,
              decoration: pw.BoxDecoration(
                color: barColor,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
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

  static pw.Widget _thCell(
    String text,
    pw.Font font, {
    pw.TextAlign align = pw.TextAlign.center,
    PdfColor? color,
    double fontSize = 7.5, // ← tambah parameter ini
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize, // ← gunakan di sini
          color: color ?? _textPrimary,
        ),
      ),
    );
  }

  static pw.Widget _tdCell(
    String text,
    pw.Font font, {
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          font: font,
          fontSize: 7.5,
          color: color ?? _textSecondary,
        ),
      ),
    );
  }

  static pw.Widget _statusCell(String code, pw.Font font) {
    final accent = _codeColor(code);
    final bg = _codeBg(code);
    final isDash = code == '-';

    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Container(
          width: 22,
          height: 22,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: isDash ? null : bg,
            shape: pw.BoxShape.circle,
            border: isDash
                ? pw.Border.all(color: _border, width: 0.5)
                : pw.Border.all(color: accent, width: 0.5),
          ),
          child: pw.Text(
            code,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: font,
              fontSize: 7.5,
              color: isDash ? _textSecondary : accent,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Utility ──────────────────────────────────────────────────────────────
  static final _fmtKey = DateFormat('yyyy-MM-dd');

  static DateTime _midnight(DateTime d) => DateTime(d.year, d.month, d.day);

  static String _shortDay(int weekday) {
    const n = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return n[(weekday - 1) % 7];
  }

  static String _buildNote(Map<String, String> dayData, List<String> keys) {
    final absent = <String>[];
    for (final key in keys) {
      if (dayData[key] == 'A') absent.add(_sesiLabel(key));
    }
    if (absent.isNotEmpty) return 'Alfa: ${absent.join(', ')}';

    final sakit = <String>[];
    for (final key in keys) {
      if (dayData[key] == 'S') sakit.add(_sesiLabel(key));
    }
    if (sakit.isNotEmpty) return 'Sakit: ${sakit.join(', ')}';

    return '';
  }

  static String _sesiLabel(String key) {
    switch (key) {
      case 'shubuh':
        return 'Shubuh';
      case 'dhuha':
        return 'Dhuha';
      case 'siang':
        return 'Siang';
      case 'ashar':
        return 'Ashar';
      case 'maghrib':
        return 'Maghrib';
      default:
        return key;
    }
  }
}
