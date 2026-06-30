# MyHalaqoh — DI Registration Order (service_locator.dart)

WAJIB ikuti urutan ini. Jangan insert di sembarang posisi.

1. SharedPreferences → ThemeRepository/Cubit → LocaleRepository/Cubit
2. StorageService (LazySingleton)
3. ActivityLogService (LazySingleton) ← HARUS sebelum repo manapun yang pakai
4. Firebase: Firestore, Auth, Functions, Messaging
5. Auth: DataSource → Repository → AuthCubit (Singleton)
6. Master Data: Local DS (Singleton) → Remote DSes → Repositories → Cubits (Factory)
7. SantriExtraTarget: Remote DS → Repository → Cubit (Factory)
8. Kelas: Remote DS → Repository → KelasCubit (Factory)
9. Program: Remote DS → Repository → ProgramCubit (Factory)
10. Guru Absensi: Local DS → Remote DS → Repository → AbsensiSyncService → AbsensiCubit (Factory)
11. Guru Hafalan: Local DS → Remote DS → Repository → HafalanSyncService → Cubits (Factory)
12. Guru Dashboard: DashboardSummaryCubit (Factory)
13. Guru Profile: Remote DS → Repository → GuruProfileCubit (Factory)
14. Guru Laporan: sesuai urutan setelah Hafalan
15. Super Admin: ActivityLogCubit, ImpersonationCubit (Singleton)
16. Wali Santri: semua Cubits (Factory)
17. Notifications: NotificationCubit (Singleton) ← HARUS Singleton