import 'dart:io';
import 'package:hive/hive.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/hive_adapters.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_record_entry.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/local/absensi_hive_adapters.dart';

void main() async {
  Hive.init(Directory.current.path + '/test_hive3');
  Hive.registerAdapter(GuruModelAdapter());
  Hive.registerAdapter(AbsensiModelAdapter());
  Hive.registerAdapter(AbsensiRecordEntryAdapter());
  
  var box2 = await Hive.openBox<AbsensiModel>('test_absensi');
  try {
    await box2.put('1', AbsensiModel(id: '1', halaqohId: '1', guruId: '1', tanggal: DateTime.now(), sesi: 's', records: [
      AbsensiRecordEntry(santriId: '1', nis: '1', nama: 'test', status: 'hadir')
    ], createdAt: DateTime.now(), updatedAt: DateTime.now()));
    print('AbsensiModel put success');
  } catch (e) {
    print('AbsensiModel put failed: $e');
  }
}
