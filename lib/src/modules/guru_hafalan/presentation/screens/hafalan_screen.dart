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
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/widgets/hafalan_santri_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Hafalan Santri Screen — search bar, count badge, and santri card list with actions
@RoutePage()
class HafalanScreen extends StatefulWidget {
  const HafalanScreen({super.key});

  @override
  State<HafalanScreen> createState() => _HafalanScreenState();
}

class _HafalanScreenState extends State<HafalanScreen> {
  String _searchQuery = '';

  // Filter logic is now handled in build method dynamically based on Cubits

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Retrieve Auth Context
    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    // Collect all targets for lookup
    List<TargetHafalanModel> allTargets = [];
    targetHafalanState.maybeWhen(
      loaded: (targets) => allTargets = targets,
      orElse: () {},
    );

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: t.hafalan.cariSantri,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      color: colors.textSecondary.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 22.sp,
                      color: colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Daftar Santri header with count badge
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.hafalan.daftarSantri,
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
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Text(
                      t.hafalan.santriCount(count: '${filtered.length}'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Santri list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final santri = filtered[index];

                  // Look up this santri's target
                  final santriTarget = TargetHafalanHelper.findTarget(
                    allTargets,
                    santri.kelas,
                    santri.program,
                  );
                  final targetInfoText = santriTarget != null
                      ? 'Target: ${santriTarget.targetJuz} Juz (${TargetHafalanHelper.formatJuzRange(santriTarget.juzList)})'
                      : null;

                  return HafalanSantriItem(
                    name: santri.nama,
                    nis: santri.nis,
                    targetInfo: targetInfoText,
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
                      if (result != null && result is Map<String, dynamic>) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Hafalan berhasil disimpan!',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              backgroundColor: colors.primary,
                            ),
                          );
                        }
                      }
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
}
