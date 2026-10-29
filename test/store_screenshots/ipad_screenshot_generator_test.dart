// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/locale/cubit/locale_cubit.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/theme/cubit/theme_cubit.dart';
import 'package:my_halaqoh/src/core/widget/navigation/app_liquid_bottom_nav.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_record_entry.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_state.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/barcode_scanner_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/detail_absensi_hari_ini_screen.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/domain/models/latest_setoran_item.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_state.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/screens/guru_dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/input_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/input_hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/progress_hafalan_per_juz_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_cubit.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_state.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/cubits/sertifikasi_cubit.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/cubits/sertifikasi_state.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/screens/wali_santri_dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_progress_hafalan_cubit.dart';

// Mocks
class MockAuthCubit extends Mock implements AuthCubit {
  @override
  Future<void> close() async {}
}
class MockGuruCubit extends Mock implements GuruCubit {
  @override
  Future<void> close() async {}
}
class MockHalaqohCubit extends Mock implements HalaqohCubit {
  @override
  Future<void> close() async {}
}
class MockSantriCubit extends Mock implements SantriCubit {
  @override
  Future<void> close() async {}
}
class MockTargetHafalanCubit extends Mock implements TargetHafalanCubit {
  @override
  Future<void> close() async {}
}
class MockKelasCubit extends Mock implements KelasCubit {
  @override
  Future<void> close() async {}
}
class MockProgramCubit extends Mock implements ProgramCubit {
  @override
  Future<void> close() async {}
}
class MockDashboardSummaryCubit extends Mock implements DashboardSummaryCubit {
  @override
  Future<void> close() async {}
}
class MockThemeCubit extends Mock implements ThemeCubit {
  @override
  Future<void> close() async {}
}
class MockLocaleCubit extends Mock implements LocaleCubit {
  @override
  Future<void> close() async {}
}
class MockNotificationBadgeCubit extends Mock implements NotificationBadgeCubit {
  @override
  Future<void> close() async {}
}
class MockInputHafalanCubit extends Mock implements InputHafalanCubit {
  @override
  Future<void> close() async {}
}
class MockProgressHafalanCubit extends Mock implements ProgressHafalanCubit {
  @override
  Future<void> close() async {}
}
class MockWaliSantriProgressHafalanCubit extends Mock implements WaliSantriProgressHafalanCubit {
  @override
  Future<void> close() async {}
}
class MockAbsensiCubit extends Mock implements AbsensiCubit {
  @override
  Future<void> close() async {}
}
class MockSantriExtraTargetCubit extends Mock implements SantriExtraTargetCubit {
  @override
  Future<void> close() async {}
}
class MockSertifikasiCubit extends Mock implements SertifikasiCubit {
  @override
  Future<void> close() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const physicalWidth = 2048.0;
  const physicalHeight = 2732.0;
  const dpr = 2.0;
  const logicalSize = Size(physicalWidth / dpr, physicalHeight / dpr);

  final now = DateTime(2026, 10, 28, 16, 45);

  final sampleSantriList = [
    SantriModel(id: 's1', nama: 'Ahmad Bernas Satrio', nis: '3100002603', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's2', nama: 'Ach. Fikrie Ardana', nis: '3100002604', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's3', nama: 'Muhammad Ziyad Al-Farisi', nis: '3100002605', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's4', nama: 'Abdullah Azzam', nis: '3100002606', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's5', nama: 'Fadhil Rahman', nis: '3100002607', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's6', nama: 'Hamzah Asadullah', nis: '3100002608', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's7', nama: 'Bilal bin Rabah', nis: '3100002609', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's8', nama: 'Salman Al-Farisi', nis: '3100002610', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's9', nama: 'Usamah bin Zayd', nis: '3100002611', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
    SantriModel(id: 's10', nama: 'Thalhah bin Ubaidillah', nis: '3100002612', kelas: '7', program: 'R', halaqohId: 'halaqoh_1', createdAt: now, updatedAt: now),
  ];

  final sampleHalaqoh = HalaqohModel(
    id: 'halaqoh_1',
    nama: 'Halaqoh Al-Fatih 2',
    kelas: '7',
    program: 'R',
    guruId: 'guru_1',
    guruNama: 'Ust. Mufti Al-Faruqi',
    santriIds: ['s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8', 's9', 's10'],
    jumlahSantri: 10,
    createdAt: now,
    updatedAt: now,
  );

  final sampleGuru = GuruModel(
    id: 'guru_1',
    nip: '19870512',
    nama: 'Ust. Mufti Al-Faruqi',
    program: 'R',
    createdAt: now,
    updatedAt: now,
  );

  final sampleTarget = TargetHafalanModel(
    id: '7_Reguler',
    kelas: '7',
    program: 'Reguler',
    tahunAjaran: '2026/2027',
    semesterAktif: 1,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() async {
    print('[DEBUG] Initializing translations...');
    await LocaleSettings.setLocale(AppLocale.id);

    print('[DEBUG] Initializing date formatting...');
    await initializeDateFormatting('id_ID', null);
    await initializeDateFormatting('id', null);

    print('[DEBUG] Initializing QuranService...');
    try {
      await QuranService.instance.initialize();
    } catch (e) {
      print('[DEBUG] QuranService init note: $e');
    }

    print('[DEBUG] Loading Poppins fonts...');
    final fontPaths = [
      'assets/fonts/Poppins/Poppins-Regular.ttf',
      'assets/fonts/Poppins/Poppins-Medium.ttf',
      'assets/fonts/Poppins/Poppins-SemiBold.ttf',
      'assets/fonts/Poppins/Poppins-Bold.ttf',
    ];
    for (final p in fontPaths) {
      final file = File(p);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        await ui.loadFontFromList(bytes, fontFamily: 'Poppins');
      }
    }

    print('[DEBUG] Loading MaterialIcons font...');
    final iconFile = File('C:/src/flutter/bin/cache/artifacts/material_fonts/materialicons-regular.otf');
    if (iconFile.existsSync()) {
      final bytes = iconFile.readAsBytesSync();
      await ui.loadFontFromList(bytes, fontFamily: 'MaterialIcons');
    }
    print('[DEBUG] Fonts loaded successfully.');
  });

  // Helper to build full Juz 30 progress
  OverallHafalanProgress buildFullJuz30Progress() {
    final juz30 = QuranService.instance.getJuzByNumber(30);
    final surahProgressList = <SurahProgress>[];
    if (juz30 != null) {
      for (final s in juz30.surahs) {
        final surah = QuranService.instance.getSurahById(s.surahId);
        final segAyatCount = s.ayatEnd - s.ayatStart + 1;
        surahProgressList.add(
          SurahProgress(
            surahId: s.surahId,
            surahName: surah?.name ?? 'Surah ${s.surahId}',
            totalAyat: segAyatCount,
            memorizedAyat: segAyatCount,
          ),
        );
      }
    }
    final juz30Progress = JuzProgress(
      juzNumber: 30,
      totalAyat: 564,
      memorizedAyat: 564,
      surahProgressList: surahProgressList,
    );

    final juz29 = QuranService.instance.getJuzByNumber(29);
    final surah29List = <SurahProgress>[];
    if (juz29 != null) {
      for (final s in juz29.surahs) {
        final surah = QuranService.instance.getSurahById(s.surahId);
        final segAyatCount = s.ayatEnd - s.ayatStart + 1;
        surah29List.add(
          SurahProgress(
            surahId: s.surahId,
            surahName: surah?.name ?? 'Surah ${s.surahId}',
            totalAyat: segAyatCount,
            memorizedAyat: (segAyatCount * 0.6).round(),
          ),
        );
      }
    }
    final juz29Progress = JuzProgress(
      juzNumber: 29,
      totalAyat: 431,
      memorizedAyat: 260,
      surahProgressList: surah29List,
    );

    final allJuz = List.generate(30, (i) {
      final num = i + 1;
      if (num == 30) return juz30Progress;
      if (num == 29) return juz29Progress;
      return JuzProgress(juzNumber: num, totalAyat: 200, memorizedAyat: 0, surahProgressList: const []);
    });

    return OverallHafalanProgress(
      totalAyatQuran: 6236,
      totalMemorized: 824,
      juzProgressList: allJuz,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Screen 1: Guru Dashboard
  // ─────────────────────────────────────────────────────────────────────────────
  testWidgets('Generate 01_dashboard_guru_ipad.png', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(physicalWidth, physicalHeight);
    tester.view.devicePixelRatio = dpr;

    final mockAuthCubit = MockAuthCubit();
    final mockGuruCubit = MockGuruCubit();
    final mockHalaqohCubit = MockHalaqohCubit();
    final mockSantriCubit = MockSantriCubit();
    final mockTargetCubit = MockTargetHafalanCubit();
    final mockKelasCubit = MockKelasCubit();
    final mockProgramCubit = MockProgramCubit();
    final mockDashboardCubit = MockDashboardSummaryCubit();
    final mockThemeCubit = MockThemeCubit();
    final mockLocaleCubit = MockLocaleCubit();
    final mockNotificationBadgeCubit = MockNotificationBadgeCubit();

    when(() => mockAuthCubit.state).thenReturn(
      const AuthState.authenticated(
        UserModel(
          uid: 'guru_1',
          identifier: '19870512',
          role: 'guru',
          displayName: 'Ust. Mufti Al-Faruqi',
          linkedDocId: 'guru_1',
          programType: 'R',
        ),
      ),
    );
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockGuruCubit.state).thenReturn(GuruState.loaded([sampleGuru]));
    when(() => mockGuruCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockHalaqohCubit.state).thenReturn(HalaqohState.loaded([sampleHalaqoh]));
    when(() => mockHalaqohCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockSantriCubit.state).thenReturn(SantriState.loaded(sampleSantriList));
    when(() => mockSantriCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockTargetCubit.state).thenReturn(TargetHafalanState.loaded([sampleTarget]));
    when(() => mockTargetCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockKelasCubit.state).thenReturn(const KelasState.loaded([]));
    when(() => mockKelasCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockProgramCubit.state).thenReturn(const ProgramState.loaded([]));
    when(() => mockProgramCubit.stream).thenAnswer((_) => const Stream.empty());

    final recentItems = [
      LatestSetoranItem(
        santriId: 's1',
        santriName: 'Ahmad Bernas Satrio',
        tanggalSetoran: now.subtract(const Duration(minutes: 15)),
        jenis: 'Ziyadah',
        nilaiKelancaran: 95,
        nilaiTajwid: 95,
        records: [
          HafalanSantriModel(
            id: 'h1',
            santriId: 's1',
            guruId: 'guru_1',
            halaqohId: 'halaqoh_1',
            tanggalSetoran: now.subtract(const Duration(minutes: 15)),
            jenis: 'Ziyadah',
            surahId: 78,
            surahName: "An-Naba'",
            ayatMulai: 1,
            ayatSelesai: 40,
            juz: 30,
            nilaiKelancaran: 95,
            nilaiTajwid: 95,
            createdAt: now,
          ),
        ],
      ),
      LatestSetoranItem(
        santriId: 's2',
        santriName: 'Ach. Fikrie Ardana',
        tanggalSetoran: now.subtract(const Duration(minutes: 30)),
        jenis: "Muraja'ah",
        nilaiKelancaran: 92,
        nilaiTajwid: 92,
        records: [
          HafalanSantriModel(
            id: 'h2',
            santriId: 's2',
            guruId: 'guru_1',
            halaqohId: 'halaqoh_1',
            tanggalSetoran: now.subtract(const Duration(minutes: 30)),
            jenis: "Muraja'ah",
            surahId: 79,
            surahName: "An-Nazi'at",
            ayatMulai: 1,
            ayatSelesai: 46,
            juz: 30,
            nilaiKelancaran: 92,
            nilaiTajwid: 92,
            createdAt: now,
          ),
        ],
      ),
    ];

    when(() => mockDashboardCubit.state).thenReturn(
      DashboardSummaryState.loaded(
        attendedCount: 10,
        totalSantriCount: 10,
        attendancePercent: 1.0,
        setoranCount: 9,
        setoranPercent: 0.90,
        activeSesi: 'ashar',
        latestSetoran: recentItems,
      ),
    );
    when(() => mockDashboardCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockDashboardCubit.loadDashboardData(
      halaqohId: any(named: 'halaqohId'),
      santriIds: any(named: 'santriIds'),
      santriNameMap: any(named: 'santriNameMap'),
      programType: any(named: 'programType'),
    )).thenAnswer((_) async {});

    when(() => mockNotificationBadgeCubit.state).thenReturn(
      const NotificationBadgeState.loaded(items: [], unreadCount: 2),
    );
    when(() => mockNotificationBadgeCubit.stream).thenAnswer((_) => const Stream.empty());

    final sl = GetIt.instance;
    await sl.reset();
    sl.registerLazySingleton<DashboardSummaryCubit>(() => mockDashboardCubit);
    sl.registerLazySingleton<ThemeCubit>(() => mockThemeCubit);
    sl.registerLazySingleton<LocaleCubit>(() => mockLocaleCubit);
    sl.registerLazySingleton<NotificationBadgeCubit>(() => mockNotificationBadgeCubit);

    final repaintKey = GlobalKey();

    final testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        BlocProvider<GuruCubit>.value(value: mockGuruCubit),
        BlocProvider<HalaqohCubit>.value(value: mockHalaqohCubit),
        BlocProvider<SantriCubit>.value(value: mockSantriCubit),
        BlocProvider<TargetHafalanCubit>.value(value: mockTargetCubit),
        BlocProvider<KelasCubit>.value(value: mockKelasCubit),
        BlocProvider<ProgramCubit>.value(value: mockProgramCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(600, 900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
            home: Scaffold(
              backgroundColor: const Color(0xFFF8F9FA),
              body: SizedBox(
                width: logicalSize.width,
                height: logicalSize.height,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: GuruDashboardScreen(programType: 'reguler'),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AppLiquidBottomNav(
                          currentIndex: 0,
                          items: [
                            AppLiquidNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Beranda'),
                            AppLiquidNavItem(icon: Icons.auto_stories_outlined, selectedIcon: Icons.auto_stories, label: 'Halaqoh'),
                            AppLiquidNavItem(icon: Icons.qr_code_scanner_outlined, selectedIcon: Icons.qr_code_scanner, label: 'Absensi'),
                            AppLiquidNavItem(icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: 'Hafalan'),
                            AppLiquidNavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profil'),
                          ],
                          theme: AppLiquidNavTheme(
                            surfaceColor: Colors.white,
                            blurSigma: 0,
                            accentColor: const Color(0xFF115D69),
                            selectedColor: Colors.white,
                            unselectedColor: Colors.grey.shade600,
                            borderColor: Colors.grey.shade200,
                            height: 72,
                            bottomGap: 16,
                            horizontalMargin: 24,
                            iconSize: 24,
                            labelFontSize: 11,
                          ),
                          onTap: (_) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.runAsync(() async {
      final element = tester.element(find.byType(MaterialApp));
      await precacheImage(const AssetImage('assets/images/my_halaqoh_logo_new.png'), element);
      await precacheImage(const AssetImage('assets/images/Mosque-Silhouette.png'), element);
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: dpr);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final outFile = File('app_store_assets/2_screenshots/ipad_13_inch/01_dashboard_guru_ipad_raw.png');
      await outFile.writeAsBytes(pngBytes);
      print('[DEBUG] SUCCESS: Saved raw 01 (${image.width}x${image.height})');
    });

    await tester.pumpWidget(const SizedBox());
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // Screen 2: Barcode Scanner
  // ─────────────────────────────────────────────────────────────────────────────
  testWidgets('Generate 02_barcode_scanner_ipad.png', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(physicalWidth, physicalHeight);
    tester.view.devicePixelRatio = dpr;

    final mockAuthCubit = MockAuthCubit();
    final mockHalaqohCubit = MockHalaqohCubit();
    final mockSantriCubit = MockSantriCubit();

    when(() => mockAuthCubit.state).thenReturn(
      const AuthState.authenticated(
        UserModel(
          uid: 'guru_1',
          identifier: '19870512',
          role: 'guru',
          displayName: 'Ust. Mufti Al-Faruqi',
          linkedDocId: 'guru_1',
          programType: 'R',
        ),
      ),
    );
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockHalaqohCubit.state).thenReturn(HalaqohState.loaded([sampleHalaqoh]));
    when(() => mockHalaqohCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockSantriCubit.state).thenReturn(SantriState.loaded(sampleSantriList));
    when(() => mockSantriCubit.stream).thenAnswer((_) => const Stream.empty());

    final repaintKey = GlobalKey();

    final testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        BlocProvider<HalaqohCubit>.value(value: mockHalaqohCubit),
        BlocProvider<SantriCubit>.value(value: mockSantriCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(600, 900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins'),
            home: Scaffold(
              body: SizedBox(
                width: logicalSize.width,
                height: logicalSize.height,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: BarcodeScannerScreen(
                    selectedDate: now,
                    selectedSesi: 'ashar',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.runAsync(() async {
      final element = tester.element(find.byType(MaterialApp));
      await precacheImage(const AssetImage('assets/images/my_halaqoh_logo_new.png'), element);
      await precacheImage(const AssetImage('assets/images/Mosque-Silhouette.png'), element);
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: dpr);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final outFile = File('app_store_assets/2_screenshots/ipad_13_inch/02_barcode_scanner_ipad_raw.png');
      await outFile.writeAsBytes(pngBytes);
      print('[DEBUG] SUCCESS: Saved raw 02 (${image.width}x${image.height})');
    });

    await tester.pumpWidget(const SizedBox());
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // Screen 3: Input Hafalan Screen
  // ─────────────────────────────────────────────────────────────────────────────
  testWidgets('Generate 03_input_hafalan_ipad.png', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(physicalWidth, physicalHeight);
    tester.view.devicePixelRatio = dpr;

    final mockAuthCubit = MockAuthCubit();
    final mockHalaqohCubit = MockHalaqohCubit();
    final mockSantriCubit = MockSantriCubit();
    final mockInputHafalanCubit = MockInputHafalanCubit();

    when(() => mockAuthCubit.state).thenReturn(
      const AuthState.authenticated(
        UserModel(
          uid: 'guru_1',
          identifier: '19870512',
          role: 'guru',
          displayName: 'Ust. Mufti Al-Faruqi',
          linkedDocId: 'guru_1',
          programType: 'R',
        ),
      ),
    );
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockHalaqohCubit.state).thenReturn(HalaqohState.loaded([sampleHalaqoh]));
    when(() => mockHalaqohCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSantriCubit.state).thenReturn(SantriState.loaded(sampleSantriList));
    when(() => mockSantriCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockInputHafalanCubit.state).thenReturn(const InputHafalanState.initial());
    when(() => mockInputHafalanCubit.stream).thenAnswer((_) => const Stream.empty());

    final sl = GetIt.instance;
    await sl.reset();
    sl.registerLazySingleton<InputHafalanCubit>(() => mockInputHafalanCubit);

    final editRecords = [
      HafalanSantriModel(
        id: 'h1',
        santriId: 's1',
        guruId: 'guru_1',
        halaqohId: 'halaqoh_1',
        tanggalSetoran: now,
        jenis: 'Ziyadah',
        surahId: 78,
        surahName: "An-Naba'",
        ayatMulai: 1,
        ayatSelesai: 40,
        juz: 30,
        nilaiKelancaran: 92,
        nilaiTajwid: 95,
        createdAt: now,
      ),
    ];

    final repaintKey = GlobalKey();

    final testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        BlocProvider<HalaqohCubit>.value(value: mockHalaqohCubit),
        BlocProvider<SantriCubit>.value(value: mockSantriCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(600, 900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
            home: Scaffold(
              body: SizedBox(
                width: logicalSize.width,
                height: logicalSize.height,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: InputHafalanScreen(
                    santriId: 's1',
                    name: 'Ahmad Bernas Satrio',
                    nis: '3100002603',
                    halaqohId: 'halaqoh_1',
                    guruId: 'guru_1',
                    editRecords: editRecords,
                  ).wrappedRoute(context),
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.runAsync(() async {
      final element = tester.element(find.byType(MaterialApp));
      await precacheImage(const AssetImage('assets/images/my_halaqoh_logo_new.png'), element);
      await precacheImage(const AssetImage('assets/images/Mosque-Silhouette.png'), element);
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: dpr);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final outFile = File('app_store_assets/2_screenshots/ipad_13_inch/03_input_hafalan_ipad_raw.png');
      await outFile.writeAsBytes(pngBytes);
      print('[DEBUG] SUCCESS: Saved raw 03 (${image.width}x${image.height})');
    });

    await tester.pumpWidget(const SizedBox());
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // Screen 4: Wali Santri Dashboard Screen
  // ─────────────────────────────────────────────────────────────────────────────
  testWidgets('Generate 04_dashboard_wali_ipad.png', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(physicalWidth, physicalHeight);
    tester.view.devicePixelRatio = dpr;

    final mockAuthCubit = MockAuthCubit();
    final mockHalaqohCubit = MockHalaqohCubit();
    final mockSantriCubit = MockSantriCubit();
    final mockTargetCubit = MockTargetHafalanCubit();
    final mockProgressCubit = MockWaliSantriProgressHafalanCubit();
    final mockAbsensiCubit = MockAbsensiCubit();
    final mockExtraTargetCubit = MockSantriExtraTargetCubit();
    final mockThemeCubit = MockThemeCubit();
    final mockLocaleCubit = MockLocaleCubit();
    final mockNotificationBadgeCubit = MockNotificationBadgeCubit();

    when(() => mockAuthCubit.state).thenReturn(
      const AuthState.authenticated(
        UserModel(
          uid: 'santri_user_1',
          identifier: '3100002603',
          role: 'santri',
          displayName: 'Ahmad Bernas Satrio',
          linkedDocId: 's1',
          programType: 'R',
        ),
      ),
    );
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockHalaqohCubit.state).thenReturn(HalaqohState.loaded([sampleHalaqoh]));
    when(() => mockHalaqohCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockSantriCubit.state).thenReturn(SantriState.loaded(sampleSantriList));
    when(() => mockSantriCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockTargetCubit.state).thenReturn(TargetHafalanState.loaded([sampleTarget]));
    when(() => mockTargetCubit.stream).thenAnswer((_) => const Stream.empty());

    final overallProgress = buildFullJuz30Progress();

    when(() => mockProgressCubit.state).thenReturn(WaliSantriProgressHafalanState.loaded(overallProgress));
    when(() => mockProgressCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockProgressCubit.watchProgress(any())).thenAnswer((_) {});

    final absensiEntries = [
      AbsensiModel(
        id: 'abs_1',
        halaqohId: 'halaqoh_1',
        guruId: 'guru_1',
        tanggal: now,
        sesi: 'ashar',
        records: [
          const AbsensiRecordEntry(santriId: 's1', nis: '3100002603', nama: 'Ahmad Bernas Satrio', status: 'hadir'),
        ],
        createdAt: now,
        updatedAt: now,
      ),
    ];
    when(() => mockAbsensiCubit.state).thenReturn(AbsensiState.loaded(absensiEntries));
    when(() => mockAbsensiCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAbsensiCubit.watchByHalaqohFromRemote(any())).thenAnswer((_) {});

    when(() => mockExtraTargetCubit.state).thenReturn(const SantriExtraTargetState.loaded([]));
    when(() => mockExtraTargetCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockExtraTargetCubit.watchExtraJuz(any())).thenAnswer((_) {});

    when(() => mockNotificationBadgeCubit.state).thenReturn(
      const NotificationBadgeState.loaded(items: [], unreadCount: 1),
    );
    when(() => mockNotificationBadgeCubit.stream).thenAnswer((_) => const Stream.empty());

    final sl = GetIt.instance;
    await sl.reset();
    sl.registerLazySingleton<WaliSantriProgressHafalanCubit>(() => mockProgressCubit);
    sl.registerLazySingleton<AbsensiCubit>(() => mockAbsensiCubit);
    sl.registerLazySingleton<SantriExtraTargetCubit>(() => mockExtraTargetCubit);
    sl.registerLazySingleton<ThemeCubit>(() => mockThemeCubit);
    sl.registerLazySingleton<LocaleCubit>(() => mockLocaleCubit);
    sl.registerLazySingleton<NotificationBadgeCubit>(() => mockNotificationBadgeCubit);

    final repaintKey = GlobalKey();

    final testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        BlocProvider<HalaqohCubit>.value(value: mockHalaqohCubit),
        BlocProvider<SantriCubit>.value(value: mockSantriCubit),
        BlocProvider<TargetHafalanCubit>.value(value: mockTargetCubit),
        BlocProvider<SantriExtraTargetCubit>.value(value: mockExtraTargetCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(600, 900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
            home: Scaffold(
              backgroundColor: const Color(0xFFF8F9FA),
              body: SizedBox(
                width: logicalSize.width,
                height: logicalSize.height,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: WaliSantriDashboardScreen(programType: 'reguler'),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AppLiquidBottomNav(
                          currentIndex: 0,
                          items: [
                            AppLiquidNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Beranda'),
                            AppLiquidNavItem(icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: 'Hafalan'),
                            AppLiquidNavItem(icon: Icons.fact_check_outlined, selectedIcon: Icons.fact_check, label: 'Presensi'),
                            AppLiquidNavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profil'),
                          ],
                          theme: AppLiquidNavTheme(
                            surfaceColor: Colors.white,
                            blurSigma: 0,
                            accentColor: const Color(0xFF115D69),
                            selectedColor: Colors.white,
                            unselectedColor: Colors.grey.shade600,
                            borderColor: Colors.grey.shade200,
                            height: 72,
                            bottomGap: 16,
                            horizontalMargin: 24,
                            iconSize: 24,
                            labelFontSize: 11,
                          ),
                          onTap: (_) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.runAsync(() async {
      final element = tester.element(find.byType(MaterialApp));
      await precacheImage(const AssetImage('assets/images/my_halaqoh_logo_new.png'), element);
      await precacheImage(const AssetImage('assets/images/Mosque-Silhouette.png'), element);
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: dpr);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final outFile = File('app_store_assets/2_screenshots/ipad_13_inch/04_dashboard_wali_ipad_raw.png');
      await outFile.writeAsBytes(pngBytes);
      print('[DEBUG] SUCCESS: Saved raw 04 (${image.width}x${image.height})');
    });

    await tester.pumpWidget(const SizedBox());
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // Screen 5: Progress Hafalan Per Juz
  // ─────────────────────────────────────────────────────────────────────────────
  testWidgets('Generate 05_progress_juz_ipad.png', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(physicalWidth, physicalHeight);
    tester.view.devicePixelRatio = dpr;

    final mockProgressCubit = MockProgressHafalanCubit();
    final mockExtraTargetCubit = MockSantriExtraTargetCubit();
    final mockSertifikasiCubit = MockSertifikasiCubit();
    final mockTargetCubit = MockTargetHafalanCubit();
    final mockSantriCubit = MockSantriCubit();

    when(() => mockSantriCubit.state).thenReturn(SantriState.loaded(sampleSantriList));
    when(() => mockSantriCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockTargetCubit.state).thenReturn(TargetHafalanState.loaded([sampleTarget]));
    when(() => mockTargetCubit.stream).thenAnswer((_) => const Stream.empty());

    final overallProgress = buildFullJuz30Progress();

    when(() => mockProgressCubit.state).thenReturn(ProgressHafalanState.loaded(overallProgress));
    when(() => mockProgressCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockProgressCubit.watchProgress(any())).thenAnswer((_) {});

    when(() => mockExtraTargetCubit.state).thenReturn(const SantriExtraTargetState.loaded([]));
    when(() => mockExtraTargetCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockExtraTargetCubit.watchExtraJuz(any())).thenAnswer((_) {});

    final sertifikasiSample = SertifikasiModel(
      id: 'sert_1',
      santriId: 's1',
      santriNama: 'Ahmad Bernas Satrio',
      nis: '3100002603',
      kelas: '7',
      program: 'R',
      guruId: 'guru_1',
      guruNama: 'Ust. Mufti Al-Faruqi',
      halaqohId: 'halaqoh_1',
      halaqohNama: 'Halaqoh Al-Fatih 2',
      juz: 30,
      tanggalUjian: now.subtract(const Duration(days: 7)),
      nilai: 95,
      predikat: 'Mumtaz',
      status: 'passed',
      catatanPenguji: 'Mumtaz',
      createdAt: now,
      updatedAt: now,
    );
    when(() => mockSertifikasiCubit.state).thenReturn(SertifikasiState.loaded([sertifikasiSample]));
    when(() => mockSertifikasiCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSertifikasiCubit.watchBySantriId(any())).thenAnswer((_) {});

    final sl = GetIt.instance;
    await sl.reset();
    sl.registerLazySingleton<ProgressHafalanCubit>(() => mockProgressCubit);
    sl.registerLazySingleton<SantriExtraTargetCubit>(() => mockExtraTargetCubit);
    sl.registerLazySingleton<SertifikasiCubit>(() => mockSertifikasiCubit);

    final repaintKey = GlobalKey();

    final testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<TargetHafalanCubit>.value(value: mockTargetCubit),
        BlocProvider<SantriCubit>.value(value: mockSantriCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(600, 900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
            home: Scaffold(
              body: SizedBox(
                width: logicalSize.width,
                height: logicalSize.height,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: ProgressHafalanPerJuzScreen(
                    santriId: 's1',
                    name: 'Ahmad Bernas Satrio',
                    nis: '3100002603',
                  ).wrappedRoute(context),
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.runAsync(() async {
      final element = tester.element(find.byType(MaterialApp));
      await precacheImage(const AssetImage('assets/images/my_halaqoh_logo_new.png'), element);
      await precacheImage(const AssetImage('assets/images/Mosque-Silhouette.png'), element);
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: dpr);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final outFile = File('app_store_assets/2_screenshots/ipad_13_inch/05_progress_juz_ipad_raw.png');
      await outFile.writeAsBytes(pngBytes);
      print('[DEBUG] SUCCESS: Saved raw 05 (${image.width}x${image.height})');
    });

    await tester.pumpWidget(const SizedBox());
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // Screen 6: Detail Absensi Hari Ini
  // ─────────────────────────────────────────────────────────────────────────────
  testWidgets('Generate 06_detail_absensi_ipad.png', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(physicalWidth, physicalHeight);
    tester.view.devicePixelRatio = dpr;

    final mockAuthCubit = MockAuthCubit();
    final mockHalaqohCubit = MockHalaqohCubit();
    final mockSantriCubit = MockSantriCubit();
    final mockAbsensiCubit = MockAbsensiCubit();

    when(() => mockAuthCubit.state).thenReturn(
      const AuthState.authenticated(
        UserModel(
          uid: 'guru_1',
          identifier: '19870512',
          role: 'guru',
          displayName: 'Ust. Mufti Al-Faruqi',
          linkedDocId: 'guru_1',
          programType: 'R',
        ),
      ),
    );
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockHalaqohCubit.state).thenReturn(HalaqohState.loaded([sampleHalaqoh]));
    when(() => mockHalaqohCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockSantriCubit.state).thenReturn(SantriState.loaded(sampleSantriList));
    when(() => mockSantriCubit.stream).thenAnswer((_) => const Stream.empty());

    final absensiEntries = [
      AbsensiModel(
        id: 'abs_1',
        halaqohId: 'halaqoh_1',
        guruId: 'guru_1',
        tanggal: now,
        sesi: 'ashar',
        records: sampleSantriList.map((s) => AbsensiRecordEntry(
          santriId: s.id,
          nis: s.nis,
          nama: s.nama,
          status: 'hadir',
        )).toList(),
        createdAt: now,
        updatedAt: now,
      ),
    ];

    when(() => mockAbsensiCubit.state).thenReturn(AbsensiState.loaded(absensiEntries));
    when(() => mockAbsensiCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAbsensiCubit.findExisting(any(), any(), any())).thenAnswer((_) async => absensiEntries.first);

    final sl = GetIt.instance;
    await sl.reset();
    sl.registerLazySingleton<AbsensiCubit>(() => mockAbsensiCubit);

    final repaintKey = GlobalKey();

    final testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        BlocProvider<HalaqohCubit>.value(value: mockHalaqohCubit),
        BlocProvider<SantriCubit>.value(value: mockSantriCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(600, 900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
            home: Scaffold(
              body: SizedBox(
                width: logicalSize.width,
                height: logicalSize.height,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: DetailAbsensiHariIniScreen(
                    selectedDate: now,
                    selectedSesi: 'ashar',
                    scannedNisList: sampleSantriList.map((s) => s.nis).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.runAsync(() async {
      final element = tester.element(find.byType(MaterialApp));
      await precacheImage(const AssetImage('assets/images/my_halaqoh_logo_new.png'), element);
      await precacheImage(const AssetImage('assets/images/Mosque-Silhouette.png'), element);
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: dpr);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final outFile = File('app_store_assets/2_screenshots/ipad_13_inch/06_detail_absensi_ipad_raw.png');
      await outFile.writeAsBytes(pngBytes);
      print('[DEBUG] SUCCESS: Saved raw 06 (${image.width}x${image.height})');
    });

    await tester.pumpWidget(const SizedBox());
  });
}
