import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Dialog for starting an attendance session — date picker + session chips + action buttons.
/// Adapts session chips based on [programType]: 'reguler' (2) or 'takhassus' (5).
class MulaiAbsensiDialog extends StatefulWidget {
  final String programType;
  final void Function(DateTime date, String sesi) onScanBarcode;
  final void Function(DateTime date, String sesi)? onTandaiSemuaHadir;

  const MulaiAbsensiDialog({
    super.key,
    required this.onScanBarcode,
    this.onTandaiSemuaHadir,
    this.programType = 'reguler',
  });

  @override
  State<MulaiAbsensiDialog> createState() => _MulaiAbsensiDialogState();
}

class _MulaiAbsensiDialogState extends State<MulaiAbsensiDialog> {
  DateTime _selectedDate = DateTime.now();
  String _selectedSesi = 'shubuh';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Session definitions per program type
  List<_SessionDef> get _sessionDefs {
    if (widget.programType == 'takhassus') {
      return [
        _SessionDef('shubuh', t.absensi.mulaiAbsensi.shubuh, Icons.wb_twilight),
        _SessionDef('dhuha', t.absensi.mulaiAbsensi.dhuha, Icons.wb_sunny_outlined),
        _SessionDef('siang', t.absensi.mulaiAbsensi.siang, Icons.wb_sunny),
        _SessionDef('ashar', t.absensi.mulaiAbsensi.soreAshar, Icons.wb_sunny),
        _SessionDef('maghrib', t.absensi.mulaiAbsensi.maghrib, Icons.nights_stay_outlined),
      ];
    }
    return [
      _SessionDef('shubuh', t.absensi.mulaiAbsensi.shubuh, Icons.wb_twilight),
      _SessionDef('maghrib', t.absensi.mulaiAbsensi.maghrib, Icons.nights_stay_outlined),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: colors.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.absensi.dialogTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 22.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Tanggal Halaqoh ──
              Text(
                t.absensi.tanggalHalaqoh,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // ── Pilih Sesi ──
              Text(
                t.absensi.pilihSesi,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8.h),
              _buildSessionGrid(colors),
              SizedBox(height: 24.h),

              // ── Scan Barcode button ──
              PrimaryButton(
                width: double.infinity,
                height: 48.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onScanBarcode(_selectedDate, _selectedSesi);
                },
                icon: Icons.qr_code_scanner,
                label: t.absensi.scanBarcode,
              ),
              SizedBox(height: 10.h),

              // ── Tandai Semua Hadir button ──
              CustomOutlinedButton(
                width: double.infinity,
                height: 48.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onTandaiSemuaHadir?.call(
                    _selectedDate,
                    _selectedSesi,
                  );
                },
                icon: Icons.checklist,
                label: t.absensi.mulaiAbsensi.markAllPresent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build session chips — Row for reguler, Grid for takhassus
  Widget _buildSessionGrid(AppColorSet colors) {
    final defs = _sessionDefs;

    if (widget.programType == 'takhassus') {
      // 2-column grid: first 4 in pairs, last one centered
      return Column(
        children: [
          // Row 1: Shubuh, Dhuha
          Row(
            children: [
              Expanded(child: _buildSessionChip(defs[0], colors)),
              SizedBox(width: 10.w),
              Expanded(child: _buildSessionChip(defs[1], colors)),
            ],
          ),
          SizedBox(height: 10.h),
          // Row 2: Siang, Sore/Ashar
          Row(
            children: [
              Expanded(child: _buildSessionChip(defs[2], colors)),
              SizedBox(width: 10.w),
              Expanded(child: _buildSessionChip(defs[3], colors)),
            ],
          ),
          SizedBox(height: 10.h),
          // Row 3: Maghrib (full width)
          _buildSessionChip(defs[4], colors),
        ],
      );
    }

    // Reguler: single row
    return Row(
      children: [
        Expanded(child: _buildSessionChip(defs[0], colors)),
        SizedBox(width: 10.w),
        Expanded(child: _buildSessionChip(defs[1], colors)),
      ],
    );
  }

  Widget _buildSessionChip(_SessionDef def, AppColorSet colors) {
    final isSelected = _selectedSesi == def.value;

    return GestureDetector(
      onTap: () => setState(() => _selectedSesi = def.value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              def.icon,
              size: 20.sp,
              color: isSelected ? colors.textOnButton : colors.textSecondary,
            ),
            SizedBox(height: 4.h),
            Text(
              def.label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? colors.textOnButton : colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionDef {
  final String value;
  final String label;
  final IconData icon;

  const _SessionDef(this.value, this.label, this.icon);
}
