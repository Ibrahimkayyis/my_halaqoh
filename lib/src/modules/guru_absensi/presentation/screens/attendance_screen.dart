import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/widgets/absensi_santri_item.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/widgets/mulai_absensi_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Main attendance screen:
/// - Prominent top action button (Mulai Sesi Absensi) immune to bottom nav overlap
/// - 2-column action tiles with multi-line text (no ellipsis truncation)
/// - Clean search bar & section title with counter
/// - Interactive santri list items
@RoutePage()
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMulaiAbsensiDialog(
    List<SantriModel> mySantriList,
    String halaqohId,
    String guruId,
    String effectiveProgramType,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => MulaiAbsensiDialog(
        programType: effectiveProgramType,
        onScanBarcode: (date, sesi) {
          context.router.push(
            BarcodeScannerRoute(selectedDate: date, selectedSesi: sesi),
          );
        },
        onAbsensiManual: (date, sesi) => _handleAbsensiManual(date, sesi),
        onTandaiSemuaHadir: (date, sesi) =>
            _handleTandaiSemuaHadir(mySantriList, date, sesi),
      ),
    );
  }

  void _handleAbsensiManual(DateTime date, String sesi) {
    context.router.push(
      DetailAbsensiHariIniRoute(
        scannedNisList: const [],
        selectedDate: date,
        selectedSesi: sesi,
      ),
    );
  }

  void _handleTandaiSemuaHadir(
    List<SantriModel> mySantriList,
    DateTime date,
    String sesi,
  ) {
    final allNisList = mySantriList.map((s) => s.nis).toList();
    context.router.push(
      DetailAbsensiHariIniRoute(
        scannedNisList: allNisList,
        selectedDate: date,
        selectedSesi: sesi,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Retrieve Auth & Master Data Context
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;

    // Linked doc ID (supports super_admin impersonation)
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    bool isHalaqohLoading = false;
    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      initial: () => isHalaqohLoading = true,
      loading: () => isHalaqohLoading = true,
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    final effectiveProgramType =
        myHalaqoh?.program == 'T' ? 'takhassus' : 'reguler';

    bool isSantriLoading = false;
    List<SantriModel> mySantriList = [];
    if (myHalaqoh != null || isHalaqohLoading) {
      santriState.maybeWhen(
        initial: () => isSantriLoading = true,
        loading: () => isSantriLoading = true,
        loaded: (sList) {
          mySantriList = sList
              .where((s) => myHalaqoh!.santriIds.contains(s.id))
              .toList();
        },
        orElse: () {},
      );
    }

    final filtered = mySantriList.where((santri) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return santri.nama.toLowerCase().contains(q) || santri.nis.contains(q);
    }).toList();

    return BlocProvider(
      create: (_) {
        final cubit = sl<AbsensiCubit>();
        if (myHalaqoh != null) {
          cubit.watchByHalaqoh(myHalaqoh!.id);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              // ── Top Header Controls ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 14.h),

                      // 1. Primary Action Button: Mulai Sesi Absensi
                      Container(
                        width: double.infinity,
                        height: 48.h,
                        decoration: BoxDecoration(
                          gradient: colors.primaryGradient,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showMulaiAbsensiDialog(
                              mySantriList,
                              myHalaqoh?.id ?? '',
                              linkedDocId,
                              effectiveProgramType,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            splashColor: Colors.white.withValues(alpha: 0.15),
                            highlightColor: Colors.white.withValues(alpha: 0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  t.absensi.mulaiSesi,
                                  style: textTheme.titleMedium?.copyWith(
                                        fontSize: 14.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ) ??
                                      TextStyle(
                                        fontSize: 14.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // 2. 2-Column Action Tiles (Absensi Halaqoh & Detail Hari Ini)
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionTile(
                              context: context,
                              icon: Icons.calendar_today_rounded,
                              label: t.absensi.lihatAbsensiHalaqoh,
                              onTap: () => context.router.push(
                                AbsensiHalaqohRoute(),
                              ),
                              colors: colors,
                              textTheme: textTheme,
                              isDark: isDark,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildActionTile(
                              context: context,
                              icon: Icons.event_note_rounded,
                              label: t.absensi.lihatDetailHariIni,
                              onTap: () => context.router.push(
                                DetailAbsensiHariIniRoute(
                                  selectedDate: DateTime.now(),
                                  selectedSesi: 'shubuh',
                                ),
                              ),
                              colors: colors,
                              textTheme: textTheme,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      // 3. Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isDark
                                ? colors.border
                                : colors.border.withValues(alpha: 0.7),
                            width: 0.8,
                          ),
                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13.5.sp,
                                color: colors.textPrimary,
                              ) ??
                              TextStyle(
                                fontSize: 13.5.sp,
                                fontFamily: 'Poppins',
                                color: colors.textPrimary,
                              ),
                          decoration: InputDecoration(
                            hintText: t.absensi.searchHint,
                            hintStyle: textTheme.bodyMedium?.copyWith(
                                  fontSize: 13.5.sp,
                                  color: colors.textSecondary
                                      .withValues(alpha: 0.6),
                                ) ??
                                TextStyle(
                                  fontSize: 13.5.sp,
                                  fontFamily: 'Poppins',
                                  color: colors.textSecondary
                                      .withValues(alpha: 0.6),
                                ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20.sp,
                              color: colors.primary,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      size: 18.sp,
                                      color: colors.textSecondary,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // 4. Section Title: ▎ Daftar Santri [N Santri]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 3.5.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                t.absensi.daftarSantri,
                                style: textTheme.titleMedium?.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                    ) ??
                                    TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                      fontFamily: 'Poppins',
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              t.absensi.santriCount(
                                count: '${filtered.length}',
                              ),
                              style: textTheme.labelSmall?.copyWith(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ) ??
                                  TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                    fontFamily: 'Poppins',
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),

              // ── Scrollable Santri List ─────────────────────────────
              if (isHalaqohLoading || isSantriLoading)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ShimmerAbsensiSantriItem(),
                      childCount: 4,
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 32.h),
                      child: Text(
                        t.myHalaqohScreen.santriNotFound,
                        style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                            ) ??
                            TextStyle(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    bottom: 100.h, // Clearance for bottom navigation bar
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final santri = filtered[index];
                        return AbsensiSantriItem(
                          name: santri.nama,
                          nis: santri.nis,
                          onRiwayatTap: () {
                            context.router.push(
                              RiwayatAbsensiRoute(
                                name: santri.nama,
                                nis: santri.nis,
                              ),
                            );
                          },
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 2-column action tile with vertical icon & text alignment
  /// Eliminates ellipsis truncation by allowing multi-line text.
  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required AppColorSet colors,
    required TextTheme textTheme,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.7),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: colors.primary.withValues(alpha: 0.08),
          highlightColor: colors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 19.sp,
                    color: colors.primary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  style: textTheme.titleSmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        height: 1.25,
                      ) ??
                      TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                        height: 1.25,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
