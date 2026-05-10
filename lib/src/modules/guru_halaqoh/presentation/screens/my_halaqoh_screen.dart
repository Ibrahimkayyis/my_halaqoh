import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/halaqoh_info_card.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/santri_list_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';

/// My Halaqoh screen showing halaqoh info card, search bar, and santri list.
/// Uses CustomScrollView for a smooth, unified scrolling experience.
@RoutePage()
class MyHalaqohScreen extends StatefulWidget {
  const MyHalaqohScreen({super.key});

  @override
  State<MyHalaqohScreen> createState() => _MyHalaqohScreenState();
}

class _MyHalaqohScreenState extends State<MyHalaqohScreen> {
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

    // Retrieve Auth Context
    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    String linkedDocId = '';
    authState.maybeWhen(
      authenticated: (userMeta) {
        linkedDocId = userMeta.linkedDocId;
      },
      orElse: () {},
    );

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    // Look up the admin-defined target for this halaqoh's kelas + program
    TargetHafalanModel? myTarget;
    if (myHalaqoh != null) {
      targetHafalanState.maybeWhen(
        loaded: (targets) {
          myTarget = TargetHafalanHelper.findTarget(
            targets,
            myHalaqoh!.kelas,
            myHalaqoh!.program,
          );
        },
        orElse: () {},
      );
    }

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

    final filtered = mySantriList.where((sanitize) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return sanitize.nama.toLowerCase().contains(q) ||
          sanitize.nis.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          // UX Upgrade: Scroll pantulan halus ala iOS dan scroll bisa ditarik meskipun item sedikit
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          // UX Upgrade: Otomatis menutup keyboard jika user mulai men-scroll layar
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // --- HEADER SECTION (SCROLLS WITH THE PAGE) ---
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    // Halaqoh info card
                    if (myHalaqoh != null)
                      HalaqohInfoCard(
                        kelas: t.myHalaqohScreen.kelas(kelas: myHalaqoh!.kelas),
                        program: t.myHalaqohScreen.program(
                          program: myHalaqoh!.program == 'T'
                              ? 'Takhassus'
                              : 'Reguler',
                        ),
                        halaqohName: myHalaqoh!.nama,
                        pengampu: myHalaqoh!.guruNama.isNotEmpty
                            ? myHalaqoh!.guruNama
                            : t.myHalaqohScreen.pengampu,
                        target: t.myHalaqohScreen.target(
                          count: myTarget != null && myHalaqoh != null
                              ? '${TargetHafalanHelper.getTargetJuzCount(myTarget!, myHalaqoh!.kelas, myHalaqoh!.program)}'
                              : '0',
                          range: myTarget != null && myHalaqoh != null
                              ? TargetHafalanHelper.getActiveSemesterSummary(myTarget!, myHalaqoh!.kelas, myHalaqoh!.program) ?? '-'
                              : '-',
                        ),
                        totalSantri: t.myHalaqohScreen.total(
                          count: mySantriList.length.toString(),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        child: Text(
                          'Anda belum ditugaskan ke Halaqoh manapun.',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),

                    // Search bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                            color: colors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: t.myHalaqohScreen.searchHint,
                            hintStyle: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'Poppins',
                              color: colors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
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
                    SizedBox(height: 24.h),

                    // Daftar Santri header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.myHalaqohScreen.daftarSantri,
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
                              t.myHalaqohScreen.santriCount(
                                count: '${filtered.length}',
                              ),
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
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // --- SCROLLABLE LIST SECTION ---
            if (filtered.isEmpty)
              // UX Upgrade: Tampilan empty state jika hasil pencarian kosong
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: Text(
                      'Santri tidak ditemukan.',
                      style: TextStyle(
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
                  top: 16.h,
                  left: 24.w,
                  right: 24.w,
                  bottom: MediaQuery.of(context).padding.bottom + 24.h,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final santri = filtered[index];

                    return BlocProvider(
                      create: (_) =>
                          sl<ProgressHafalanCubit>()..watchProgress(santri.id),
                      child:
                          BlocBuilder<
                            ProgressHafalanCubit,
                            ProgressHafalanState
                          >(
                            builder: (context, state) {
                              double completed = 0.0;
                              state.maybeWhen(
                                loaded: (progressData) {
                                  for (final jp
                                      in progressData.juzProgressList) {
                                    if (jp.totalAyat > 0) {
                                      completed +=
                                          jp.memorizedAyat / jp.totalAyat;
                                    }
                                  }
                                },
                                orElse: () {},
                              );

                              final targetJuz = myTarget != null && myHalaqoh != null
                                  ? TargetHafalanHelper.getTargetJuzCount(myTarget!, myHalaqoh!.kelas, myHalaqoh!.program).toDouble()
                                  : 0.0;
                              final progress = targetJuz > 0
                                  ? completed / targetJuz
                                  : 0.0;
                              final pct = (progress * 100).round();

                              String formatJuz(double v) {
                                if (v == 0) return '0';
                                return v == v.roundToDouble()
                                    ? v.toInt().toString()
                                    : v.toStringAsFixed(2);
                              }

                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: SantriListItem(
                                  name: santri.nama,
                                  progressText: t.myHalaqohScreen.progressText(
                                    completed: formatJuz(completed),
                                    target: formatJuz(targetJuz),
                                  ),
                                  percentage: '$pct%',
                                  progress: progress,
                                  onTap: () {
                                    context.router.push(
                                      DetailSantriRoute(
                                        name: santri.nama,
                                        nis: santri.nis,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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
