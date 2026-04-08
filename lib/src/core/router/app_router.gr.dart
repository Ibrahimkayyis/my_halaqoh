// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AbsensiHalaqohScreen]
class AbsensiHalaqohRoute extends PageRouteInfo<AbsensiHalaqohRouteArgs> {
  AbsensiHalaqohRoute({
    Key? key,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         AbsensiHalaqohRoute.name,
         args: AbsensiHalaqohRouteArgs(key: key, programType: programType),
         rawPathParams: {'programType': programType},
         initialChildren: children,
       );

  static const String name = 'AbsensiHalaqohRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AbsensiHalaqohRouteArgs>(
        orElse: () => AbsensiHalaqohRouteArgs(
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return AbsensiHalaqohScreen(key: args.key, programType: args.programType);
    },
  );
}

class AbsensiHalaqohRouteArgs {
  const AbsensiHalaqohRouteArgs({this.key, this.programType = 'reguler'});

  final Key? key;

  final String programType;

  @override
  String toString() {
    return 'AbsensiHalaqohRouteArgs{key: $key, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AbsensiHalaqohRouteArgs) return false;
    return key == other.key && programType == other.programType;
  }

  @override
  int get hashCode => key.hashCode ^ programType.hashCode;
}

/// generated route for
/// [AddHalaqohScreen]
class AddHalaqohRoute extends PageRouteInfo<AddHalaqohRouteArgs> {
  AddHalaqohRoute({
    Key? key,
    HalaqohModel? existingHalaqoh,
    List<PageRouteInfo>? children,
  }) : super(
         AddHalaqohRoute.name,
         args: AddHalaqohRouteArgs(key: key, existingHalaqoh: existingHalaqoh),
         initialChildren: children,
       );

  static const String name = 'AddHalaqohRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddHalaqohRouteArgs>(
        orElse: () => const AddHalaqohRouteArgs(),
      );
      return AddHalaqohScreen(
        key: args.key,
        existingHalaqoh: args.existingHalaqoh,
      );
    },
  );
}

class AddHalaqohRouteArgs {
  const AddHalaqohRouteArgs({this.key, this.existingHalaqoh});

  final Key? key;

  final HalaqohModel? existingHalaqoh;

  @override
  String toString() {
    return 'AddHalaqohRouteArgs{key: $key, existingHalaqoh: $existingHalaqoh}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddHalaqohRouteArgs) return false;
    return key == other.key && existingHalaqoh == other.existingHalaqoh;
  }

  @override
  int get hashCode => key.hashCode ^ existingHalaqoh.hashCode;
}

/// generated route for
/// [AttendanceScreen]
class AttendanceRoute extends PageRouteInfo<AttendanceRouteArgs> {
  AttendanceRoute({
    Key? key,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         AttendanceRoute.name,
         args: AttendanceRouteArgs(key: key, programType: programType),
         initialChildren: children,
       );

  static const String name = 'AttendanceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AttendanceRouteArgs>(
        orElse: () => const AttendanceRouteArgs(),
      );
      return AttendanceScreen(key: args.key, programType: args.programType);
    },
  );
}

class AttendanceRouteArgs {
  const AttendanceRouteArgs({this.key, this.programType = 'reguler'});

  final Key? key;

  final String programType;

  @override
  String toString() {
    return 'AttendanceRouteArgs{key: $key, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AttendanceRouteArgs) return false;
    return key == other.key && programType == other.programType;
  }

  @override
  int get hashCode => key.hashCode ^ programType.hashCode;
}

/// generated route for
/// [BarcodeScannerScreen]
class BarcodeScannerRoute extends PageRouteInfo<void> {
  const BarcodeScannerRoute({List<PageRouteInfo>? children})
    : super(BarcodeScannerRoute.name, initialChildren: children);

  static const String name = 'BarcodeScannerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BarcodeScannerScreen();
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
/// [DetailAbsensiHariIniScreen]
class DetailAbsensiHariIniRoute
    extends PageRouteInfo<DetailAbsensiHariIniRouteArgs> {
  DetailAbsensiHariIniRoute({
    Key? key,
    List<String> scannedNisList = const [],
    List<PageRouteInfo>? children,
  }) : super(
         DetailAbsensiHariIniRoute.name,
         args: DetailAbsensiHariIniRouteArgs(
           key: key,
           scannedNisList: scannedNisList,
         ),
         initialChildren: children,
       );

  static const String name = 'DetailAbsensiHariIniRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailAbsensiHariIniRouteArgs>(
        orElse: () => const DetailAbsensiHariIniRouteArgs(),
      );
      return DetailAbsensiHariIniScreen(
        key: args.key,
        scannedNisList: args.scannedNisList,
      );
    },
  );
}

class DetailAbsensiHariIniRouteArgs {
  const DetailAbsensiHariIniRouteArgs({
    this.key,
    this.scannedNisList = const [],
  });

  final Key? key;

  final List<String> scannedNisList;

  @override
  String toString() {
    return 'DetailAbsensiHariIniRouteArgs{key: $key, scannedNisList: $scannedNisList}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DetailAbsensiHariIniRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(scannedNisList, other.scannedNisList);
  }

  @override
  int get hashCode => key.hashCode ^ const ListEquality().hash(scannedNisList);
}

/// generated route for
/// [DetailSantriScreen]
class DetailSantriRoute extends PageRouteInfo<DetailSantriRouteArgs> {
  DetailSantriRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         DetailSantriRoute.name,
         args: DetailSantriRouteArgs(key: key, name: name, nis: nis),
         initialChildren: children,
       );

  static const String name = 'DetailSantriRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailSantriRouteArgs>();
      return DetailSantriScreen(key: args.key, name: args.name, nis: args.nis);
    },
  );
}

class DetailSantriRouteArgs {
  const DetailSantriRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'DetailSantriRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DetailSantriRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [EditProfileScreen]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfileScreen();
    },
  );
}

/// generated route for
/// [GuruDashboardWrapperScreen]
class GuruDashboardWrapperRoute
    extends PageRouteInfo<GuruDashboardWrapperRouteArgs> {
  GuruDashboardWrapperRoute({
    Key? key,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         GuruDashboardWrapperRoute.name,
         args: GuruDashboardWrapperRouteArgs(
           key: key,
           programType: programType,
         ),
         rawPathParams: {'programType': programType},
         initialChildren: children,
       );

  static const String name = 'GuruDashboardWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<GuruDashboardWrapperRouteArgs>(
        orElse: () => GuruDashboardWrapperRouteArgs(
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return GuruDashboardWrapperScreen(
        key: args.key,
        programType: args.programType,
      );
    },
  );
}

class GuruDashboardWrapperRouteArgs {
  const GuruDashboardWrapperRouteArgs({this.key, this.programType = 'reguler'});

  final Key? key;

  final String programType;

  @override
  String toString() {
    return 'GuruDashboardWrapperRouteArgs{key: $key, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GuruDashboardWrapperRouteArgs) return false;
    return key == other.key && programType == other.programType;
  }

  @override
  int get hashCode => key.hashCode ^ programType.hashCode;
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
/// [InputHafalanScreen]
class InputHafalanRoute extends PageRouteInfo<InputHafalanRouteArgs> {
  InputHafalanRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         InputHafalanRoute.name,
         args: InputHafalanRouteArgs(key: key, name: name, nis: nis),
         initialChildren: children,
       );

  static const String name = 'InputHafalanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InputHafalanRouteArgs>();
      return InputHafalanScreen(key: args.key, name: args.name, nis: args.nis);
    },
  );
}

class InputHafalanRouteArgs {
  const InputHafalanRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'InputHafalanRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InputHafalanRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [KalenderAbsensiScreen]
class KalenderAbsensiRoute extends PageRouteInfo<KalenderAbsensiRouteArgs> {
  KalenderAbsensiRoute({
    Key? key,
    required String name,
    required String nis,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         KalenderAbsensiRoute.name,
         args: KalenderAbsensiRouteArgs(
           key: key,
           name: name,
           nis: nis,
           programType: programType,
         ),
         rawPathParams: {'name': name, 'nis': nis, 'programType': programType},
         initialChildren: children,
       );

  static const String name = 'KalenderAbsensiRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<KalenderAbsensiRouteArgs>(
        orElse: () => KalenderAbsensiRouteArgs(
          name: pathParams.getString('name'),
          nis: pathParams.getString('nis'),
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return KalenderAbsensiScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
        programType: args.programType,
      );
    },
  );
}

class KalenderAbsensiRouteArgs {
  const KalenderAbsensiRouteArgs({
    this.key,
    required this.name,
    required this.nis,
    this.programType = 'reguler',
  });

  final Key? key;

  final String name;

  final String nis;

  final String programType;

  @override
  String toString() {
    return 'KalenderAbsensiRouteArgs{key: $key, name: $name, nis: $nis, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! KalenderAbsensiRouteArgs) return false;
    return key == other.key &&
        name == other.name &&
        nis == other.nis &&
        programType == other.programType;
  }

  @override
  int get hashCode =>
      key.hashCode ^ name.hashCode ^ nis.hashCode ^ programType.hashCode;
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
/// [MutabaahSantriScreen]
class MutabaahSantriRoute extends PageRouteInfo<MutabaahSantriRouteArgs> {
  MutabaahSantriRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         MutabaahSantriRoute.name,
         args: MutabaahSantriRouteArgs(key: key, name: name, nis: nis),
         initialChildren: children,
       );

  static const String name = 'MutabaahSantriRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MutabaahSantriRouteArgs>();
      return MutabaahSantriScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
      );
    },
  );
}

class MutabaahSantriRouteArgs {
  const MutabaahSantriRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'MutabaahSantriRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MutabaahSantriRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [MyHalaqohScreen]
class MyHalaqohRoute extends PageRouteInfo<void> {
  const MyHalaqohRoute({List<PageRouteInfo>? children})
    : super(MyHalaqohRoute.name, initialChildren: children);

  static const String name = 'MyHalaqohRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyHalaqohScreen();
    },
  );
}

/// generated route for
/// [PengaturanMasterDataScreen]
class PengaturanMasterDataRoute extends PageRouteInfo<void> {
  const PengaturanMasterDataRoute({List<PageRouteInfo>? children})
    : super(PengaturanMasterDataRoute.name, initialChildren: children);

  static const String name = 'PengaturanMasterDataRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PengaturanMasterDataScreen();
    },
  );
}

/// generated route for
/// [PengaturanScreen]
class PengaturanRoute extends PageRouteInfo<void> {
  const PengaturanRoute({List<PageRouteInfo>? children})
    : super(PengaturanRoute.name, initialChildren: children);

  static const String name = 'PengaturanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PengaturanScreen();
    },
  );
}

/// generated route for
/// [ProgressHafalanPerJuzScreen]
class ProgressHafalanPerJuzRoute
    extends PageRouteInfo<ProgressHafalanPerJuzRouteArgs> {
  ProgressHafalanPerJuzRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         ProgressHafalanPerJuzRoute.name,
         args: ProgressHafalanPerJuzRouteArgs(key: key, name: name, nis: nis),
         initialChildren: children,
       );

  static const String name = 'ProgressHafalanPerJuzRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProgressHafalanPerJuzRouteArgs>();
      return ProgressHafalanPerJuzScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
      );
    },
  );
}

class ProgressHafalanPerJuzRouteArgs {
  const ProgressHafalanPerJuzRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'ProgressHafalanPerJuzRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgressHafalanPerJuzRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [ProgressHafalanPerSuratScreen]
class ProgressHafalanPerSuratRoute
    extends PageRouteInfo<ProgressHafalanPerSuratRouteArgs> {
  ProgressHafalanPerSuratRoute({
    Key? key,
    required String name,
    required String nis,
    required int juzNumber,
    List<PageRouteInfo>? children,
  }) : super(
         ProgressHafalanPerSuratRoute.name,
         args: ProgressHafalanPerSuratRouteArgs(
           key: key,
           name: name,
           nis: nis,
           juzNumber: juzNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'ProgressHafalanPerSuratRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProgressHafalanPerSuratRouteArgs>();
      return ProgressHafalanPerSuratScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
        juzNumber: args.juzNumber,
      );
    },
  );
}

class ProgressHafalanPerSuratRouteArgs {
  const ProgressHafalanPerSuratRouteArgs({
    this.key,
    required this.name,
    required this.nis,
    required this.juzNumber,
  });

  final Key? key;

  final String name;

  final String nis;

  final int juzNumber;

  @override
  String toString() {
    return 'ProgressHafalanPerSuratRouteArgs{key: $key, name: $name, nis: $nis, juzNumber: $juzNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgressHafalanPerSuratRouteArgs) return false;
    return key == other.key &&
        name == other.name &&
        nis == other.nis &&
        juzNumber == other.juzNumber;
  }

  @override
  int get hashCode =>
      key.hashCode ^ name.hashCode ^ nis.hashCode ^ juzNumber.hashCode;
}

/// generated route for
/// [RiwayatAbsensiScreen]
class RiwayatAbsensiRoute extends PageRouteInfo<RiwayatAbsensiRouteArgs> {
  RiwayatAbsensiRoute({
    Key? key,
    required String name,
    required String nis,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         RiwayatAbsensiRoute.name,
         args: RiwayatAbsensiRouteArgs(
           key: key,
           name: name,
           nis: nis,
           programType: programType,
         ),
         rawPathParams: {'name': name, 'nis': nis, 'programType': programType},
         initialChildren: children,
       );

  static const String name = 'RiwayatAbsensiRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RiwayatAbsensiRouteArgs>(
        orElse: () => RiwayatAbsensiRouteArgs(
          name: pathParams.getString('name'),
          nis: pathParams.getString('nis'),
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return RiwayatAbsensiScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
        programType: args.programType,
      );
    },
  );
}

class RiwayatAbsensiRouteArgs {
  const RiwayatAbsensiRouteArgs({
    this.key,
    required this.name,
    required this.nis,
    this.programType = 'reguler',
  });

  final Key? key;

  final String name;

  final String nis;

  final String programType;

  @override
  String toString() {
    return 'RiwayatAbsensiRouteArgs{key: $key, name: $name, nis: $nis, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RiwayatAbsensiRouteArgs) return false;
    return key == other.key &&
        name == other.name &&
        nis == other.nis &&
        programType == other.programType;
  }

  @override
  int get hashCode =>
      key.hashCode ^ name.hashCode ^ nis.hashCode ^ programType.hashCode;
}

/// generated route for
/// [RiwayatHafalanSantriScreen]
class RiwayatHafalanSantriRoute
    extends PageRouteInfo<RiwayatHafalanSantriRouteArgs> {
  RiwayatHafalanSantriRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         RiwayatHafalanSantriRoute.name,
         args: RiwayatHafalanSantriRouteArgs(key: key, name: name, nis: nis),
         initialChildren: children,
       );

  static const String name = 'RiwayatHafalanSantriRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RiwayatHafalanSantriRouteArgs>();
      return RiwayatHafalanSantriScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
      );
    },
  );
}

class RiwayatHafalanSantriRouteArgs {
  const RiwayatHafalanSantriRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'RiwayatHafalanSantriRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RiwayatHafalanSantriRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
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
/// [UbahPasswordScreen]
class UbahPasswordRoute extends PageRouteInfo<void> {
  const UbahPasswordRoute({List<PageRouteInfo>? children})
    : super(UbahPasswordRoute.name, initialChildren: children);

  static const String name = 'UbahPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UbahPasswordScreen();
    },
  );
}

/// generated route for
/// [WaliSantriDashboardWrapperScreen]
class WaliSantriDashboardWrapperRoute
    extends PageRouteInfo<WaliSantriDashboardWrapperRouteArgs> {
  WaliSantriDashboardWrapperRoute({
    Key? key,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriDashboardWrapperRoute.name,
         args: WaliSantriDashboardWrapperRouteArgs(
           key: key,
           programType: programType,
         ),
         rawPathParams: {'programType': programType},
         initialChildren: children,
       );

  static const String name = 'WaliSantriDashboardWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WaliSantriDashboardWrapperRouteArgs>(
        orElse: () => WaliSantriDashboardWrapperRouteArgs(
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return WaliSantriDashboardWrapperScreen(
        key: args.key,
        programType: args.programType,
      );
    },
  );
}

class WaliSantriDashboardWrapperRouteArgs {
  const WaliSantriDashboardWrapperRouteArgs({
    this.key,
    this.programType = 'reguler',
  });

  final Key? key;

  final String programType;

  @override
  String toString() {
    return 'WaliSantriDashboardWrapperRouteArgs{key: $key, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriDashboardWrapperRouteArgs) return false;
    return key == other.key && programType == other.programType;
  }

  @override
  int get hashCode => key.hashCode ^ programType.hashCode;
}

/// generated route for
/// [WaliSantriEditProfileScreen]
class WaliSantriEditProfileRoute extends PageRouteInfo<void> {
  const WaliSantriEditProfileRoute({List<PageRouteInfo>? children})
    : super(WaliSantriEditProfileRoute.name, initialChildren: children);

  static const String name = 'WaliSantriEditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WaliSantriEditProfileScreen();
    },
  );
}

/// generated route for
/// [WaliSantriKalenderAbsensiScreen]
class WaliSantriKalenderAbsensiRoute
    extends PageRouteInfo<WaliSantriKalenderAbsensiRouteArgs> {
  WaliSantriKalenderAbsensiRoute({
    Key? key,
    required String name,
    required String nis,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriKalenderAbsensiRoute.name,
         args: WaliSantriKalenderAbsensiRouteArgs(
           key: key,
           name: name,
           nis: nis,
           programType: programType,
         ),
         rawPathParams: {'name': name, 'nis': nis, 'programType': programType},
         initialChildren: children,
       );

  static const String name = 'WaliSantriKalenderAbsensiRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WaliSantriKalenderAbsensiRouteArgs>(
        orElse: () => WaliSantriKalenderAbsensiRouteArgs(
          name: pathParams.getString('name'),
          nis: pathParams.getString('nis'),
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return WaliSantriKalenderAbsensiScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
        programType: args.programType,
      );
    },
  );
}

class WaliSantriKalenderAbsensiRouteArgs {
  const WaliSantriKalenderAbsensiRouteArgs({
    this.key,
    required this.name,
    required this.nis,
    this.programType = 'reguler',
  });

  final Key? key;

  final String name;

  final String nis;

  final String programType;

  @override
  String toString() {
    return 'WaliSantriKalenderAbsensiRouteArgs{key: $key, name: $name, nis: $nis, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriKalenderAbsensiRouteArgs) return false;
    return key == other.key &&
        name == other.name &&
        nis == other.nis &&
        programType == other.programType;
  }

  @override
  int get hashCode =>
      key.hashCode ^ name.hashCode ^ nis.hashCode ^ programType.hashCode;
}

/// generated route for
/// [WaliSantriMutabaahScreen]
class WaliSantriMutabaahRoute
    extends PageRouteInfo<WaliSantriMutabaahRouteArgs> {
  WaliSantriMutabaahRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriMutabaahRoute.name,
         args: WaliSantriMutabaahRouteArgs(key: key, name: name, nis: nis),
         initialChildren: children,
       );

  static const String name = 'WaliSantriMutabaahRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WaliSantriMutabaahRouteArgs>();
      return WaliSantriMutabaahScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
      );
    },
  );
}

class WaliSantriMutabaahRouteArgs {
  const WaliSantriMutabaahRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'WaliSantriMutabaahRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriMutabaahRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [WaliSantriPengaturanScreen]
class WaliSantriPengaturanRoute extends PageRouteInfo<void> {
  const WaliSantriPengaturanRoute({List<PageRouteInfo>? children})
    : super(WaliSantriPengaturanRoute.name, initialChildren: children);

  static const String name = 'WaliSantriPengaturanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WaliSantriPengaturanScreen();
    },
  );
}

/// generated route for
/// [WaliSantriProfileScreen]
class WaliSantriProfileRoute extends PageRouteInfo<void> {
  const WaliSantriProfileRoute({List<PageRouteInfo>? children})
    : super(WaliSantriProfileRoute.name, initialChildren: children);

  static const String name = 'WaliSantriProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WaliSantriProfileScreen();
    },
  );
}

/// generated route for
/// [WaliSantriProgressPerJuzScreen]
class WaliSantriProgressPerJuzRoute
    extends PageRouteInfo<WaliSantriProgressPerJuzRouteArgs> {
  WaliSantriProgressPerJuzRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriProgressPerJuzRoute.name,
         args: WaliSantriProgressPerJuzRouteArgs(
           key: key,
           name: name,
           nis: nis,
         ),
         initialChildren: children,
       );

  static const String name = 'WaliSantriProgressPerJuzRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WaliSantriProgressPerJuzRouteArgs>();
      return WaliSantriProgressPerJuzScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
      );
    },
  );
}

class WaliSantriProgressPerJuzRouteArgs {
  const WaliSantriProgressPerJuzRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'WaliSantriProgressPerJuzRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriProgressPerJuzRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [WaliSantriProgressPerSuratScreen]
class WaliSantriProgressPerSuratRoute
    extends PageRouteInfo<WaliSantriProgressPerSuratRouteArgs> {
  WaliSantriProgressPerSuratRoute({
    Key? key,
    required String name,
    required String nis,
    required int juzNumber,
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriProgressPerSuratRoute.name,
         args: WaliSantriProgressPerSuratRouteArgs(
           key: key,
           name: name,
           nis: nis,
           juzNumber: juzNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'WaliSantriProgressPerSuratRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WaliSantriProgressPerSuratRouteArgs>();
      return WaliSantriProgressPerSuratScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
        juzNumber: args.juzNumber,
      );
    },
  );
}

class WaliSantriProgressPerSuratRouteArgs {
  const WaliSantriProgressPerSuratRouteArgs({
    this.key,
    required this.name,
    required this.nis,
    required this.juzNumber,
  });

  final Key? key;

  final String name;

  final String nis;

  final int juzNumber;

  @override
  String toString() {
    return 'WaliSantriProgressPerSuratRouteArgs{key: $key, name: $name, nis: $nis, juzNumber: $juzNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriProgressPerSuratRouteArgs) return false;
    return key == other.key &&
        name == other.name &&
        nis == other.nis &&
        juzNumber == other.juzNumber;
  }

  @override
  int get hashCode =>
      key.hashCode ^ name.hashCode ^ nis.hashCode ^ juzNumber.hashCode;
}

/// generated route for
/// [WaliSantriRiwayatAbsensiScreen]
class WaliSantriRiwayatAbsensiRoute
    extends PageRouteInfo<WaliSantriRiwayatAbsensiRouteArgs> {
  WaliSantriRiwayatAbsensiRoute({
    Key? key,
    required String name,
    required String nis,
    String programType = 'reguler',
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriRiwayatAbsensiRoute.name,
         args: WaliSantriRiwayatAbsensiRouteArgs(
           key: key,
           name: name,
           nis: nis,
           programType: programType,
         ),
         rawPathParams: {'name': name, 'nis': nis, 'programType': programType},
         initialChildren: children,
       );

  static const String name = 'WaliSantriRiwayatAbsensiRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WaliSantriRiwayatAbsensiRouteArgs>(
        orElse: () => WaliSantriRiwayatAbsensiRouteArgs(
          name: pathParams.getString('name'),
          nis: pathParams.getString('nis'),
          programType: pathParams.getString('programType', 'reguler'),
        ),
      );
      return WaliSantriRiwayatAbsensiScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
        programType: args.programType,
      );
    },
  );
}

class WaliSantriRiwayatAbsensiRouteArgs {
  const WaliSantriRiwayatAbsensiRouteArgs({
    this.key,
    required this.name,
    required this.nis,
    this.programType = 'reguler',
  });

  final Key? key;

  final String name;

  final String nis;

  final String programType;

  @override
  String toString() {
    return 'WaliSantriRiwayatAbsensiRouteArgs{key: $key, name: $name, nis: $nis, programType: $programType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriRiwayatAbsensiRouteArgs) return false;
    return key == other.key &&
        name == other.name &&
        nis == other.nis &&
        programType == other.programType;
  }

  @override
  int get hashCode =>
      key.hashCode ^ name.hashCode ^ nis.hashCode ^ programType.hashCode;
}

/// generated route for
/// [WaliSantriRiwayatHafalanScreen]
class WaliSantriRiwayatHafalanRoute
    extends PageRouteInfo<WaliSantriRiwayatHafalanRouteArgs> {
  WaliSantriRiwayatHafalanRoute({
    Key? key,
    required String name,
    required String nis,
    List<PageRouteInfo>? children,
  }) : super(
         WaliSantriRiwayatHafalanRoute.name,
         args: WaliSantriRiwayatHafalanRouteArgs(
           key: key,
           name: name,
           nis: nis,
         ),
         initialChildren: children,
       );

  static const String name = 'WaliSantriRiwayatHafalanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WaliSantriRiwayatHafalanRouteArgs>();
      return WaliSantriRiwayatHafalanScreen(
        key: args.key,
        name: args.name,
        nis: args.nis,
      );
    },
  );
}

class WaliSantriRiwayatHafalanRouteArgs {
  const WaliSantriRiwayatHafalanRouteArgs({
    this.key,
    required this.name,
    required this.nis,
  });

  final Key? key;

  final String name;

  final String nis;

  @override
  String toString() {
    return 'WaliSantriRiwayatHafalanRouteArgs{key: $key, name: $name, nis: $nis}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WaliSantriRiwayatHafalanRouteArgs) return false;
    return key == other.key && name == other.name && nis == other.nis;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode ^ nis.hashCode;
}

/// generated route for
/// [WaliSantriUbahPasswordScreen]
class WaliSantriUbahPasswordRoute extends PageRouteInfo<void> {
  const WaliSantriUbahPasswordRoute({List<PageRouteInfo>? children})
    : super(WaliSantriUbahPasswordRoute.name, initialChildren: children);

  static const String name = 'WaliSantriUbahPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WaliSantriUbahPasswordScreen();
    },
  );
}
