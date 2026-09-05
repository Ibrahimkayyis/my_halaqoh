import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/widgets/hafalan_santri_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/laporan_konfigurasi_hafalan_halaqoh_sheet.dart';

/// Hafalan Santri Screen — unified search bar, section title with ▎ bar accent
/// and pill badge counter, and clean santri card list with actions.
@RoutePage()
class HafalanScreen extends StatefulWidget {
  const HafalanScreen({super.key});

  @override
  State<HafalanScreen> createState() => _HafalanScreenState();
}

class _HafalanScreenState extends State<HafalanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Retrieve Auth Context
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;

    // Gunakan ActiveSessionHelper agar super_admin yang sedang impersonasi
    // guru mendapatkan linkedDocId guru yang dipilih, bukan 'SYSTEM'.
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    List<SantriModel> mySantriList = [];
    if (myHalaqoh != null) {
      santriState.maybeWhen(
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
      return santri.nama.toLowerCase().contains(q) ||
          santri.nis.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // ── Header Controls (Search Bar & Section Title) ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.h),

                    // 1. Primary Action Button: Buat Laporan Hafalan
                    if (myHalaqoh != null) ...[
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
                            onTap: () {
                              final now = DateTime.now();
                              LaporanKonfigurasiHafalanHalaqohSheet.show(
                                context,
                                halaqoh: myHalaqoh!,
                                santriList: mySantriList,
                                initialMonth: now.month,
                                initialYear: now.year,
                              );
                            },
                            borderRadius: BorderRadius.circular(14.r),
                            splashColor: Colors.white.withValues(alpha: 0.15),
                            highlightColor: Colors.white.withValues(alpha: 0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  t.hafalan.buatLaporanHafalan,
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                    ],

                    // Search Bar (unified design)
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
                          hintText: t.hafalan.cariSantri,
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

                    // Section Title: ▎ Daftar Santri [N Santri]
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
                              t.hafalan.daftarSantri,
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
                            t.hafalan.santriCount(
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
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: Text(
                      t.hafalan.santriNotFound,
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
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final santri = filtered[index];

                    return HafalanSantriItem(
                      name: santri.nama,
                      nis: santri.nis,
                      riwayatLabel: t.hafalan.riwayatHafalan,
                      inputLabel: t.hafalan.inputHafalan,
                      onRiwayatTap: () {
                        context.router.push(
                          RiwayatHafalanSantriRoute(
                            santriId: santri.id,
                            name: santri.nama,
                            nis: santri.nis,
                          ),
                        );
                      },
                      onInputTap: () async {
                        final result = await context.router.push(
                          InputHafalanRoute(
                            santriId: santri.id,
                            name: santri.nama,
                            nis: santri.nis,
                            halaqohId: myHalaqoh!.id,
                            guruId: myHalaqoh!.guruId,
                          ),
                        );
                        if (result != null &&
                            result is Map<String, dynamic>) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  t.hafalan.successSave,
                                  style:
                                      const TextStyle(fontFamily: 'Poppins'),
                                ),
                                backgroundColor: colors.primary,
                              ),
                            );
                          }
                        }
                      },
                    );
                  }, childCount: filtered.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
