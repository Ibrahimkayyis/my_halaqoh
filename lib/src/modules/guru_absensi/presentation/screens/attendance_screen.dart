import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/widgets/absensi_santri_item.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/widgets/mulai_absensi_dialog.dart';

/// Main attendance screen — start session button, search, action buttons, santri list
@RoutePage()
class AttendanceScreen extends StatefulWidget {
  final String programType;

  const AttendanceScreen({super.key, this.programType = 'reguler'});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allSantri = [
    {'name': 'Ahmad', 'nis': '220512140601'},
    {'name': 'Fauzan', 'nis': '220512140602'},
    {'name': 'Yusuf', 'nis': '220512140603'},
    {'name': 'Ibrahim', 'nis': '220512140604'},
    {'name': 'Khalid', 'nis': '220512140605'},
    {'name': 'Usman', 'nis': '220512140606'},
    {'name': 'Ghulam', 'nis': '220512140607'},
    {'name': 'Haikal', 'nis': '220512140608'},
    {'name': 'Fikrie', 'nis': '220512140609'},
    {'name': 'Ghatfhan', 'nis': '220512140610'},
  ];

  List<Map<String, String>> get _filteredSantri {
    if (_searchQuery.isEmpty) return _allSantri;
    return _allSantri.where((s) {
      final name = s['name']!.toLowerCase();
      final nis = s['nis']!;
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || nis.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMulaiAbsensiDialog() {
    showDialog(
      context: context,
      builder: (ctx) => MulaiAbsensiDialog(
        programType: widget.programType,
        onScanBarcode: () {
          context.router.push(const BarcodeScannerRoute());
        },
        onTandaiSemuaHadir: _handleTandaiSemuaHadir,
      ),
    );
  }

  /// Tandai semua hadir — pass semua NIS sebagai scannedNisList
  /// sehingga DetailAbsensiHariIniScreen akan pre-fill semua status ke "hadir"
  void _handleTandaiSemuaHadir() {
    final allNisList = _allSantri.map((s) => s['nis']!).toList();
    context.router.push(
      DetailAbsensiHariIniRoute(scannedNisList: allNisList),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final filtered = _filteredSantri;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            // Mulai Sesi Absensi button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: PrimaryButton(
                  width: double.infinity,
                  height: 52.h,
                  onPressed: _showMulaiAbsensiDialog,
                  icon: Icons.qr_code_scanner,
                  label: t.absensi.mulaiSesi,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: t.absensi.searchHint,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      color: colors.textSecondary.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _buildActionButton(
                    Icons.calendar_today,
                    t.absensi.lihatAbsensiHalaqoh,
                    colors,
                    () {
                      context.router.push(
                        AbsensiHalaqohRoute(programType: widget.programType),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  _buildActionButton(
                    Icons.event_note,
                    t.absensi.lihatDetailHariIni,
                    colors,
                    () {
                      // Buka tanpa data scan — semua santri mulai dari "belum"
                      context.router.push(
                         DetailAbsensiHariIniRoute(),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Daftar Santri header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.absensi.daftarSantri,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      t.absensi.santriCount(count: '${filtered.length}'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Santri list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final santri = filtered[index];
                  return AbsensiSantriItem(
                    name: santri['name']!,
                    nis: santri['nis']!,
                    riwayatLabel: t.absensi.riwayatAbsensi,
                    onRiwayatTap: () {
                      context.router.push(
                        RiwayatAbsensiRoute(
                          name: santri['name']!,
                          nis: santri['nis']!,
                          programType: widget.programType,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    AppColorSet colors,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: colors.primary),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}