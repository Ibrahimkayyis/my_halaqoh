import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/helpers/sertifikasi_status_helper.dart';

void main() {
  group('SertifikasiStatusHelper Tests', () {
    test('Status labels are returned correctly in Indonesian', () {
      expect(
        SertifikasiStatusHelper.getStatusLabel(SertifikasiStatusHelper.statusPending),
        'Menunggu Persetujuan',
      );
      expect(
        SertifikasiStatusHelper.getStatusLabel(SertifikasiStatusHelper.statusScheduled),
        'Terjadwal',
      );
      expect(
        SertifikasiStatusHelper.getStatusLabel(SertifikasiStatusHelper.statusPassed),
        'Lulus Sertifikasi',
      );
      expect(
        SertifikasiStatusHelper.getStatusLabel(SertifikasiStatusHelper.statusFailed),
        'Perlu Mengulang',
      );
      expect(
        SertifikasiStatusHelper.getStatusLabel(SertifikasiStatusHelper.statusRejected),
        'Ditolak',
      );
    });

    test('calculatePredikat returns correct score categories', () {
      expect(SertifikasiStatusHelper.calculatePredikat(95), 'Mumtaz (Istimewa)');
      expect(SertifikasiStatusHelper.calculatePredikat(90), 'Mumtaz (Istimewa)');
      expect(SertifikasiStatusHelper.calculatePredikat(85), 'Jayyid Jiddan (Sangat Baik)');
      expect(SertifikasiStatusHelper.calculatePredikat(80), 'Jayyid Jiddan (Sangat Baik)');
      expect(SertifikasiStatusHelper.calculatePredikat(75), 'Jayyid (Baik)');
      expect(SertifikasiStatusHelper.calculatePredikat(70), 'Jayyid (Baik)');
      expect(SertifikasiStatusHelper.calculatePredikat(65), 'Maqbul (Cukup)');
      expect(SertifikasiStatusHelper.calculatePredikat(55), 'Rasib (Kurang)');
    });
  });
}
