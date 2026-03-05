import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Bottom sheet shown after scanning a QR code — displays student info, status chips, notes, and save/cancel
class ScannerResultSheet extends StatefulWidget {
  final String name;
  final String nis;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const ScannerResultSheet({
    super.key,
    required this.name,
    required this.nis,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<ScannerResultSheet> createState() => _ScannerResultSheetState();
}

class _ScannerResultSheetState extends State<ScannerResultSheet> {
  String _selectedStatus = 'hadir';
  final TextEditingController _keteranganController = TextEditingController();

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: 12.h,
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Student info
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.border.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.person,
                  size: 26.sp,
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.absensi.nama(name: widget.name),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    t.absensi.nis(nis: widget.nis),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Status kehadiran label
          Text(
            t.absensi.statusKehadiran,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10.h),

          // Status chips
          Row(
            children: [
              _buildStatusChip('hadir', t.absensi.hadir, colors.primary, colors),
              SizedBox(width: 8.w),
              _buildStatusChip('sakit', t.absensi.sakit, colors.yellow, colors),
              SizedBox(width: 8.w),
              _buildStatusChip('izin', t.absensi.izin, colors.blue, colors),
              SizedBox(width: 8.w),
              _buildStatusChip('alfa', t.absensi.alfa, colors.red, colors),
            ],
          ),
          SizedBox(height: 18.h),

          // Keterangan field
          Container(
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _keteranganController,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: t.absensi.keterangan,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Poppins',
                  color: colors.textSecondary.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Batal button
              OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.border, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
                child: Text(
                  t.absensi.batal,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Simpan button
              ElevatedButton(
                onPressed: widget.onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
                child: Text(
                  t.absensi.simpan,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textOnButton,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    String value,
    String label,
    Color chipColor,
    AppColorSet colors,
  ) {
    final isSelected = _selectedStatus == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : colors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? chipColor : colors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? colors.textOnButton : colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
