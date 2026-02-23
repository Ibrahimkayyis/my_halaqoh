import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/splash_screen.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/login_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/attendance_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/dashboard_wrapper_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/add_halaqoh_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/select_santri_screen.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/screens/guru_dashboard_wrapper_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/screens/wali_santri_dashboard_wrapper_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: SplashRoute.page,
        ),
        AutoRoute(
          page: LoginRoute.page,
        ),
        AutoRoute(
          page: DashboardWrapperRoute.page,
        ),
        AutoRoute(
          page: GuruDashboardWrapperRoute.page,
        ),
        AutoRoute(
          page: WaliSantriDashboardWrapperRoute.page,
        ),
        AutoRoute(page: AttendanceRoute.page),
        AutoRoute(page: HafalanRoute.page),
        AutoRoute(page: AddHalaqohRoute.page),
        AutoRoute(page: SelectSantriRoute.page),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
