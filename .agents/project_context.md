# MyHalaqoh — Project Context (Source of Truth)

> **Purpose:** Authoritative system prompt for any AI model working on this codebase. Every AI-generated change **must** conform to the rules documented here.
> **Last Updated:** 2026-05-02

---

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [System Architecture (Clean Architecture)](#2-system-architecture-clean-architecture)
3. [State Management (Cubit Strategy)](#3-state-management-cubit-strategy)
4. [Database Configuration & Caching Strategy](#4-database-configuration--caching-strategy)
5. [Quran Data Implementation (Core Feature)](#5-quran-data-implementation-core-feature)
6. [Authentication & Session Management](#6-authentication--session-management)
7. [Push Notifications (FCM)](#7-push-notifications-fcm)
8. [Offline-First & Sync Architecture](#8-offline-first--sync-architecture)
9. [Dependencies & Core Packages](#9-dependencies--core-packages)
10. [Error Handling & Data Mapping](#10-error-handling--data-mapping)
11. [AI Coding Rules & Conventions](#11-ai-coding-rules--conventions)

---

## 1. Project Overview

**MyHalaqoh** is a Flutter mobile application for managing Islamic boarding school (pesantren) operations.

| Attribute | Value |
|---|---|
| Package | `my_halaqoh` |
| Dart SDK | `^3.9.2` |
| Firebase Project | `my-halaqoh` |
| Design Size | `360 × 690` (ScreenUtil) |
| Primary Font | Poppins (100–900, bundled) |
| Localization | `slang` (ID/EN), default `id` |
| State Management | `flutter_bloc` / Cubit |
| Routing | `auto_route` v10 |
| DI | `get_it` |
| Remote DB | Cloud Firestore |
| Local Cache | Hive |
| Auth | Firebase Auth (identifier-based email/password) |
| Cloud Functions | Account creation + FCM notifications |
| Push Notifications | Firebase Cloud Messaging (FCM) |

**Core features:**
- **Halaqoh Management** — Study group CRUD; Admin only.
- **Attendance (Absensi)** — QR/barcode-based session recording; offline-first with Hive.
- **Hafalan Monitoring** — Quran memorization recording & progress tracking; offline-first with Hive.
- **Target Hafalan** — Curriculum targets per grade/program (Admin-defined).
- **Push Notifications** — FCM notifications to Wali Santri on attendance & hafalan events.
- **Multi-Role Dashboard** — Separate experiences for Admin, Guru, and Wali Santri.

---

## 2. System Architecture (Clean Architecture)

### 2.1 Directory Structure

```
lib/
├── main.dart                          # App entry point & bootstrap
├── firebase_options.dart              # FlutterFire generated config
├── gen/                               # flutter_gen & slang generated (DO NOT EDIT)
│   ├── assets.gen.dart
│   ├── colors.gen.dart
│   ├── fonts.gen.dart
│   └── i18n/translations.g.dart
└── src/
    ├── core/
    │   ├── dictionaries/i18n/         # slang translation source files
    │   ├── locale/cubit/ + data/      # Locale cubit & SharedPreferences repo
    │   ├── quran/                     # Static Quran data (singleton service)
    │   ├── router/                    # auto_route config + generated file
    │   ├── service_locator/           # GetIt DI — single file
    │   ├── services/storage_service.dart  # Firebase Storage wrapper
    │   ├── theme/cubit/ + data/       # Theme cubit & SharedPreferences repo
    │   └── widget/                    # Global reusable widgets (barrel: widgets.dart)
    └── modules/                       # Feature modules (13 total)
        ├── auth/
        ├── master_data/
        ├── notifications/             # FCM token management (NEW)
        ├── guru_dashboard/
        ├── guru_absensi/              # Full Clean Architecture (NEW)
        ├── guru_hafalan/              # Full Clean Architecture (NEW)
        ├── guru_halaqoh/
        ├── guru_laporan/
        ├── guru_profile/              # Full Clean Architecture (NEW)
        ├── wali_santri_dashboard/
        ├── wali_santri_absensi/
        ├── wali_santri_hafalan/       # Full Clean Architecture (NEW)
        └── wali_santri_profile/       # Full Clean Architecture (NEW)
```

### 2.2 Module Layer Structure

Every fully-implemented module follows this pattern:

```
modules/<feature>/
├── data/
│   ├── datasources/
│   │   ├── local/        # Hive datasource + adapter registration helper
│   │   └── remote/
│   │       ├── mapper/   # Static Mapper classes (fromFirestore / toFirestore)
│   │       └── source/
│   │           ├── abstract/         # DataSource interface
│   │           └── implementation/   # Firestore impl
│   └── repositories_impl/
├── domain/
│   ├── models/           # @freezed models
│   ├── repositories/     # Abstract repo contracts
│   ├── services/         # Domain-level services (e.g., SyncService)
│   ├── usecase/          # (optional) single-responsibility use cases
│   └── helpers/          # Pure utility classes
└── presentation/
    ├── cubits/           # Cubit + State files
    ├── screens/          # @RoutePage() screens
    └── widgets/          # Feature-specific widgets
```

> **Partial modules** (e.g., `guru_halaqoh`, `guru_laporan`, `wali_santri_absensi`) have only a `presentation/` layer and rely on cubits/repositories from other modules provided through the global `MultiBlocProvider`.

### 2.3 Data Flow

```
UI Widget
  └── context.read<XxxCubit>().method()
        └── Repository (abstract)
              ├── RemoteDataSource → Firestore / Cloud Functions
              └── LocalDataSource  → Hive (cache / offline-first)
```

- **Realtime:** `watchAll()` → `collection.snapshots().map(mapper)` → side-effect caches to Hive
- **One-time:** `getAll()` → Firestore fetch → cache to Hive; on failure → read Hive fallback
- **Offline-first (Absensi & Hafalan):** Write to Hive first → mark `isSynced: false` → SyncService pushes to Firestore when online

### 2.4 Dependency Injection (GetIt)

Global singleton: `final sl = GetIt.instance;` in `service_locator.dart`.

**Registration order (strict):**

1. `SharedPreferences` → `ThemeRepository/Cubit` → `LocaleRepository/Cubit` → `StorageService`
2. Firebase: `FirebaseFirestore`, `FirebaseAuth`, `FirebaseFunctions`, **`FirebaseMessaging`** *(new)*
3. Auth: DataSource → Repository → `AuthCubit` (Singleton)
4. Master Data: Local DS (Singleton) → Remote DSes → Repositories → Cubits (Factory)
5. Guru Absensi: Local DS → Remote DS → Repository → `AbsensiSyncService` → `AbsensiCubit` (Factory)
6. Guru Hafalan: Local DS → Remote DS → Repository → `HafalanSyncService` → Cubits (Factory)
7. Guru Dashboard: `DashboardSummaryCubit` (Factory)
8. Guru Profile: Remote DS → Repository → `GuruProfileCubit` (Factory)
9. Wali Santri Hafalan: Remote DS → Repository → Cubits (Factory)
10. Wali Santri Profile: Remote DS → Repository → `WaliSantriProfileCubit` (Factory)
11. Notifications: Remote DS → Repository → **`NotificationCubit` (Singleton)** *(new)*

**Registration rules:**

| Type | Method | Reason |
|---|---|---|
| Firebase instances | `registerLazySingleton` | Single SDK instance |
| DataSources | `registerLazySingleton` | Stateless |
| Repositories | `registerLazySingleton` | Stateless |
| Global Cubits (Auth, Theme, Locale, **Notification**) | `registerSingleton` | Must persist for app lifetime |
| Feature Cubits | `registerFactory` | Scoped per screen |

### 2.5 Bootstrap Sequence (`main.dart`)

```dart
// 1. Firebase.initializeApp()
// 1a. FirebaseMessaging.onBackgroundMessage(_handler)  // top-level function
// 1b. Android notification channels (absensi + hafalan) via flutter_local_notifications
// 1c. FirebaseAppCheck.instance.activate()             // debug/release providers
// 2. Hive.initFlutter()
//    registerMasterDataAdapters()   // in hive_adapters.dart
//    registerAbsensiAdapters()      // in absensi_hive_adapters.dart
// 3. QuranService.instance.initialize()
// 4. initDependencies()              // GetIt
// 5. sl<MasterDataLocalDataSource>().init()  // open Hive boxes
// 6. sl<ThemeCubit>().initialize() + sl<LocaleCubit>().initialize()
// 7. sl<AbsensiSyncService>().start()
//    sl<HafalanSyncService>().start()
// 8. runApp(TranslationProvider(child: MyApp()))
```

`AppRouter` now receives `AuthCubit` via constructor: `AppRouter(sl<AuthCubit>())`.

**Global `MultiBlocProvider`:** ThemeCubit, LocaleCubit, AuthCubit (+ `checkAuthStatus()`), GuruCubit (+ `watchAll()`), SantriCubit, HalaqohCubit, TargetHafalanCubit.

> `NotificationCubit` is **not** in the global MultiBlocProvider. It is initialized directly on `AuthState.authenticated` and accessed via `sl<NotificationCubit>()`.

---

## 3. State Management (Cubit Strategy)

### 3.1 Standard State Definition

```dart
@freezed
abstract class XxxState with _$XxxState {
  const factory XxxState.initial()                   = _Initial;
  const factory XxxState.loading()                   = _Loading;
  const factory XxxState.loaded(List<XxxModel> data) = _Loaded;
  const factory XxxState.error(String message)       = _Error;
}
```

### 3.2 Specialized States

**`AuthState`** adds `authenticated(UserModel)` and `unauthenticated()`.

**`NotificationState`** uses: `initial`, `loading`, `tokenSaved`, `permissionDenied`, `error`. Note: `permissionDenied` is **not** treated as an error — the app continues normally.

### 3.3 Standard Cubit Pattern

```dart
class XxxCubit extends Cubit<XxxState> {
  final XxxRepository _repository;
  StreamSubscription? _sub;

  XxxCubit(this._repository) : super(const XxxState.initial());

  void watchAll() {
    emit(const XxxState.loading());
    _sub?.cancel();
    _sub = _repository.watchAll().listen(
      (list) => emit(XxxState.loaded(list)),
      onError: (e) => emit(XxxState.error(e.toString())),
    );
  }

  Future<void> loadAll() async {
    emit(const XxxState.loading());
    final result = await _repository.getAll();
    result.fold(
      (err) => emit(XxxState.error(err)),
      (list) => emit(XxxState.loaded(list)),
    );
  }

  // CUD methods return bool for UI feedback
  Future<bool> addXxx(XxxModel model) async =>
      (await _repository.add(model)).isRight();

  @override
  Future<void> close() { _sub?.cancel(); return super.close(); }
}
```

### 3.4 UI Consumption

- `BlocBuilder` → render UI based on state (`state.when(...)`)
- `BlocListener` → side effects: snackbars, navigation
- `context.read<XxxCubit>().method()` → invoke actions from event handlers

---

## 4. Database Configuration & Caching Strategy

### 4.1 Firestore Collections Schema

| Collection | Doc ID | Key Fields |
|---|---|---|
| `/users/{uid}` | Firebase Auth UID | `uid`, `identifier`, `role` ("admin"/"guru"/"santri"), `programType` ("R"/"T"), `displayName`, `linkedDocId`, **`fcmToken`** *(new)*, **`fcmTokenUpdatedAt`** *(new)* |
| `/guru/{id}` | Auto | `nip`, `nama`, `phone?`, `profilePicture?`, `program` ("R"/"T"), `authUid?`, `createdAt`, `updatedAt` |
| `/santri/{id}` | Auto | `nis`, `nama`, `kelas` ("7"-"12"), `program` ("R"/"T"), `halaqohId?`, `waliSantri` (embedded), `authUid?`, `profilePicture?`, `createdAt`, `updatedAt` |
| `/halaqoh/{id}` | Auto | `nama`, `kelas`, `program`, `guruId`, `guruNama` (denorm.), `santriIds[]`, `jumlahSantri`, `createdAt`, `updatedAt` |
| `/targetHafalan/{id}` | `"{kelas}_{program}"` (e.g., `"7_Reguler"`) | `kelas`, `program` ("Reguler"/"Takhassus"), `targetJuz`, `juzList[]`, `tahunAjaran`, `createdAt`, `updatedAt` |
| `/absensi/{id}` | Auto | `halaqohId`, `guruId`, `tanggal`, `sesi` ("shubuh"/"dhuha"/"siang"/"ashar"/"maghrib"), `records[]` (embedded `AbsensiRecordEntry`), `isSynced`, `createdAt`, `updatedAt`, `notifiedAt?` (server-only) |
| `/hafalan/{id}` | Auto | `santriId`, `guruId`, `halaqohId`, `tanggalSetoran`, `jenis` ("Ziyadah"/"Murajaah"), `surahId`, `surahName`, `ayatMulai`, `ayatSelesai`, `juz`, `nilaiKelancaran`, `nilaiTajwid`, `createdAt`, `isSynced`, `notifiedAt?` (server-only) |

**Schema design principles:**
1. **Denormalization:** `guruNama` in halaqoh; `nama`/`nis` in `AbsensiRecordEntry` — avoids joins.
2. **Embedded documents:** `WaliSantriModel` inside santri; `AbsensiRecordEntry` list inside absensi.
3. **Server-only fields:** `notifiedAt` on absensi and hafalan is **written only by Cloud Functions** after FCM dispatch. The Flutter client must **never** set this field.
4. **Program codes:** Master data uses `"R"`/`"T"` short codes; `targetHafalan` uses `"Reguler"`/`"Takhassus"`. Use `TargetHafalanHelper.programCodeToFullName()` to convert.
5. **Timestamps:** Firestore `Timestamp` ↔ Dart `DateTime` conversion is handled exclusively in Mapper classes.

### 4.2 Hive — Complete Type ID Registry

> **CRITICAL: Type IDs are permanent. Never reuse a retired ID.**

| Type ID | Class | Adapter Location |
|---|---|---|
| 1 | `GuruModel` | `hive_adapters.dart` |
| 2 | `SantriModel` | `hive_adapters.dart` |
| 3 | `WaliSantriModel` | `hive_adapters.dart` |
| 4 | `HalaqohModel` | `hive_adapters.dart` |
| 5 | `TargetHafalanModel` | `hive_adapters.dart` |
| 6 | `HafalanSantriModel` | `hive_adapters.dart` |
| 7 | *(reserved / deprecated)* | — |
| 8 | `AbsensiModel` | `absensi_hive_adapters.dart` |
| 9 | `AbsensiRecordEntry` | `absensi_hive_adapters.dart` |

**Next available Type ID: 10**

**Two adapter registration helpers:**
- `registerMasterDataAdapters()` — in `hive_adapters.dart`, called first in `main()`
- `registerAbsensiAdapters()` — in `absensi_hive_adapters.dart`, called second in `main()`

### 4.3 Hive Boxes

| Box Name | Type | Opened By |
|---|---|---|
| `guru_box` | `Box<GuruModel>` | `MasterDataLocalDataSource.init()` |
| `santri_box` | `Box<SantriModel>` | `MasterDataLocalDataSource.init()` |
| `halaqoh_box` | `Box<HalaqohModel>` | `MasterDataLocalDataSource.init()` |
| `target_hafalan_box` | `Box<TargetHafalanModel>` | `MasterDataLocalDataSource.init()` |
| `hafalan_santri_box` | `Box<HafalanSantriModel>` | `HafalanSantriLocalDataSource` (lazy via `Hive.box()`) |
| `absensi_box` | `Box<AbsensiModel>` | `AbsensiLocalDataSource` (lazy via `Hive.box()`) |

> Absensi and Hafalan boxes use **lazy access** (`Hive.box<T>(name)`) — they must be opened before being accessed. Opening happens in the respective local datasource constructors or `init()` methods.

### 4.4 Caching Strategies by Module

**Master Data (Guru, Santri, Halaqoh, TargetHafalan):** Write-through cache.
- `watchAll()` → Firestore stream → cache Hive on each emission → emit to Cubit.
- `getAll()` → fetch Firestore → cache Hive → on failure read Hive.

**Absensi & Hafalan (Offline-First):**
- **Write:** Save to Hive immediately with `isSynced: false`. SyncService pushes to Firestore when connectivity is restored.
- **Read:** Stream from Hive box (reactive via `box.watch()`). Seed from Firestore on first open if local box is empty (`seedFromRemoteIfEmpty`).
- **Sync flag:** `isSynced: false` = pending. SyncService calls `syncPendingRecords()` on connectivity change.
- **`notifiedAt`:** Read-only from client perspective. Set by Cloud Function only.

---

## 5. Quran Data Implementation (Core Feature)

### 5.1 Data Loading Workflow

```
main() → QuranService.instance.initialize()
  1. rootBundle.loadString('assets/data/quran.json')
  2. jsonDecode(raw) → Map<String, dynamic>
  3. QuranData.fromJson(json)    // Freezed deserialization
  4. Build O(1) maps:
     _surahById   : Map<int, SurahModel>
     _juzByNumber : Map<int, JuzModel>
  5. _initialized = true
```

### 5.2 Data Model Hierarchy

```
QuranData
├── surahs: List<SurahModel>
│   ├── id, name, nameAr, ayatCount, juzStart
│   └── juzMappings: List<JuzSegmentModel>
│       └── juz, ayatStart, ayatEnd
└── juz: List<JuzModel>
    ├── number, totalAyat
    └── surahs: List<JuzSegmentModel>
        └── surahId, ayatStart, ayatEnd
```

### 5.3 QuranService API

`QuranService.instance` — Singleton. Call `initialize()` once in `main()`.

| Method | Returns | Notes |
|---|---|---|
| `getAllSurahs()` | `List<SurahModel>` (unmodifiable) | |
| `getSurahById(int)` | `SurahModel?` | O(1) map lookup |
| `getSurahsByJuz(int)` | `List<SurahModel>` | |
| `getAllJuz()` | `List<JuzModel>` (unmodifiable) | |
| `getJuzByNumber(int)` | `JuzModel?` | O(1) map lookup |
| `getTotalAyatInJuz(int)` | `int` | |
| `getTotalAyatForJuzList(List<int>)` | `int` | Used for target calculation |
| `isValidAyatRange(...)` | `bool` | Validates hafalan input ranges |
| `calculateProgress(List<Map<String, int>>)` | `OverallHafalanProgress` | Core progress engine |
| `getSegmentsForJuzList(List<int>)` | `List<JuzSegmentModel>` | |

### 5.4 Progress Data Model

```
OverallHafalanProgress
├── totalAyatQuran, totalMemorized, percentage, completedJuz
└── juzProgressList: List<JuzProgress>
    ├── juzNumber, totalAyat, memorizedAyat, percentage
    └── surahProgressList: List<SurahProgress>
        └── surahId, surahName, totalAyat, memorizedAyat, percentage
```

### 5.5 Memory Considerations

- JSON loaded **once at startup**, held in memory for app lifetime.
- `_assertInitialized()` guards all public methods.
- `calculateProgress` uses `Set<int>` per range to deduplicate overlapping memorized segments.

---

## 6. Authentication & Session Management

### 6.1 Login Flow

```
1. User enters identifier (NIP/NIS) + password
2. Build email: "{identifier}@myhalaqoh.app"
3. FirebaseAuth.signInWithEmailAndPassword(email, password)
4. Fetch /users/{uid} from Firestore → parse UserModel
5. AuthCubit.authStateChanges listener → _fetchUserMeta() → emit authenticated(userModel)
```

> **Important:** On successful login, `AuthCubit` does **not** manually emit `authenticated`. The `authStateChanges` stream detects the new Firebase session and triggers `_fetchUserMeta()` automatically.

### 6.2 UserModel Fields

```dart
UserModel {
  uid: String,           // Firebase Auth UID
  identifier: String,    // NIP, NIS, or "admin"
  role: String,          // "admin", "guru", or "santri"
  programType: String?,  // "R" or "T" (null for Admin)
  displayName: String,
  linkedDocId: String,   // doc ID in /guru or /santri (or "SYSTEM" for admin)
}
```

`/users/{uid}` also stores `fcmToken` and `fcmTokenUpdatedAt` — managed exclusively by `NotificationCubit`.

### 6.3 AuthState Variants

```dart
AuthState.initial()                   // App start
AuthState.loading()                   // Checking / signing in
AuthState.authenticated(UserModel)    // Logged in with role metadata
AuthState.unauthenticated()           // No session / logged out
AuthState.error(String message)       // Auth failure
```

### 6.4 Role-Based Routing (SplashScreen)

| `user.role` | Destination |
|---|---|
| `"admin"` | `DashboardWrapperRoute()` |
| `"guru"` | `GuruDashboardWrapperRoute(programType: "reguler"/"takhassus")` |
| `"santri"` | `WaliSantriDashboardWrapperRoute(programType: ...)` |
| other | `LoginRoute()` |

### 6.5 Account Creation

New accounts are created via **Cloud Function `createUserAccount`** — never client-side. The function creates the Firebase Auth user and the `/users/{uid}` document. The returned `uid` is stored as `authUid` on the guru/santri document.

### 6.6 Session Persistence

Firebase Auth persists the token natively. On restart, `AuthCubit.checkAuthStatus()` listens to `authStateChanges`. If metadata fetch fails (missing `/users/{uid}`), the user is force signed-out.

---

## 7. Push Notifications (FCM)

### 7.1 Architecture

FCM is integrated for notifying Wali Santri when:
- A guru records attendance (`sendAbsensiNotification` Cloud Function)
- A guru submits hafalan (`sendHafalanNotification` Cloud Function)

The client is **passive** — it only manages the FCM device token. The Cloud Functions dispatch the actual notifications.

### 7.2 Android Notification Channels

Two channels are created at startup in `main()`:

| Channel ID | Name | Used by |
|---|---|---|
| `my_halaqoh_absensi` | Notifikasi Absensi MyHalaqoh | `sendAbsensiNotification` CF |
| `my_halaqoh_hafalan` | Notifikasi Hafalan MyHalaqoh | `sendHafalanNotification` CF |

### 7.3 Background Handler

```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // FCM native SDK handles OS notification display automatically.
  // CONSTRAINT: Runs in a SEPARATE ISOLATE.
  // NEVER use GetIt (sl), Cubits, BuildContext, or UI code here.
}
```

### 7.4 NotificationCubit Lifecycle

- **Registration:** `registerSingleton<NotificationCubit>` in GetIt.
- **Initialization:** Call `sl<NotificationCubit>().initialize(uid)` after a Wali Santri authenticates (role == "santri").
- **Token refresh:** `NotificationCubit` subscribes to `NotificationRepository.onTokenRefresh` and auto-persists new tokens. This is why it must be a **Singleton** (not Factory) — a Factory would destroy the subscription on navigation.
- **Logout:** Call `sl<NotificationCubit>().clearToken(uid)` **before** `AuthCubit.logout()` to wipe the stale token from Firestore.

### 7.5 Token Storage in Firestore

`NotificationRepository.saveToken(uid, token)` writes:
```
/users/{uid} {
  fcmToken: "...",
  fcmTokenUpdatedAt: Timestamp
}
```

---

## 8. Offline-First & Sync Architecture

### 8.1 Modules with Offline-First Behavior

Both `guru_absensi` and `guru_hafalan` use **Hive as the primary write target**, with Firestore as the eventual sync destination.

### 8.2 Write Path (Online or Offline)

```
1. Build model with isSynced: false
2. Put model into Hive box (immediate)
3. Attempt Firestore write:
   - Success → mark isSynced: true in Hive
   - Failure → leave isSynced: false (SyncService will retry)
4. Return success to UI (user never sees failure if Hive write succeeds)
```

### 8.3 Sync Services

Both `AbsensiSyncService` and `HafalanSyncService` follow the same pattern:

```dart
class XxxSyncService {
  // Uses connectivity_plus to detect network changes
  void start() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        _repository.syncPendingRecords();
      }
    });
    _trySyncNow(); // immediate attempt on start
  }
  void dispose() => _subscription?.cancel();
}
```

Both services are started in `main()` **after** `initDependencies()`:
```dart
sl<AbsensiSyncService>().start();
sl<HafalanSyncService>().start();
```

### 8.4 `syncPendingRecords()` Contract

- Reads all Hive records where `isSynced == false`.
- Writes each to Firestore.
- On success: marks record as `isSynced: true` in Hive.
- On failure: leaves record pending for next sync attempt.

### 8.5 `seedFromRemoteIfEmpty(santriId)`

- Called when opening a hafalan history/progress screen.
- Only fetches from Firestore if the local Hive box has **no records** for that santri.
- Prevents redundant network calls on subsequent opens.

### 8.6 Dashboard Reactive Updates

`DashboardSummaryCubit` (guru dashboard) uses `HafalanSantriRepository.watchAnyChanges()` — a stream that emits `void` on any Hive box change — to reactively recompute today's setoran percentage without polling Firestore.

---

## 9. Dependencies & Core Packages

### 9.1 New Packages (added since v1 of this document)

| Package | Version | Rule |
|---|---|---|
| `firebase_messaging` | `^16.1.3` | FCM. Used only through `NotificationRemoteDataSource`. Never call directly in UI or Cubits. |
| `firebase_app_check` | `^0.4.2` | App attestation. Activated in `main()` only. |
| `flutter_local_notifications` | `^18.0.1` | Android channel setup in `main()` only. Do NOT use elsewhere. |
| `connectivity_plus` | `^7.1.1` | Network detection. Used only in SyncService classes. Never poll in UI. |

### 9.2 Full Dependency Reference

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` / `bloc` | `^9.1.1` / `^9.0.0` | Always use Cubit. Never emit outside Cubit class. |
| `auto_route` | `^10.1.2` | `@RoutePage()` on all screens. `AppRouter(sl<AuthCubit>())`. |
| `get_it` | `^8.2.0` | `sl<T>()`. Register all deps in `service_locator.dart`. |
| `cloud_firestore` | `^6.2.0` | Remote DB. Only through DataSource abstractions. |
| `firebase_auth` | `^6.3.0` | Only inside `AuthRemoteDataSource`. |
| `firebase_core` | `^4.6.0` | Init once in `main()`. |
| `firebase_storage` | `^13.2.0` | File uploads via `StorageService`. |
| `cloud_functions` | `^6.1.0` | Account creation + callable functions. |
| `freezed_annotation` | `^3.1.0` | All domain models and states use `@freezed`. |
| `json_annotation` | `^4.9.0` | `@JsonKey(name: 'snake_case')` for field name mapping. |
| `dartz` | `^0.10.1` | `Either<String, T>`. Left=error, Right=success. |
| `hive` / `hive_flutter` | `^2.2.3` / `^1.1.0` | Local cache. Only via datasource classes. |
| `flutter_screenutil` | `^5.9.3` | `.w`, `.h`, `.sp`, `.r` everywhere. Design 360x690. |
| `slang` / `slang_flutter` | `^4.8.1` / `^4.8.0` | `t.section.key`. Never hardcode user-facing strings. |
| `logger` | `^2.6.1` | `Logger()` in services/datasources. Never use `print()`. |
| `mobile_scanner` | `^7.1.2` | QR/barcode attendance scanning. |
| `image_picker` | `^1.1.2` | Profile photo selection. |
| `pdf` / `printing` | `^3.11.3` / `^5.14.2` | Report generation and printing. |
| `share_plus` | `^12.0.0` | Native sharing of reports. |
| `percent_indicator` | `^4.2.5` | Hafalan progress display. |
| `animated_custom_dropdown` | `3.1.1` | Dropdown menus in forms. |
| `animated_notch_bottom_bar` | `^1.0.3` | Bottom navigation bar. |
| `shared_preferences` | `^2.5.4` | Theme/locale persistence. |
| `collection` | `^1.19.1` | `firstWhereOrNull`, etc. |
| `csv` / `file_picker` | `^6.0.0` / `^8.1.2` | Bulk data import. |
| `intl` | `^0.20.2` | Date/number formatting. |
| `flutter_gen` | `^5.12.0` | `Assets.xxx`, `ColorName.xxx` — do not hardcode paths. |
| `dio` | `^5.9.0` | External REST APIs with `pretty_dio_logger`. |
| `equatable` | `^2.0.7` | Value equality for non-Freezed classes. |
| `google_fonts` | `^6.3.2` | Secondary fonts only. Primary is bundled Poppins. |

### 9.3 Code Generation Command

`
dart run build_runner build --delete-conflicting-outputs
`

Run after: @freezed model changes, @RoutePage() additions, translation source changes, asset changes.

---

## 10. Error Handling & Data Mapping

### 10.1 Either Pattern

- Left(String) = user-facing error in Bahasa Indonesia.
- Right(T) = success payload.
- Stream<T> methods do NOT use Either — errors flow to onError callback.

### 10.2 Offline-First Write Strategy (Absensi & Hafalan)

Write to Hive first, then attempt Firestore. On Firestore failure, SyncService retries later. The UI always sees a success if the Hive write succeeds.

### 10.3 Firebase Auth Error Mapping

user-not-found / invalid-credential / wrong-password → 'NIP/NIS atau Password salah'
network-request-failed → 'Tidak ada koneksi internet'
too-many-requests → 'Terlalu banyak percobaan. Harap tunggu sesaat.'
user-disabled → 'Akun pengguna ini telah dinonaktifkan.'
default → 'Error autentikasi: {e.message}'

### 10.4 Firestore Mapper Pattern

- doc.id is always the model 'id' field — never stored as a Firestore field.
- Timestamp from Firestore always converted to DateTime in the model.
- toFirestore() NEVER includes 'id' or 'notifiedAt' (server-only).

---

## 11. AI Coding Rules & Conventions

### 11.1 Absolute Rules (NEVER Break)

1. No business logic in UI widgets. No Firestore/Hive calls in widgets.
2. No data layer imports in domain layer. Domain has zero framework dependencies.
3. No data/domain imports directly in UI — only Models for type annotations.
4. Every new Cubit must be registered in service_locator.dart.
5. No raw Firebase instances in Cubits or UI — always DataSource → Repository → Cubit.
6. Never reuse Hive Type IDs. Next available: 10.
7. Never edit generated files (.freezed.dart, .g.dart, .gr.dart, gen/).
8. Never write notifiedAt from Flutter client. It is a server-only field set by Cloud Functions.
9. NotificationCubit must be Singleton — Factory would kill the onTokenRefresh subscription.
10. No GetIt/Cubits/BuildContext in _firebaseMessagingBackgroundHandler — it runs in a separate isolate.

### 11.2 Naming Conventions

| Artifact | Pattern | Example |
|---|---|---|
| Feature module dir | snake_case with role prefix | guru_hafalan/ |
| Model | snake_case_model.dart | hafalan_santri_model.dart |
| Repo contract | snake_case_repository.dart | hafalan_santri_repository.dart |
| Repo impl | snake_case_repository_impl.dart | |
| Remote DS abstract | snake_case_remote_datasource.dart | |
| Remote DS impl | snake_case_remote_datasource_impl.dart | |
| Local DS | snake_case_local_data_source.dart | |
| Hive adapters file | snake_case_hive_adapters.dart | absensi_hive_adapters.dart |
| Mapper | snake_case_mapper.dart | guru_mapper.dart |
| Cubit | snake_case_cubit.dart | input_hafalan_cubit.dart |
| State | snake_case_state.dart | input_hafalan_state.dart |
| Screen | snake_case_screen.dart + @RoutePage() | |
| SyncService | snake_case_sync_service.dart | hafalan_sync_service.dart |

### 11.3 Model Rules

1. All domain models: @freezed.
2. Use @JsonKey(name: 'snake_case') for field name differences.
3. Use @Default(value) for optional fields with defaults.
4. DateTime in models always. Mappers handle Timestamp conversion.
5. Server-only fields (e.g., notifiedAt): DateTime? + comment "Server-only. NEVER set by client."

### 11.4 Hive Adapter Rules

1. Hand-written adapters only (no code generation).
2. DateTime serialization: ISO 8601 string (master data / hafalan) OR millisecondsSinceEpoch int (absensi). Be consistent per module.
3. New fields on existing adapters must be read as nullable for backward compatibility.
4. Use `if (!Hive.isAdapterRegistered(typeId))` guard in registerAbsensiAdapters().

### 11.5 Repository Rules

1. Abstract repos in domain/repositories/ using Either<String, T> and Stream<List<T>>.
2. Impls in data/repositories_impl/ composing remote + local.
3. Always provide offline fallback for getAll().
4. Offline-first modules: write Hive first, then attempt Firestore.

### 11.6 Notification Rules

1. Initialize NotificationCubit only for Wali Santri (role == "santri").
2. Call clearToken(uid) BEFORE logout(), not after.
3. Never craft FCM payloads from the client — Cloud Functions handle dispatch.
4. Never include notifiedAt in toFirestore() mapper output.

### 11.7 SyncService Rules

1. SyncServices live in domain/services/ (depend on Repository only).
2. Registered as registerLazySingleton in GetIt.
3. start() called in main() after initDependencies().
4. Never call dispose() during normal app lifecycle.

### 11.8 General Code Quality

1. /// docstrings for all public classes and methods.
2. const constructors wherever possible.
3. final over var.
4. Cancel stream subscriptions in Cubit close().
5. Logger() for all logging. Never print().
6. Canonical references:
   - Master data pattern: GuruCubit, GuruRepository, GuruRemoteDataSourceImpl, GuruMapper
   - Offline-first pattern: HafalanSantriRepository, HafalanSantriLocalDataSource, HafalanSyncService
   - Notification pattern: NotificationCubit, NotificationRepositoryImpl

---

## Appendix: Checklist for New Features

- [ ] Model: @freezed in domain/models/
- [ ] Repo contract: abstract in domain/repositories/
- [ ] Remote DS abstract: in data/datasources/remote/source/abstract/
- [ ] Remote DS impl: in data/datasources/remote/source/implementation/
- [ ] Mapper: static class in data/datasources/remote/mapper/
- [ ] Repo impl: in data/repositories_impl/
- [ ] If offline-first: Local DS in data/datasources/local/; Hive adapter (Type ID >= 10); register in adapter helper; open box before use
- [ ] If syncing: SyncService in domain/services/; registerLazySingleton; start() in main()
- [ ] State: Freezed sealed union in presentation/cubits/
- [ ] Cubit: in presentation/cubits/; register in service_locator.dart
- [ ] If global: add BlocProvider to MultiBlocProvider in main.dart
- [ ] Screens: @RoutePage() annotation in presentation/screens/
- [ ] Router: add AutoRoute(page: XxxRoute.page) in app_router.dart
- [ ] Run codegen: dart run build_runner build --delete-conflicting-outputs
