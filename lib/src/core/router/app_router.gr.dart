// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddHalaqohScreen]
class AddHalaqohRoute extends PageRouteInfo<void> {
  const AddHalaqohRoute({List<PageRouteInfo>? children})
    : super(AddHalaqohRoute.name, initialChildren: children);

  static const String name = 'AddHalaqohRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddHalaqohScreen();
    },
  );
}

/// generated route for
/// [AttendanceScreen]
class AttendanceRoute extends PageRouteInfo<void> {
  const AttendanceRoute({List<PageRouteInfo>? children})
    : super(AttendanceRoute.name, initialChildren: children);

  static const String name = 'AttendanceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AttendanceScreen();
    },
  );
}

/// generated route for
/// [DashboardWrapperScreen]
class DashboardWrapperRoute extends PageRouteInfo<void> {
  const DashboardWrapperRoute({List<PageRouteInfo>? children})
    : super(DashboardWrapperRoute.name, initialChildren: children);

  static const String name = 'DashboardWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardWrapperScreen();
    },
  );
}

/// generated route for
/// [GuruDashboardWrapperScreen]
class GuruDashboardWrapperRoute extends PageRouteInfo<void> {
  const GuruDashboardWrapperRoute({List<PageRouteInfo>? children})
    : super(GuruDashboardWrapperRoute.name, initialChildren: children);

  static const String name = 'GuruDashboardWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GuruDashboardWrapperScreen();
    },
  );
}

/// generated route for
/// [HafalanScreen]
class HafalanRoute extends PageRouteInfo<void> {
  const HafalanRoute({List<PageRouteInfo>? children})
    : super(HafalanRoute.name, initialChildren: children);

  static const String name = 'HafalanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HafalanScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [SelectSantriScreen]
class SelectSantriRoute extends PageRouteInfo<void> {
  const SelectSantriRoute({List<PageRouteInfo>? children})
    : super(SelectSantriRoute.name, initialChildren: children);

  static const String name = 'SelectSantriRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectSantriScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    Key? key,
    Duration splashDuration = const Duration(seconds: 3),
    List<PageRouteInfo>? children,
  }) : super(
         SplashRoute.name,
         args: SplashRouteArgs(key: key, splashDuration: splashDuration),
         initialChildren: children,
       );

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SplashRouteArgs>(
        orElse: () => const SplashRouteArgs(),
      );
      return SplashScreen(key: args.key, splashDuration: args.splashDuration);
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.splashDuration = const Duration(seconds: 3),
  });

  final Key? key;

  final Duration splashDuration;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, splashDuration: $splashDuration}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SplashRouteArgs) return false;
    return key == other.key && splashDuration == other.splashDuration;
  }

  @override
  int get hashCode => key.hashCode ^ splashDuration.hashCode;
}

/// generated route for
/// [WaliSantriDashboardWrapperScreen]
class WaliSantriDashboardWrapperRoute extends PageRouteInfo<void> {
  const WaliSantriDashboardWrapperRoute({List<PageRouteInfo>? children})
    : super(WaliSantriDashboardWrapperRoute.name, initialChildren: children);

  static const String name = 'WaliSantriDashboardWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WaliSantriDashboardWrapperScreen();
    },
  );
}
