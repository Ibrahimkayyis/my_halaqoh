import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_halaqoh/src/core/helpers/prayer_time_helper.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_record_entry.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/repositories/absensi_repository.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_state.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/repositories/hafalan_santri_repository.dart';

class MockAbsensiRepository extends Mock implements AbsensiRepository {}
class MockHafalanSantriRepository extends Mock implements HafalanSantriRepository {}

void main() {
  late MockAbsensiRepository mockAbsensiRepo;
  late MockHafalanSantriRepository mockHafalanRepo;
  late DashboardSummaryCubit cubit;
  late StreamController<List<AbsensiModel>> absensiLocalStreamController;
  late StreamController<List<AbsensiModel>> absensiRemoteStreamController;
  late StreamController<void> hafalanChangeController;
  late StreamController<List<HafalanSantriModel>> hafalanRemoteStreamController;

  setUp(() {
    mockAbsensiRepo = MockAbsensiRepository();
    mockHafalanRepo = MockHafalanSantriRepository();

    absensiLocalStreamController = StreamController<List<AbsensiModel>>.broadcast();
    absensiRemoteStreamController = StreamController<List<AbsensiModel>>.broadcast();
    hafalanChangeController = StreamController<void>.broadcast();
    hafalanRemoteStreamController = StreamController<List<HafalanSantriModel>>.broadcast();

    when(() => mockAbsensiRepo.watchByHalaqoh(any()))
        .thenAnswer((_) => absensiLocalStreamController.stream);
    when(() => mockAbsensiRepo.watchByHalaqohFromRemote(any()))
        .thenAnswer((_) => absensiRemoteStreamController.stream);
    when(() => mockHafalanRepo.watchAnyChanges())
        .thenAnswer((_) => hafalanChangeController.stream);
    when(() => mockHafalanRepo.watchByHalaqohFromRemote(any()))
        .thenAnswer((_) => hafalanRemoteStreamController.stream);

    when(() => mockHafalanRepo.getHafalanByHalaqohAndDate(any(), any()))
        .thenReturn([]);
    when(() => mockHafalanRepo.getRecentHafalanBySantriIds(any(), limit: any(named: 'limit')))
        .thenReturn([]);

    cubit = DashboardSummaryCubit(mockAbsensiRepo, mockHafalanRepo);
  });

  tearDown(() async {
    await cubit.close();
    await absensiLocalStreamController.close();
    await absensiRemoteStreamController.close();
    await hafalanChangeController.close();
    await hafalanRemoteStreamController.close();
  });

  group('DashboardSummaryCubit', () {
    test('initial state is DashboardSummaryState.initial', () {
      expect(cubit.state, const DashboardSummaryState.initial());
    });

    test('loadDashboardData computes attendance and hafalan setoran correctly', () async {
      final now = DateTime.now();
      final activeSesi = PrayerTimeHelper.getCurrentSession(
        programType: 'reguler',
        now: now,
      );

      final santriIds = ['santri-1', 'santri-2', 'santri-3'];
      final santriNameMap = {
        'santri-1': 'Ahmad',
        'santri-2': 'Budi',
        'santri-3': 'Chandra',
      };

      final todayAttendanceRecord = AbsensiModel(
        id: 'session-today',
        halaqohId: 'h-1',
        guruId: 'g-1',
        tanggal: DateTime(now.year, now.month, now.day),
        sesi: activeSesi,
        records: [
          const AbsensiRecordEntry(santriId: 'santri-1', nis: '001', nama: 'Ahmad', status: 'hadir'),
          const AbsensiRecordEntry(santriId: 'santri-2', nis: '002', nama: 'Budi', status: 'hadir_barcode'),
          const AbsensiRecordEntry(santriId: 'santri-3', nis: '003', nama: 'Chandra', status: 'sakit'),
        ],
        isSynced: true,
        createdAt: now,
        updatedAt: now,
      );

      final todayHafalan = [
        HafalanSantriModel(
          id: 'hafalan-1',
          santriId: 'santri-1',
          halaqohId: 'h-1',
          guruId: 'g-1',
          tanggalSetoran: now,
          jenis: 'Ziyadah',
          surahId: 1,
          surahName: 'Al-Fatihah',
          ayatMulai: 1,
          ayatSelesai: 7,
          juz: 1,
          nilaiKelancaran: 90,
          nilaiTajwid: 90,
          createdAt: now,
          isSynced: true,
        ),
      ];

      when(() => mockHafalanRepo.getHafalanByHalaqohAndDate(santriIds, any()))
          .thenReturn(todayHafalan);
      when(() => mockHafalanRepo.getRecentHafalanBySantriIds(santriIds, limit: any(named: 'limit')))
          .thenReturn(todayHafalan);

      cubit.loadDashboardData(
        halaqohId: 'h-1',
        santriIds: santriIds,
        santriNameMap: santriNameMap,
        programType: 'reguler',
      );

      // Emit attendance from local stream
      absensiLocalStreamController.add([todayAttendanceRecord]);

      await pumpEventQueue();

      cubit.state.maybeWhen(
        loaded: (
          attendedCount,
          totalSantriCount,
          attendancePercent,
          setoranCount,
          setoranPercent,
          latestSetoran,
          currentSesi,
        ) {
          // 2 present out of 3 (hadir + hadir_barcode)
          expect(attendedCount, 2);
          expect(totalSantriCount, 3);
          expect(attendancePercent, closeTo(2 / 3, 0.01));

          // 1 santri submitted hafalan
          expect(setoranCount, 1);
          expect(setoranPercent, closeTo(1 / 3, 0.01));
          expect(latestSetoran.length, 1);
          expect(currentSesi, activeSesi);
        },
        orElse: () => fail('State should be loaded, got ${cubit.state}'),
      );
    });

    test('refresh() re-reads data and emits updated state', () async {
      final now = DateTime.now();
      final santriIds = ['santri-1'];

      cubit.loadDashboardData(
        halaqohId: 'h-1',
        santriIds: santriIds,
        santriNameMap: {'santri-1': 'Ahmad'},
        programType: 'reguler',
      );

      await pumpEventQueue();

      // Now add a hafalan submission into repo mock
      final newHafalan = [
        HafalanSantriModel(
          id: 'hafalan-2',
          santriId: 'santri-1',
          halaqohId: 'h-1',
          guruId: 'g-1',
          tanggalSetoran: now,
          jenis: 'Murajaah',
          surahId: 2,
          surahName: 'Al-Baqarah',
          ayatMulai: 1,
          ayatSelesai: 10,
          juz: 1,
          nilaiKelancaran: 85,
          nilaiTajwid: 85,
          createdAt: now,
          isSynced: true,
        ),
      ];

      when(() => mockHafalanRepo.getHafalanByHalaqohAndDate(santriIds, any()))
          .thenReturn(newHafalan);
      when(() => mockHafalanRepo.getRecentHafalanBySantriIds(santriIds, limit: any(named: 'limit')))
          .thenReturn(newHafalan);

      // Trigger refresh
      cubit.refresh();
      await pumpEventQueue();

      cubit.state.maybeWhen(
        loaded: (
          attendedCount,
          totalSantriCount,
          attendancePercent,
          setoranCount,
          setoranPercent,
          latestSetoran,
          currentSesi,
        ) {
          expect(setoranCount, 1);
          expect(setoranPercent, 1.0);
          expect(latestSetoran.isNotEmpty, isTrue);
          expect(latestSetoran.first.santriName, 'Ahmad');
        },
        orElse: () => fail('State should be loaded after refresh'),
      );
    });
  });
}
