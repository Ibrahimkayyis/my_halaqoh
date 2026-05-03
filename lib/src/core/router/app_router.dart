import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:my_halaqoh/src/core/router/guards/auth_guard.dart';
import 'package:my_halaqoh/src/core/router/guards/role_guard.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/access_denied_screen.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/login_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/attendance_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/barcode_scanner_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/riwayat_absensi_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/kalender_absensi_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/absensi_halaqoh_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/detail_absensi_hari_ini_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/input_hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/riwayat_hafalan_santri_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/progress_hafalan_per_juz_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/progress_hafalan_per_surat_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/mutabaah_santri_screen.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/screens/edit_profile_screen.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/screens/ubah_password_screen.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/screens/pengaturan_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/dashboard_wrapper_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/add_halaqoh_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/pengaturan_master_data_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/select_santri_screen.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/screens/guru_dashboard_wrapper_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/screens/wali_santri_dashboard_wrapper_screen.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/screens/my_halaqoh_screen.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/screens/detail_santri_screen.dart';
// Wali Santri Hafalan
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_riwayat_hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_progress_per_juz_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_progress_per_surat_screen.dart';
// Wali Santri Hafalan - Mutabaah
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_mutabaah_screen.dart';
// Wali Santri Absensi
import 'package:my_halaqoh/src/modules/wali_santri_absensi/presentation/screens/wali_santri_riwayat_absensi_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_absensi/presentation/screens/wali_santri_kalender_absensi_screen.dart';
// Wali Santri Profile
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/screens/wali_santri_profile_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/screens/wali_santri_edit_profile_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/screens/wali_santri_ubah_password_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/screens/wali_santri_pengaturan_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthCubit _authCubit;

  AppRouter(this._authCubit);

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // ── Public routes (no guards) ──────────────────────────────────────
    // LoginRoute is initial: the native splash covers the screen while
    // AuthCubit resolves; once it does, BlocListener in MyApp navigates
    // to the correct dashboard and calls FlutterNativeSplash.remove().
    AutoRoute(initial: true, page: LoginRoute.page),
    AutoRoute(page: AccessDeniedRoute.page),

    // ── Admin-only routes ──────────────────────────────────────────────
    AutoRoute(
      page: DashboardWrapperRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['admin']),
      ],
    ),
    AutoRoute(
      page: AddHalaqohRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['admin']),
      ],
    ),
    AutoRoute(
      page: SelectSantriRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['admin']),
      ],
    ),
    AutoRoute(
      page: PengaturanMasterDataRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['admin']),
      ],
    ),

    // ── Guru-only routes ───────────────────────────────────────────────
    AutoRoute(
      page: GuruDashboardWrapperRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: AttendanceRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: HafalanRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: MyHalaqohRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: DetailSantriRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: BarcodeScannerRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: RiwayatAbsensiRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: KalenderAbsensiRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: AbsensiHalaqohRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: DetailAbsensiHariIniRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: InputHafalanRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: RiwayatHafalanSantriRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: ProgressHafalanPerJuzRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: ProgressHafalanPerSuratRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: MutabaahSantriRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: EditProfileRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: UbahPasswordRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),
    AutoRoute(
      page: PengaturanRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['guru']),
      ],
    ),

    // ── Wali Santri-only routes ────────────────────────────────────────
    AutoRoute(
      page: WaliSantriDashboardWrapperRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriRiwayatHafalanRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriProgressPerJuzRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriProgressPerSuratRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriMutabaahRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriRiwayatAbsensiRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriKalenderAbsensiRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriProfileRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriEditProfileRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriUbahPasswordRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
    AutoRoute(
      page: WaliSantriPengaturanRoute.page,
      guards: [
        AuthGuard(_authCubit),
        RoleGuard(_authCubit, allowedRoles: ['santri']),
      ],
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
