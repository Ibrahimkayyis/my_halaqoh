import 'package:my_halaqoh/src/modules/guru_hafalan/data/datasources/local/hafalan_santri_local_data_source.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/data/datasources/remote/source/abstract/hafalan_santri_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/data/datasources/remote/source/implementation/hafalan_santri_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/repositories/hafalan_santri_repository.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/data/repositories_impl/hafalan_santri_repository_impl.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/services/hafalan_sync_service.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/input_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/riwayat_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_halaqoh/src/core/theme/data/theme_repository.dart';
import 'package:my_halaqoh/src/core/theme/cubit/theme_cubit.dart';
import 'package:my_halaqoh/src/core/locale/data/locale_repository.dart';
import 'package:my_halaqoh/src/core/locale/cubit/locale_cubit.dart';

// Auth Layer
import 'package:my_halaqoh/src/modules/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/auth/domain/repositories/auth_repository.dart';
import 'package:my_halaqoh/src/modules/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/core/services/storage_service.dart';

// Master Data — Data Layer
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/guru_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/halaqoh_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/target_hafalan_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/implementation/guru_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/implementation/santri_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/implementation/halaqoh_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/implementation/target_hafalan_remote_datasource_impl.dart';

// Master Data — Domain Layer
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/guru_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/halaqoh_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/target_hafalan_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/data/repositories_impl/guru_repository_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/repositories_impl/santri_repository_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/repositories_impl/halaqoh_repository_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/repositories_impl/target_hafalan_repository_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_extra_target_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/implementation/santri_extra_target_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/data/repositories_impl/santri_extra_target_repository_impl.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_extra_target_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_cubit.dart';

// Master Data — Presentation Layer (Cubits)
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';

// Guru Absensi — Data Layer
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/local/absensi_local_datasource.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/remote/source/abstract/absensi_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/remote/source/implementation/absensi_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/remote/source/implementation/absensi_sync_service.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/repositories_impl/absensi_repository_impl.dart';

// Guru Absensi — Domain Layer
import 'package:my_halaqoh/src/modules/guru_absensi/domain/repositories/absensi_repository.dart';

// Guru Absensi — Presentation Layer
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';

// Guru Profile — Data Layer
import 'package:my_halaqoh/src/modules/guru_profile/data/datasources/remote/source/abstract/guru_profile_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/guru_profile/data/datasources/remote/source/implementation/guru_profile_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/guru_profile/data/repositories_impl/guru_profile_repository_impl.dart';

// Guru Profile — Domain Layer
import 'package:my_halaqoh/src/modules/guru_profile/domain/repositories/guru_profile_repository.dart';

// Guru Profile — Presentation Layer
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_cubit.dart';

// Wali Santri Hafalan — Data Layer
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/data/datasources/remote/source/abstract/wali_santri_hafalan_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/data/datasources/remote/source/implementation/wali_santri_hafalan_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/data/repositories_impl/wali_santri_hafalan_repository_impl.dart';

// Wali Santri Hafalan — Domain Layer
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/repositories/wali_santri_hafalan_repository.dart';

// Wali Santri Hafalan — Presentation Layer
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_riwayat_hafalan_cubit.dart';

// Wali Santri Profile — Data Layer
import 'package:my_halaqoh/src/modules/wali_santri_profile/data/datasources/remote/source/abstract/wali_santri_profile_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/data/datasources/remote/source/implementation/wali_santri_profile_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/data/repositories_impl/wali_santri_profile_repository_impl.dart';

// Wali Santri Profile — Domain Layer
import 'package:my_halaqoh/src/modules/wali_santri_profile/domain/repositories/wali_santri_profile_repository.dart';

// Wali Santri Profile — Presentation Layer
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_cubit.dart';

// Notifications — Data Layer
import 'package:my_halaqoh/src/modules/notifications/data/datasources/remote/source/abstract/notification_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/notifications/data/datasources/remote/source/implementation/notification_remote_datasource_impl.dart';
import 'package:my_halaqoh/src/modules/notifications/data/repositories_impl/notification_repository_impl.dart';

// Notifications — Domain Layer
import 'package:my_halaqoh/src/modules/notifications/domain/repositories/notification_repository.dart';

// Notifications — Presentation Layer
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_cubit.dart';

// Guru Laporan — Presentation Layer
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/cubits/laporan_absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/cubits/laporan_absensi_halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/cubits/laporan_hafalan_cubit.dart';

final sl = GetIt.instance;

/// Call this in main.dart before runApp()
Future<void> initDependencies() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Theme System
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepository(sl()));
  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl()));

  // Locale System
  sl.registerLazySingleton<LocaleRepository>(() => LocaleRepository(sl()));
  sl.registerSingleton<LocaleCubit>(LocaleCubit(sl()));

  // Core Services
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // ── Firebase ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFunctions>(
    // Functions createUserAccount, resetUserPassword, onDeleteUser are deployed
    // to us-central1 (Firebase default). The notification functions run in
    // asia-southeast2 but are triggered server-side, not called by the client.
    () => FirebaseFunctions.instance,
  );
  sl.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerSingleton<AuthCubit>(AuthCubit(sl()));

  // ── Master Data — Local DataSource ────────────────────────────────────────
  sl.registerSingleton<MasterDataLocalDataSource>(
    MasterDataLocalDataSource(),
  );

  // ── Master Data — Remote DataSources ──────────────────────────────────────
  sl.registerLazySingleton<GuruRemoteDataSource>(
    () => GuruRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<SantriRemoteDataSource>(
    () => SantriRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<HalaqohRemoteDataSource>(
    () => HalaqohRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TargetHafalanRemoteDataSource>(
    () => TargetHafalanRemoteDataSourceImpl(sl()),
  );

  // ── Master Data — Repositories ────────────────────────────────────────────
  sl.registerLazySingleton<GuruRepository>(
    () => GuruRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<SantriRepository>(
    () => SantriRepositoryImpl(sl(), sl(), sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<HalaqohRepository>(
    () => HalaqohRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<TargetHafalanRepository>(
    () => TargetHafalanRepositoryImpl(sl(), sl()),
  );

  // ── Master Data — Cubits ──────────────────────────────────────────────────
  sl.registerFactory<GuruCubit>(() => GuruCubit(sl()));
  sl.registerFactory<SantriCubit>(() => SantriCubit(sl()));
  sl.registerFactory<HalaqohCubit>(() => HalaqohCubit(sl()));
  sl.registerFactory<TargetHafalanCubit>(() => TargetHafalanCubit(sl()));

  // ── Master Data — SantriExtraTarget (Firestore teacher-added targets) ──────
  sl.registerLazySingleton<SantriExtraTargetRemoteDataSource>(
    () => SantriExtraTargetRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SantriExtraTargetRepository>(
    () => SantriExtraTargetRepositoryImpl(sl()),
  );
  sl.registerFactory<SantriExtraTargetCubit>(
    () => SantriExtraTargetCubit(sl()),
  );

  // ── Guru Absensi — DataSources ─────────────────────────────────────────────
  sl.registerLazySingleton<AbsensiLocalDataSource>(
    () => AbsensiLocalDataSource(),
  );
  sl.registerLazySingleton<AbsensiRemoteDataSource>(
    () => AbsensiRemoteDataSourceImpl(sl()),
  );

  // ── Guru Absensi — Repository ──────────────────────────────────────────────
  sl.registerLazySingleton<AbsensiRepository>(
    () => AbsensiRepositoryImpl(sl(), sl()),
  );

  // ── Guru Absensi — Sync Service ────────────────────────────────────────────
  sl.registerLazySingleton<AbsensiSyncService>(
    () => AbsensiSyncService(sl()),
  );

  // ── Guru Absensi — Cubit (Factory — requires halaqohId scoping) ────────────
  sl.registerFactory<AbsensiCubit>(() => AbsensiCubit(sl()));

  // ── Guru Hafalan — DataSources ─────────────────────────────────────────────
  sl.registerLazySingleton<HafalanSantriLocalDataSource>(
    () => HafalanSantriLocalDataSource(),
  );
  sl.registerLazySingleton<HafalanSantriRemoteDataSource>(
    () => HafalanSantriRemoteDataSourceImpl(sl()),
  );

  // ── Guru Hafalan — Repository ──────────────────────────────────────────────
  sl.registerLazySingleton<HafalanSantriRepository>(
    () => HafalanSantriRepositoryImpl(sl(), sl()),
  );

  // ── Guru Hafalan — Sync Service ────────────────────────────────────────────
  sl.registerLazySingleton<HafalanSyncService>(
    () => HafalanSyncService(sl()),
  );

  // ── Guru Hafalan — Cubits ──────────────────────────────────────────────────
  sl.registerFactory<InputHafalanCubit>(() => InputHafalanCubit(sl()));
  sl.registerFactory<RiwayatHafalanCubit>(() => RiwayatHafalanCubit(sl()));
  sl.registerFactory<ProgressHafalanCubit>(() => ProgressHafalanCubit(sl()));

  // ── Guru Dashboard — Cubits ─────────────────────────────────────────────────
  sl.registerFactory<DashboardSummaryCubit>(
    () => DashboardSummaryCubit(sl(), sl()),
  );

  // ── Guru Profile — DataSources ──────────────────────────────────────────────
  sl.registerLazySingleton<GuruProfileRemoteDataSource>(
    () => GuruProfileRemoteDataSourceImpl(sl(), sl(), sl()),
  );

  // ── Guru Profile — Repository ──────────────────────────────────────────────
  sl.registerLazySingleton<GuruProfileRepository>(
    () => GuruProfileRepositoryImpl(sl()),
  );

  // ── Guru Profile — Cubit (Factory — scoped per screen) ─────────────────────
  sl.registerFactory<GuruProfileCubit>(() => GuruProfileCubit(sl()));

  // ── Wali Santri Hafalan — DataSources ──────────────────────────────────────
  sl.registerLazySingleton<WaliSantriHafalanRemoteDataSource>(
    () => WaliSantriHafalanRemoteDataSourceImpl(sl()),
  );

  // ── Wali Santri Hafalan — Repository ───────────────────────────────────────
  sl.registerLazySingleton<WaliSantriHafalanRepository>(
    () => WaliSantriHafalanRepositoryImpl(sl()),
  );

  // ── Wali Santri Hafalan — Cubits ───────────────────────────────────────────
  sl.registerFactory<WaliSantriRiwayatHafalanCubit>(() => WaliSantriRiwayatHafalanCubit(sl()));
  sl.registerFactory<WaliSantriProgressHafalanCubit>(() => WaliSantriProgressHafalanCubit(sl()));

  // ── Wali Santri Profile — DataSources ──────────────────────────────────────
  sl.registerLazySingleton<WaliSantriProfileRemoteDataSource>(
    () => WaliSantriProfileRemoteDataSourceImpl(sl(), sl(), sl()),
  );

  // ── Wali Santri Profile — Repository ───────────────────────────────────────
  sl.registerLazySingleton<WaliSantriProfileRepository>(
    () => WaliSantriProfileRepositoryImpl(sl()),
  );

  // ── Wali Santri Profile — Cubit (Factory — scoped per screen) ─────────────
  sl.registerFactory<WaliSantriProfileCubit>(() => WaliSantriProfileCubit(sl()));

  // ── Notifications — DataSource ────────────────────────────────────────────
  // Receives FirebaseMessaging + FirebaseFirestore via GetIt injection.
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl<FirebaseMessaging>(), sl<FirebaseFirestore>()),
  );

  // ── Notifications — Repository ────────────────────────────────────────────
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  // ── Notifications — Cubit (Singleton — must outlive navigation) ───────────
  // Registered as Singleton (not Factory) so the onTokenRefresh stream
  // subscription persists for the entire app session without being torn down
  // on screen disposal.
  sl.registerSingleton<NotificationCubit>(NotificationCubit(sl(), sl()));

  // ── Guru Laporan — Cubit ──────────────────────────────────────────────────
  // Factory — scoped to the LaporanKonfigurasiSheet bottom sheet lifetime.
  // Requires no repository dependencies — delegates to AbsensiPdfBuilder.
  sl.registerFactory<LaporanAbsensiCubit>(() => LaporanAbsensiCubit());
  sl.registerFactory<LaporanAbsensiHalaqohCubit>(() => LaporanAbsensiHalaqohCubit());
  sl.registerFactory<LaporanHafalanCubit>(() => LaporanHafalanCubit(sl()));
}
