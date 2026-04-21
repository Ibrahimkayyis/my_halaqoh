import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/local/absensi_hive_adapters.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/data/datasources/local/absensi_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/hive_adapters.dart';

void main() async {
  await Hive.initFlutter(Directory.current.path + '/test_hive2');
  registerAbsensiAdapters();
  registerMasterDataAdapters();
  
  final ds = AbsensiLocalDataSource();
  
  var list = [AbsensiModel(id: 'test', halaqohId: 'h1', guruId: 'g1', tanggal: DateTime.now(), sesi: 'shubuh', records: [], createdAt: DateTime.now(), updatedAt: DateTime.now())];
  try {
    await ds.cacheAll(list);
    print('cacheAll success');
  } catch(e) {
    print('cacheAll failed: $e');
  }
}
