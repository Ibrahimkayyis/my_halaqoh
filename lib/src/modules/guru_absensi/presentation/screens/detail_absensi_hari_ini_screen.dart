import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Detail Absensi Hari Ini — today's attendance with status dropdowns
@RoutePage()
class DetailAbsensiHariIniScreen extends StatefulWidget {
  const DetailAbsensiHariIniScreen({super.key});

  @override
  State<DetailAbsensiHariIniScreen> createState() =>
      _DetailAbsensiHariIniScreenState();
}

class _DetailAbsensiHariIniScreenState
    extends State<DetailAbsensiHariIniScreen> {
  String _selectedSesi = 'shubuh';

  // 10 santri with default status "belum"
  final List<Map<String, String>> _santriList = [
    {'name': 'Ahmad', 'nis': '123456'},
    {'name': 'Fauzan', 'nis': '123457'},
    {'name': 'Yusuf', 'nis': '123458'},
    {'name': 'Ibrahim', 'nis': '123459'},
    {'name': 'Khalid', 'nis': '123460'},
    {'name': 'Usman', 'nis': '123461'},
    {'name': 'Ghulam', 'nis': '123462'},
    {'name': 'Haikal', 'nis': '123463'},
    {'name': 'Fikrie', 'nis': '123464'},
    {'name': 'Ghatfhan', 'nis': '123465'},
  ];

  // Status per santri: index -> status string
  late Map<int, String> _santriStatuses;

  final List<String> _statusOptions = [
    'belum',
    'hadir',
    'sakit',
    'izin',
    'alfa',
  ];

  @override
  void initState() {
    super.initState();
    _santriStatuses = {
      for (int i = 0; i < _santriList.length; i++) i: 'belum'
    };
  }

  // Count stats
  Map<String, int> get _stats {
    int hadir = 0, sakit = 0, izin = 0, alfa = 0, belum = 0;
    for (final status in _santriStatuses.values) {
      switch (status) {
        case 'hadir':
          hadir++;
          break;
        case 'sakit':
          sakit++;
          break;
        case 'izin':
          izin++;
          break;
        case 'alfa':
          alfa++;
          break;
        default:
          belum++;
      }
    }
    return {
      'hadir': hadir,
      'sakit': sakit,
      'izin': izin,
      'alfa': alfa,
      'belum': belum,
    };
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'hadir':
        return t.detailAbsensiHariIni.hadir;
      case 'sakit':
        return t.detailAbsensiHariIni.sakit;
      case 'izin':
        return t.detailAbsensiHariIni.izin;
      case 'alfa':
        return t.detailAbsensiHariIni.alfa;
      default:
        return t.detailAbsensiHariIni.belumDiabsen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stats = _stats;
    final now = DateTime.now();
    final dayName = DateFormat('EEEE', 'id').format(now);
    final dateStr = DateFormat('d MMMM yyyy', 'id').format(now);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Header card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.detailAbsensiHariIni.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14.sp,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '$dayName, $dateStr',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Status chips
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.hadir} (${stats['hadir']})',
                          colors.primary,
                          colors,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.sakit} (${stats['sakit']})',
                          colors.yellow,
                          colors,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.izin} (${stats['izin']})',
                          colors.blue,
                          colors,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.alfa} (${stats['alfa']})',
                          colors.red,
                          colors,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.belumAbsen} (${stats['belum']})',
                          colors.textSecondary,
                          colors,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Session tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Row(
                  children: [
                    _buildSessionTab('shubuh', t.absensi.shubuh, colors),
                    _buildSessionTab('maghrib', t.absensi.maghrib, colors),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Daftar Kehadiran header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                t.detailAbsensiHariIni.daftarKehadiranSantri,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Santri list with dropdowns
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _santriList.length,
                itemBuilder: (context, index) {
                  final santri = _santriList[index];
                  return _buildSantriCard(
                    index,
                    santri['name']!,
                    santri['nis']!,
                    colors,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, Color color, AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildSessionTab(String value, String label, AppColorSet colors) {
    final isSelected = _selectedSesi == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSesi = value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? colors.textOnButton : colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSantriCard(
    int index,
    String name,
    String nis,
    AppColorSet colors,
  ) {
    final currentStatus = _santriStatuses[index] ?? 'belum';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 20.sp,
              color: colors.primary,
            ),
          ),
          SizedBox(width: 12.w),

          // Name and NIS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'NIS: $nis',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Animated Custom Dropdown
          SizedBox(
            width: 140.w,
            child: CustomDropdown<String>(
              items: _statusOptions,
              initialItem: currentStatus,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _santriStatuses[index] = value);
                }
              },
              listItemBuilder: (context, item, isSelected, onItemSelect) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Text(
                    _getStatusLabel(item),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: _getStatusTextColor(item, colors),
                    ),
                  ),
                );
              },
              headerBuilder: (context, selectedItem, enabled) {
                return Text(
                  _getStatusLabel(selectedItem),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: _getStatusTextColor(selectedItem, colors),
                  ),
                );
              },
              closedHeaderPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              decoration: CustomDropdownDecoration(
                closedBorder: Border.all(
                  color: _getStatusBorderColor(currentStatus, colors),
                  width: 1,
                ),
                closedBorderRadius: BorderRadius.circular(10.r),
                closedFillColor: _getStatusBgColor(currentStatus, colors),
                expandedBorderRadius: BorderRadius.circular(10.r),
                expandedFillColor: colors.surface,
                expandedBorder: Border.all(
                  color: colors.border,
                  width: 1,
                ),
                closedSuffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 16.sp,
                  color: _getStatusTextColor(currentStatus, colors),
                ),
                expandedSuffixIcon: Icon(
                  Icons.keyboard_arrow_up,
                  size: 16.sp,
                  color: colors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBgColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir':
        return colors.primary.withValues(alpha: 0.1);
      case 'sakit':
        return colors.yellow.withValues(alpha: 0.1);
      case 'izin':
        return colors.blue.withValues(alpha: 0.1);
      case 'alfa':
        return colors.red.withValues(alpha: 0.1);
      default:
        return colors.border.withValues(alpha: 0.2);
    }
  }

  Color _getStatusBorderColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir':
        return colors.primary.withValues(alpha: 0.3);
      case 'sakit':
        return colors.yellow.withValues(alpha: 0.3);
      case 'izin':
        return colors.blue.withValues(alpha: 0.3);
      case 'alfa':
        return colors.red.withValues(alpha: 0.3);
      default:
        return colors.border;
    }
  }

  Color _getStatusTextColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir':
        return colors.primary;
      case 'sakit':
        return colors.yellow;
      case 'izin':
        return colors.blue;
      case 'alfa':
        return colors.red;
      default:
        return colors.textSecondary;
    }
  }
}
