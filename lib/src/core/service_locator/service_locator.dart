import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

// Master Data — Presentation Layer (Cubits)
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';

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
    () => FirebaseFunctions.instance,
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
    () => SantriRepositoryImpl(sl(), sl()),
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
}
