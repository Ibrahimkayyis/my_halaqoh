import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/splash_screen.dart';
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
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/dashboard_wrapper_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/add_halaqoh_screen.dart';
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
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(initial: true, page: SplashRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: DashboardWrapperRoute.page),
    AutoRoute(page: GuruDashboardWrapperRoute.page),
    AutoRoute(page: WaliSantriDashboardWrapperRoute.page),
    AutoRoute(page: AttendanceRoute.page),
    AutoRoute(page: HafalanRoute.page),
    AutoRoute(page: AddHalaqohRoute.page),
    AutoRoute(page: SelectSantriRoute.page),
    AutoRoute(page: MyHalaqohRoute.page),
    AutoRoute(page: DetailSantriRoute.page),
    AutoRoute(page: BarcodeScannerRoute.page),
    AutoRoute(page: RiwayatAbsensiRoute.page),
    AutoRoute(page: KalenderAbsensiRoute.page),
    AutoRoute(page: AbsensiHalaqohRoute.page),
    AutoRoute(page: DetailAbsensiHariIniRoute.page),
    AutoRoute(page: InputHafalanRoute.page),
    AutoRoute(page: RiwayatHafalanSantriRoute.page),
    AutoRoute(page: ProgressHafalanPerJuzRoute.page),
    AutoRoute(page: ProgressHafalanPerSuratRoute.page),
    AutoRoute(page: MutabaahSantriRoute.page),
    AutoRoute(page: EditProfileRoute.page),
    AutoRoute(page: UbahPasswordRoute.page),
    AutoRoute(page: PengaturanRoute.page),
    // Wali Santri Hafalan
    AutoRoute(page: WaliSantriRiwayatHafalanRoute.page),
    AutoRoute(page: WaliSantriProgressPerJuzRoute.page),
    AutoRoute(page: WaliSantriProgressPerSuratRoute.page),
    AutoRoute(page: WaliSantriMutabaahRoute.page),
    // Wali Santri Absensi
    AutoRoute(page: WaliSantriRiwayatAbsensiRoute.page),
    AutoRoute(page: WaliSantriKalenderAbsensiRoute.page),
    // Wali Santri Profile
    AutoRoute(page: WaliSantriProfileRoute.page),
    AutoRoute(page: WaliSantriEditProfileRoute.page),
    AutoRoute(page: WaliSantriUbahPasswordRoute.page),
    AutoRoute(page: WaliSantriPengaturanRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
