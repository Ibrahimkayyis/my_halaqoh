///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsId implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsId _root = this; // ignore: unused_field

	@override 
	TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppId app = _TranslationsAppId._(_root);
	@override late final _TranslationsSplashId splash = _TranslationsSplashId._(_root);
	@override late final _TranslationsAuthId auth = _TranslationsAuthId._(_root);
	@override late final _TranslationsDashboardId dashboard = _TranslationsDashboardId._(_root);
	@override late final _TranslationsSantriId santri = _TranslationsSantriId._(_root);
	@override late final _TranslationsGuruId guru = _TranslationsGuruId._(_root);
	@override late final _TranslationsHalaqohId halaqoh = _TranslationsHalaqohId._(_root);
	@override late final _TranslationsTargetHafalanId targetHafalan = _TranslationsTargetHafalanId._(_root);
	@override late final _TranslationsEditTargetId editTarget = _TranslationsEditTargetId._(_root);
	@override late final _TranslationsNavId nav = _TranslationsNavId._(_root);
	@override late final _TranslationsAddDataId addData = _TranslationsAddDataId._(_root);
	@override late final _TranslationsAddHalaqohId addHalaqoh = _TranslationsAddHalaqohId._(_root);
	@override late final _TranslationsSelectSantriId selectSantri = _TranslationsSelectSantriId._(_root);
	@override late final _TranslationsGuruDashboardId guruDashboard = _TranslationsGuruDashboardId._(_root);
	@override late final _TranslationsGuruNavId guruNav = _TranslationsGuruNavId._(_root);
	@override late final _TranslationsMyHalaqohScreenId myHalaqohScreen = _TranslationsMyHalaqohScreenId._(_root);
	@override late final _TranslationsDetailSantriId detailSantri = _TranslationsDetailSantriId._(_root);
	@override late final _TranslationsAbsensiId absensi = _TranslationsAbsensiId._(_root);
	@override late final _TranslationsRiwayatAbsensiId riwayatAbsensi = _TranslationsRiwayatAbsensiId._(_root);
	@override late final _TranslationsKalenderAbsensiId kalenderAbsensi = _TranslationsKalenderAbsensiId._(_root);
	@override late final _TranslationsAbsensiHalaqohId absensiHalaqoh = _TranslationsAbsensiHalaqohId._(_root);
	@override late final _TranslationsDetailAbsensiHariIniId detailAbsensiHariIni = _TranslationsDetailAbsensiHariIniId._(_root);
	@override late final _TranslationsHafalanId hafalan = _TranslationsHafalanId._(_root);
	@override late final _TranslationsInputHafalanFormId inputHafalanForm = _TranslationsInputHafalanFormId._(_root);
	@override late final _TranslationsRiwayatHafalanSantriId riwayatHafalanSantri = _TranslationsRiwayatHafalanSantriId._(_root);
	@override late final _TranslationsProgressHafalanPerJuzId progressHafalanPerJuz = _TranslationsProgressHafalanPerJuzId._(_root);
	@override late final _TranslationsProgressHafalanPerSuratId progressHafalanPerSurat = _TranslationsProgressHafalanPerSuratId._(_root);
	@override late final _TranslationsMutabaahSantriId mutabaahSantri = _TranslationsMutabaahSantriId._(_root);
	@override late final _TranslationsGuruProfileId guruProfile = _TranslationsGuruProfileId._(_root);
	@override late final _TranslationsEditProfileId editProfile = _TranslationsEditProfileId._(_root);
	@override late final _TranslationsUbahPasswordId ubahPassword = _TranslationsUbahPasswordId._(_root);
	@override late final _TranslationsPengaturanScreenId pengaturanScreen = _TranslationsPengaturanScreenId._(_root);
	@override late final _TranslationsWaliSantriDashboardId waliSantriDashboard = _TranslationsWaliSantriDashboardId._(_root);
	@override late final _TranslationsWaliSantriNavId waliSantriNav = _TranslationsWaliSantriNavId._(_root);
	@override late final _TranslationsWaliSantriPengaturanScreenId WaliSantriPengaturanScreen = _TranslationsWaliSantriPengaturanScreenId._(_root);
	@override late final _TranslationsDialogsId dialogs = _TranslationsDialogsId._(_root);
	@override late final _TranslationsMasterDataSettingsId masterDataSettings = _TranslationsMasterDataSettingsId._(_root);
}

// Path: app
class _TranslationsAppId implements TranslationsAppEn {
	_TranslationsAppId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyHalaqoh';
	@override String get attendance => 'Absensi';
	@override String get hafalan => 'Hafalan';
	@override String get login => 'Masuk';
	@override String get logout => 'Keluar';
}

// Path: splash
class _TranslationsSplashId implements TranslationsSplashEn {
	_TranslationsSplashId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Halaqoh Management System';
	@override String get version => 'v1.0.0';
}

// Path: auth
class _TranslationsAuthId implements TranslationsAuthEn {
	_TranslationsAuthId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get loginTitle => 'Masuk';
	@override String get loginSubtitle => 'Masuk ke akun anda';
	@override String get usernameLabel => 'NIP / NIS';
	@override String get usernameHint => 'Masukkan NIP/NIS anda';
	@override String get passwordLabel => 'PASSWORD';
	@override String get passwordHint => 'Masukkan password';
	@override String get forgotPassword => 'Lupa Password?';
	@override String get loginButton => 'MASUK';
	@override String get validationEmpty => 'NIP/NIS dan Password tidak boleh kosong';
	@override String get validationInvalid => 'Username atau password tidak valid. Gunakan admin/admin, NIP (13 digit), atau NIS (12 digit).';
}

// Path: dashboard
class _TranslationsDashboardId implements TranslationsDashboardEn {
	_TranslationsDashboardId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'Selamat Datang,';
	@override String get admin => 'Admin';
	@override String get totalSantri => 'Total Santri';
	@override String get totalGuru => 'Total Guru';
	@override String get totalHalaqoh => 'Total Halaqoh';
	@override String get menuUtama => 'Menu Utama';
	@override String get kelolaSantri => 'Kelola data Santri';
	@override String get kelolaGuru => 'Kelola data Guru';
	@override String get kelolaHalaqoh => 'Kelola Halaqoh';
	@override String get kelolaTarget => 'Kelola Target';
	@override String get santriCount => '261 Santri';
	@override String get guruCount => '28 Guru';
	@override String get halaqohCount => '20 Halaqoh';
	@override String get perKelas => 'Per Kelas';
}

// Path: santri
class _TranslationsSantriId implements TranslationsSantriEn {
	_TranslationsSantriId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Data Santri';
	@override String get searchHint => 'Cari Santri';
	@override String showCount({required Object count}) => 'Menampilkan ${count} Santri';
	@override String get identitas => 'IDENTITAS';
	@override String get kelas => 'KELAS';
	@override String get aksi => 'AKSI';
	@override String get filter => 'Filter';
}

// Path: guru
class _TranslationsGuruId implements TranslationsGuruEn {
	_TranslationsGuruId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Data Guru';
	@override String get searchHint => 'Cari Guru';
	@override String showCount({required Object count}) => 'Menampilkan ${count} Guru';
	@override String get identitas => 'IDENTITAS';
	@override String get aksi => 'AKSI';
	@override String get filter => 'Filter';
}

// Path: halaqoh
class _TranslationsHalaqohId implements TranslationsHalaqohEn {
	_TranslationsHalaqohId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Data Halaqoh';
	@override String get searchHint => 'Cari Halaqoh';
	@override String showCount({required Object count}) => 'Menampilkan ${count} Halaqoh';
	@override String get sort => 'Urutkan';
	@override String santriCount({required Object count}) => '${count} Santri';
	@override String kelasLabel({required Object kelas}) => 'Kelas ${kelas}';
}

// Path: targetHafalan
class _TranslationsTargetHafalanId implements TranslationsTargetHafalanEn {
	_TranslationsTargetHafalanId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Target Hafalan';
	@override String get reguler => 'REGULER';
	@override String get takhassus => 'TAKHASSUS';
	@override String get infoText => 'Atur target hafalan untuk setiap kelas, target akan diterapkan untuk seluruh santri pada kelas tersebut.';
	@override String get kelasLabel => 'Kelas';
	@override String targetJuz({required Object count}) => 'Target: ${count} Juz';
	@override String juzRange({required Object range}) => 'Juz ${range}';
	@override String get smp => 'SMP';
}

// Path: editTarget
class _TranslationsEditTargetId implements TranslationsEditTargetEn {
	_TranslationsEditTargetId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edit Target Hafalan';
	@override String get tahunAjaran => 'TAHUN AJARAN';
	@override String get pilihJuz => 'PILIH JUZ';
	@override String get totalTarget => 'TOTAL TARGET';
	@override String totalJuz({required Object count}) => '${count} Juz';
	@override String get simpanPerubahan => 'Simpan Perubahan';
}

// Path: nav
class _TranslationsNavId implements TranslationsNavEn {
	_TranslationsNavId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Dashboard';
	@override String get santri => 'Santri';
	@override String get guru => 'Guru';
	@override String get halaqoh => 'Halaqoh';
	@override String get target => 'Target';
	@override String get pengaturan => 'Pengaturan';
}

// Path: addData
class _TranslationsAddDataId implements TranslationsAddDataEn {
	_TranslationsAddDataId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tambah Data';
	@override String get subtitle => 'Pilih metode input data yang diinginkan';
	@override String get inputManual => 'Input Manual';
	@override String get inputManualDesc => 'Isi form data satu per satu secara detail';
	@override String get uploadExcel => 'Upload File Excel/CSV';
	@override String get uploadExcelDesc => 'Impor banyak data sekaligus dari file';
	@override String get addSantriManual => 'Tambah Santri Manual';
	@override String get addGuruManual => 'Tambah Guru Manual';
	@override String get nis => 'NIS';
	@override String get nisHint => 'Nomor Induk Santri';
	@override String get nip => 'NIP';
	@override String get nipHint => 'Nomor Induk Pengajar';
	@override String get namaLengkap => 'Nama Lengkap';
	@override String get namaSantriHint => 'Nama lengkap siswa';
	@override String get namaGuruHint => 'Nama lengkap guru';
	@override String get kelas => 'Kelas';
	@override String get kelasHint => 'Pilih Kelas';
	@override String get nomorHp => 'Nomor HP';
	@override String get nomorHpHint => 'Contoh: 08123456789';
	@override String get simpan => 'Simpan';
	@override String get bulkTitle => 'Tambah Data Massal';
	@override String get bulkSubtitle => 'Import Data secara otomatis menggunakan file excel.';
	@override String get bulkTapUpload => 'Tap untuk upload file Excel';
	@override String get bulkFormat => 'Format .xlsx atau .csv (Maks. 5MB)';
	@override String get bulkUploadButton => 'Upload Sekarang';
}

// Path: addHalaqoh
class _TranslationsAddHalaqohId implements TranslationsAddHalaqohEn {
	_TranslationsAddHalaqohId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tambah Halaqoh Baru';
	@override String get namaHalaqoh => 'Nama Halaqoh';
	@override String get namaHalaqohHint => 'Contoh: Halaqoh 7A';
	@override String get kelas => 'Kelas';
	@override String get kelasHint => 'Pilih Kelas';
	@override String get program => 'Program';
	@override String get programHint => 'Pilih Program';
	@override String get pengampu => 'Pengampu (Guru)';
	@override String get pengampuHint => 'Cari nama pengampu...';
	@override String get daftarSantri => 'Daftar Santri';
	@override String get tambahSantri => '+ Tambah Santri';
	@override String get nis => 'NIS';
	@override String get namaSantri => 'NAMA SANTRI';
	@override String get aksi => 'AKSI';
	@override String totalTerpilih({required Object count}) => 'Total: ${count} Santri terpilih';
	@override String get simpanHalaqoh => 'SIMPAN HALAQOH';
}

// Path: selectSantri
class _TranslationsSelectSantriId implements TranslationsSelectSantriEn {
	_TranslationsSelectSantriId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pilih Santri';
	@override String get searchHint => 'Cari nama atau NIS santri...';
	@override String get filter => 'FILTER';
	@override String countLabel({required Object count}) => '${count} Santri';
	@override String get nis => 'NIS';
	@override String get nama => 'NAMA';
	@override String get kelas => 'KELAS';
	@override String tambahkanButton({required Object count}) => 'TAMBAHKAN (${count}) SANTRI';
}

// Path: guruDashboard
class _TranslationsGuruDashboardId implements TranslationsGuruDashboardEn {
	_TranslationsGuruDashboardId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'AHLAN WA SAHLAN';
	@override String get subtitle => 'Awali Halaqoh Dengan Doa Bersama Agar Selalu Diberkahi';
	@override String get capaianHariIni => 'Capaian hari ini';
	@override String get kehadiranHariIni => 'Kehadiran Hari ini';
	@override String get setoranHafalan => 'Setoran Hafalan';
	@override String santriCount({required Object current, required Object total}) => '${current}/${total} Santri';
	@override String get menuUtama => 'Menu Utama';
	@override String get myHalaqoh => 'Halaqoh';
	@override String get scanAbsensi => 'Scan Absensi';
	@override String get inputHafalan => 'Input Hafalan';
	@override String get laporan => 'Laporan';
	@override String get setoranTerakhir => 'Setoran Terakhir';
}

// Path: guruNav
class _TranslationsGuruNavId implements TranslationsGuruNavEn {
	_TranslationsGuruNavId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get myHalaqoh => 'Halaqoh';
	@override String get absensi => 'Absensi';
	@override String get hafalan => 'Hafalan';
	@override String get profile => 'Profile';
}

// Path: myHalaqohScreen
class _TranslationsMyHalaqohScreenId implements TranslationsMyHalaqohScreenEn {
	_TranslationsMyHalaqohScreenId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'My Halaqoh';
	@override String get searchHint => 'Cari nama atau NIS santri...';
	@override String get daftarSantri => 'Daftar Santri';
	@override String santriCount({required Object count}) => '${count} Santri';
	@override String kelas({required Object kelas}) => 'Kelas ${kelas}';
	@override String program({required Object program}) => 'Program: ${program}';
	@override String target({required Object count, required Object range}) => 'Target: ${count} Juz (${range})';
	@override String total({required Object count}) => 'Total: ${count} Santri';
	@override String get pengampu => 'Ustadz Kayyis';
	@override String progressText({required Object completed, required Object target}) => '${completed} Juz terselesaikan dari ${target} Juz';
}

// Path: detailSantri
class _TranslationsDetailSantriId implements TranslationsDetailSantriEn {
	_TranslationsDetailSantriId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Profil Santri';
	@override String get informasiAkademik => 'INFORMASI AKADEMIK';
	@override String get kelas => 'Kelas';
	@override String get program => 'Program';
	@override String get halaqoh => 'Halaqoh';
	@override String get pembimbing => 'Pembimbing';
	@override String get progressHafalan => 'PROGRESS HAFALAN';
	@override String get totalHafalan => 'Total Hafalan';
	@override String sertifikasiInfo({required Object done, required Object total}) => '${done} dari ${total} Juz Tersertifikasi';
	@override String get sertifikasiJuz => 'Sertifikasi Juz';
}

// Path: absensi
class _TranslationsAbsensiId implements TranslationsAbsensiEn {
	_TranslationsAbsensiId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get mulaiSesi => 'MULAI SESI ABSENSI';
	@override String get searchHint => 'Cari Santri';
	@override String get lihatAbsensiHalaqoh => 'Lihat Absensi Halaqoh';
	@override String get lihatDetailHariIni => 'Lihat Detail Absensi Hari Ini';
	@override String get daftarSantri => 'Daftar Santri';
	@override String santriCount({required Object count}) => '${count} Santri';
	@override String get riwayatAbsensi => 'RIWAYAT ABSENSI';
	@override String get dialogTitle => 'Mulai Sesi Absensi';
	@override String get tanggalHalaqoh => 'TANGGAL HALAQOH';
	@override String get pilihSesi => 'PILIH SESI';
	@override String get shubuh => 'Shubuh';
	@override String get maghrib => 'Maghrib';
	@override String get scanBarcode => 'SCAN BARCODE';
	@override String get scanInstruction => 'Arahkan kamera ke QR Code Santri';
	@override String nama({required Object name}) => 'Nama: ${name}';
	@override String nis({required Object nis}) => 'NIS: ${nis}';
	@override String get statusKehadiran => 'STATUS KEHADIRAN';
	@override String get hadir => 'Hadir';
	@override String get sakit => 'Sakit';
	@override String get izin => 'Izin';
	@override String get alfa => 'Alfa';
	@override String get keterangan => 'Keterangan (opsional)';
	@override String get batal => 'BATAL';
	@override String get simpan => 'SIMPAN';
}

// Path: riwayatAbsensi
class _TranslationsRiwayatAbsensiId implements TranslationsRiwayatAbsensiEn {
	_TranslationsRiwayatAbsensiId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Riwayat Absensi';
	@override String halaqohKelas({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Kelas ${kelas}';
	@override String get hadir => 'HADIR';
	@override String get sakit => 'SAKIT';
	@override String get izin => 'IZIN';
	@override String get alfa => 'ALFA';
	@override String get pagi => 'PAGI';
	@override String get mlm => 'MLM';
	@override String get geserHint => 'Geser untuk melihat semua tanggal';
	@override String get lihatKalender => 'LIHAT KALENDER ABSENSI LENGKAP';
	@override String get keterangan => 'Keterangan';
	@override String get hadirLabel => 'Hadir';
	@override String get sakitLabel => 'Sakit';
	@override String get alphaLabel => 'Alpha';
	@override String get izinLabel => 'Izin';
	@override String get downloadLaporan => 'DOWNLOAD LAPORAN ABSENSI';
}

// Path: kalenderAbsensi
class _TranslationsKalenderAbsensiId implements TranslationsKalenderAbsensiEn {
	_TranslationsKalenderAbsensiId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kalender Absensi';
	@override String nisHalaqoh({required Object nis, required Object halaqoh}) => 'NIS: ${nis}  •  Halaqoh ${halaqoh}';
	@override String get keterangan => 'Keterangan';
	@override String get hadirLabel => 'Hadir';
	@override String get sakitIzinLabel => 'Sakit / Izin';
	@override String get alfaLabel => 'Alfa';
	@override String get belumAbsen => 'Belum Absen';
	@override String get pagiKiri => 'Pagi (Kiri)';
	@override String get malamKanan => 'Malam (Kanan)';
	@override String get aha => 'AHA';
	@override String get sen => 'SEN';
	@override String get sel => 'SEL';
	@override String get rab => 'RAB';
	@override String get kam => 'KAM';
	@override String get jum => 'JUM';
	@override String get sab => 'SAB';
}

// Path: absensiHalaqoh
class _TranslationsAbsensiHalaqohId implements TranslationsAbsensiHalaqohEn {
	_TranslationsAbsensiHalaqohId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Absensi Halaqoh';
	@override String get tglSesi => 'TGL / SESI';
	@override String get santri => 'SANTRI';
	@override String get pagi => 'Pagi';
	@override String get malam => 'Malam';
	@override String get dhuha1 => 'Dhuha 1';
	@override String get dhuha2 => 'Dhuha 2';
	@override String get sore => 'Sore';
	@override String get hadir => 'Hadir';
	@override String get sakit => 'Sakit';
	@override String get izin => 'Izin';
	@override String get alfa => 'Alfa';
	@override String get downloadLaporan => 'DOWNLOAD LAPORAN ABSENSI';
}

// Path: detailAbsensiHariIni
class _TranslationsDetailAbsensiHariIniId implements TranslationsDetailAbsensiHariIniEn {
	_TranslationsDetailAbsensiHariIniId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Detail Absensi Hari Ini';
	@override String get hadir => 'Hadir';
	@override String get sakit => 'Sakit';
	@override String get izin => 'Izin';
	@override String get alfa => 'Alfa';
	@override String get belumAbsen => 'Belum Absen';
	@override String get belumDiabsen => 'Belum absen';
	@override String get daftarKehadiranSantri => 'Daftar Kehadiran Santri';
}

// Path: hafalan
class _TranslationsHafalanId implements TranslationsHafalanEn {
	_TranslationsHafalanId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get cariSantri => 'Cari Santri';
	@override String get daftarSantri => 'Daftar Santri';
	@override String santriCount({required Object count}) => '${count} Santri';
	@override String get riwayatHafalan => 'Riwayat Hafalan';
	@override String get inputHafalan => 'Input Hafalan';
}

// Path: inputHafalanForm
class _TranslationsInputHafalanFormId implements TranslationsInputHafalanFormEn {
	_TranslationsInputHafalanFormId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String nama({required Object name}) => 'Nama: ${name}';
	@override String get ziyadah => 'ZIYADAH';
	@override String get murajaah => 'MURAJAAH';
	@override String get formulirHafalan => 'Formulir Hafalan';
	@override String get pilihSurat => 'Pilih Surat';
	@override String get ayatAwal => 'Ayat Awal';
	@override String get ayatAkhir => 'Ayat Akhir';
	@override String get juz => 'Juz';
	@override String get penilaian => 'Penilaian';
	@override String get kelancaran => 'Kelancaran 1 - 100';
	@override String get tajwid => 'Tajwid 1 - 100';
	@override String get simpan => 'SIMPAN';
	@override String get batal => 'BATAL';
}

// Path: riwayatHafalanSantri
class _TranslationsRiwayatHafalanSantriId implements TranslationsRiwayatHafalanSantriEn {
	_TranslationsRiwayatHafalanSantriId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Riwayat Hafalan';
	@override String halaqohKelas({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Kelas ${kelas}';
	@override String get totalHafalanBaru => 'Total Hafalan Baru';
	@override String get totalMurajaah => 'Total Muraja\'ah';
	@override String get semuaTipe => 'Semua Tipe';
	@override String get bukaMutabaah => 'BUKA MUTABA\'AH';
	@override String get hafalanBaru => 'Hafalan Baru';
	@override String get murajaah => 'Muraja\'ah';
	@override String get lihatProgress => 'LIHAT PROGRESS HAFALAN PER SURAT';
	@override String get downloadLaporan => 'DOWNLOAD LAPORAN HAFALAN';
}

// Path: progressHafalanPerJuz
class _TranslationsProgressHafalanPerJuzId implements TranslationsProgressHafalanPerJuzEn {
	_TranslationsProgressHafalanPerJuzId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Progress Hafalan';
	@override String get targetHafalan => 'Target Hafalan';
	@override String get pilihJuz => 'Pilih Juz untuk melihat detail progress per surat';
	@override String suratSelesai({required Object completed, required Object total}) => '${completed} dari ${total} Surat Selesai';
}

// Path: progressHafalanPerSurat
class _TranslationsProgressHafalanPerSuratId implements TranslationsProgressHafalanPerSuratEn {
	_TranslationsProgressHafalanPerSuratId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Progress Per Surat';
	@override String detailJuz({required Object juz}) => 'Detail Hafalan Juz ${juz}';
	@override String ayatDari({required Object memorized, required Object total}) => 'Ayat ${memorized} dari ${total}';
	@override String get selesai => 'Selesai';
	@override String get dalamProses => 'Dalam Proses';
	@override String get belumDimulai => 'Belum Dimulai';
}

// Path: mutabaahSantri
class _TranslationsMutabaahSantriId implements TranslationsMutabaahSantriEn {
	_TranslationsMutabaahSantriId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mutaba\'ah Santri';
	@override String get hafalanBaru => 'Hafalan Baru';
	@override String get murajaah => 'Muraja\'ah';
	@override String get hari => 'HARI';
	@override String get tgl => 'TGL';
	@override String get surat => 'SURAT';
	@override String get ayat => 'AYAT';
	@override String get nilai => 'NILAI';
}

// Path: guruProfile
class _TranslationsGuruProfileId implements TranslationsGuruProfileEn {
	_TranslationsGuruProfileId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get editProfile => 'Edit Profile';
	@override String get ubahPassword => 'Ubah Password';
	@override String get pengaturan => 'Pengaturan';
	@override String get tentangAplikasi => 'Tentang Aplikasi';
	@override String get keluar => 'Keluar';
	@override String get guruHalaqoh => 'Guru Halaqoh';
	@override String appVersion({required Object version}) => 'MyHalaqoh App v${version}';
}

// Path: editProfile
class _TranslationsEditProfileId implements TranslationsEditProfileEn {
	_TranslationsEditProfileId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edit Profile';
	@override String get editFotoProfil => 'Edit Foto Profil';
	@override String get informasiPribadi => 'INFORMASI PRIBADI';
	@override String get namaLengkap => 'Nama Lengkap';
	@override String get nip => 'NIP';
	@override String get jabatan => 'Jabatan';
	@override String get kontak => 'KONTAK';
	@override String get nomorHp => 'Nomor HP';
	@override String get email => 'Email';
	@override String get simpanPerubahan => 'Simpan Perubahan';
}

// Path: ubahPassword
class _TranslationsUbahPasswordId implements TranslationsUbahPasswordEn {
	_TranslationsUbahPasswordId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ubah Password';
	@override String get subtitle => 'Silakan masukkan kata sandi baru Anda untuk meningkatkan keamanan akun.';
	@override String get kataSandiLama => 'Kata Sandi Lama';
	@override String get kataSandiBaru => 'Kata Sandi Baru';
	@override String get konfirmasiKataSandiBaru => 'Konfirmasi Kata Sandi Baru';
	@override String get syaratKeamanan => 'SYARAT KEAMANAN';
	@override String get minimal8Karakter => 'Minimal 8 karakter';
	@override String get kombinasiHurufDanAngka => 'Kombinasi huruf dan angka';
	@override String get ubahKataSandi => 'Ubah Kata Sandi';
}

// Path: pengaturanScreen
class _TranslationsPengaturanScreenId implements TranslationsPengaturanScreenEn {
	_TranslationsPengaturanScreenId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan';
	@override String get bahasa => 'Bahasa';
	@override String get bahasaIndonesia => 'Bahasa Indonesia';
	@override String get english => 'English';
	@override String get pilihBahasa => 'Pilih Bahasa';
	@override String get tema => 'Tema';
	@override String get terangLight => 'Terang / Light';
	@override String get gelapDark => 'Gelap / Dark';
	@override String get pilihTema => 'Pilih Tema';
}

// Path: waliSantriDashboard
class _TranslationsWaliSantriDashboardId implements TranslationsWaliSantriDashboardEn {
	_TranslationsWaliSantriDashboardId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get progressHafalan => 'Progress Hafalan';
	@override String get juzTerselesaikan => 'Juz Terselesaikan';
	@override String target({required Object target}) => 'Target : ${target} Juz';
	@override String get kehadiran => 'Kehadiran';
	@override String periode({required Object periode}) => 'Periode: ${periode}';
	@override String get hadir => 'Hadir';
	@override String get sakit => 'Sakit';
	@override String get izin => 'Izin';
	@override String get alpha => 'Alpha';
}

// Path: waliSantriNav
class _TranslationsWaliSantriNavId implements TranslationsWaliSantriNavEn {
	_TranslationsWaliSantriNavId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get hafalan => 'Hafalan';
	@override String get absensi => 'Absensi';
	@override String get profile => 'Profile';
}

// Path: WaliSantriPengaturanScreen
class _TranslationsWaliSantriPengaturanScreenId implements TranslationsWaliSantriPengaturanScreenEn {
	_TranslationsWaliSantriPengaturanScreenId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan';
	@override String get bahasa => 'Bahasa';
	@override String get bahasaIndonesia => 'Bahasa Indonesia';
	@override String get english => 'English';
	@override String get pilihBahasa => 'Pilih Bahasa';
	@override String get tema => 'Tema';
	@override String get terangLight => 'Terang / Light';
	@override String get gelapDark => 'Gelap / Dark';
	@override String get pilihTema => 'Pilih Tema';
}

// Path: dialogs
class _TranslationsDialogsId implements TranslationsDialogsEn {
	_TranslationsDialogsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get deleteTitle => 'Hapus Data?';
	@override String get deleteMessage => 'Apakah Anda yakin ingin menghapus data ini? Tindakan ini tidak dapat dibatalkan dan akan hilang secara permanen.';
	@override String get saveTitle => 'Simpan Perubahan?';
	@override String get saveMessage => 'Pastikan semua data yang Anda masukkan sudah benar sebelum menyimpan.';
	@override String get batal => 'Batal';
	@override String get hapus => 'Hapus';
	@override String get simpan => 'Simpan';
	@override String get logoutTitle => 'Keluar Akun?';
	@override String get logoutMessage => 'Apakah Anda yakin ingin keluar dari akun ini? Anda harus masuk kembali untuk menggunakan aplikasi.';
	@override String get keluar => 'Keluar';
}

// Path: masterDataSettings
class _TranslationsMasterDataSettingsId implements TranslationsMasterDataSettingsEn {
	_TranslationsMasterDataSettingsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan';
	@override String get tentangAplikasi => 'Tentang Aplikasi';
	@override String get keluar => 'Keluar';
	@override String get appVersion => 'Versi {version}';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsId {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return 'MyHalaqoh';
			case 'app.attendance': return 'Absensi';
			case 'app.hafalan': return 'Hafalan';
			case 'app.login': return 'Masuk';
			case 'app.logout': return 'Keluar';
			case 'splash.subtitle': return 'Halaqoh Management System';
			case 'splash.version': return 'v1.0.0';
			case 'auth.loginTitle': return 'Masuk';
			case 'auth.loginSubtitle': return 'Masuk ke akun anda';
			case 'auth.usernameLabel': return 'NIP / NIS';
			case 'auth.usernameHint': return 'Masukkan NIP/NIS anda';
			case 'auth.passwordLabel': return 'PASSWORD';
			case 'auth.passwordHint': return 'Masukkan password';
			case 'auth.forgotPassword': return 'Lupa Password?';
			case 'auth.loginButton': return 'MASUK';
			case 'auth.validationEmpty': return 'NIP/NIS dan Password tidak boleh kosong';
			case 'auth.validationInvalid': return 'Username atau password tidak valid. Gunakan admin/admin, NIP (13 digit), atau NIS (12 digit).';
			case 'dashboard.greeting': return 'Selamat Datang,';
			case 'dashboard.admin': return 'Admin';
			case 'dashboard.totalSantri': return 'Total Santri';
			case 'dashboard.totalGuru': return 'Total Guru';
			case 'dashboard.totalHalaqoh': return 'Total Halaqoh';
			case 'dashboard.menuUtama': return 'Menu Utama';
			case 'dashboard.kelolaSantri': return 'Kelola data Santri';
			case 'dashboard.kelolaGuru': return 'Kelola data Guru';
			case 'dashboard.kelolaHalaqoh': return 'Kelola Halaqoh';
			case 'dashboard.kelolaTarget': return 'Kelola Target';
			case 'dashboard.santriCount': return '261 Santri';
			case 'dashboard.guruCount': return '28 Guru';
			case 'dashboard.halaqohCount': return '20 Halaqoh';
			case 'dashboard.perKelas': return 'Per Kelas';
			case 'santri.title': return 'Data Santri';
			case 'santri.searchHint': return 'Cari Santri';
			case 'santri.showCount': return ({required Object count}) => 'Menampilkan ${count} Santri';
			case 'santri.identitas': return 'IDENTITAS';
			case 'santri.kelas': return 'KELAS';
			case 'santri.aksi': return 'AKSI';
			case 'santri.filter': return 'Filter';
			case 'guru.title': return 'Data Guru';
			case 'guru.searchHint': return 'Cari Guru';
			case 'guru.showCount': return ({required Object count}) => 'Menampilkan ${count} Guru';
			case 'guru.identitas': return 'IDENTITAS';
			case 'guru.aksi': return 'AKSI';
			case 'guru.filter': return 'Filter';
			case 'halaqoh.title': return 'Data Halaqoh';
			case 'halaqoh.searchHint': return 'Cari Halaqoh';
			case 'halaqoh.showCount': return ({required Object count}) => 'Menampilkan ${count} Halaqoh';
			case 'halaqoh.sort': return 'Urutkan';
			case 'halaqoh.santriCount': return ({required Object count}) => '${count} Santri';
			case 'halaqoh.kelasLabel': return ({required Object kelas}) => 'Kelas ${kelas}';
			case 'targetHafalan.title': return 'Target Hafalan';
			case 'targetHafalan.reguler': return 'REGULER';
			case 'targetHafalan.takhassus': return 'TAKHASSUS';
			case 'targetHafalan.infoText': return 'Atur target hafalan untuk setiap kelas, target akan diterapkan untuk seluruh santri pada kelas tersebut.';
			case 'targetHafalan.kelasLabel': return 'Kelas';
			case 'targetHafalan.targetJuz': return ({required Object count}) => 'Target: ${count} Juz';
			case 'targetHafalan.juzRange': return ({required Object range}) => 'Juz ${range}';
			case 'targetHafalan.smp': return 'SMP';
			case 'editTarget.title': return 'Edit Target Hafalan';
			case 'editTarget.tahunAjaran': return 'TAHUN AJARAN';
			case 'editTarget.pilihJuz': return 'PILIH JUZ';
			case 'editTarget.totalTarget': return 'TOTAL TARGET';
			case 'editTarget.totalJuz': return ({required Object count}) => '${count} Juz';
			case 'editTarget.simpanPerubahan': return 'Simpan Perubahan';
			case 'nav.dashboard': return 'Dashboard';
			case 'nav.santri': return 'Santri';
			case 'nav.guru': return 'Guru';
			case 'nav.halaqoh': return 'Halaqoh';
			case 'nav.target': return 'Target';
			case 'nav.pengaturan': return 'Pengaturan';
			case 'addData.title': return 'Tambah Data';
			case 'addData.subtitle': return 'Pilih metode input data yang diinginkan';
			case 'addData.inputManual': return 'Input Manual';
			case 'addData.inputManualDesc': return 'Isi form data satu per satu secara detail';
			case 'addData.uploadExcel': return 'Upload File Excel/CSV';
			case 'addData.uploadExcelDesc': return 'Impor banyak data sekaligus dari file';
			case 'addData.addSantriManual': return 'Tambah Santri Manual';
			case 'addData.addGuruManual': return 'Tambah Guru Manual';
			case 'addData.nis': return 'NIS';
			case 'addData.nisHint': return 'Nomor Induk Santri';
			case 'addData.nip': return 'NIP';
			case 'addData.nipHint': return 'Nomor Induk Pengajar';
			case 'addData.namaLengkap': return 'Nama Lengkap';
			case 'addData.namaSantriHint': return 'Nama lengkap siswa';
			case 'addData.namaGuruHint': return 'Nama lengkap guru';
			case 'addData.kelas': return 'Kelas';
			case 'addData.kelasHint': return 'Pilih Kelas';
			case 'addData.nomorHp': return 'Nomor HP';
			case 'addData.nomorHpHint': return 'Contoh: 08123456789';
			case 'addData.simpan': return 'Simpan';
			case 'addData.bulkTitle': return 'Tambah Data Massal';
			case 'addData.bulkSubtitle': return 'Import Data secara otomatis menggunakan file excel.';
			case 'addData.bulkTapUpload': return 'Tap untuk upload file Excel';
			case 'addData.bulkFormat': return 'Format .xlsx atau .csv (Maks. 5MB)';
			case 'addData.bulkUploadButton': return 'Upload Sekarang';
			case 'addHalaqoh.title': return 'Tambah Halaqoh Baru';
			case 'addHalaqoh.namaHalaqoh': return 'Nama Halaqoh';
			case 'addHalaqoh.namaHalaqohHint': return 'Contoh: Halaqoh 7A';
			case 'addHalaqoh.kelas': return 'Kelas';
			case 'addHalaqoh.kelasHint': return 'Pilih Kelas';
			case 'addHalaqoh.program': return 'Program';
			case 'addHalaqoh.programHint': return 'Pilih Program';
			case 'addHalaqoh.pengampu': return 'Pengampu (Guru)';
			case 'addHalaqoh.pengampuHint': return 'Cari nama pengampu...';
			case 'addHalaqoh.daftarSantri': return 'Daftar Santri';
			case 'addHalaqoh.tambahSantri': return '+ Tambah Santri';
			case 'addHalaqoh.nis': return 'NIS';
			case 'addHalaqoh.namaSantri': return 'NAMA SANTRI';
			case 'addHalaqoh.aksi': return 'AKSI';
			case 'addHalaqoh.totalTerpilih': return ({required Object count}) => 'Total: ${count} Santri terpilih';
			case 'addHalaqoh.simpanHalaqoh': return 'SIMPAN HALAQOH';
			case 'selectSantri.title': return 'Pilih Santri';
			case 'selectSantri.searchHint': return 'Cari nama atau NIS santri...';
			case 'selectSantri.filter': return 'FILTER';
			case 'selectSantri.countLabel': return ({required Object count}) => '${count} Santri';
			case 'selectSantri.nis': return 'NIS';
			case 'selectSantri.nama': return 'NAMA';
			case 'selectSantri.kelas': return 'KELAS';
			case 'selectSantri.tambahkanButton': return ({required Object count}) => 'TAMBAHKAN (${count}) SANTRI';
			case 'guruDashboard.greeting': return 'AHLAN WA SAHLAN';
			case 'guruDashboard.subtitle': return 'Awali Halaqoh Dengan Doa Bersama Agar Selalu Diberkahi';
			case 'guruDashboard.capaianHariIni': return 'Capaian hari ini';
			case 'guruDashboard.kehadiranHariIni': return 'Kehadiran Hari ini';
			case 'guruDashboard.setoranHafalan': return 'Setoran Hafalan';
			case 'guruDashboard.santriCount': return ({required Object current, required Object total}) => '${current}/${total} Santri';
			case 'guruDashboard.menuUtama': return 'Menu Utama';
			case 'guruDashboard.myHalaqoh': return 'Halaqoh';
			case 'guruDashboard.scanAbsensi': return 'Scan Absensi';
			case 'guruDashboard.inputHafalan': return 'Input Hafalan';
			case 'guruDashboard.laporan': return 'Laporan';
			case 'guruDashboard.setoranTerakhir': return 'Setoran Terakhir';
			case 'guruNav.home': return 'Home';
			case 'guruNav.myHalaqoh': return 'Halaqoh';
			case 'guruNav.absensi': return 'Absensi';
			case 'guruNav.hafalan': return 'Hafalan';
			case 'guruNav.profile': return 'Profile';
			case 'myHalaqohScreen.title': return 'My Halaqoh';
			case 'myHalaqohScreen.searchHint': return 'Cari nama atau NIS santri...';
			case 'myHalaqohScreen.daftarSantri': return 'Daftar Santri';
			case 'myHalaqohScreen.santriCount': return ({required Object count}) => '${count} Santri';
			case 'myHalaqohScreen.kelas': return ({required Object kelas}) => 'Kelas ${kelas}';
			case 'myHalaqohScreen.program': return ({required Object program}) => 'Program: ${program}';
			case 'myHalaqohScreen.target': return ({required Object count, required Object range}) => 'Target: ${count} Juz (${range})';
			case 'myHalaqohScreen.total': return ({required Object count}) => 'Total: ${count} Santri';
			case 'myHalaqohScreen.pengampu': return 'Ustadz Kayyis';
			case 'myHalaqohScreen.progressText': return ({required Object completed, required Object target}) => '${completed} Juz terselesaikan dari ${target} Juz';
			case 'detailSantri.title': return 'Profil Santri';
			case 'detailSantri.informasiAkademik': return 'INFORMASI AKADEMIK';
			case 'detailSantri.kelas': return 'Kelas';
			case 'detailSantri.program': return 'Program';
			case 'detailSantri.halaqoh': return 'Halaqoh';
			case 'detailSantri.pembimbing': return 'Pembimbing';
			case 'detailSantri.progressHafalan': return 'PROGRESS HAFALAN';
			case 'detailSantri.totalHafalan': return 'Total Hafalan';
			case 'detailSantri.sertifikasiInfo': return ({required Object done, required Object total}) => '${done} dari ${total} Juz Tersertifikasi';
			case 'detailSantri.sertifikasiJuz': return 'Sertifikasi Juz';
			case 'absensi.mulaiSesi': return 'MULAI SESI ABSENSI';
			case 'absensi.searchHint': return 'Cari Santri';
			case 'absensi.lihatAbsensiHalaqoh': return 'Lihat Absensi Halaqoh';
			case 'absensi.lihatDetailHariIni': return 'Lihat Detail Absensi Hari Ini';
			case 'absensi.daftarSantri': return 'Daftar Santri';
			case 'absensi.santriCount': return ({required Object count}) => '${count} Santri';
			case 'absensi.riwayatAbsensi': return 'RIWAYAT ABSENSI';
			case 'absensi.dialogTitle': return 'Mulai Sesi Absensi';
			case 'absensi.tanggalHalaqoh': return 'TANGGAL HALAQOH';
			case 'absensi.pilihSesi': return 'PILIH SESI';
			case 'absensi.shubuh': return 'Shubuh';
			case 'absensi.maghrib': return 'Maghrib';
			case 'absensi.scanBarcode': return 'SCAN BARCODE';
			case 'absensi.scanInstruction': return 'Arahkan kamera ke QR Code Santri';
			case 'absensi.nama': return ({required Object name}) => 'Nama: ${name}';
			case 'absensi.nis': return ({required Object nis}) => 'NIS: ${nis}';
			case 'absensi.statusKehadiran': return 'STATUS KEHADIRAN';
			case 'absensi.hadir': return 'Hadir';
			case 'absensi.sakit': return 'Sakit';
			case 'absensi.izin': return 'Izin';
			case 'absensi.alfa': return 'Alfa';
			case 'absensi.keterangan': return 'Keterangan (opsional)';
			case 'absensi.batal': return 'BATAL';
			case 'absensi.simpan': return 'SIMPAN';
			case 'riwayatAbsensi.title': return 'Riwayat Absensi';
			case 'riwayatAbsensi.halaqohKelas': return ({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Kelas ${kelas}';
			case 'riwayatAbsensi.hadir': return 'HADIR';
			case 'riwayatAbsensi.sakit': return 'SAKIT';
			case 'riwayatAbsensi.izin': return 'IZIN';
			case 'riwayatAbsensi.alfa': return 'ALFA';
			case 'riwayatAbsensi.pagi': return 'PAGI';
			case 'riwayatAbsensi.mlm': return 'MLM';
			case 'riwayatAbsensi.geserHint': return 'Geser untuk melihat semua tanggal';
			case 'riwayatAbsensi.lihatKalender': return 'LIHAT KALENDER ABSENSI LENGKAP';
			case 'riwayatAbsensi.keterangan': return 'Keterangan';
			case 'riwayatAbsensi.hadirLabel': return 'Hadir';
			case 'riwayatAbsensi.sakitLabel': return 'Sakit';
			case 'riwayatAbsensi.alphaLabel': return 'Alpha';
			case 'riwayatAbsensi.izinLabel': return 'Izin';
			case 'riwayatAbsensi.downloadLaporan': return 'DOWNLOAD LAPORAN ABSENSI';
			case 'kalenderAbsensi.title': return 'Kalender Absensi';
			case 'kalenderAbsensi.nisHalaqoh': return ({required Object nis, required Object halaqoh}) => 'NIS: ${nis}  •  Halaqoh ${halaqoh}';
			case 'kalenderAbsensi.keterangan': return 'Keterangan';
			case 'kalenderAbsensi.hadirLabel': return 'Hadir';
			case 'kalenderAbsensi.sakitIzinLabel': return 'Sakit / Izin';
			case 'kalenderAbsensi.alfaLabel': return 'Alfa';
			case 'kalenderAbsensi.belumAbsen': return 'Belum Absen';
			case 'kalenderAbsensi.pagiKiri': return 'Pagi (Kiri)';
			case 'kalenderAbsensi.malamKanan': return 'Malam (Kanan)';
			case 'kalenderAbsensi.aha': return 'AHA';
			case 'kalenderAbsensi.sen': return 'SEN';
			case 'kalenderAbsensi.sel': return 'SEL';
			case 'kalenderAbsensi.rab': return 'RAB';
			case 'kalenderAbsensi.kam': return 'KAM';
			case 'kalenderAbsensi.jum': return 'JUM';
			case 'kalenderAbsensi.sab': return 'SAB';
			case 'absensiHalaqoh.title': return 'Absensi Halaqoh';
			case 'absensiHalaqoh.tglSesi': return 'TGL / SESI';
			case 'absensiHalaqoh.santri': return 'SANTRI';
			case 'absensiHalaqoh.pagi': return 'Pagi';
			case 'absensiHalaqoh.malam': return 'Malam';
			case 'absensiHalaqoh.dhuha1': return 'Dhuha 1';
			case 'absensiHalaqoh.dhuha2': return 'Dhuha 2';
			case 'absensiHalaqoh.sore': return 'Sore';
			case 'absensiHalaqoh.hadir': return 'Hadir';
			case 'absensiHalaqoh.sakit': return 'Sakit';
			case 'absensiHalaqoh.izin': return 'Izin';
			case 'absensiHalaqoh.alfa': return 'Alfa';
			case 'absensiHalaqoh.downloadLaporan': return 'DOWNLOAD LAPORAN ABSENSI';
			case 'detailAbsensiHariIni.title': return 'Detail Absensi Hari Ini';
			case 'detailAbsensiHariIni.hadir': return 'Hadir';
			case 'detailAbsensiHariIni.sakit': return 'Sakit';
			case 'detailAbsensiHariIni.izin': return 'Izin';
			case 'detailAbsensiHariIni.alfa': return 'Alfa';
			case 'detailAbsensiHariIni.belumAbsen': return 'Belum Absen';
			case 'detailAbsensiHariIni.belumDiabsen': return 'Belum absen';
			case 'detailAbsensiHariIni.daftarKehadiranSantri': return 'Daftar Kehadiran Santri';
			case 'hafalan.cariSantri': return 'Cari Santri';
			case 'hafalan.daftarSantri': return 'Daftar Santri';
			case 'hafalan.santriCount': return ({required Object count}) => '${count} Santri';
			case 'hafalan.riwayatHafalan': return 'Riwayat Hafalan';
			case 'hafalan.inputHafalan': return 'Input Hafalan';
			case 'inputHafalanForm.nama': return ({required Object name}) => 'Nama: ${name}';
			case 'inputHafalanForm.ziyadah': return 'ZIYADAH';
			case 'inputHafalanForm.murajaah': return 'MURAJAAH';
			case 'inputHafalanForm.formulirHafalan': return 'Formulir Hafalan';
			case 'inputHafalanForm.pilihSurat': return 'Pilih Surat';
			case 'inputHafalanForm.ayatAwal': return 'Ayat Awal';
			case 'inputHafalanForm.ayatAkhir': return 'Ayat Akhir';
			case 'inputHafalanForm.juz': return 'Juz';
			case 'inputHafalanForm.penilaian': return 'Penilaian';
			case 'inputHafalanForm.kelancaran': return 'Kelancaran 1 - 100';
			case 'inputHafalanForm.tajwid': return 'Tajwid 1 - 100';
			case 'inputHafalanForm.simpan': return 'SIMPAN';
			case 'inputHafalanForm.batal': return 'BATAL';
			case 'riwayatHafalanSantri.title': return 'Riwayat Hafalan';
			case 'riwayatHafalanSantri.halaqohKelas': return ({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Kelas ${kelas}';
			case 'riwayatHafalanSantri.totalHafalanBaru': return 'Total Hafalan Baru';
			case 'riwayatHafalanSantri.totalMurajaah': return 'Total Muraja\'ah';
			case 'riwayatHafalanSantri.semuaTipe': return 'Semua Tipe';
			case 'riwayatHafalanSantri.bukaMutabaah': return 'BUKA MUTABA\'AH';
			case 'riwayatHafalanSantri.hafalanBaru': return 'Hafalan Baru';
			case 'riwayatHafalanSantri.murajaah': return 'Muraja\'ah';
			case 'riwayatHafalanSantri.lihatProgress': return 'LIHAT PROGRESS HAFALAN PER SURAT';
			case 'riwayatHafalanSantri.downloadLaporan': return 'DOWNLOAD LAPORAN HAFALAN';
			case 'progressHafalanPerJuz.title': return 'Progress Hafalan';
			case 'progressHafalanPerJuz.targetHafalan': return 'Target Hafalan';
			case 'progressHafalanPerJuz.pilihJuz': return 'Pilih Juz untuk melihat detail progress per surat';
			case 'progressHafalanPerJuz.suratSelesai': return ({required Object completed, required Object total}) => '${completed} dari ${total} Surat Selesai';
			case 'progressHafalanPerSurat.title': return 'Progress Per Surat';
			case 'progressHafalanPerSurat.detailJuz': return ({required Object juz}) => 'Detail Hafalan Juz ${juz}';
			case 'progressHafalanPerSurat.ayatDari': return ({required Object memorized, required Object total}) => 'Ayat ${memorized} dari ${total}';
			case 'progressHafalanPerSurat.selesai': return 'Selesai';
			case 'progressHafalanPerSurat.dalamProses': return 'Dalam Proses';
			case 'progressHafalanPerSurat.belumDimulai': return 'Belum Dimulai';
			case 'mutabaahSantri.title': return 'Mutaba\'ah Santri';
			case 'mutabaahSantri.hafalanBaru': return 'Hafalan Baru';
			case 'mutabaahSantri.murajaah': return 'Muraja\'ah';
			case 'mutabaahSantri.hari': return 'HARI';
			case 'mutabaahSantri.tgl': return 'TGL';
			case 'mutabaahSantri.surat': return 'SURAT';
			case 'mutabaahSantri.ayat': return 'AYAT';
			case 'mutabaahSantri.nilai': return 'NILAI';
			case 'guruProfile.editProfile': return 'Edit Profile';
			case 'guruProfile.ubahPassword': return 'Ubah Password';
			case 'guruProfile.pengaturan': return 'Pengaturan';
			case 'guruProfile.tentangAplikasi': return 'Tentang Aplikasi';
			case 'guruProfile.keluar': return 'Keluar';
			case 'guruProfile.guruHalaqoh': return 'Guru Halaqoh';
			case 'guruProfile.appVersion': return ({required Object version}) => 'MyHalaqoh App v${version}';
			case 'editProfile.title': return 'Edit Profile';
			case 'editProfile.editFotoProfil': return 'Edit Foto Profil';
			case 'editProfile.informasiPribadi': return 'INFORMASI PRIBADI';
			case 'editProfile.namaLengkap': return 'Nama Lengkap';
			case 'editProfile.nip': return 'NIP';
			case 'editProfile.jabatan': return 'Jabatan';
			case 'editProfile.kontak': return 'KONTAK';
			case 'editProfile.nomorHp': return 'Nomor HP';
			case 'editProfile.email': return 'Email';
			case 'editProfile.simpanPerubahan': return 'Simpan Perubahan';
			case 'ubahPassword.title': return 'Ubah Password';
			case 'ubahPassword.subtitle': return 'Silakan masukkan kata sandi baru Anda untuk meningkatkan keamanan akun.';
			case 'ubahPassword.kataSandiLama': return 'Kata Sandi Lama';
			case 'ubahPassword.kataSandiBaru': return 'Kata Sandi Baru';
			case 'ubahPassword.konfirmasiKataSandiBaru': return 'Konfirmasi Kata Sandi Baru';
			case 'ubahPassword.syaratKeamanan': return 'SYARAT KEAMANAN';
			case 'ubahPassword.minimal8Karakter': return 'Minimal 8 karakter';
			case 'ubahPassword.kombinasiHurufDanAngka': return 'Kombinasi huruf dan angka';
			case 'ubahPassword.ubahKataSandi': return 'Ubah Kata Sandi';
			case 'pengaturanScreen.title': return 'Pengaturan';
			case 'pengaturanScreen.bahasa': return 'Bahasa';
			case 'pengaturanScreen.bahasaIndonesia': return 'Bahasa Indonesia';
			case 'pengaturanScreen.english': return 'English';
			case 'pengaturanScreen.pilihBahasa': return 'Pilih Bahasa';
			case 'pengaturanScreen.tema': return 'Tema';
			case 'pengaturanScreen.terangLight': return 'Terang / Light';
			case 'pengaturanScreen.gelapDark': return 'Gelap / Dark';
			case 'pengaturanScreen.pilihTema': return 'Pilih Tema';
			case 'waliSantriDashboard.progressHafalan': return 'Progress Hafalan';
			case 'waliSantriDashboard.juzTerselesaikan': return 'Juz Terselesaikan';
			case 'waliSantriDashboard.target': return ({required Object target}) => 'Target : ${target} Juz';
			case 'waliSantriDashboard.kehadiran': return 'Kehadiran';
			case 'waliSantriDashboard.periode': return ({required Object periode}) => 'Periode: ${periode}';
			case 'waliSantriDashboard.hadir': return 'Hadir';
			case 'waliSantriDashboard.sakit': return 'Sakit';
			case 'waliSantriDashboard.izin': return 'Izin';
			case 'waliSantriDashboard.alpha': return 'Alpha';
			case 'waliSantriNav.home': return 'Home';
			case 'waliSantriNav.hafalan': return 'Hafalan';
			case 'waliSantriNav.absensi': return 'Absensi';
			case 'waliSantriNav.profile': return 'Profile';
			case 'WaliSantriPengaturanScreen.title': return 'Pengaturan';
			case 'WaliSantriPengaturanScreen.bahasa': return 'Bahasa';
			case 'WaliSantriPengaturanScreen.bahasaIndonesia': return 'Bahasa Indonesia';
			case 'WaliSantriPengaturanScreen.english': return 'English';
			case 'WaliSantriPengaturanScreen.pilihBahasa': return 'Pilih Bahasa';
			case 'WaliSantriPengaturanScreen.tema': return 'Tema';
			case 'WaliSantriPengaturanScreen.terangLight': return 'Terang / Light';
			case 'WaliSantriPengaturanScreen.gelapDark': return 'Gelap / Dark';
			case 'WaliSantriPengaturanScreen.pilihTema': return 'Pilih Tema';
			case 'dialogs.deleteTitle': return 'Hapus Data?';
			case 'dialogs.deleteMessage': return 'Apakah Anda yakin ingin menghapus data ini? Tindakan ini tidak dapat dibatalkan dan akan hilang secara permanen.';
			case 'dialogs.saveTitle': return 'Simpan Perubahan?';
			case 'dialogs.saveMessage': return 'Pastikan semua data yang Anda masukkan sudah benar sebelum menyimpan.';
			case 'dialogs.batal': return 'Batal';
			case 'dialogs.hapus': return 'Hapus';
			case 'dialogs.simpan': return 'Simpan';
			case 'dialogs.logoutTitle': return 'Keluar Akun?';
			case 'dialogs.logoutMessage': return 'Apakah Anda yakin ingin keluar dari akun ini? Anda harus masuk kembali untuk menggunakan aplikasi.';
			case 'dialogs.keluar': return 'Keluar';
			case 'masterDataSettings.title': return 'Pengaturan';
			case 'masterDataSettings.tentangAplikasi': return 'Tentang Aplikasi';
			case 'masterDataSettings.keluar': return 'Keluar';
			case 'masterDataSettings.appVersion': return 'Versi {version}';
			default: return null;
		}
	}
}

