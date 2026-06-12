import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:csv/csv.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';

enum BulkImportType { guru, santri }

class BulkUploadDialog extends StatefulWidget {
  final BulkImportType importType;

  const BulkUploadDialog({super.key, required this.importType});

  static Future<void> show(
    BuildContext context, {
    required BulkImportType importType,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => BulkUploadDialog(importType: importType),
    );
  }

  @override
  State<BulkUploadDialog> createState() => _BulkUploadDialogState();
}

class _BulkUploadDialogState extends State<BulkUploadDialog> {
  Uint8List? _selectedBytes;

  bool _isProcessing = false;
  int _totalRows = 0;
  int _currentRow = 0;
  int _successCount = 0;
  int _failCount = 0;
  String _statusMessage = '';

  // ---------------------------------------------------------------------------
  // File picker
  // ---------------------------------------------------------------------------

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      if (file.bytes == null || file.bytes!.isEmpty) {
        setState(() {
          _statusMessage = 'Gagal membaca file. Coba pilih file lain.';
        });
        return;
      }

      setState(() {
        _selectedBytes = file.bytes;
        _statusMessage = 'File siap diproses: ${file.name}';
        _isProcessing = false;
        _totalRows = 0;
        _currentRow = 0;
        _successCount = 0;
        _failCount = 0;
      });
    }
  }



  // ---------------------------------------------------------------------------
  // Upload entry point
  // ---------------------------------------------------------------------------

  Future<void> _processUpload() async {
    if (_selectedBytes == null) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Membaca file...';
      _successCount = 0;
      _failCount = 0;
      _currentRow = 0;
    });

    try {
      // Decode bytes — tangani BOM (Byte Order Mark) dari Excel
      String raw = utf8.decode(_selectedBytes!, allowMalformed: true);
      if (raw.startsWith('\uFEFF')) raw = raw.substring(1);

      // Coba delimiter koma dulu; jika hasilnya 1 kolom, coba titik koma
      List<List<dynamic>> rows = const CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
      ).convert(raw);

      if (rows.isNotEmpty && rows.first.length == 1) {
        rows = const CsvToListConverter(
          eol: '\n',
          fieldDelimiter: ';',
        ).convert(raw);
      }

      if (rows.isEmpty || rows.length < 2) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'File kosong atau tidak memiliki baris data!';
        });
        return;
      }

      final dataRows = rows.skip(1).toList(); // lewati baris header

      // Filter baris yang benar-benar kosong (semua cell kosong/null)
      final validRows = dataRows.where((row) {
        if (row.isEmpty) return false;
        final allEmpty = row.every((cell) => cell == null || cell.toString().trim().isEmpty);
        return !allEmpty;
      }).toList();

      _totalRows = validRows.length;

      if (_totalRows == 0) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Tidak ada baris data yang valid untuk diunggah!';
        });
        return;
      }

      setState(() => _statusMessage = 'Memproses $_totalRows baris...');

      if (widget.importType == BulkImportType.guru) {
        await _processGuruRows(validRows);
      } else {
        await _processSantriRows(validRows);
      }
    } catch (e) {
      Logger().e('Error parsing csv', error: e);
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Gagal membaca format file. Pastikan file CSV valid.';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Guru rows
  // ---------------------------------------------------------------------------

  Future<void> _processGuruRows(List<List<dynamic>> rows) async {
    final cubit = context.read<GuruCubit>();
    final models = <GuruModel>[];

    for (final row in rows) {
      if (row.length >= 3 && row[0].toString().trim().isNotEmpty && row[1].toString().trim().isNotEmpty) {
        models.add(
          GuruModel(
            id: '',
            nip: row[0].toString().trim(),
            nama: row[1].toString().trim(),
            phone: row.length > 3 ? row[3].toString().trim() : null,
            program: row[2].toString().trim().toUpperCase() == 'T' ? 'T' : 'R',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        // Baris tidak lengkap (misal NIP/Nama kosong) masuk hitungan gagal
        _failCount++;
      }
    }

    if (models.isNotEmpty) {
      final int chunkSize = 50;
      for (int i = 0; i < models.length; i += chunkSize) {
        if (!mounted) break;
        
        final chunk = models.skip(i).take(chunkSize).toList();
        final endIdx = (i + chunk.length).clamp(0, models.length);

        if (mounted) {
          setState(() {
            _statusMessage = 'Menyimpan $endIdx / ${models.length} ke server...';
          });
        }
        
        try {
          final successCount = await cubit.addBulkGuru(chunk);
          _successCount += successCount;
          _failCount += (chunk.length - successCount);
        } catch (e) {
          _failCount += chunk.length;
          // Tampilkan snackbar untuk kegagalan utama
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceAll('Exception: ', '')),
                backgroundColor: Colors.red,
              ),
            );
          }
        }

        _currentRow += chunk.length;
        if (_currentRow > _totalRows) _currentRow = _totalRows;
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _currentRow = _totalRows;
        _statusMessage =
            'Selesai! Sukses: $_successCount, Gagal: $_failCount\n(Data Gagal biasanya karena NIP sudah terdaftar)';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Santri rows
  // ---------------------------------------------------------------------------

  Future<void> _processSantriRows(List<List<dynamic>> rows) async {
    final cubit = context.read<SantriCubit>();
    final models = <SantriModel>[];

    for (final row in rows) {
      if (row.length >= 3 && row[0].toString().trim().isNotEmpty && row[1].toString().trim().isNotEmpty) {
        final kelasRaw = row[2].toString().trim().toUpperCase();
        final k = kelasRaw.replaceAll(RegExp(r'[RT]'), '');
        final p = kelasRaw.endsWith('T') ? 'T' : 'R';

        models.add(
          SantriModel(
            id: '',
            nis: row[0].toString().trim(),
            nama: row[1].toString().trim(),
            kelas: k.isEmpty ? '7' : k,
            program: p,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        // Baris tidak lengkap (misal NIS/Nama kosong) masuk hitungan gagal
        _failCount++;
      }
    }

    if (models.isNotEmpty) {
      final int chunkSize = 50;
      for (int i = 0; i < models.length; i += chunkSize) {
        if (!mounted) break;
        
        final chunk = models.skip(i).take(chunkSize).toList();
        final endIdx = (i + chunk.length).clamp(0, models.length);

        if (mounted) {
          setState(() {
            _statusMessage = 'Menyimpan $endIdx / ${models.length} ke server...';
          });
        }
        
        try {
          final successCount = await cubit.addBulkSantri(chunk);
          _successCount += successCount;
          _failCount += (chunk.length - successCount);
        } catch (e) {
          _failCount += chunk.length;
          // Tampilkan snackbar untuk kegagalan utama
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceAll('Exception: ', '')),
                backgroundColor: Colors.red,
              ),
            );
          }
        }

        _currentRow += chunk.length;
        if (_currentRow > _totalRows) _currentRow = _totalRows;
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _currentRow = _totalRows;
        _statusMessage =
            'Selesai! Sukses: $_successCount, Gagal: $_failCount\n(Data Gagal biasanya karena NIS sudah terdaftar)';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDone = _currentRow > 0 && _currentRow == _totalRows;

    return Container(
      padding: EdgeInsets.only(
        top: 24.h,
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).padding.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title row ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      t.addData.bulkTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      t.addData.bulkSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _isProcessing ? null : () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: _isProcessing ? colors.border : colors.textSecondary,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // ── Upload area ────────────────────────────────────────────────────
          GestureDetector(
            onTap: _isProcessing ? null : _pickFile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                color: colors.primary.withValues(alpha: 0.03),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.table_chart,
                        color: colors.primary,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    t.addData.bulkTapUpload,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      _statusMessage.isEmpty
                          ? t.addData.bulkFormat
                          : _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _statusMessage.isNotEmpty ? 13.sp : 12.sp,
                        fontWeight: _statusMessage.isNotEmpty
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _statusMessage.isNotEmpty
                            ? colors.primary
                            : colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  if (_isProcessing) ...[
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: LinearProgressIndicator(
                        value: (_currentRow == 0 && _isProcessing) || _totalRows == 0
                            ? null
                            : (_currentRow / _totalRows),
                        color: colors.primary,
                        backgroundColor: colors.border,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // ── Action button ──────────────────────────────────────────────────
          PrimaryButton(
            width: double.infinity,
            onPressed: () {
              if (_isProcessing) return;
              if (_selectedBytes == null || isDone) {
                Navigator.of(context).pop();
                return;
              }
              _processUpload();
            },
            icon: isDone ? Icons.check_circle : Icons.cloud_upload,
            label: isDone ? 'Selesai' : t.addData.bulkUploadButton,
            borderRadius: 25.r,
          ),
        ],
      ),
    );
  }
}
