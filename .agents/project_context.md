# MyHalaqoh — Project Context (Source of Truth)

> **Purpose:** This document is the authoritative system prompt for any AI model interacting with the MyHalaqoh codebase. It describes the project's ecosystem, architecture, conventions, and constraints in detail. Every AI-generated code change **must** conform to the rules and patterns documented here.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [System Architecture (Clean Architecture)](#2-system-architecture-clean-architecture)
3. [State Management (Cubit Strategy)](#3-state-management-cubit-strategy)
4. [Database Configuration & Caching Strategy](#4-database-configuration--caching-strategy)
5. [Quran Data Implementation (Core Feature)](#5-quran-data-implementation-core-feature)
6. [Authentication & Session Management](#6-authentication--session-management)
7. [Dependencies & Core Packages](#7-dependencies--core-packages)
8. [Error Handling & API Integration](#8-error-handling--api-integration)
9. [AI Coding Rules & Conventions](#9-ai-coding-rules--conventions)

---

## 1. Project Overview

**MyHalaqoh** is a Flutter mobile application for managing Islamic boarding school (pesantren) operations. Its primary functions are:

- **Halaqoh Management** — Creating and managing Quran study groups (halaqoh), each led by a guru (teacher) with assigned santri (students).
- **Attendance (Absensi)** — QR/barcode-based attendance tracking for halaqoh sessions.
- **Hafalan Monitoring** — Recording and tracking Quran memorization (hafalan) progress per student, per juz, and per surah.
- **Multi-Role Dashboard** — Three distinct role-based experiences: **Admin**, **Guru**, and **Wali Santri** (parent/guardian of santri).
- **Target Hafalan** — Curriculum-based memorization targets defined per grade level and program (Reguler / Takhassus).

| Attribute         | Value                                       |
| ----------------- | ------------------------------------------- |
| Package Name      | `my_halaqoh`                                |
| Dart SDK          | `^3.9.2`                                    |
| Flutter           | Material 3 enabled                          |
| Firebase Project  | `my-halaqoh`                                |
| Design Size       | `360 × 690` (ScreenUtil)                    |
| Primary Font      | Poppins (100–900 weights bundled)           |
| Localization      | `slang` (ID / EN), default `id`             |
| State Management  | `flutter_bloc` / `Cubit`                    |
| Routing           | `auto_route` v10                            |
| DI                | `get_it`                                    |
| Remote DB         | Cloud Firestore                             |
| Local Cache       | Hive                                        |
| Auth              | Firebase Auth (email/password, identifier-based) |
| Cloud Functions   | Firebase Cloud Functions (user account creation) |

---

## 2. System Architecture (Clean Architecture)

### 2.1 Directory Structure

```
lib/
├── main.dart                          # App entry point & bootstrap
├── firebase_options.dart              # FlutterFire generated config
├── gen/                               # flutter_gen & slang generated code
│   ├── assets.gen.dart
│   ├── colors.gen.dart
│   ├── fonts.gen.dart
│   └── i18n/                          # slang translations
│       └── translations.g.dart
└── src/
    ├── core/                          # Cross-cutting concerns
    │   ├── dictionaries/i18n/         # Translation source files
    │   ├── locale/                    # Locale cubit & repository
    │   │   ├── cubit/
    │   │   └── data/
    │   ├── quran/                     # Static Quran data module
    │   │   ├── quran_service.dart
    │   │   ├── quran_data.dart
    │   │   ├── surah_model.dart
    │   │   ├── juz_model.dart
    │   │   ├── juz_segment_model.dart
    │   │   └── hafalan_progress.dart
    │   ├── router/                    # auto_route config
    │   │   ├── app_router.dart
    │   │   └── app_router.gr.dart     # Generated
    │   ├── service_locator/           # GetIt DI setup
    │   │   └── service_locator.dart
    │   ├── services/                  # Shared services
    │   │   └── storage_service.dart   # Firebase Storage wrapper
    │   ├── theme/                     # Theme system
    │   │   ├── app_colors.dart
    │   │   ├── app_theme.dart
    │   │   ├── theme_mode.dart
    │   │   ├── cubit/
    │   │   └── data/
    │   └── widget/                    # Global reusable widgets
    │       ├── widgets.dart           # Barrel file
    │       ├── button/
    │       ├── dialog/
    │       ├── month/
    │       └── tab/
    └── modules/                       # Feature modules
        ├── auth/                      # Authentication
        ├── master_data/               # Admin CRUD (guru, santri, halaqoh, target)
        ├── guru_dashboard/            # Guru main dashboard
        ├── guru_absensi/              # Guru attendance features
        ├── guru_hafalan/              # Guru hafalan recording
        ├── guru_halaqoh/              # Guru halaqoh detail
        ├── guru_laporan/              # Guru reports
        ├── guru_profile/              # Guru profile & settings
        ├── wali_santri_dashboard/     # Parent/Guardian dashboard
        ├── wali_santri_absensi/       # Parent attendance view
        ├── wali_santri_hafalan/       # Parent hafalan view
        └── wali_santri_profile/       # Parent profile & settings
```

### 2.2 Clean Architecture Layers (per Module)

Each feature module follows a strict three-layer architecture:

```
modules/<feature>/
├── data/                              # DATA LAYER
│   ├── datasources/
│   │   ├── local/                     # Hive cache
│   │   └── remote/
│   │       ├── mapper/                # Firestore ↔ Model mappers
│   │       └── source/
│   │           ├── abstract/          # DataSource contracts
│   │           └── implementation/    # Firestore implementations
│   └── repositories_impl/            # Repository implementations
├── domain/                            # DOMAIN LAYER
│   ├── models/                        # Freezed data models
│   ├── repositories/                  # Repository contracts (abstract)
│   ├── usecase/                       # Use cases (if applicable)
│   └── helpers/                       # Domain utility classes
└── presentation/                      # PRESENTATION LAYER
    ├── cubits/                        # Cubit + State files
    ├── screens/                       # Page-level widgets (@RoutePage)
    └── widgets/                       # Feature-specific widgets
```

> **Note:** Some leaf feature modules (e.g., `guru_hafalan`, `guru_absensi`) currently have only a `presentation/` layer, meaning they rely on shared cubits/repositories from `master_data` or `auth` modules provided via the global `MultiBlocProvider`.

### 2.3 Data Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                           │
│  Screen (Widget) ──► BlocBuilder/Listener ──► Cubit.method()        │
│                                                    │                │
│                                                    ▼                │
│                              Cubit (extends Cubit<State>)           │
│                              emits State variants                   │
│                              calls Repository methods               │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DOMAIN LAYER                               │
│  Repository (abstract class)                                        │
│  - Defines contracts: Stream<List<T>>, Future<Either<String, T>>    │
│  - No implementation details, no imports from data layer            │
│                                                                     │
│  UseCase (optional)                                                 │
│  - Single-responsibility business logic                             │
│  - Calls repository methods                                        │
│                                                                     │
│  Model (Freezed @freezed)                                           │
│  - Immutable data classes with copyWith, fromJson, toJson           │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                                │
│                                                                     │
│  RepositoryImpl                                                     │
│  ├── RemoteDataSource (Firestore)                                   │
│  │   ├── watchAll()  → Stream via .snapshots()                      │
│  │   ├── getAll()    → Future one-time fetch                        │
│  │   ├── add()       → Create document                              │
│  │   ├── update()    → Update document                              │
│  │   └── delete()    → Delete document                              │
│  │                                                                  │
│  └── LocalDataSource (Hive)                                         │
│      ├── cacheAll()  → Clear + re-put all items                     │
│      ├── put()       → Upsert single item                           │
│      ├── getAll()    → Read from box                                │
│      └── delete()    → Remove from box                              │
│                                                                     │
│  Mapper (static utility class)                                      │
│  ├── fromFirestore(DocumentSnapshot) → Model                       │
│  └── toFirestore(Model) → Map<String, dynamic>                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.4 Dependency Injection (GetIt)

All dependencies are registered in `lib/src/core/service_locator/service_locator.dart`.

**Registration order (critical):**

1. **Core:** `SharedPreferences`, `ThemeRepository`, `ThemeCubit`, `LocaleRepository`, `LocaleCubit`, `StorageService`
2. **Firebase Instances:** `FirebaseFirestore.instance`, `FirebaseAuth.instance`, `FirebaseFunctions.instance`
3. **Auth:** `AuthRemoteDataSource` → `AuthRepository` → `AuthCubit`
4. **Master Data Local:** `MasterDataLocalDataSource` (singleton)
5. **Master Data Remote:** `GuruRemoteDataSource`, `SantriRemoteDataSource`, `HalaqohRemoteDataSource`, `TargetHafalanRemoteDataSource`
6. **Repositories:** `GuruRepository`, `SantriRepository`, `HalaqohRepository`, `TargetHafalanRepository`
7. **Cubits:** `GuruCubit`, `SantriCubit`, `HalaqohCubit`, `TargetHafalanCubit` (registered as `Factory`)

**Conventions:**

| Type                 | Registration Method         | Reason                                         |
| -------------------- | --------------------------- | ---------------------------------------------- |
| Firebase instances   | `registerLazySingleton`     | Single instance, created on first use          |
| DataSources          | `registerLazySingleton`     | Stateless, shared across repos                 |
| Repositories         | `registerLazySingleton`     | Stateless, shared across cubits                |
| Global Cubits        | `registerSingleton`         | Auth, Theme, Locale — need to persist          |
| Feature Cubits       | `registerFactory`           | New instance per widget tree                   |

**Access pattern:** Use `sl<Type>()` to resolve dependencies. Never construct classes manually if they are registered in the service locator.

### 2.5 Bootstrap Sequence (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Firebase.initializeApp()
  // 2. Hive.initFlutter() + registerMasterDataAdapters()
  // 3. QuranService.instance.initialize()
  // 4. initDependencies() (GetIt)
  // 5. sl<MasterDataLocalDataSource>().init() (open Hive boxes)
  // 6. sl<ThemeCubit>().initialize() + sl<LocaleCubit>().initialize()
  // 7. runApp(TranslationProvider(child: MyApp()))
}
```

Global cubits are provided via `MultiBlocProvider` in `MyApp.build()`:
- `ThemeCubit`, `LocaleCubit`
- `AuthCubit` (with `..checkAuthStatus()`)
- `GuruCubit`, `SantriCubit`, `HalaqohCubit`, `TargetHafalanCubit` (each with `..watchAll()`)

---

## 3. State Management (Cubit Strategy)

### 3.1 State Definition Pattern

All Cubit states use **Freezed sealed unions** with the following canonical variants:

```dart
@freezed
abstract class XxxState with _$XxxState {
  const factory XxxState.initial()                  = _Initial;
  const factory XxxState.loading()                  = _Loading;
  const factory XxxState.loaded(List<XxxModel> data) = _Loaded;
  const factory XxxState.error(String message)      = _Error;
}
```

**Key rules:**
- The `loaded` state carries the **domain model(s)** as its payload.
- The `error` state carries a **user-facing `String` message** (not an exception object).
- Additional state variants (e.g., `authenticated`, `unauthenticated`) are added only when semantically necessary (see `AuthState`).

### 3.2 Cubit Implementation Pattern

```dart
class XxxCubit extends Cubit<XxxState> {
  final XxxRepository _repository;
  StreamSubscription<List<XxxModel>>? _subscription;

  XxxCubit(this._repository) : super(const XxxState.initial());

  /// Real-time streaming from Firestore
  void watchAll() {
    emit(const XxxState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(XxxState.loaded(list)),
      onError: (e) => emit(XxxState.error(e.toString())),
    );
  }

  /// One-time fetch (uses Either for error handling)
  Future<void> loadAll() async {
    emit(const XxxState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(XxxState.error(error)),
      (list)  => emit(XxxState.loaded(list)),
    );
  }

  /// CUD operations return bool for UI feedback
  Future<bool> addXxx(XxxModel model) async {
    final result = await _repository.add(model);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

### 3.3 UI Consumption Pattern

**BlocBuilder** — For rendering based on state:
```dart
BlocBuilder<XxxCubit, XxxState>(
  builder: (context, state) {
    return state.when(
      initial:  () => const SizedBox.shrink(),
      loading:  () => const CircularProgressIndicator(),
      loaded:   (data) => ListView(...),
      error:    (msg) => Text(msg),
    );
  },
)
```

**BlocListener** — For side effects (snackbars, navigation):
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(...),
      orElse: () {},
    );
  },
)
```

**context.read\<Cubit\>()** — To invoke cubit methods from event handlers.

---

## 4. Database Configuration & Caching Strategy

### 4.1 Remote — Cloud Firestore

#### Collections Schema

| Collection        | Document ID Format      | Key Fields                                                                      |
| ----------------- | ----------------------- | ------------------------------------------------------------------------------- |
| `/users/{uid}`    | Firebase Auth UID       | `uid`, `identifier`, `role` ("admin"/"guru"/"santri"), `programType`, `displayName`, `linkedDocId` |
| `/guru/{id}`      | Auto-generated          | `nip`, `nama`, `phone?`, `profilePicture?`, `program` ("R"/"T"), `authUid?`, `createdAt`, `updatedAt` |
| `/santri/{id}`    | Auto-generated          | `nis`, `nama`, `profilePicture?`, `kelas` ("7"-"12"), `program` ("R"/"T"), `halaqohId?`, `waliSantri?` (embedded), `authUid?`, `createdAt`, `updatedAt` |
| `/halaqoh/{id}`   | Auto-generated          | `nama`, `kelas`, `program`, `guruId`, `guruNama` (denormalized), `santriIds[]`, `jumlahSantri`, `createdAt`, `updatedAt` |
| `/targetHafalan/{id}` | `"{kelas}_{program}"` (e.g., `"7_Reguler"`) | `kelas`, `program` ("Reguler"/"Takhassus"), `targetJuz`, `juzList[]`, `tahunAjaran`, `createdAt`, `updatedAt` |

#### Schema Design Principles

1. **Denormalization:** `guruNama` is stored in `halaqoh` documents to avoid extra reads for display.
2. **Embedded Documents:** `WaliSantriModel` (parent info) is nested inside the `santri` document, not a separate collection.
3. **Timestamps:** All documents use Firestore `Timestamp` type for `createdAt` / `updatedAt`. Mappers convert to/from Dart `DateTime`.
4. **Program Codes:** Master data uses short codes (`"R"`, `"T"`). `TargetHafalan` uses full names (`"Reguler"`, `"Takhassus"`). Use `TargetHafalanHelper` for conversion.

#### Data Fetching Patterns

- **Realtime Streams:** Primary method. `watchAll()` uses `collection.snapshots().map(...)` for live updates.
- **One-Time Fetch:** `getAll()` uses `collection.get()` as fallback (e.g., offline mode reads from Hive cache).
- **Ordering:** Documents are typically ordered by `'nama'` (alphabetically).

#### Firestore Security Rules

```
- Authenticated users can READ all data.
- Only Admin role can WRITE/MODIFY data.
- Users can read their own /users/{uid} document.
```

### 4.2 Local — Hive (Cache Layer)

#### Setup

1. **Initialization:** `Hive.initFlutter()` is called in `main()`.
2. **Adapter Registration:** `registerMasterDataAdapters()` registers all custom `TypeAdapter`s before any boxes are opened. Called in `main()` immediately after Hive init.
3. **Box Opening:** `MasterDataLocalDataSource.init()` opens all typed boxes.

#### Hive Boxes

| Box Name            | Type                      | Type ID |
| ------------------- | ------------------------- | ------- |
| `guru_box`          | `Box<GuruModel>`          | 1       |
| `santri_box`        | `Box<SantriModel>`        | 2       |
| `halaqoh_box`       | `Box<HalaqohModel>`       | 4       |
| `target_hafalan_box`| `Box<TargetHafalanModel>` | 5       |

> `WaliSantriModel` has Type ID `3` (embedded inside `SantriModel`).

#### TypeAdapter Convention

- Adapters are **hand-written** (not generated) in `hive_adapters.dart`.
- Each adapter reads/writes fields by index (byte-based).
- `DateTime` fields are serialized as ISO 8601 strings.
- **Type IDs must never be reused.** The next available Type ID is **6**.

#### Caching Strategy

The repository implementation follows a **write-through cache** pattern:

```
watchAll():
  Firestore stream → on each emission:
    1. Update Hive cache (clear + re-put all)
    2. Emit data to Cubit

getAll():
  try: Fetch from Firestore → cache to Hive → return Right(data)
  catch: Read from Hive cache → if not empty return Right(cached)
         else return Left(errorMessage)

add/update/delete():
  1. Perform Firestore operation
  2. Update Hive cache (put/delete)
  3. Return Either result
```

---

## 5. Quran Data Implementation (Core Feature)

### 5.1 Overview

The Quran data is a **static JSON asset** (`assets/data/quran.json`) containing the complete structure of all 114 surahs and 30 juz, including ayat counts and juz-to-surah mappings. It is the backbone for hafalan target definition and progress calculation.

### 5.2 Data Loading Workflow

```
main() → QuranService.instance.initialize()
           │
           ├── rootBundle.loadString('assets/data/quran.json')
           ├── jsonDecode(raw) → Map<String, dynamic>
           ├── QuranData.fromJson(json)  (Freezed deserialization)
           │
           └── Build O(1) lookup maps:
               _surahById   : Map<int, SurahModel>
               _juzByNumber : Map<int, JuzModel>
```

### 5.3 Data Models

```
QuranData
├── surahs: List<SurahModel>
│   ├── id: int (1-114)
│   ├── name: String (e.g., "Al-Fatihah")
│   ├── nameAr: String (Arabic name)
│   ├── ayatCount: int
│   ├── juzStart: int
│   └── juzMappings: List<JuzSegmentModel>
│       ├── juz: int (juz number)
│       ├── ayatStart: int
│       └── ayatEnd: int
│
└── juz: List<JuzModel>
    ├── number: int (1-30)
    ├── totalAyat: int
    └── surahs: List<JuzSegmentModel>
        ├── surahId: int
        ├── ayatStart: int
        └── ayatEnd: int
```

### 5.4 QuranService API

`QuranService` is a **Singleton** accessed via `QuranService.instance`.

| Method | Description |
| --- | --- |
| `initialize()` | Load & parse JSON. Must be called once before any queries. |
| `getAllSurahs()` | Returns unmodifiable list of all 114 surahs. |
| `getSurahById(int)` | O(1) lookup by surah ID. |
| `getSurahsByJuz(int)` | All surahs that appear in a given juz. |
| `getAllJuz()` | Returns unmodifiable list of all 30 juz. |
| `getJuzByNumber(int)` | O(1) lookup by juz number. |
| `getTotalAyatInJuz(int)` | Total ayat count for a specific juz. |
| `getTotalAyatForJuzList(List<int>)` | Sum of ayat for multiple juz numbers. |
| `isValidAyatRange(...)` | Validates a surah/ayat range. |
| `calculateProgress(...)` | Computes `OverallHafalanProgress` from memorized segments. |
| `getSegmentsForJuzList(List<int>)` | All `JuzSegmentModel`s for given juz numbers. |

### 5.5 Progress Calculation

`calculateProgress(List<Map<String, int>> memorizedSegments)` produces:

```
OverallHafalanProgress
├── totalAyatQuran: int
├── totalMemorized: int
├── percentage: double
├── completedJuz: int
└── juzProgressList: List<JuzProgress>
    ├── juzNumber, totalAyat, memorizedAyat, percentage
    └── surahProgressList: List<SurahProgress>
        └── surahId, surahName, totalAyat, memorizedAyat, percentage
```

### 5.6 Memory Considerations

- The full `quran.json` is loaded once at startup and held in memory for the app's lifetime.
- O(1) lookup maps (`_surahById`, `_juzByNumber`) are built during initialization.
- `_assertInitialized()` guards all public methods to prevent NPE on uninitialized access.
- The `calculateProgress` method uses a `Set<int>` per ayat range to deduplicate overlapping memorized segments.

---

## 6. Authentication & Session Management

### 6.1 Auth Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                         LOGIN FLOW                                │
│                                                                   │
│  1. User enters identifier (NIP or NIS) + password                │
│  2. App constructs email: "{identifier}@myhalaqoh.app"            │
│  3. FirebaseAuth.signInWithEmailAndPassword(email, password)      │
│  4. On success → fetch /users/{uid} document from Firestore       │
│  5. Parse UserModel (uid, identifier, role, programType, etc.)    │
│  6. AuthCubit emits AuthState.authenticated(userModel)            │
│                                                                   │
│  NOTE: The AuthCubit does NOT manually emit authenticated on      │
│  login success. Instead, the authStateChanges listener detects    │
│  the new user and triggers _fetchUserMeta() automatically.        │
└──────────────────────────────────────────────────────────────────┘
```

### 6.2 Auth Account Creation

New guru/santri accounts are created via **Firebase Cloud Functions** (`createUserAccount`), not client-side. The flow:

1. Admin adds a guru/santri via the master data UI.
2. `RemoteDataSourceImpl.add()` calls `FirebaseFunctions.httpsCallable('createUserAccount')`.
3. Cloud Function creates a Firebase Auth user with email `"{nip_or_nis}@myhalaqoh.app"` and a default password.
4. Cloud Function creates the `/users/{uid}` metadata document.
5. The returned `uid` is stored in the guru/santri Firestore document as `authUid`.

### 6.3 UserModel

```dart
UserModel {
  uid: String,           // Firebase Auth UID
  identifier: String,    // NIP, NIS, or "admin"
  role: String,          // "admin", "guru", or "santri"
  programType: String?,  // "R" or "T" (nullable for Admin)
  displayName: String,
  linkedDocId: String,   // Doc ID in /guru or /santri (or "SYSTEM" for admin)
}
```

### 6.4 AuthState Variants

```dart
AuthState.initial()                    // App just started
AuthState.loading()                    // Checking auth / signing in
AuthState.authenticated(UserModel)     // User logged in with metadata
AuthState.unauthenticated()            // No user / logged out
AuthState.error(String message)        // Auth failure
```

### 6.5 Role-Based Routing (SplashScreen)

The `SplashScreen` reads `AuthCubit.state` after a timed delay and routes accordingly:

| Role      | Destination Route                        |
| --------- | ---------------------------------------- |
| `admin`   | `DashboardWrapperRoute()`                |
| `guru`    | `GuruDashboardWrapperRoute(programType)` |
| `santri`  | `WaliSantriDashboardWrapperRoute(programType)` |
| Others    | `LoginRoute()`                           |

### 6.6 Session Persistence

- Firebase Auth handles session persistence natively (token stored by Firebase SDK).
- On app restart, `AuthCubit.checkAuthStatus()` listens to `authStateChanges` stream.
- If a Firebase user exists, `_fetchUserMeta()` loads the `/users/{uid}` document.
- If metadata is missing (invalid state), the user is forcefully signed out.

---

## 7. Dependencies & Core Packages

### 7.1 Runtime Dependencies

| Package | Version | Purpose & Usage Rule |
| --- | --- | --- |
| `flutter_bloc` / `bloc` | `^9.1.1` / `^9.0.0` | State management. Always use `Cubit` (not `Bloc`). Never emit states outside the Cubit class. |
| `auto_route` | `^10.1.2` | Declarative routing. All screens must be annotated with `@RoutePage()`. Route names are auto-generated by stripping `Screen`/`Page` suffix. |
| `get_it` | `^8.2.0` | Service locator DI. Access via the global `sl<T>()` function. Register all new dependencies in `service_locator.dart`. |
| `cloud_firestore` | `^6.2.0` | Firestore database. Use through `RemoteDataSource` abstractions, never directly in Cubits or UI. |
| `firebase_auth` | `^6.3.0` | Authentication. Used only inside `AuthRemoteDataSource`. |
| `firebase_core` | `^4.6.0` | Firebase initialization. Called once in `main()`. |
| `firebase_storage` | `^13.2.0` | File uploads (profile pictures). Wrapped by `StorageService`. |
| `cloud_functions` | `^6.1.0` | Server-side user account creation. Used in remote datasource `add()` methods. |
| `freezed_annotation` | `^3.1.0` | Immutable model annotations. All domain models and states must use `@freezed`. |
| `json_annotation` | `^4.9.0` | JSON serialization annotations. Use `@JsonKey(name: 'snake_case')` for Firestore field mapping. |
| `dartz` | `^0.10.1` | Functional programming. Use `Either<String, T>` for repository return types (`Left` = error message, `Right` = success value). |
| `hive` / `hive_flutter` | `^2.2.3` / `^1.1.0` | Local cache database. Used only in `MasterDataLocalDataSource`. Never use directly in UI. |
| `flutter_screenutil` | `^5.9.3` | Responsive dimensions. Use `.w`, `.h`, `.sp`, `.r` extensions for all sizing. Design size: 360×690. |
| `slang` / `slang_flutter` | `^4.8.1` / `^4.8.0` | Type-safe i18n. Access translations via `t.section.key`. |
| `dio` | `^5.9.0` | HTTP client (for any external REST APIs). Wrap with `pretty_dio_logger` for debug logging. |
| `equatable` | `^2.0.7` | Value equality. Use for classes that need comparison but don't warrant full Freezed treatment. |
| `google_fonts` | `^6.3.2` | Font loading. Primary font is bundled Poppins; use Google Fonts only for secondary/accent fonts. |
| `logger` | `^2.6.1` | Structured logging. Use `Logger()` for debug/info/error logs in services and datasources. |
| `mobile_scanner` | `^7.1.2` | QR/barcode scanning for attendance. |
| `image_picker` | `^1.1.2` | Profile picture selection from gallery/camera. |
| `pdf` / `printing` | `^3.11.3` / `^5.14.2` | PDF generation and printing for reports. |
| `share_plus` | `^12.0.0` | Native sharing (e.g., PDF reports). |
| `percent_indicator` | `^4.2.5` | Circular/linear progress indicators for hafalan progress display. |
| `animated_custom_dropdown` | `3.1.1` | Enhanced dropdown menus in forms. |
| `animated_notch_bottom_bar` | `^1.0.3` | Bottom navigation bar with notch animation. |
| `shared_preferences` | `^2.5.4` | Simple key-value persistence (theme mode, locale preference). |
| `collection` | `^1.19.1` | Extended collection utilities (e.g., `firstWhereOrNull`). |
| `csv` | `^6.0.0` | CSV parsing for bulk data import. |
| `file_picker` | `^8.1.2` | File selection for bulk upload. |
| `intl` | `^0.20.2` | Date/number formatting. |
| `flutter_gen` | `^5.12.0` | Asset/color/font code generation. Access via `Assets.images.xxx`, `ColorName.xxx`. |
| `flutter_localization` | `^0.3.3` | Localization delegate support. |

### 7.2 Dev Dependencies

| Package | Purpose |
| --- | --- |
| `build_runner` | Code generation runner (`dart run build_runner build --delete-conflicting-outputs`). |
| `freezed` | Generates `.freezed.dart` files for immutable classes. |
| `json_serializable` | Generates `.g.dart` files for JSON serialization. |
| `auto_route_generator` | Generates `app_router.gr.dart` from `@RoutePage()` annotations. |
| `flutter_gen_runner` | Generates asset/color/font references from `pubspec.yaml` config. |
| `slang_build_runner` | Generates translation files from i18n source. |
| `mocktail` | Mocking framework for unit tests. |
| `flutter_lints` | Linting rules. Config in `analysis_options.yaml`. |

### 7.3 Code Generation Command

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run this after modifying any:
- `@freezed` model
- `@RoutePage()` screen
- `@JsonSerializable()` class
- Translation source files
- Asset files

---

## 8. Error Handling & API Integration

### 8.1 Error Handling Pattern — Either<String, T>

All repository methods return `Either<String, T>` from the `dartz` package:

```dart
// Repository contract
abstract class XxxRepository {
  Future<Either<String, List<XxxModel>>> getAll();
  Future<Either<String, String>> add(XxxModel model);
  Future<Either<String, void>> update(XxxModel model);
  Future<Either<String, void>> delete(String id);
  Stream<List<XxxModel>> watchAll(); // Streams don't use Either
}
```

**Convention:**
- `Left(String)` = User-facing error message (in Bahasa Indonesia).
- `Right(T)` = Success payload.

### 8.2 Repository Error Handling

```dart
@override
Future<Either<String, List<XxxModel>>> getAll() async {
  try {
    final list = await _remote.getAll();
    await _local.cacheXxx(list);
    return Right(list);
  } catch (e) {
    // Fallback to local cache
    final cached = _local.getAllXxx();
    if (cached.isNotEmpty) return Right(cached);
    return Left('Gagal memuat data xxx: $e');
  }
}
```

### 8.3 Firebase Auth Error Mapping

```dart
String _mapFirebaseAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
    case 'invalid-credential':
    case 'invalid-email':
    case 'wrong-password':
      return 'NIP/NIS atau Password salah';
    case 'network-request-failed':
      return 'Tidak ada koneksi internet';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Harap tunggu sesaat.';
    case 'user-disabled':
      return 'Akun pengguna ini telah dinonaktifkan.';
    default:
      return 'Error autentikasi: ${e.message}';
  }
}
```

### 8.4 Firestore Mapper Pattern

Each entity has a dedicated `Mapper` class that handles the Firestore ↔ Model conversion:

```dart
class XxxMapper {
  const XxxMapper._();

  static XxxModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return XxxModel(
      id: doc.id,                                         // Always from doc.id
      field: data['field'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(), // Timestamp → DateTime
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(XxxModel model) {
    return {
      'field': model.field,
      'createdAt': Timestamp.fromDate(model.createdAt),   // DateTime → Timestamp
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}
```

**Rules:**
- `doc.id` is **never stored** as a field in Firestore; it's always extracted from the document reference.
- `Timestamp` from Firestore is always converted to `DateTime` in the model.
- The `toFirestore()` method **excludes the `id` field** since it's the document path.

### 8.5 UI Error Display

Errors bubble up to the Cubit state as `XxxState.error(String message)`, and the UI reacts using `BlocBuilder`'s `state.when(error: (msg) => ...)` or `BlocListener` for snackbars.

---

## 9. AI Coding Rules & Conventions

### 9.1 Absolute Rules (NEVER Break)

1. **NEVER mix UI and business logic.** UI widgets must not contain Firestore calls, Hive operations, or complex data transformations. All logic goes through Cubits → Repositories → DataSources.

2. **NEVER import `data` layer classes in `domain` layer files.** The domain layer is the innermost ring; it has zero knowledge of Firestore, Hive, or any external framework.

3. **NEVER import `data` or `domain` layer classes directly in UI widgets.** Widgets interact with the domain only through Cubits. The only exception is importing Models for type annotations.

4. **NEVER create a Cubit without registering it in `service_locator.dart`.** Every new Cubit must be registered and provided via `BlocProvider`.

5. **NEVER use raw Firebase instances in Cubits or UI.** Always go through the DataSource → Repository → Cubit chain.

6. **NEVER reuse Hive Type IDs.** Current max is `5`. The next available ID is `6`.

7. **NEVER commit generated files with manual edits.** Files ending in `.freezed.dart`, `.g.dart`, `.gr.dart`, and `gen/` are auto-generated. Only edit source files and re-run `build_runner`.

### 9.2 Naming Conventions

| Artifact | Convention | Example |
| --- | --- | --- |
| Feature Module Dir | `snake_case` with role prefix | `guru_hafalan/`, `wali_santri_absensi/` |
| Model File | `snake_case_model.dart` | `guru_model.dart` |
| Repository Contract | `snake_case_repository.dart` | `guru_repository.dart` |
| Repository Impl | `snake_case_repository_impl.dart` | `guru_repository_impl.dart` |
| Remote DataSource Abstract | `snake_case_remote_datasource.dart` | `guru_remote_datasource.dart` |
| Remote DataSource Impl | `snake_case_remote_datasource_impl.dart` | `guru_remote_datasource_impl.dart` |
| Mapper | `snake_case_mapper.dart` | `guru_mapper.dart` |
| Cubit File | `snake_case_cubit.dart` | `guru_cubit.dart` |
| State File | `snake_case_state.dart` | `guru_state.dart` |
| Screen File | `snake_case_screen.dart` | `hafalan_screen.dart` |
| Widget File | `snake_case_widget.dart` or descriptive | `attendance_card.dart` |
| Hive Adapter | `XxxModelAdapter` class in `hive_adapters.dart` | `GuruModelAdapter` |
| Cubit Class | `XxxCubit` | `GuruCubit` |
| State Class | `XxxState` | `GuruState` |
| Model Class | `XxxModel` | `GuruModel` |
| Repository Class | `XxxRepository` (abstract), `XxxRepositoryImpl` | `GuruRepository`, `GuruRepositoryImpl` |

### 9.3 File Organization Rules

1. **One model per file.** Each Freezed model gets its own `.dart` file plus generated `.freezed.dart` and `.g.dart`.
2. **One cubit per file, one state per file.** `xxx_cubit.dart` and `xxx_state.dart` are always separate files.
3. **Barrel files** are used sparingly (only `widgets.dart` for shared widgets). Avoid adding barrel files for modules.
4. **Screen files** must be annotated with `@RoutePage()` for auto_route code generation.

### 9.4 Model Rules

1. **All domain models must use `@freezed`.** This ensures immutability, `copyWith`, `==`, `hashCode`, and `toString`.
2. **Use `@JsonKey(name: 'snake_case')` for Firestore fields** that differ from Dart property names.
3. **Use `@Default(value)` for optional fields with defaults** (e.g., `@Default([]) List<String> santriIds`).
4. **Include the private constructor** `const XxxModel._();` only if you need helper methods/getters on the model.
5. **Timestamps:** Always use `DateTime` in models. Mappers handle `Timestamp` ↔ `DateTime` conversion.

### 9.5 Repository Rules

1. **Abstract repositories live in `domain/repositories/`.** They define the contract using `Either<String, T>` return types and `Stream<List<T>>` for realtime data.
2. **Implementations live in `data/repositories_impl/`.** They compose remote and local datasources.
3. **Always implement offline fallback:** If the remote fetch fails, try reading from the Hive cache before returning an error.
4. **Stream operations update the cache as a side-effect** inside `.map()`.

### 9.6 DataSource Rules

1. **Remote datasources always have an abstract + implementation pair** in separate directories.
2. **The abstract class lives in `source/abstract/`**, the implementation in `source/implementation/`.
3. **Each remote datasource implementation receives Firebase instances via constructor injection** from GetIt.
4. **Use Mappers** for all Firestore ↔ Model conversions. Never do inline map parsing.

### 9.7 Routing Rules

1. **All screens must have `@RoutePage()` annotation.**
2. **Route names strip `Screen`/`Page` suffix.** `HafalanScreen` → `HafalanRoute`.
3. **Navigation uses `context.router.push()`, `.replace()`, or `.pop()`** from auto_route.
4. **Route parameters** use constructor parameters on the screen class.
5. **After adding a new screen**, re-run `build_runner` and update `app_router.dart` with the new `AutoRoute(page: XxxRoute.page)` entry.

### 9.8 Theming Rules

1. **Always use `AppColors.of(context)` to get theme-aware colors.** Never hardcode color values in widgets.
2. **Use theme text styles** from `Theme.of(context).textTheme`. Always specify `fontFamily: 'Poppins'` for custom text styles.
3. **Design size is 360×690.** Use `flutter_screenutil` extensions (`.w`, `.h`, `.sp`, `.r`) for responsive scaling.
4. **Both light and dark themes** must be supported. Test UI in both modes.

### 9.9 Internationalization Rules

1. **Use `slang` for all user-facing strings.** Access via `t.section.key`.
2. **Never hardcode user-facing strings** in Dart files. The only exception is internal error messages for debugging.
3. **Error messages from repositories** may be in Bahasa Indonesia since they are user-facing.

### 9.10 Testing Rules

1. **Use `mocktail` for mocking** in unit tests (not `mockito`).
2. **Test Cubits** by verifying state emissions for each method.
3. **Test Repositories** by mocking datasources and verifying correct delegation.

### 9.11 General Code Quality

1. **Write docstrings** for all public classes, methods, and complex functions. Use `///` format.
2. **Use `const` constructors** wherever possible for performance.
3. **Prefer `final` variables** over `var`.
4. **Handle stream subscriptions** — Always cancel in `close()` override of Cubits.
5. **Avoid `print()`** — Use `Logger()` from the `logger` package.
6. **Follow existing patterns.** When in doubt, look at how `GuruCubit`, `GuruRepository`, `GuruRemoteDataSourceImpl`, and `GuruMapper` are implemented — they are the canonical reference.

---

## Appendix: Quick Reference Checklist for New Features

When adding a new entity/feature, follow this checklist:

- [ ] **Model:** Create `xxx_model.dart` with `@freezed` in `domain/models/`.
- [ ] **Repository Contract:** Create abstract `xxx_repository.dart` in `domain/repositories/`.
- [ ] **Remote DataSource Abstract:** Create in `data/datasources/remote/source/abstract/`.
- [ ] **Remote DataSource Impl:** Create in `data/datasources/remote/source/implementation/`.
- [ ] **Mapper:** Create `xxx_mapper.dart` in `data/datasources/remote/mapper/`.
- [ ] **Repository Impl:** Create `xxx_repository_impl.dart` in `data/repositories_impl/`.
- [ ] **Hive Adapter:** Add to `hive_adapters.dart` with a new unique Type ID. Register in `registerMasterDataAdapters()`.
- [ ] **Local DataSource:** Add box and CRUD methods to `MasterDataLocalDataSource`.
- [ ] **State:** Create `xxx_state.dart` with Freezed sealed union.
- [ ] **Cubit:** Create `xxx_cubit.dart` with `watchAll()`, `loadAll()`, CUD methods.
- [ ] **Register in GetIt:** Add datasource, repository, and cubit to `service_locator.dart`.
- [ ] **Provide Cubit:** Add `BlocProvider` in `main.dart` `MultiBlocProvider` if global.
- [ ] **Screens:** Create screen files with `@RoutePage()` annotation.
- [ ] **Router:** Add `AutoRoute(page: XxxRoute.page)` in `app_router.dart`.
- [ ] **Run code gen:** `dart run build_runner build --delete-conflicting-outputs`.

---

> **Last Updated:** 2026-04-14
> **Maintained by:** AI System Prompt — Do not edit manually without updating all sections consistently.
