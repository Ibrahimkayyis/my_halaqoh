import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:hive/hive.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/wali_santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

// ═══════════════════════════════════════════════════════════════════════════
// TYPE IDs — unique per adapter, never reuse
// ═══════════════════════════════════════════════════════════════════════════
// 1 = GuruModel
// 2 = SantriModel
// 3 = WaliSantriModel
// 4 = HalaqohModel
// 5 = TargetHafalanModel

// ─── GuruModel Adapter ──────────────────────────────────────────────────────

class GuruModelAdapter extends TypeAdapter<GuruModel> {
  @override
  final int typeId = 1;

  @override
  GuruModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return GuruModel(
      id: fields[0] as String,
      nip: fields[1] as String,
      nama: fields[2] as String,
      phone: fields[3] as String?,
      authUid: fields[4] as String?,
      createdAt: DateTime.parse(fields[5] as String),
      updatedAt: DateTime.parse(fields[6] as String),
      program: fields[7] as String? ?? 'R',
      profilePicture: fields[8] as String?,
      email: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GuruModel obj) {
    writer.writeByte(10); // number of fields
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.nip);
    writer.writeByte(2);
    writer.write(obj.nama);
    writer.writeByte(3);
    writer.write(obj.phone);
    writer.writeByte(4);
    writer.write(obj.authUid);
    writer.writeByte(5);
    writer.write(obj.createdAt.toIso8601String());
    writer.writeByte(6);
    writer.write(obj.updatedAt.toIso8601String());
    writer.writeByte(7);
    writer.write(obj.program);
    writer.writeByte(8);
    writer.write(obj.profilePicture);
    writer.writeByte(9);
    writer.write(obj.email);
  }
}

// ─── WaliSantriModel Adapter ────────────────────────────────────────────────

class WaliSantriModelAdapter extends TypeAdapter<WaliSantriModel> {
  @override
  final int typeId = 3;

  @override
  WaliSantriModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return WaliSantriModel(
      nama: fields[0] as String,
      phone: fields[1] as String,
      hubungan: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WaliSantriModel obj) {
    writer.writeByte(3);
    writer.writeByte(0);
    writer.write(obj.nama);
    writer.writeByte(1);
    writer.write(obj.phone);
    writer.writeByte(2);
    writer.write(obj.hubungan);
  }
}

// ─── SantriModel Adapter ────────────────────────────────────────────────────

class SantriModelAdapter extends TypeAdapter<SantriModel> {
  @override
  final int typeId = 2;

  @override
  SantriModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return SantriModel(
      id: fields[0] as String,
      nis: fields[1] as String,
      nama: fields[2] as String,
      kelas: fields[3] as String,
      program: fields[4] as String,
      halaqohId: fields[5] as String?,
      waliSantri: fields[6] as WaliSantriModel?,
      authUid: fields[7] as String?,
      createdAt: DateTime.parse(fields[8] as String),
      updatedAt: DateTime.parse(fields[9] as String),
      profilePicture: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SantriModel obj) {
    writer.writeByte(11);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.nis);
    writer.writeByte(2);
    writer.write(obj.nama);
    writer.writeByte(3);
    writer.write(obj.kelas);
    writer.writeByte(4);
    writer.write(obj.program);
    writer.writeByte(5);
    writer.write(obj.halaqohId);
    writer.writeByte(6);
    writer.write(obj.waliSantri);
    writer.writeByte(7);
    writer.write(obj.authUid);
    writer.writeByte(8);
    writer.write(obj.createdAt.toIso8601String());
    writer.writeByte(9);
    writer.write(obj.updatedAt.toIso8601String());
    writer.writeByte(10);
    writer.write(obj.profilePicture);
  }
}

// ─── HalaqohModel Adapter ───────────────────────────────────────────────────

class HalaqohModelAdapter extends TypeAdapter<HalaqohModel> {
  @override
  final int typeId = 4;

  @override
  HalaqohModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return HalaqohModel(
      id: fields[0] as String,
      nama: fields[1] as String,
      kelas: fields[2] as String,
      program: fields[3] as String,
      guruId: fields[4] as String,
      guruNama: fields[5] as String,
      santriIds: List<String>.from(fields[6] as List),
      jumlahSantri: fields[7] as int,
      createdAt: DateTime.parse(fields[8] as String),
      updatedAt: DateTime.parse(fields[9] as String),
    );
  }

  @override
  void write(BinaryWriter writer, HalaqohModel obj) {
    writer.writeByte(10);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.nama);
    writer.writeByte(2);
    writer.write(obj.kelas);
    writer.writeByte(3);
    writer.write(obj.program);
    writer.writeByte(4);
    writer.write(obj.guruId);
    writer.writeByte(5);
    writer.write(obj.guruNama);
    writer.writeByte(6);
    writer.write(obj.santriIds);
    writer.writeByte(7);
    writer.write(obj.jumlahSantri);
    writer.writeByte(8);
    writer.write(obj.createdAt.toIso8601String());
    writer.writeByte(9);
    writer.write(obj.updatedAt.toIso8601String());
  }
}

// ─── TargetHafalanModel Adapter ─────────────────────────────────────────────

class TargetHafalanModelAdapter extends TypeAdapter<TargetHafalanModel> {
  @override
  final int typeId = 5;

  @override
  TargetHafalanModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return TargetHafalanModel(
      id: fields[0] as String,
      kelas: fields[1] as String,
      program: fields[2] as String,
      targetJuz: fields[3] as int,
      juzList: List<int>.from(fields[4] as List),
      tahunAjaran: fields[5] as String,
      createdAt: DateTime.parse(fields[6] as String),
      updatedAt: DateTime.parse(fields[7] as String),
    );
  }

  @override
  void write(BinaryWriter writer, TargetHafalanModel obj) {
    writer.writeByte(8);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.kelas);
    writer.writeByte(2);
    writer.write(obj.program);
    writer.writeByte(3);
    writer.write(obj.targetJuz);
    writer.writeByte(4);
    writer.write(obj.juzList);
    writer.writeByte(5);
    writer.write(obj.tahunAjaran);
    writer.writeByte(6);
    writer.write(obj.createdAt.toIso8601String());
    writer.writeByte(7);
    writer.write(obj.updatedAt.toIso8601String());
  }
}


// ─── Registration helper ────────────────────────────────────────────────────

/// Register all master data Hive adapters.
/// Call this once before opening any boxes.
void registerMasterDataAdapters() {
  Hive.registerAdapter(GuruModelAdapter());
  Hive.registerAdapter(SantriModelAdapter());
  Hive.registerAdapter(WaliSantriModelAdapter());
  Hive.registerAdapter(HalaqohModelAdapter());
  Hive.registerAdapter(TargetHafalanModelAdapter());
  Hive.registerAdapter(HafalanSantriModelAdapter());
}

// ─── HafalanSantriModel Adapter ─────────────────────────────────────────────

class HafalanSantriModelAdapter extends TypeAdapter<HafalanSantriModel> {
  @override
  final int typeId = 6;

  @override
  HafalanSantriModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return HafalanSantriModel(
      id: fields[0] as String,
      santriId: fields[1] as String,
      guruId: fields[2] as String,
      halaqohId: fields[3] as String,
      tanggalSetoran: DateTime.parse(fields[4] as String),
      jenis: fields[5] as String,
      surahId: fields[6] as int,
      surahName: fields[7] as String,
      ayatMulai: fields[8] as int,
      ayatSelesai: fields[9] as int,
      juz: fields[10] as int,
      nilaiKelancaran: fields[11] as int,
      nilaiTajwid: fields[12] as int,
      createdAt: DateTime.parse(fields[13] as String),
      isSynced: fields[14] as bool? ?? false,
      // fields[15] is notifiedAt — null-safe for boxes written before this field was added
      notifiedAt: fields[15] != null
          ? DateTime.parse(fields[15] as String)
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, HafalanSantriModel obj) {
    writer.writeByte(16); // number of fields (0–15)
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.santriId);
    writer.writeByte(2);
    writer.write(obj.guruId);
    writer.writeByte(3);
    writer.write(obj.halaqohId);
    writer.writeByte(4);
    writer.write(obj.tanggalSetoran.toIso8601String());
    writer.writeByte(5);
    writer.write(obj.jenis);
    writer.writeByte(6);
    writer.write(obj.surahId);
    writer.writeByte(7);
    writer.write(obj.surahName);
    writer.writeByte(8);
    writer.write(obj.ayatMulai);
    writer.writeByte(9);
    writer.write(obj.ayatSelesai);
    writer.writeByte(10);
    writer.write(obj.juz);
    writer.writeByte(11);
    writer.write(obj.nilaiKelancaran);
    writer.writeByte(12);
    writer.write(obj.nilaiTajwid);
    writer.writeByte(13);
    writer.write(obj.createdAt.toIso8601String());
    writer.writeByte(14);
    writer.write(obj.isSynced);
    writer.writeByte(15);
    writer.write(obj.notifiedAt?.toIso8601String());
  }
}
