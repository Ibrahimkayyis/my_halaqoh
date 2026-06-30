# MyHalaqoh — Project Context (Source of Truth)

> **Purpose:** Authoritative system prompt for any AI model working on this codebase. Every AI-generated change **must** conform to the rules documented here.
> **Last Updated:** 2026-06-28

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
9. [Super Admin Module](#9-super-admin-module)
10. [Guru Laporan Module](#10-guru-laporan-module)
11. [Dependencies & Core Packages](#11-dependencies--core-packages)
12. [Error Handling & Data Mapping](#12-error-handling--data-mapping)
13. [AI Coding Rules & Conventions](#13-ai-coding-rules--conventions)

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

**Roles:**

| Role | Description |
|---|---|
| `admin` | School admin — manages master data (guru, santri, halaqoh, targets, kelas, program) |
| `guru` | Teacher — records attendance & hafalan; generates PDF reports |
| `santri` | Student / Wali Santri — views attendance & hafalan progress |
| `super_admin` | Platform super admin — view-only impersonation of any role; reads activity logs |

**Core features:**
- **Halaqoh Management** — Study group CRUD; Admin only.
- **Kelas & Program Management** — Dynamic class/program CRUD; Admin only.
- **Attendance (Absensi)** — QR/barcode-based session recording; offline-first with Hive.
- **Hafalan Monitoring** — Quran memorization recording & progress tracking; offline-first with Hive.
- **Target Hafalan** — Curriculum targets per grade/program (Admin-defined).
- **Santri Extra Targets** — Teacher-added individual juz targets beyond the admin curriculum.
- **PDF Reports** — Absensi and Hafalan PDF generation & sharing.
- **Push Notifications** — FCM notifications to Wali Santri on attendance & hafalan events.
- **Super Admin Console** — Impersonation mode + Activity Log viewer.
- **Multi-Role Dashboard** — Separate experiences for Admin, Guru, Wali Santri, and Super Admin.
- **Native Splash Screen** — Zero-flicker launch via `flutter_native_splash`.
- **Shimmer Loading** — Skeleton loading states across all data-driven screens.

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
    │   ├── notifications/
    │   │   └── notification_tap_handler.dart  # Global ValueNotifier for FCM taps
    │   ├── quran/                     # Static Quran data (singleton service)
    │   ├── router/                    # auto_route config + generated file
    │   ├── service_locator/           # GetIt DI — single file
    │   ├── services/
    │   │   ├── storage_service.dart   # Firebase Storage wrapper
    │   │   └── activity_log_service.dart  # Cross-cutting audit log writer (NEW)
    │   ├── theme/cubit/ + data/       # Theme cubit & SharedPreferences repo
    │   └── widget/                    # Global reusable widgets (barrel: widgets.dart)
    └── modules/                       # Feature modules (15 total)
        ├── about/                     # About screen (presentation only)
        ├── auth/
        ├── master_data/               # Guru, Santri, Halaqoh, Target, Kelas, Program, ExtraTarget
        ├── notifications/             # FCM token management
        ├── guru_dashboard/
        ├── guru_absensi/              # Full Clean Architecture + offline-first
        ├── guru_hafalan/              # Full Clean Architecture + offline-first
        ├── guru_halaqoh/              # Presentation only
        ├── guru_laporan/              # Full Clean Architecture (PDF reports) (NEW)
        ├── guru_profile/              # Full Clean Architecture
        ├── super_admin/               # Full Clean Architecture (NEW)
        ├── wali_santri_dashboard/
        ├── wali_santri_absensi/       # Presentation only
        ├── wali_santri_hafalan/       # Full Clean Architecture
        └── wali_santri_profile/       # Full Clean Architecture
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

> **Partial modules** (e.g., `about`, `guru_halaqoh`, `guru_dashboard`, `wali_santri_absensi`) have only a `presentation/` layer and consume cubits/repositories from other modules via the global `MultiBlocProvider`.

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
- **Activity Logging:** Cross-cutting concern via `ActivityLogService` — call sites use `unawaited()` so logging never blocks the primary operation

### 2.4 Dependency Injection (GetIt)

Global singleton: `final sl = GetIt.instance;` in `service_locator.dart`.

**Registration order (strict):**

1. `SharedPreferences` → `ThemeRepository/Cubit` → `LocaleRepository/Cubit`
2. `StorageService` (LazySingleton)
3. **`ActivityLogService` (LazySingleton)** — must be before any repo that uses it
4. Firebase: `FirebaseFirestore`, `FirebaseAuth`, `FirebaseFunctions`, `FirebaseMessaging`
5. Auth: DataSource (receives `ActivityLogService`) → Repository → `AuthCubit` (Singleton)
6. Master Data: Local DS (Singleton) → Remote DSes → Repositories (receive `ActivityLogService`) → Cubits (Factory)
7. SantriExtraTarget: Remote DS → Repository → Cubit (Factory)
8. **Kelas:** Remote DS → Repository → `KelasCubit` (Factory) *(new)*
9. **Program:** Remote DS → Repository → `ProgramCubit` (Factory) *(new)*
10. Guru Absensi: Local DS → Remote DS → Repository (receives `ActivityLogService`) → `AbsensiSyncService` → `AbsensiCubit` (Factory)
11. Guru Hafalan: Local DS → Remote DS → Repository (receives `ActivityLogService`) → `HafalanSyncService` → Cubits (Factory)
12. Guru Dashboard: `DashboardSummaryCubit` (Factory)
13. Guru Profile: Remote DS → Repository → `GuruProfileCubit` (Factory)
14. Wali Santri Hafalan: Remote DS → Repository → Cubits (Factory)
15. Wali Santri Profile: Remote DS → Repository → `WaliSantriProfileCubit` (Factory)
16. Notifications: Remote DS → Repository → `NotificationCubit` (Singleton)
17. **Guru Laporan:** `LaporanAbsensiCubit` (Factory), `LaporanAbsensiHalaqohCubit` (Factory), `LaporanHafalanCubit` (Factory) *(new)*
18. **Super Admin:** `ActivityLogRemoteDataSource` → `ActivityLogRepository` → `ActivityLogCubit` (Factory); `ImpersonationCubit` (Singleton) *(new)*

**Registration rules:**

| Type | Method | Reason |
|---|---|---|
| Firebase instances | `registerLazySingleton` | Single SDK instance |
| DataSources | `registerLazySingleton` | Stateless |
| Repositories | `registerLazySingleton` | Stateless |
| `ActivityLogService` | `registerLazySingleton` | Stateless cross-cutting service |
| Global Cubits (Auth, Theme, Locale, Notification, **Impersonation**) | `registerSingleton` | Must persist for app lifetime |
| Feature Cubits | `registerFactory` | Scoped per screen |

### 2.5 Bootstrap Sequence (`main.dart`)

```dart
// 0. WidgetsFlutterBinding.ensureInitialized()
//    FlutterNativeSplash.preserve(widgetsBinding) — holds splash until auth resolves

// 1. Firebase.initializeApp()
//    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler)
//    _setupNotificationTapHandlers()  // FCM tap → pendingNotificationTab ValueNotifier

// 2. Parallel (await Future.wait):
//    _initNotificationChannels()   // Android channels via flutter_local_notifications
//    _initHive()                   // Hive.initFlutter() + registerMasterDataAdapters()
//                                  //                   + registerAbsensiAdapters()
//    QuranService.instance.initialize()

// 3. Firebase App Check — fire-and-forget (currently commented out in code)

// 4. initDependencies()  // GetIt

// 5. sl<MasterDataLocalDataSource>().init()  // Open Hive boxes

// 6. Parallel: sl<ThemeCubit>().initialize() + sl<LocaleCubit>().initialize()

// 7. Fire-and-forget:
//    sl<AbsensiSyncService>().start()
//    sl<HafalanSyncService>().start()

// 8. runApp(TranslationProvider(child: MyApp()))
```

**Native Splash removal:** `FlutterNativeSplash.remove()` is called inside the `BlocListener<AuthCubit>` **after** the router has navigated to the role's root screen. There is no longer a separate `SplashScreen` widget.

**Global `MultiBlocProvider`:** ThemeCubit, LocaleCubit, AuthCubit (+ `checkAuthStatus()`), GuruCubit (+ `watchAll()`), SantriCubit (+ `watchAll()`), HalaqohCubit (+ `watchAll()`), TargetHafalanCubit (+ `watchAll()`), **KelasCubit** (+ `watchAll()`), **ProgramCubit** (+ `watchAll()`), **ImpersonationCubit** (value, singleton).

**Role-Based Routing (inside `BlocListener<AuthCubit>`):**

| `user.role` | Route |
|---|---|
| `"admin"` | `DashboardWrapperRoute()` |
| `"guru"` | `GuruDashboardWrapperRoute(programType: "reguler"/"takhassus")` |
| `"santri"` | `WaliSantriDashboardWrapperRoute(programType: ...)` |
| `"super_admin"` | `SuperAdminPickerRoute()` *(new)* |
| other | `LoginRoute()` |

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

**`AuthState`:** `initial`, `loading`, `authenticated(UserModel)`, `unauthenticated`, `error(String)`.

**`NotificationState`:** `initial`, `loading`, `tokenSaved`, `permissionDenied`, `error`. `permissionDenied` is **not** treated as a fatal error — the app continues normally.

**`ImpersonationState`:** `idle()`, `active(ImpersonationContext)`. *(new)*

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
| `/users/{uid}` | Firebase Auth UID | `uid`, `identifier`, `role` ("admin"/"guru"/"santri"/"super_admin"), `programType` ("R"/"T"), `displayName`, `linkedDocId`, `fcmToken?`, `fcmTokenUpdatedAt?` |
| `/guru/{id}` | Auto | `nip`, `nama`, `phone?`, `profilePicture?`, `program` ("R"/"T"), `authUid?`, `createdAt`, `updatedAt` |
| `/santri/{id}` | Auto | `nis`, `nama`, `kelas`, `program` ("R"/"T"), `halaqohId?`, `waliSantri` (embedded), `authUid?`, `profilePicture?`, `createdAt`, `updatedAt` |
| `/halaqoh/{id}` | Auto | `nama`, `kelas`, `program`, `guruId`, `guruNama` (denorm.), `santriIds[]`, `jumlahSantri`, `createdAt`, `updatedAt` |
| `/targetHafalan/{id}` | `"{kelas}_{program}"` | `kelas`, `program` ("Reguler"/"Takhassus"), `targetJuz`, `juzList[]`, `tahunAjaran`, `createdAt`, `updatedAt` |
| `/santriExtraTarget/{santriId}` | `santriId` | `santriId`, `extraJuz[]`, `updatedAt` |
| `/absensi/{id}` | Auto | `halaqohId`, `guruId`, `tanggal`, `sesi`, `records[]` (embedded `AbsensiRecordEntry`), `isSynced`, `createdAt`, `updatedAt`, `notifiedAt?` (server-only) |
| `/hafalan/{id}` | Auto | `santriId`, `guruId`, `halaqohId`, `tanggalSetoran`, `jenis`, `surahId`, `surahName`, `ayatMulai`, `ayatSelesai`, `juz`, `nilaiKelancaran`, `nilaiTajwid`, `createdAt`, `isSynced`, `notifiedAt?` (server-only) |
| `/kelas/{id}` | Auto (e.g., `"7"`) | `id`, `nama`, `urutan`, `nextKelasId?`, `createdAt`, `updatedAt` |
| `/program/{id}` | Auto (e.g., `"R"`) | `id`, `nama`, `createdAt`, `updatedAt` |
| `/activity_log/{id}` | Auto | `userId`, `userRole`, `userName`, `action`, `module`, `entityId?`, `entityName?`, `description?`, `metadata?`, `createdAt` |

**Schema design principles:**
1. **Denormalization:** `guruNama` in halaqoh; `nama`/`nis` in `AbsensiRecordEntry`.
2. **Embedded documents:** `WaliSantriModel` inside santri; `AbsensiRecordEntry` list inside absensi.
3. **Server-only fields:** `notifiedAt` on absensi and hafalan — **written only by Cloud Functions**. The Flutter client must **never** set this field.
4. **Program codes:** Master data uses `"R"`/`"T"` short codes; `targetHafalan` uses `"Reguler"`/`"Takhassus"`. Use `TargetHafalanHelper.programCodeToFullName()` to convert.
5. **Timestamps:** Firestore `Timestamp` ↔ Dart `DateTime` conversion is handled exclusively in Mapper classes.
6. **Activity logs:** Never cached locally. Always streamed directly from Firestore in the super admin console.

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
- `registerMasterDataAdapters()` — in `hive_adapters.dart`, called inside `_initHive()`
- `registerAbsensiAdapters()` — in `absensi_hive_adapters.dart`, called inside `_initHive()`

### 4.3 Hive Boxes

| Box Name | Type | Opened By |
|---|---|---|
| `guru_box` | `Box<GuruModel>` | `MasterDataLocalDataSource.init()` |
| `santri_box` | `Box<SantriModel>` | `MasterDataLocalDataSource.init()` |
| `halaqoh_box` | `Box<HalaqohModel>` | `MasterDataLocalDataSource.init()` |
| `target_hafalan_box` | `Box<TargetHafalanModel>` | `MasterDataLocalDataSource.init()` |
| `hafalan_santri_box` | `Box<HafalanSantriModel>` | `HafalanSantriLocalDataSource` (lazy) |
| `absensi_box` | `Box<AbsensiModel>` | `AbsensiLocalDataSource` (lazy) |

> `KelasModel`, `ProgramModel`, `SantriExtraTargetModel`, and `ActivityLogModel` are **not** Hive-cached. They are always fetched from Firestore.

### 4.4 Caching Strategies by Module

**Master Data (Guru, Santri, Halaqoh, TargetHafalan):** Write-through cache.
- `watchAll()` → Firestore stream → cache Hive on each emission → emit to Cubit.
- `getAll()` → fetch Firestore → cache Hive → on failure read Hive.

**Kelas, Program, SantriExtraTarget:** Firestore-only (no Hive cache). Always fetched live.

**Absensi & Hafalan (Offline-First):**
- **Write:** Save to Hive immediately with `isSynced: false`. SyncService pushes to Firestore when connectivity is restored.
- **Read:** Stream from Hive box (reactive via `box.watch()`). Seed from Firestore on first open if local box is empty.
- **`notifiedAt`:** Read-only. Set by Cloud Function only.

**Activity Log:** Firestore-only, streamed in real-time. Never cached locally.

---

## 5. Quran Data Implementation (Core Feature)

### 5.1 Data Loading Workflow

```
main() → QuranService.instance.initialize()
  1. rootBundle.loadString('assets/data/quran.json')
  2. jsonDecode(raw) → Map<String, dynamic>
  3. QuranData.fromJson(json)
  4. Build O(1) maps: _surahById : Map<int, SurahModel>
                       _juzByNumber : Map<int, JuzModel>
  5. _initialized = true
```

### 5.2 QuranService API

`QuranService.instance` — Singleton. Call `initialize()` once in `main()`.

| Method | Returns | Notes |
|---|---|---|
| `getAllSurahs()` | `List<SurahModel>` | Unmodifiable |
| `getSurahById(int)` | `SurahModel?` | O(1) |
| `getSurahsByJuz(int)` | `List<SurahModel>` | |
| `getAllJuz()` | `List<JuzModel>` | Unmodifiable |
| `getJuzByNumber(int)` | `JuzModel?` | O(1) |
| `getTotalAyatInJuz(int)` | `int` | |
| `getTotalAyatForJuzList(List<int>)` | `int` | For target calculation |
| `isValidAyatRange(...)` | `bool` | Validates hafalan input |
| `calculateProgress(List<Map<String, int>>)` | `OverallHafalanProgress` | Core progress engine |
| `getSegmentsForJuzList(List<int>)` | `List<JuzSegmentModel>` | |

### 5.3 Progress Data Model

```
OverallHafalanProgress
├── totalAyatQuran, totalMemorized, percentage, completedJuz
└── juzProgressList: List<JuzProgress>
    ├── juzNumber, totalAyat, memorizedAyat, percentage
    └── surahProgressList: List<SurahProgress>
        └── surahId, surahName, totalAyat, memorizedAyat, percentage
```

---

## 6. Authentication & Session Management

### 6.1 Login Flow

```
1. User enters identifier (NIP/NIS/admin/"super_admin") + password
2. Build email: "{identifier}@myhalaqoh.app"
3. FirebaseAuth.signInWithEmailAndPassword(email, password)
4. Fetch /users/{uid} from Firestore → parse UserModel
5. ActivityLogService.log(action: 'login', module: 'auth')  // unawaited
6. AuthCubit.authStateChanges → _fetchUserMeta() → emit authenticated(userModel)
```

### 6.2 UserModel Fields

```dart
UserModel {
  uid: String,           // Firebase Auth UID
  identifier: String,    // NIP, NIS, "admin", or "super_admin"
  role: String,          // "admin" | "guru" | "santri" | "super_admin"
  programType: String?,  // "R" or "T" (null for Admin/SuperAdmin)
  displayName: String,
  linkedDocId: String,   // doc ID in /guru or /santri ("SYSTEM" for admin/super_admin)
}
```

`/users/{uid}` also stores `fcmToken` and `fcmTokenUpdatedAt` — managed by `NotificationCubit` (Wali Santri only).

### 6.3 Account Creation

Via Cloud Function `createUserAccount` — never client-side.

### 6.4 Session Persistence & Splash

Firebase Auth persists sessions natively. On cold start, `AuthCubit.checkAuthStatus()` (triggered by `BlocProvider.value(value: sl<AuthCubit>()..checkAuthStatus())`) drives the `BlocListener` in `MyApp`. The native splash is preserved until auth resolves, then `FlutterNativeSplash.remove()` is called post-navigation.

---

## 7. Push Notifications (FCM)

### 7.1 Architecture

Wali Santri receive FCM notifications when:
- A guru records attendance (`sendAbsensiNotification` Cloud Function — `asia-southeast2`)
- A guru submits hafalan (`sendHafalanNotification` Cloud Function — `asia-southeast2`)

The Flutter client is **passive** — it only manages the FCM device token. Cloud Functions dispatch notifications.

### 7.2 Notification Tap Handling

A global `ValueNotifier<int?> pendingNotificationTab` in `notification_tap_handler.dart` bridges FCM tap events to the `WaliSantriDashboardWrapperScreen` navigation. The tap handlers are set up via `_setupNotificationTapHandlers()` in `main()`.

| Tab value | Destination |
|---|---|
| `1` | Hafalan tab |
| `2` | Absensi tab |

Three tap scenarios are handled:
- **Terminated state:** `FirebaseMessaging.instance.getInitialMessage()`
- **Background state:** `FirebaseMessaging.onMessageOpenedApp`
- **Foreground state:** `FirebaseMessaging.onMessage` → show local notification via `flutter_local_notifications` → tap triggers `onDidReceiveNotificationResponse`

### 7.3 Android Notification Channels

| Channel ID | Name |
|---|---|
| `my_halaqoh_absensi` | Notifikasi Absensi MyHalaqoh |
| `my_halaqoh_hafalan` | Notifikasi Hafalan MyHalaqoh |

### 7.4 Background Handler Constraint

```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in a SEPARATE ISOLATE.
  // NEVER use GetIt (sl), Cubits, BuildContext, or UI code here.
}
```

### 7.5 NotificationCubit Lifecycle

- **Registration:** `registerSingleton<NotificationCubit>` — persists for app lifetime.
- **Init:** Call `sl<NotificationCubit>().initialize(uid)` only for Wali Santri.
- **Token refresh:** Subscribes to `onTokenRefresh` — auto-persists new tokens. Singleton is mandatory to keep this subscription alive.
- **Logout:** Call `sl<NotificationCubit>().clearToken(uid)` **before** `AuthCubit.logout()`.

---

## 8. Offline-First & Sync Architecture

### 8.1 Write Path (Absensi & Hafalan)

```
1. Build model with isSynced: false
2. Put into Hive box (immediate — always succeeds)
3. Attempt Firestore write:
   - Success → mark isSynced: true in Hive
   - Failure → leave isSynced: false (SyncService retries)
4. Return success to UI (Hive write is the source of truth)
```

### 8.2 Sync Services

Both `AbsensiSyncService` and `HafalanSyncService` use `connectivity_plus`:

```dart
void start() {
  _subscription = Connectivity().onConnectivityChanged.listen((results) {
    if (results.any((r) => r != ConnectivityResult.none)) {
      _repository.syncPendingRecords();
    }
  });
  _trySyncNow(); // immediate attempt on start
}
```

Started in `main()` **after** `initDependencies()` as fire-and-forget.

### 8.3 ActivityLogService Impact on Repositories

`ActivityLogService` is injected into repositories that write data. Call sites always use `unawaited()`:

```dart
unawaited(sl<ActivityLogService>().log(
  action: 'create',
  module: 'guru',
  entityId: model.id,
  entityName: model.nama,
));
```

**Supported action values:** `'login'`, `'logout'`, `'create'`, `'update'`, `'delete'`, `'save_absensi'`, `'sync_absensi'`, `'add_hafalan'`, `'sync_hafalan'`

**Supported module values:** `'auth'`, `'guru'`, `'santri'`, `'halaqoh'`, `'target_hafalan'`, `'absensi'`, `'hafalan'`

---

## 9. Super Admin Module

### 9.1 Overview

The `super_admin` module is a read-only console for platform administrators. It does not modify any data — it observes and impersonates.

### 9.2 Impersonation System

`ImpersonationCubit` is registered as a **Singleton** and exposed globally via `BlocProvider.value` in `MyApp`. It stores an `ImpersonationContext` with:

```dart
ImpersonationContext {
  targetRole: String,    // 'admin' | 'guru' | 'santri'
  linkedDocId: String?,  // /guru or /santri doc ID (null for admin)
  displayName: String?,  // human-readable name
  programType: String?,  // 'R' or 'T' (null for admin)
}
```

**Impersonation methods:**
- `impersonateAsAdmin()` → navigate to `DashboardWrapperRoute`
- `impersonateAsGuru(GuruModel)` → navigate to `GuruDashboardWrapperRoute`
- `impersonateAsSantri(SantriModel)` → navigate to `WaliSantriDashboardWrapperRoute`
- `exitImpersonation()` → navigate back to `SuperAdminPickerRoute`

**ImpersonationState:** `idle()` | `active(ImpersonationContext)`

> `ImpersonationContext` is a plain Dart class — NOT `@freezed`, NOT Hive-cached. Lives only in memory.

### 9.3 Activity Log

`ActivityLogModel` fields:

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Firestore auto-ID |
| `userId` | `String` | Firebase Auth UID |
| `userRole` | `String` | actor's role |
| `userName` | `String` | actor's display name |
| `action` | `String` | see supported values in §8.3 |
| `module` | `String` | see supported values in §8.3 |
| `entityId` | `String?` | affected document ID |
| `entityName` | `String?` | human-readable entity name |
| `description` | `String?` | Bahasa Indonesia sentence |
| `metadata` | `Map<String, dynamic>` | additional context |
| `createdAt` | `DateTime` | Firestore server timestamp |

`ActivityLogRepository` provides `Stream<List<ActivityLogModel>> watchAll()` for real-time display in `ActivityLogCubit`.

`ActivityLogService` is the cross-cutting write path. It maintains an in-memory `_userMetaCache` (uid → role/displayName) to avoid repeated Firestore reads. Call `clearCache()` on logout.

---

## 10. Guru Laporan Module

### 10.1 Architecture

`guru_laporan` has a **full Clean Architecture** structure. It generates PDF reports from in-memory data (no Firestore queries of its own — it receives data passed by the calling screen).

### 10.2 Cubits

| Cubit | Registered As | Purpose |
|---|---|---|
| `LaporanAbsensiCubit` | Factory | Per-session PDF generation for a single guru's attendance |
| `LaporanAbsensiHalaqohCubit` | Factory | PDF generation for a full halaqoh's attendance |
| `LaporanHafalanCubit` | Factory | PDF generation for hafalan records (receives `HafalanSantriRepository` via sl) |

All laporan cubits are scoped to the `LaporanKonfigurasiSheet` bottom sheet lifetime.

---

## 11. Dependencies & Core Packages

### 11.1 New Packages (added since last context update)

| Package | Version | Purpose |
|---|---|---|
| `flutter_native_splash` | `^2.4.5` | Zero-flicker native splash screen. Config in `pubspec.yaml`. Run `dart run flutter_native_splash:create`. |
| `url_launcher` | `^6.3.2` | Opens external URLs (e.g., in About screen). |
| `shimmer_animation` | `^2.2.1` | Skeleton loading states across all data-driven screens. |

### 11.2 Full Dependency Reference

| Package | Version | Usage Rule |
|---|---|---|
| `flutter_bloc` / `bloc` | `^9.1.1` / `^9.0.0` | Always Cubit. Never emit outside Cubit. |
| `auto_route` | `^10.1.2` | `@RoutePage()` on all screens. |
| `get_it` | `^8.2.0` | `sl<T>()`. All deps in `service_locator.dart`. |
| `cloud_firestore` | `^6.2.0` | Only through DataSource abstractions. |
| `firebase_auth` | `^6.3.0` | Only inside `AuthRemoteDataSource`. |
| `firebase_core` | `^4.6.0` | Init once in `main()`. |
| `firebase_storage` | `^13.2.0` | Via `StorageService`. |
| `cloud_functions` | `^6.1.0` | Account creation + callable functions. Region: `us-central1`. |
| `firebase_messaging` | `^16.1.3` | Via `NotificationRemoteDataSource` only. |
| `firebase_app_check` | `^0.4.2` | Currently commented out in main.dart. |
| `flutter_local_notifications` | `^18.0.1` | Channel setup + foreground notification display in `main()` only. |
| `connectivity_plus` | `^7.1.1` | Only in SyncService classes. Never poll in UI. |
| `freezed_annotation` | `^3.1.0` | All domain models and states. |
| `json_annotation` | `^4.9.0` | `@JsonKey(name: 'snake_case')` for Firestore fields. |
| `dartz` | `^0.10.1` | `Either<String, T>`. Left=error, Right=success. |
| `hive` / `hive_flutter` | `^2.2.3` / `^1.1.0` | Only via datasource classes. |
| `flutter_screenutil` | `^5.9.3` | `.w`, `.h`, `.sp`, `.r` everywhere. Design 360×690. |
| `slang` / `slang_flutter` | `^4.8.1` / `^4.8.0` | `t.section.key`. Never hardcode user-facing strings. |
| `logger` | `^2.6.1` | `Logger()`. Never use `print()`. |
| `mobile_scanner` | `^7.1.2` | QR/barcode scanning. |
| `image_picker` | `^1.1.2` | Profile photo selection. |
| `pdf` / `printing` | `^3.11.3` / `^5.14.2` | PDF generation & printing. |
| `share_plus` | `^12.0.0` | Native sharing. |
| `percent_indicator` | `^4.2.5` | Hafalan progress display. |
| `animated_custom_dropdown` | `3.1.1` | Dropdown menus in forms. |
| `animated_notch_bottom_bar` | `^1.0.3` | Bottom navigation bar. |
| `shared_preferences` | `^2.5.4` | Theme/locale persistence. |
| `collection` | `^1.19.1` | `firstWhereOrNull`, etc. |
| `csv` / `file_picker` | `^6.0.0` / `^8.1.2` | Bulk data import. |
| `intl` | `^0.20.2` | Date/number formatting. |
| `flutter_gen` | `^5.12.0` | `Assets.xxx`, `ColorName.xxx`. Never hardcode paths. |
| `dio` | `^5.9.0` | External REST APIs with `pretty_dio_logger`. |
| `equatable` | `^2.0.7` | Value equality for non-Freezed classes. |
| `google_fonts` | `^6.3.2` | Secondary fonts only. Primary is bundled Poppins. |
| `flutter_native_splash` | `^2.4.5` | Native OS splash. Config in `pubspec.yaml`. |
| `url_launcher` | `^6.3.2` | External links (About screen). |
| `shimmer_animation` | `^2.2.1` | Skeleton loading states. |
| `flutter_localization` | `^0.3.3` | Localization support alongside slang. |

### 11.3 Code Generation Commands

```bash
# After any @freezed model, @RoutePage(), translation, or asset change:
dart run build_runner build --delete-conflicting-outputs

# After adding assets (images, colors):
dart run flutter_gen:generate

# After changing pubspec.yaml native splash config:
dart run flutter_native_splash:create

# After changing launcher icon config:
dart run flutter_launcher_icons
```

---

## 12. Error Handling & Data Mapping

### 12.1 Either Pattern

- `Left(String)` = user-facing error in Bahasa Indonesia.
- `Right(T)` = success payload.
- `Stream<T>` methods use `onError` callbacks — not Either.

### 12.2 Offline-First Error Strategy

```dart
Future<Either<String, Model>> add(Model model) async {
  await _local.put(model);           // 1. Write Hive (always succeeds)
  try {
    await _remote.add(model);
    await _local.markAsSynced(model.id);
    return Right(model.copyWith(isSynced: true));
  } catch (_) {
    return Right(model);             // isSynced: false — SyncService retries
  }
}
```

### 12.3 Firebase Auth Error Mapping

```dart
switch (e.code) {
  case 'user-not-found':
  case 'invalid-credential':
  case 'wrong-password':  return 'NIP/NIS atau Password salah';
  case 'network-request-failed': return 'Tidak ada koneksi internet';
  case 'too-many-requests': return 'Terlalu banyak percobaan. Harap tunggu sesaat.';
  case 'user-disabled': return 'Akun pengguna ini telah dinonaktifkan.';
  default: return 'Error autentikasi: ${e.message}';
}
```

### 12.4 Firestore Mapper Pattern

```dart
class XxxMapper {
  const XxxMapper._();

  static XxxModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return XxxModel(
      id: doc.id,                                           // Always doc.id
      field: data['field'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(XxxModel model) {
    return {
      'field': model.field,
      'createdAt': Timestamp.fromDate(model.createdAt),
      // NEVER include 'id' (doc path) or 'notifiedAt' (server-only)
    };
  }
}
```

---

## 13. AI Coding Rules & Conventions

### 13.1 Absolute Rules (NEVER Break)

1. **No business logic in UI.** No Firestore/Hive calls in widgets.
2. **No data layer imports in domain layer.** Domain has zero framework dependencies.
3. **No data/domain imports in UI** — only Models for type annotations.
4. **Every new Cubit must be registered in `service_locator.dart`.**
5. **No raw Firebase instances in Cubits or UI** — always DataSource → Repository → Cubit.
6. **Never reuse Hive Type IDs.** Next available: **10**.
7. **Never edit generated files** (`.freezed.dart`, `.g.dart`, `.gr.dart`, `gen/`).
8. **Never write `notifiedAt` from the Flutter client.** Server-only Cloud Function field.
9. **`NotificationCubit` and `ImpersonationCubit` must be Singletons.**
10. **No GetIt/Cubits/BuildContext in `_firebaseMessagingBackgroundHandler`.** Separate isolate.
11. **All `ActivityLogService.log()` calls must be wrapped with `unawaited()`.** Never `await`.
12. **`ImpersonationContext` is a plain Dart class.** Never make it @freezed or Hive-cached.
13. **Cloud Functions deployment regions:** account creation functions → `us-central1`; notification functions → `asia-southeast2`. Never change call sites without updating region.

### 13.2 Naming Conventions

| Artifact | Pattern |
|---|---|
| Feature module dir | `snake_case` with role prefix (`guru_hafalan/`, `wali_santri_absensi/`) |
| Model | `snake_case_model.dart` |
| Repo contract | `snake_case_repository.dart` |
| Repo impl | `snake_case_repository_impl.dart` |
| Remote DS abstract | `snake_case_remote_datasource.dart` |
| Remote DS impl | `snake_case_remote_datasource_impl.dart` |
| Local DS | `snake_case_local_data_source.dart` |
| Hive adapters file | `snake_case_hive_adapters.dart` |
| Mapper | `snake_case_mapper.dart` |
| Cubit | `snake_case_cubit.dart` |
| State | `snake_case_state.dart` |
| Screen | `snake_case_screen.dart` + `@RoutePage()` |
| SyncService | `snake_case_sync_service.dart` |

### 13.3 Model Rules

1. All domain models: `@freezed`.
2. `@JsonKey(name: 'snake_case')` for field name differences.
3. `@Default(value)` for optional fields with defaults.
4. `DateTime` in models always. Mappers handle `Timestamp` conversion.
5. Server-only fields: `DateTime?` + comment `// Server-only. NEVER set by client.`
6. Models that are never Hive-cached don't need a Hive adapter. Document this with a comment.

### 13.4 Hive Adapter Rules

1. Hand-written adapters only (no code generation).
2. DateTime serialization must be consistent per module: ISO 8601 string (master data / hafalan) OR millisecondsSinceEpoch int (absensi).
3. New fields on existing adapters must be read as nullable for backward compatibility.
4. Use `if (!Hive.isAdapterRegistered(typeId))` guard.

### 13.5 ActivityLogService Rules

1. Always inject via `sl<ActivityLogService>()` — never instantiate directly.
2. All call sites must use `unawaited()` — logging is fire-and-forget.
3. Never surface logging failures to the user — they are swallowed internally.
4. Call `sl<ActivityLogService>().clearCache()` inside `AuthCubit.logout()`.

### 13.6 General Code Quality

1. `///` docstrings for all public classes and methods.
2. `const` constructors wherever possible.
3. `final` over `var`.
4. Cancel stream subscriptions in Cubit `close()`.
5. `Logger()` for all logging. Never `print()`.
6. **Canonical references:**
   - Master data: `GuruCubit`, `GuruRepository`, `GuruRemoteDataSourceImpl`, `GuruMapper`
   - Offline-first: `HafalanSantriRepository`, `HafalanSantriLocalDataSource`, `HafalanSyncService`
   - Notification: `NotificationCubit`, `NotificationRepositoryImpl`
   - Super Admin: `ImpersonationCubit`, `ActivityLogCubit`, `ActivityLogService`

---

## Appendix: Checklist for New Features

- [ ] Model: `@freezed` in `domain/models/`
- [ ] Repo contract: abstract in `domain/repositories/`
- [ ] Remote DS abstract: in `data/datasources/remote/source/abstract/`
- [ ] Remote DS impl: in `data/datasources/remote/source/implementation/`
- [ ] Mapper: static class in `data/datasources/remote/mapper/`
- [ ] Repo impl: in `data/repositories_impl/`
- [ ] **If offline-first:** Local DS in `data/datasources/local/`; Hive adapter (Type ID ≥ 10); register in adapter helper; open box before use
- [ ] **If syncing:** SyncService in `domain/services/`; `registerLazySingleton`; `start()` in `main()`
- [ ] **If auditable:** Inject `ActivityLogService` into Repository; call with `unawaited()`
- [ ] State: Freezed sealed union in `presentation/cubits/`
- [ ] Cubit: `registerFactory` (or `registerSingleton` if global state) in `service_locator.dart`
- [ ] **If global:** add `BlocProvider` to `MultiBlocProvider` in `main.dart`
- [ ] Screens: `@RoutePage()` annotation in `presentation/screens/`
- [ ] Router: `AutoRoute(page: XxxRoute.page)` in `app_router.dart`
- [ ] Run: `dart run build_runner build --delete-conflicting-outputs`
