# MyHalaqoh — Absolute Rules (JANGAN PERNAH DILANGGAR)

1. Tidak ada business logic di UI. Tidak ada Firestore/Hive calls di widgets.
2. Tidak ada data layer imports di domain layer. Domain zero framework dependencies.
3. Tidak ada data/domain imports di UI — hanya Models untuk type annotations.
4. Setiap Cubit baru WAJIB didaftarkan di `service_locator.dart`.
5. Tidak ada raw Firebase instances di Cubits atau UI — selalu DataSource → Repository → Cubit.
6. JANGAN pernah reuse Hive Type IDs. Next available: 10.
7. JANGAN pernah edit generated files (.freezed.dart, .g.dart, .gr.dart, gen/).
8. JANGAN pernah tulis `notifiedAt` dari Flutter client. Server-only Cloud Function field.
9. `NotificationCubit` dan `ImpersonationCubit` harus Singleton.
10. Tidak ada GetIt/Cubits/BuildContext di `_firebaseMessagingBackgroundHandler`.
11. Semua `ActivityLogService.log()` calls WAJIB dibungkus `unawaited()`. Jangan pernah `await`.
12. `ImpersonationContext` adalah plain Dart class. Jangan jadikan @freezed atau Hive-cached.
13. Cloud Functions regions: account creation → `us-central1`; notification → `asia-southeast2`.