import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Detail Absensi Hari Ini.
///
/// Receives [scannedNisList] from [BarcodeScannerScreen].
/// Santri whose NIS is in the list start with status "hadir".
/// Santri not yet scanned start with status "belum" and can be changed
/// via dropdown.
@RoutePage()
class DetailAbsensiHariIniScreen extends StatefulWidget {
  final List<String> scannedNisList;

  const DetailAbsensiHariIniScreen({
    super.key,
    this.scannedNisList = const [],
  });

  @override
  State<DetailAbsensiHariIniScreen> createState() =>
      _DetailAbsensiHariIniScreenState();
}

class _DetailAbsensiHariIniScreenState
    extends State<DetailAbsensiHariIniScreen>
    with SingleTickerProviderStateMixin {
  // ── Tab controller (replaces _selectedSesi string) ────────────────────────
  late TabController _tabController;

  // ── Dummy santri data ─────────────────────────────────────────────────────
  final List<Map<String, String>> _santriList = [
    {'name': 'Ahmad',    'nis': '220512140601'},
    {'name': 'Fauzan',   'nis': '220512140602'},
    {'name': 'Yusuf',    'nis': '220512140603'},
    {'name': 'Ibrahim',  'nis': '220512140604'},
    {'name': 'Khalid',   'nis': '220512140605'},
    {'name': 'Usman',    'nis': '220512140606'},
    {'name': 'Ghulam',   'nis': '220512140607'},
    {'name': 'Haikal',   'nis': '220512140608'},
    {'name': 'Fikrie',   'nis': '220512140609'},
    {'name': 'Ghatfhan', 'nis': '220512140610'},
  ];

  late Map<int, String> _santriStatuses;

  final List<String> _statusOptions = [
    'belum', 'hadir', 'sakit', 'izin', 'alfa',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _santriStatuses = {
      for (int i = 0; i < _santriList.length; i++)
        i: widget.scannedNisList.contains(_santriList[i]['nis'])
            ? 'hadir'
            : 'belum',
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Stats ──────────────────────────────────────────────────────────────────
  Map<String, int> get _stats {
    int hadir = 0, sakit = 0, izin = 0, alfa = 0, belum = 0;
    for (final status in _santriStatuses.values) {
      switch (status) {
        case 'hadir': hadir++; break;
        case 'sakit': sakit++; break;
        case 'izin':  izin++;  break;
        case 'alfa':  alfa++;  break;
        default:      belum++; break;
      }
    }
    return {
      'hadir': hadir, 'sakit': sakit,
      'izin': izin,   'alfa': alfa, 'belum': belum,
    };
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'hadir': return t.detailAbsensiHariIni.hadir;
      case 'sakit': return t.detailAbsensiHariIni.sakit;
      case 'izin':  return t.detailAbsensiHariIni.izin;
      case 'alfa':  return t.detailAbsensiHariIni.alfa;
      default:      return t.detailAbsensiHariIni.belumDiabsen;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stats = _stats;
    final now = DateTime.now();
    final dayName = DateFormat('EEEE', 'id').format(now);
    final dateStr = DateFormat('d MMMM yyyy', 'id').format(now);

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final confirmed = await ConfirmSaveDialog.show(context);
          if (confirmed && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Absensi hari ini berhasil disimpan!',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: colors.primary,
              ),
            );
          }
        },
        backgroundColor: colors.primary,
        icon: Icon(Icons.save, color: colors.textOnButton),
        label: Text(
          t.absensi.simpan,
          style: TextStyle(
            color: colors.textOnButton,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back button ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // ── Header card ────────────────────────────────────────────────
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
                        Icon(Icons.calendar_today,
                            size: 14.sp, color: colors.textSecondary),
                        SizedBox(width: 6.w),
                        Text(
                          '$dayName, $dateStr',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.qr_code_scanner,
                            size: 14.sp, color: colors.primary),
                        SizedBox(width: 6.w),
                        Text(
                          '${widget.scannedNisList.length} santri berhasil di-scan',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.hadir} (${stats['hadir']})',
                          colors.primary,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.sakit} (${stats['sakit']})',
                          colors.yellow,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.izin} (${stats['izin']})',
                          colors.blue,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.alfa} (${stats['alfa']})',
                          colors.red,
                        ),
                        _buildStatChip(
                          '${t.detailAbsensiHariIni.belumAbsen} (${stats['belum']})',
                          colors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Session tab selector (global widget) ───────────────────────
            AppTabSelector(
              controller: _tabController,
              tabs: [t.absensi.shubuh, t.absensi.maghrib],
            ),
            SizedBox(height: 20.h),

            // ── List header ────────────────────────────────────────────────
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

            // ── Santri list ────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
                itemCount: _santriList.length,
                itemBuilder: (context, index) {
                  final santri = _santriList[index];
                  final wasScanned =
                      widget.scannedNisList.contains(santri['nis']);
                  return _buildSantriCard(
                    index,
                    santri['name']!,
                    santri['nis']!,
                    wasScanned,
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

  // ── Stat chip ──────────────────────────────────────────────────────────────
  Widget _buildStatChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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

  // ── Santri card ────────────────────────────────────────────────────────────
  Widget _buildSantriCard(
    int index,
    String name,
    String nis,
    bool wasScanned,
    AppColorSet colors,
  ) {
    final currentStatus = _santriStatuses[index] ?? 'belum';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: wasScanned
            ? Border.all(
                color: colors.primary.withValues(alpha: 0.3), width: 1.5)
            : null,
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
              color: wasScanned
                  ? colors.primary.withValues(alpha: 0.1)
                  : colors.border.withValues(alpha: 0.3),
              border: Border.all(
                color: wasScanned
                    ? colors.primary.withValues(alpha: 0.2)
                    : colors.border,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 20.sp,
              color: wasScanned ? colors.primary : colors.textSecondary,
            ),
          ),
          SizedBox(width: 12.w),

          // Name + NIS + scan badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: wasScanned
                              ? colors.primary
                              : colors.textPrimary,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (wasScanned) ...[
                      SizedBox(width: 5.w),
                      Icon(Icons.qr_code, size: 13.sp, color: colors.primary),
                    ],
                  ],
                ),
                Text(
                  nis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Status dropdown
          SizedBox(width: 8.w),
          SizedBox(
            width: 135.w,
            child: _buildStatusDropdown(index, currentStatus, colors),
          ),
        ],
      ),
    );
  }

  // ── Status dropdown ────────────────────────────────────────────────────────
  Widget _buildStatusDropdown(
      int index, String currentStatus, AppColorSet colors) {
    return CustomDropdown<String>(
      items: _statusOptions,
      initialItem: currentStatus,
      onChanged: (value) {
        if (value != null) setState(() => _santriStatuses[index] = value);
      },
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            _getStatusLabel(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: _getStatusTextColor(selectedItem, colors),
          ),
        );
      },
      closedHeaderPadding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: CustomDropdownDecoration(
        closedBorder:
            Border.all(color: _getStatusBorderColor(currentStatus, colors), width: 1),
        closedBorderRadius: BorderRadius.circular(10.r),
        closedFillColor: _getStatusBgColor(currentStatus, colors),
        expandedBorderRadius: BorderRadius.circular(10.r),
        expandedFillColor: colors.surface,
        expandedBorder: Border.all(color: colors.border, width: 1),
        closedSuffixIcon: Icon(Icons.keyboard_arrow_down,
            size: 16.sp,
            color: _getStatusTextColor(currentStatus, colors)),
        expandedSuffixIcon:
            Icon(Icons.keyboard_arrow_up, size: 16.sp, color: colors.primary),
      ),
    );
  }

  // ── Color helpers ──────────────────────────────────────────────────────────
  Color _getStatusBgColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir': return colors.primary.withValues(alpha: 0.1);
      case 'sakit': return colors.yellow.withValues(alpha: 0.1);
      case 'izin':  return colors.blue.withValues(alpha: 0.1);
      case 'alfa':  return colors.red.withValues(alpha: 0.1);
      default:      return colors.border.withValues(alpha: 0.2);
    }
  }

  Color _getStatusBorderColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir': return colors.primary.withValues(alpha: 0.3);
      case 'sakit': return colors.yellow.withValues(alpha: 0.3);
      case 'izin':  return colors.blue.withValues(alpha: 0.3);
      case 'alfa':  return colors.red.withValues(alpha: 0.3);
      default:      return colors.border;
    }
  }

  Color _getStatusTextColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir': return colors.primary;
      case 'sakit': return colors.yellow;
      case 'izin':  return colors.blue;
      case 'alfa':  return colors.red;
      default:      return colors.textSecondary;
    }
  }
}