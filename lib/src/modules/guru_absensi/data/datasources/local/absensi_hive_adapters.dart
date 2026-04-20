import 'package:hive/hive.dart';
import '../../../domain/models/absensi_model.dart';
import '../../../domain/models/absensi_record_entry.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Type ID 6 — AbsensiModel
// ─────────────────────────────────────────────────────────────────────────────
class AbsensiModelAdapter extends TypeAdapter<AbsensiModel> {
  @override
  final int typeId = 6;

  @override
  AbsensiModel read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < fieldsCount; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return AbsensiModel(
      id: fields[0] as String,
      halaqohId: fields[1] as String,
      guruId: fields[2] as String,
      tanggal: DateTime.fromMillisecondsSinceEpoch(fields[3] as int),
      sesi: fields[4] as String,
      records: (fields[5] as List).cast<AbsensiRecordEntry>(),
      isSynced: fields[6] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[7] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[8] as int),
    );
  }

  @override
  void write(BinaryWriter writer, AbsensiModel obj) {
    writer.writeByte(9); // field count
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.halaqohId);
    writer.writeByte(2);
    writer.write(obj.guruId);
    writer.writeByte(3);
    writer.write(obj.tanggal.millisecondsSinceEpoch);
    writer.writeByte(4);
    writer.write(obj.sesi);
    writer.writeByte(5);
    writer.write(obj.records);
    writer.writeByte(6);
    writer.write(obj.isSynced);
    writer.writeByte(7);
    writer.write(obj.createdAt.millisecondsSinceEpoch);
    writer.writeByte(8);
    writer.write(obj.updatedAt.millisecondsSinceEpoch);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Type ID 7 — AbsensiRecordEntry
// ─────────────────────────────────────────────────────────────────────────────
class AbsensiRecordEntryAdapter extends TypeAdapter<AbsensiRecordEntry> {
  @override
  final int typeId = 7;

  @override
  AbsensiRecordEntry read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < fieldsCount; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return AbsensiRecordEntry(
      santriId: fields[0] as String,
      nis: fields[1] as String,
      nama: fields[2] as String,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AbsensiRecordEntry obj) {
    writer.writeByte(4); // field count
    writer.writeByte(0);
    writer.write(obj.santriId);
    writer.writeByte(1);
    writer.write(obj.nis);
    writer.writeByte(2);
    writer.write(obj.nama);
    writer.writeByte(3);
    writer.write(obj.status);
  }
}

/// Register all absensi Hive adapters. Call before Hive.openBox.
void registerAbsensiAdapters() {
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(AbsensiRecordEntryAdapter());
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(AbsensiModelAdapter());
  }
}
