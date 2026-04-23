# MyHalaqoh — Claude Code Context

Flutter app untuk manajemen pesantren: absensi QR, hafalan Quran, multi-role dashboard (Admin / Guru / Wali Santri).

---

## Stack & Config

| Item | Value |
|---|---|
| Package | `my_halaqoh` |
| Flutter | Material 3, Dart `^3.9.2` |
| State | `flutter_bloc` / **Cubit only** (never Bloc) |
| Routing | `auto_route` v10 |
| DI | `get_it` → access via `sl<T>()` |
| Remote DB | Cloud Firestore (`asia-southeast2`) |
| Local Cache | Hive (hand-written adapters) |
| Auth | Firebase Auth — email: `"{identifier}@myhalaqoh.app"` |
| Design size | `360×690` (flutter_screenutil) |
| Font | Poppins (bundled, always explicit `fontFamily: 'Poppins'`) |
| i18n | `slang`, default `id` — access via `t.section.key` |
| Colors | `AppColors.of(context)` — NEVER hardcode hex |
| Sizing | `.w` `.h` `.sp` `.r` — NEVER hardcode px |
| Assets | `Assets.images.xxx.image()` via flutter_gen |

---

## Architecture (Clean Architecture — 3 Layer)

```
Presentation → Domain → Data
Screen/Widget → Cubit → Repository (abstract) → RepositoryImpl → DataSource → Firestore/Hive
```

**Layer rules:**
- Domain layer = zero imports from data layer
- UI = zero Firestore/Hive calls. Only interact via Cubit
- Exception: importing Models for type annotation is OK

**Per-module structure:**
```
modules/<feature>/
├── data/
│   ├── datasources/remote/
│   │   ├── mapper/           # XxxMapper (static fromFirestore/toFirestore)
│   │   └── source/
│   │       ├── abstract/     # XxxRemoteDataSource (contract)
│   │       └── implementation/
│   └── repositories_impl/
├── domain/
│   ├── models/               # @freezed models
│   ├── repositories/         # abstract contracts
│   └── usecase/              # optional
└── presentation/
    ├── cubits/               # XxxCubit + XxxState (separate files)
    ├── screens/              # @RoutePage() annotated
    └── widgets/
```

---

## Cubit & State Pattern

```dart
// State — always Freezed sealed union
@freezed
abstract class XxxState with _$XxxState {
  const factory XxxState.initial()                   = _Initial;
  const factory XxxState.loading()                   = _Loading;
  const factory XxxState.loaded(List<XxxModel> data) = _Loaded;
  const factory XxxState.error(String message)       = _Error;
}

// Cubit — cancel subscription in close()
class XxxCubit extends Cubit<XxxState> {
  final XxxRepository _repository;
  StreamSubscription? _subscription;
  XxxCubit(this._repository) : super(const XxxState.initial());

  void watchAll() {
    emit(const XxxState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (data) => emit(XxxState.loaded(data)),
      onError: (e) => emit(XxxState.error(e.toString())),
    );
  }

  @override
  Future<void> close() { _subscription?.cancel(); return super.close(); }
}
```

---

## Repository Pattern

```dart
// Contract (domain layer)
abstract class XxxRepository {
  Stream<List<XxxModel>> watchAll();
  Future<Either<String, List<XxxModel>>> getAll();
  Future<Either<String, String>> add(XxxModel model);
  Future<Either<String, void>> update(XxxModel model);
  Future<Either<String, void>> delete(String id);
}

// Return types: Left(String) = error (Bahasa Indonesia), Right(T) = success
// getAll() must fallback to Hive cache on remote failure
```

---

## Mapper Pattern

```dart
class XxxMapper {
  const XxxMapper._();
  static XxxModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return XxxModel(
      id: doc.id,  // ALWAYS from doc.id, never from field
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  static Map<String, dynamic> toFirestore(XxxModel m) => {
    // EXCLUDE id field — it's the document path
    'createdAt': Timestamp.fromDate(m.createdAt),
  };
}
```

---

## Hive Type ID Registry

| Model | Box Name | Type ID |
|---|---|---|
| GuruModel | `guru_box` | 1 |
| SantriModel | `santri_box` | 2 |
| WaliSantriModel | (embedded) | 3 |
| HalaqohModel | `halaqoh_box` | 4 |
| TargetHafalanModel | `target_hafalan_box` | 5 |
| HafalanSantriModel | `hafalan_santri_box` | 6 |
| AbsensiModel | `absensi_box` | 8 |
| AbsensiRecordEntry | (embedded) | 9 |

> ⚠️ Next available Type ID = **10**. NEVER reuse IDs.
> Adapters are hand-written (not generated). DateTime = ISO 8601 string (master data) or millisecondsSinceEpoch (absensi).

---

## GetIt Registration Order

1. Core (SharedPreferences, ThemeRepo, ThemeCubit, LocaleRepo, LocaleCubit, StorageService)
2. Firebase instances (`registerLazySingleton`)
3. Auth chain: DataSource → Repository → AuthCubit (`registerSingleton`)
4. MasterDataLocalDataSource (`registerLazySingleton`)
5. Master Data Remote DataSources
6. Master Data Repositories
7. Master Data Cubits (`registerFactory`)
8. Absensi chain: Local → Remote → Repo → SyncService → Cubit
9. Hafalan chain: Local → Remote → Repo → SyncService → Cubits
10. Dashboard, Profile cubits

**Registration types:**
- Firebase instances, DataSources, Repositories, SyncServices → `registerLazySingleton`
- Auth/Theme/Locale Cubits → `registerSingleton`
- Feature Cubits → `registerFactory`

---

## Routing Rules

- All screens: `@RoutePage()` annotation mandatory
- Route name = class name minus `Screen`/`Page` suffix
- Navigation: `context.router.push()` / `.replace()` / `.pop()`
- Protected routes MUST have guards: `AuthGuard` + `RoleGuard`
- Unauthorized → `AccessDeniedRoute` (NOT login)
- After new screen: run `build_runner` + update `app_router.dart`

---

## Auth Flow

- Login: identifier (NIP/NIS) → email `"{identifier}@myhalaqoh.app"`
- New accounts: created via Firebase Cloud Function `createUserAccount` (NEVER client-side)
- Role routing from SplashScreen: `admin` → Dashboard, `guru` → GuruDashboard, `santri` → WaliSantriDashboard

---

## Caching Strategies

**Pattern A — Master Data (write-through):**
`watchAll()` → Firestore stream → update Hive → emit to Cubit

**Pattern B — Absensi & Hafalan (offline-first):**
Save to Hive first (`isSynced: false`) → try Firestore → mark synced on success
SyncService listens to `connectivity_plus` → auto-sync on reconnect

---

## ABSOLUTE RULES (Never Break)

1. NEVER mix UI and business logic — no Firestore/Hive in widgets
2. NEVER import `data` layer in `domain` layer
3. NEVER use raw Firebase instances in Cubits or UI
4. NEVER create a Cubit without registering in `service_locator.dart`
5. NEVER reuse Hive Type IDs (next = **10**)
6. NEVER manually edit generated files (`.freezed.dart`, `.g.dart`, `.gr.dart`, `gen/`)
7. NEVER hardcode user-facing strings — always use `t.section.key`
8. NEVER hardcode colors — always `AppColors.of(context)`
9. NEVER hardcode px sizes — always `.w` `.h` `.sp` `.r`
10. Use `Logger()` from `logger` package, NEVER `print()`

---

## Naming Conventions

| Artifact | Example |
|---|---|
| Model | `guru_model.dart` → `GuruModel` |
| Repository contract | `guru_repository.dart` → `GuruRepository` |
| Repository impl | `guru_repository_impl.dart` → `GuruRepositoryImpl` |
| Remote DS abstract | `guru_remote_datasource.dart` |
| Remote DS impl | `guru_remote_datasource_impl.dart` |
| Mapper | `guru_mapper.dart` → `GuruMapper` |
| Cubit | `guru_cubit.dart` → `GuruCubit` |
| State | `guru_state.dart` → `GuruState` |
| Screen | `hafalan_screen.dart` → `HafalanScreen` |

One model per file. One cubit per file + one state per file (always separate).

---

## Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run after modifying: `@freezed` models, `@RoutePage()` screens, translation files, asset files.

---

## Checklist — New Feature

- [ ] Model (`@freezed`) in `domain/models/`
- [ ] Repository contract in `domain/repositories/`
- [ ] Remote DS abstract + implementation
- [ ] Mapper in `data/datasources/remote/mapper/`
- [ ] RepositoryImpl in `data/repositories_impl/`
- [ ] Hive Adapter (new Type ID ≥ 10) in `hive_adapters.dart`
- [ ] State (`@freezed` sealed union) in `presentation/cubits/`
- [ ] Cubit in `presentation/cubits/`
- [ ] Register all in `service_locator.dart`
- [ ] Screen(s) with `@RoutePage()`
- [ ] Add route in `app_router.dart`
- [ ] Run `build_runner`

---

## Reference Implementations

When in doubt, follow these canonical files:
- `GuruCubit` / `GuruState`
- `GuruRepository` / `GuruRepositoryImpl`
- `GuruRemoteDataSourceImpl`
- `GuruMapper`
