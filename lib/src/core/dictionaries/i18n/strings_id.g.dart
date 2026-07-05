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
	@override late final _TranslationsTentangAplikasiScreenId tentangAplikasiScreen = _TranslationsTentangAplikasiScreenId._(_root);
	@override late final _TranslationsGeneralId general = _TranslationsGeneralId._(_root);
	@override late final _TranslationsCalendarId calendar = _TranslationsCalendarId._(_root);
	@override late final _TranslationsLaporanConfigId laporanConfig = _TranslationsLaporanConfigId._(_root);
	@override late final _TranslationsKelasProgramId kelasProgram = _TranslationsKelasProgramId._(_root);
	@override late final _TranslationsSuperAdminId superAdmin = _TranslationsSuperAdminId._(_root);
	@override late final _TranslationsActivityLogId activityLog = _TranslationsActivityLogId._(_root);
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
	@override String santriCountDynamic({required Object count}) => '${count} santri';
	@override String guruCountDynamic({required Object count}) => '${count} guru';
	@override String halaqohCountDynamic({required Object count}) => '${count} halaqoh';
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
	@override String get all => 'Semua';
	@override String get noAccountError => 'Santri ini belum memiliki akun yang terhubung.';
	@override String get resetPasswordTitle => 'Reset Password';
	@override String resetPasswordConfirm({required Object name}) => 'Apakah Anda yakin ingin mereset password untuk ${name}? Password akan dikembalikan ke default "generasi554".';
	@override String get resetPasswordButton => 'Ya, Reset';
	@override String get resetPasswordSuccess => 'Password berhasil direset ke "generasi554".';
	@override String hideAlumniTooltip({required Object count}) => 'Sembunyikan Alumni (${count})';
	@override String showAlumniTooltip({required Object count}) => 'Tampilkan Alumni (${count})';
	@override String get processUpgradeTooltip => 'Proses Kenaikan Kelas';
	@override String get noActiveSantri => 'Tidak ada santri aktif untuk diproses.';
	@override String get upgradeClass => 'Naik Kelas';
	@override String get emptyList => 'Belum ada data santri';
	@override String upgradeClassConfirmMessage({required Object naikCount, required Object alumniCount, required Object tahunAjaran}) => 'Proses ini akan:\n• Menaikkan kelas ${naikCount} santri\n• Mengarsipkan ${alumniCount} santri kelas 12 sebagai alumni\n• Memperbarui target hafalan ke tahun ajaran ${tahunAjaran}\n\nTindakan ini tidak dapat dibatalkan. Lanjutkan?';
	@override String upgradeClassSuccessMessage({required Object naikCount, required Object alumniCount}) => 'Kenaikan kelas berhasil diproses. ${naikCount} santri naik kelas, ${alumniCount} alumni baru.';
	@override String get upgradeClassProcessTitle => 'Proses Kenaikan Kelas';
	@override String get upgradeClassProcessSubtitle => 'Semua santri aktif akan dinaikkan kelasnya';
	@override String get newSchoolYear => 'Tahun Ajaran Baru';
	@override String get upgradeClassWarning => 'Tindakan ini tidak dapat dibatalkan. Pastikan data sudah benar sebelum memproses.';
	@override String get upgradeClassEffectsTitle => 'Yang akan terjadi';
	@override String upgradeClassEffectNaik({required Object count}) => '${count} santri aktif akan naik kelas';
	@override String upgradeClassEffectAlumni({required Object count}) => '${count} santri kelas 12 diarsipkan sebagai alumni';
	@override String get upgradeClassEffectTarget => 'Target hafalan semua kelas diperbarui';
	@override String get upgradeClassEffectDataSafe => 'Data hafalan & halaqoh tidak berubah';
	@override String get upgradeClassEffectAttendanceSafe => 'Riwayat absensi tidak berubah';
	@override String nisExistsError({required Object nis}) => 'Santri dengan NIS ${nis} sudah terdaftar di sistem.';
	@override String get kelasRequired => 'Kelas wajib dipilih';
	@override String get editTitle => 'Edit Data Santri';
	@override String get nisRequired => 'NIS wajib diisi';
	@override String get nameRequired => 'Nama wajib diisi';
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
	@override String get noAccountError => 'Guru ini belum memiliki akun yang terhubung.';
	@override String get resetPasswordTitle => 'Reset Password';
	@override String resetPasswordConfirm({required Object name}) => 'Apakah Anda yakin ingin mereset password untuk ${name}? Password akan dikembalikan ke default "generasi554".';
	@override String get resetPasswordButton => 'Ya, Reset';
	@override String get resetPasswordSuccess => 'Password berhasil direset ke "generasi554".';
	@override String get emptyList => 'Belum ada data guru';
	@override String nipExistsError({required Object nip}) => 'Guru dengan NIP ${nip} sudah terdaftar di sistem.';
	@override String get editTitle => 'Edit Data Guru';
	@override String get nipRequired => 'NIP wajib diisi';
	@override String get nipDigitsError => 'NIP harus 12 atau 13 digit';
	@override String get nameRequired => 'Nama wajib diisi';
	@override String get phoneDigitsError => 'Nomor HP harus 10-13 digit (jika diisi)';
	@override String get programHalaqohLabel => 'Program Halaqoh';
	@override String get chooseProgramHint => 'Pilih Program';
	@override String get programRequired => 'Program wajib dipilih';
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
	@override String get all => 'Semua';
	@override String kelasProgramLabel({required Object kelas, required Object program}) => 'Kelas ${kelas}${program}';
	@override String get emptyList => 'Belum ada data halaqoh';
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
	@override String get infoTextNew => 'Kurikulum hafalan sesuai program pesantren. Semester aktif dapat diatur di sini, sedangkan Tahun Ajaran diperbarui melalui Kenaikan Kelas.';
	@override String get kelasLabel => 'Kelas';
	@override String get smp => 'SMP';
	@override String get semesterAktif => 'Semester Aktif';
	@override String get belumDitetapkan => 'Belum ditetapkan';
	@override String get semester1 => 'Semester 1';
	@override String get semester2 => 'Semester 2';
	@override String get periodeUTS => 'UTS';
	@override String get periodeUAS => 'UAS';
	@override String get tipeIdadTahsin => 'I\'dad Tahsin';
	@override String get tipeDauroh => 'Dauroh';
	@override String get tipeMurajaah => 'Muraja\'ah';
	@override String get tipeUAT => 'UAT (Ujian Akhir Tahfidz)';
	@override String get editPengaturan => 'Edit Pengaturan';
	@override String get sma => 'SMA';
	@override String kelasTitleJenjang({required Object kelas, required Object jenjang}) => 'Kelas ${kelas} ${jenjang}';
	@override String taSemLabel({required Object ta, required Object sem}) => 'TA: ${ta} • Sem: ${sem}';
	@override String semesterNumber({required Object number}) => 'SEMESTER ${number}';
	@override String get tipeZiyadah => 'Ziyadah';
}

// Path: editTarget
class _TranslationsEditTargetId implements TranslationsEditTargetEn {
	_TranslationsEditTargetId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan Target Kelas';
	@override String get tahunAjaran => 'TAHUN AJARAN';
	@override String get semesterAktif => 'SEMESTER AKTIF';
	@override String get pilihSemester => 'Pilih Semester yang Sedang Berjalan';
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
	@override String get uploadExcel => 'Upload File CSV';
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
	@override String get bulkTapUpload => 'Tap untuk upload file CSV';
	@override String get bulkFormat => 'Format .csv (Maks. 5MB)';
	@override String get bulkUploadButton => 'Upload Sekarang';
	@override String get bulkErrorFileRead => 'Gagal membaca file. Coba pilih file lain.';
	@override String bulkFileReady({required Object name}) => 'File siap diproses: ${name}';
	@override String get bulkStatusReading => 'Membaca file...';
	@override String get bulkErrorFileEmpty => 'File kosong atau tidak memiliki baris data!';
	@override String get bulkErrorNoValidRows => 'Tidak ada baris data yang valid untuk diunggah!';
	@override String bulkStatusProcessing({required Object count}) => 'Memproses ${count} baris...';
	@override String bulkStatusSaving({required Object current, required Object total}) => 'Menyimpan ${current} / ${total} ke server...';
	@override String get bulkFinishedTitle => 'Selesai!';
	@override String get bulkSuccess => 'Sukses';
	@override String get bulkFailed => 'Gagal';
	@override String get bulkGuruFailNote => 'Catatan: Data yang gagal disimpan kemungkinan disebabkan oleh Nomor Induk Pegawai (NIP) yang sudah terdaftar di sistem.';
	@override String get bulkSantriFailNote => 'Catatan: Data yang gagal disimpan kemungkinan disebabkan oleh Nomor Induk Siswa (NIS) yang sudah terdaftar di sistem.';
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
	@override String get kelasHint => 'Kelas';
	@override String get program => 'Program';
	@override String get programHint => 'Program';
	@override String get pengampu => 'Pengampu (Guru)';
	@override String get pengampuHint => 'Cari nama pengampu...';
	@override String get daftarSantri => 'Daftar Santri';
	@override String get tambahSantri => '+ Tambah Santri';
	@override String get nis => 'NIS';
	@override String get namaSantri => 'NAMA SANTRI';
	@override String get aksi => 'AKSI';
	@override String totalTerpilih({required Object count}) => 'Total: ${count} Santri terpilih';
	@override String get simpanHalaqoh => 'SIMPAN HALAQOH';
	@override String maxSantriReached({required Object max}) => 'Halaqoh sudah mencapai batas maksimum ${max} santri.';
	@override String get deleteSantriTitle => 'Hapus Santri?';
	@override String get deleteSantriMessage => 'Apakah Anda yakin ingin menghapus santri ini dari halaqoh?';
	@override String get validationEmptyFields => 'Lengkapi nama dan pengampu halaqoh';
	@override String guruFilteredNotice({required Object count}) => '* ${count} guru disembunyikan karena telah mengampu halaqoh lain.';
	@override String santriLimitCounter({required Object count, required Object max}) => '${count}/${max} santri';
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
	@override String get allClasses => 'Semua Kelas';
	@override String get allPrograms => 'Semua Program';
	@override String maxSantriNotice({required Object max}) => 'Maksimal ${max} santri per halaqoh. Hapus salah satu santri sebelum menambah yang baru.';
	@override String assignedElsewhereNotice({required Object count}) => '(${count} sudah di halaqoh lain)';
	@override String slotLimitCounter({required Object count, required Object max}) => '${count}/${max} santri';
	@override String get emptyList => 'Tidak ada santri';
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
	@override String get belumAdaSetoran => 'Belum ada setoran';
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
	@override String get noHalaqohAssigned => 'Anda belum ditugaskan ke Halaqoh manapun.';
	@override String get santriNotFound => 'Santri tidak ditemukan.';
	@override String get programReguler => 'Reguler';
	@override String get programTakhassus => 'Takhassus';
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
	@override late final _TranslationsAbsensiBarcodeScannerId barcodeScanner = _TranslationsAbsensiBarcodeScannerId._(_root);
	@override late final _TranslationsAbsensiMulaiAbsensiId mulaiAbsensi = _TranslationsAbsensiMulaiAbsensiId._(_root);
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
	@override String get belumAdaData => 'Belum ada data absensi bulan ini';
	@override List<String> get abbrTakhassus => [
		'P',
		'D',
		'S',
		'A',
		'M',
	];
	@override List<String> get abbrReguler => [
		'P',
		'M',
	];
	@override String error({required Object message}) => 'Error: ${message}';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
	@override String get belumTerdaftarHalaqoh => 'Belum Terdaftar Halaqoh';
	@override String get sessionKeterangan => 'Keterangan Sesi';
	@override String get sessionPagiShubuh => 'Pagi (Shubuh)';
	@override String get sessionDhuha => 'Dhuha';
	@override String get sessionSiang => 'Siang';
	@override String get sessionSoreAshar => 'Sore (Ashar)';
	@override String get sessionMalamMaghrib => 'Malam (Maghrib)';
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
	@override List<String> get sessionsTakhassus => [
		'1. Shubuh',
		'2. Dhuha',
		'3. Siang',
		'4. Ashar',
		'5. Maghrib',
	];
	@override List<String> get sessionsReguler => [
		'Pagi (Kiri)',
		'Malam (Kanan)',
	];
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
	@override String get sakit => 'Sakit';
	@override String get izin => 'Izin';
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
	@override String get swipeHint => 'Geser baris tanggal ke kiri/kanan untuk melihat data per hari';
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
	@override String get saveSuccess => 'Absensi berhasil disimpan!';
	@override String get saveFailed => 'Gagal menyimpan absensi';
	@override String get warningBelumTitle => 'Ada Santri Belum Diabsen';
	@override String warningBelumBody({required Object count}) => 'Masih ada ${count} santri yang belum ditentukan statusnya.\n\nSantri tersebut tidak akan tercatat dalam data absensi jika Anda tetap menyimpan.';
	@override String get keepSaving => 'Tetap Simpan';
	@override String get completeFirst => 'Lengkapi Dulu';
	@override String get warningDuplicateTitle => 'Data Sudah Ada';
	@override String warningDuplicateBody({required Object session, required Object date}) => 'Data absensi untuk sesi ${session} pada tanggal ${date} sudah ada. Apakah Anda ingin menimpa data tersebut?';
	@override String get cancel => 'Batal';
	@override String get overwrite => 'Timpa';
	@override List<String> get sessionsTakhassus => [
		'Pagi',
		'Dhuha',
		'Siang',
		'Sore',
		'Malam',
	];
	@override List<String> get sessionsReguler => [
		'Pagi',
		'Malam',
	];
	@override late final _TranslationsDetailAbsensiHariIniSessionsId sessions = _TranslationsDetailAbsensiHariIniSessionsId._(_root);
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
	@override String get santriNotFound => 'Santri tidak ditemukan.';
	@override String targetLabel({required Object target}) => 'Target: ${target}';
	@override String get successSave => 'Hafalan berhasil disimpan!';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
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
	@override String get kelancaran => 'Kelancaran';
	@override String get tajwid => 'Tajwid';
	@override String get simpan => 'SIMPAN';
	@override String get batal => 'BATAL';
	@override String get pilihDaftarSurat => 'Pilih Daftar Surat';
	@override String get pilihSatuAtauLebihSurat => 'Pilih satu atau lebih surat';
	@override String get semua => 'Semua';
	@override String juzLabel({required Object juz}) => 'Juz ${juz}';
	@override String get cariNamaSurat => 'Cari nama surat...';
	@override String konfirmasiPilihanCount({required Object count}) => 'KONFIRMASI PILIHAN (${count})';
	@override String get konfirmasiPilihan => 'KONFIRMASI PILIHAN';
	@override String get title => 'Input Hafalan';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
	@override String get tanggalSetoran => 'Tanggal Setoran';
	@override String get tambahSurat => 'Tambah Surat';
	@override String get skalaPenilaian => 'Skala 1-100';
	@override String get errPilihMinimalSatuSurah => 'Pilih minimal satu surah';
	@override String get errWajibDiisi1Sampai100 => 'Wajib diisi antara 1 sampai 100';
	@override String juzNumbers({required Object juz}) => 'Juz ${juz}';
	@override String get semuaAyat => 'Semua Ayat';
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
	@override String ayatRange({required Object start, required Object end}) => 'Ayat ${start} - ${end}';
	@override String suratCount({required Object count}) => '${count} surat';
	@override String get filterSemuaTipe => 'Semua Tipe';
	@override String get filterHafalanBaru => 'Hafalan Baru';
	@override String get filterMurajaah => 'Muraja\'ah';
	@override String get belumAdaDataBulanIni => 'Belum ada data hafalan bulan ini';
	@override String get tidakAdaHafalanFilter => 'Tidak ada hafalan untuk filter ini';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
	@override String get deleteSuccess => 'Data hafalan berhasil dihapus!';
	@override String get deleteFailed => 'Gagal menghapus data hafalan.';
}

// Path: progressHafalanPerJuz
class _TranslationsProgressHafalanPerJuzId implements TranslationsProgressHafalanPerJuzEn {
	_TranslationsProgressHafalanPerJuzId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Progress Hafalan';
	@override String get targetHafalan => 'Target Hafalan';
	@override String get pilihJuz => 'Pilih Juz untuk melihat detail progress per surat';
	@override String ayatSelesai({required Object completed, required Object total}) => '${completed} dari ${total} Ayat Selesai';
	@override String juzLabel({required Object juz}) => 'Juz ${juz}';
	@override String kelasLabel({required Object kelas}) => 'Kelas ${kelas}';
	@override String get tambahTargetHafalan => 'Tambah Target Hafalan';
	@override String warningBanner({required Object juzLabels}) => 'Perhatian: ${juzLabels} belum diselesaikan. Pastikan santri tetap menyelesaikan target hafalan semester ini. Anda tetap dapat menambah target baru, namun target yang sudah ditetapkan wajib diselesaikan terlebih dahulu.';
	@override String get cariJuz => 'Cari Juz (contoh: Juz 1)';
	@override String surahCount({required Object count}) => '${count} Surat';
	@override String get targetBelumSelesai => 'Target Belum Selesai';
	@override String confirmAddExtraJuzMessage({required Object juzLabels, required Object nextJuz}) => '${juzLabels} belum diselesaikan semester ini.\n\nIngatkan santri untuk tetap menyelesaikan target yang sudah ditetapkan. Apakah Anda yakin ingin menambahkan Juz ${nextJuz} sebagai target tambahan?';
	@override String get batal => 'Batal';
	@override String get yaTambahkan => 'Ya, Tambahkan';
	@override String successAddTarget({required Object juz}) => 'Juz ${juz} ditambahkan sebagai target';
	@override String get failedSaveTarget => 'Gagal menyimpan target, coba lagi';
	@override String get tutup => 'Tutup';
	@override String get teacherCanAddHint => 'Ketuk + untuk menambah target juz secara manual';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
	@override String ayatCompletedInfo({required Object completed, required Object total}) => '${completed} dari ${total} Ayat Selesai';
	@override String percent({required Object percent}) => '${percent} %';
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
	@override String get unknownSurah => 'Tidak Diketahui';
	@override String juzTitle({required Object juz}) => 'Juz ${juz}';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
	@override String ayatCount({required Object count}) => '${count} Ayat';
	@override String percent({required Object percent}) => '${percent}%';
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
	@override List<String> get dayNames => [
		'AHA',
		'SEN',
		'SEL',
		'RAB',
		'KAM',
		'JUM',
		'SAB',
	];
	@override String get belumAdaHafalanBaru => 'Belum ada hafalan baru';
	@override String get belumAdaMurajaah => 'Belum ada muraja\'ah';
	@override String suratCount({required Object count}) => '${count} surat';
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
	@override String get loading => 'Memuat...';
	@override String pengampu({required Object halaqoh}) => 'Pengampu ${halaqoh}';
	@override String nipLabel({required Object nip}) => 'NIP: ${nip}';
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
	@override String pengampu({required Object halaqoh}) => 'Pengampu ${halaqoh}';
	@override String get successMessage => 'Profil berhasil diperbarui';
	@override String get failedMessage => 'Gagal memperbarui profil';
	@override String get tryAgain => 'Coba Lagi';
	@override String get saving => 'Menyimpan...';
	@override String get nis => 'NIS';
	@override String get kelas => 'Kelas';
	@override String get program => 'Program';
	@override String get kontakWali => 'Kontak Wali';
	@override String get namaWali => 'Nama Wali';
	@override String get hubungan => 'Hubungan';
	@override String get pilihHubungan => 'Pilih hubungan';
	@override List<String> get hubunganOptions => [
		'Ayah',
		'Ibu',
		'Saudara',
	];
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
	@override String get successMessage => 'Password berhasil diubah';
	@override String get failedMessage => 'Gagal mengubah password';
	@override String get errOldPasswordRequired => 'Password lama wajib diisi';
	@override String get errNewPasswordRequired => 'Password baru wajib diisi';
	@override String get errMin8Chars => 'Minimal 8 karakter';
	@override String get errLetterNumberCombo => 'Harus kombinasi huruf dan angka';
	@override String get errConfirmRequired => 'Konfirmasi password wajib diisi';
	@override String get errMismatch => 'Password tidak cocok';
	@override String get processing => 'Memproses...';
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
	@override String get loading => 'Memuat...';
	@override String get notRegisteredHalaqoh => 'Belum terdaftar di Halaqoh mana pun';
	@override String nis({required Object nis}) => 'NIS: ${nis}';
	@override String guru({required Object name}) => 'Guru: ${name}';
	@override String get extraMemorization => 'Hafalan Tambahan (Ekstra)';
	@override String juzList({required Object juz}) => 'Juz: ${juz}';
	@override String extraJuzTarget({required Object count}) => 'Tambahan : ${count} Juz';
	@override String halaqohInfo({required Object kelas, required Object halaqoh}) => 'Kelas ${kelas} | ${halaqoh}';
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
	@override String get notifikasi => 'Notifikasi';
	@override String get notifikasiAktif => 'Aktif';
	@override String get notifikasiNonAktif => 'Nonaktif';
	@override String get notifikasiDialogTitle => 'Aktifkan Notifikasi';
	@override String get notifikasiDialogMessage => 'Izin notifikasi belum diberikan. Buka Pengaturan HP Anda, aktifkan izin notifikasi untuk aplikasi ini, lalu kembali dan coba lagi.';
	@override String get bukaSettingHp => 'Buka Pengaturan';
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

// Path: tentangAplikasiScreen
class _TranslationsTentangAplikasiScreenId implements TranslationsTentangAplikasiScreenEn {
	_TranslationsTentangAplikasiScreenId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tentang Aplikasi';
	@override String get appName => 'MyHalaqoh';
	@override String get tagline => 'Platform Digital Manajemen Halaqoh';
	@override String get version => 'Versi';
	@override String get sectionTentang => 'Tentang MyHalaqoh';
	@override String get deskripsi1 => 'MyHalaqoh adalah platform digital terpadu yang dirancang khusus untuk membantu pengelolaan halaqoh di lingkungan pesantren secara efisien, transparan, dan mudah diakses.';
	@override String deskripsi2({required Object pesantren}) => 'Dikembangkan khusus untuk ${pesantren}, aplikasi ini menghubungkan Admin, Guru, dan Wali Santri dalam satu ekosistem digital yang terintegrasi.';
	@override String get sectionFitur => 'Fitur Unggulan';
	@override String get fiturAbsensiJudul => 'Absensi QR Code';
	@override String get fiturAbsensiDesc => 'Rekam kehadiran santri dengan cepat menggunakan barcode scanner terintegrasi.';
	@override String get fiturHafalanJudul => 'Hafalan Al-Quran';
	@override String get fiturHafalanDesc => 'Pantau progress hafalan santri per juz dan per surat secara real-time.';
	@override String get fiturNotifJudul => 'Notifikasi Otomatis';
	@override String get fiturNotifDesc => 'Informasi absensi dan hafalan dikirim langsung ke Wali Santri via push notification.';
	@override String get fiturMultiRoleJudul => 'Multi-Role Dashboard';
	@override String get fiturMultiRoleDesc => 'Tampilan dan fitur yang disesuaikan untuk Admin, Guru, dan Wali Santri.';
	@override String get fiturOfflineJudul => 'Mode Offline';
	@override String get fiturOfflineDesc => 'Absensi dan hafalan tetap bisa direkam meskipun tanpa koneksi internet.';
	@override String get sectionInfo => 'Informasi Aplikasi';
	@override String get infoNamaApp => 'Nama Aplikasi';
	@override String get infoVersi => 'Versi';
	@override String get infoPlatform => 'Platform';
	@override String get infoLembaga => 'Lembaga';
	@override String get infoPlatformValue => 'Android';
	@override String get sectionKontak => 'Kontak & Dukungan';
	@override String get kontakDeskripsi => 'Jika Anda memerlukan bantuan teknis atau memiliki pertanyaan seputar aplikasi, silakan hubungi administrator melalui WhatsApp.';
	@override String get kontakButton => 'Hubungi Admin via WhatsApp';
	@override String get footer => 'Dibuat dengan ❤️ untuk kemajuan pendidikan pesantren';
	@override String get copyright => '© 2026 MyHalaqoh. All rights reserved.';
}

// Path: general
class _TranslationsGeneralId implements TranslationsGeneralEn {
	_TranslationsGeneralId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get warning => 'Peringatan';
	@override String get close => 'Tutup';
	@override String get saving => 'Menyimpan...';
	@override String get done => 'Selesai';
	@override String get active => 'AKTIF';
	@override String get confirmation => 'Konfirmasi';
	@override String get yesProcess => 'Ya, Proses';
}

// Path: calendar
class _TranslationsCalendarId implements TranslationsCalendarEn {
	_TranslationsCalendarId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override List<String> get months => [
		'Januari',
		'Februari',
		'Maret',
		'April',
		'Mei',
		'Juni',
		'Juli',
		'Agustus',
		'September',
		'Oktober',
		'November',
		'Desember',
	];
	@override List<String> get daysAbbr => [
		'SEN',
		'SEL',
		'RAB',
		'KAM',
		'JUM',
		'SAB',
		'AHA',
	];
	@override List<String> get daysAbbrSundayFirst => [
		'AHA',
		'SEN',
		'SEL',
		'RAB',
		'KAM',
		'JUM',
		'SAB',
	];
}

// Path: laporanConfig
class _TranslationsLaporanConfigId implements TranslationsLaporanConfigEn {
	_TranslationsLaporanConfigId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get titleAbsensi => 'Unduh Laporan Absensi';
	@override String get titleHafalan => 'Unduh Laporan Hafalan';
	@override String get titleHalaqoh => 'Rekap Absensi Halaqoh';
	@override String get subtitleAbsensi => 'Pilih periode & konfigurasi laporan PDF santri.';
	@override String get subtitleHafalan => 'Pilih periode & konfigurasi laporan PDF santri.';
	@override String get subtitleHalaqoh => 'Pilih periode untuk mengunduh rekapitulasi satu halaqoh penuh.';
	@override String get timeRange => 'Rentang Waktu';
	@override String get weekly => 'Mingguan';
	@override String get monthly => 'Bulanan';
	@override String get custom => 'Kustom';
	@override String get semester => 'Semester';
	@override String get selectDateRange => 'Pilih Rentang Tanggal';
	@override String get startDate => 'Tanggal Awal';
	@override String get endDate => 'Tanggal Akhir';
	@override String get selectDateHint => 'Pilih tanggal';
	@override String get chooseStartDate => 'Pilih Tanggal Awal';
	@override String get chooseEndDate => 'Pilih Tanggal Akhir';
	@override String get btnSelect => 'Pilih';
	@override String get btnCancel => 'Batal';
	@override String totalDaysSelected({required Object days}) => 'Total ${days} hari dipilih';
	@override String get reportPeriod => 'Periode Laporan';
	@override String daysShort({required Object days}) => '${days} hr';
	@override String get btnGeneratePdf => 'Buat Laporan PDF';
	@override String get btnGenerateRecapPdf => 'Buat Rekapan PDF';
	@override String get generatingReport => 'Membuat laporan...';
	@override String get readyTitle => 'Laporan Siap!';
	@override String get readyRecapTitle => 'Rekapan Siap!';
	@override String get readySubtitle => 'PDF berhasil dibuat. Pratinjau atau bagikan sekarang.';
	@override String get attendanceReport => 'Laporan Absensi';
	@override String get recapAttendance => 'Rekap Absensi';
	@override String get memorizationReport => 'Laporan Hafalan';
	@override String get btnPreview => 'Pratinjau';
	@override String get btnShare => 'Bagikan';
	@override String get btnCreateNewReport => 'Buat laporan baru';
	@override String get btnCreateNewRecap => 'Buat rekapan baru';
	@override String errGenerate({required Object error}) => 'Gagal membuat laporan: ${error}';
	@override String errPreview({required Object error}) => 'Gagal membuka pratinjau: ${error}';
	@override String errShare({required Object error}) => 'Gagal berbagi laporan: ${error}';
	@override late final _TranslationsLaporanConfigPdfId pdf = _TranslationsLaporanConfigPdfId._(_root);
}

// Path: kelasProgram
class _TranslationsKelasProgramId implements TranslationsKelasProgramEn {
	_TranslationsKelasProgramId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kelola Kelas & Program';
	@override String get kelasTab => 'Kelas';
	@override String get programTab => 'Program';
	@override String get belumAdaKelas => 'Belum ada data kelas';
	@override String kelasNama({required Object nama}) => 'Kelas ${nama}';
	@override String urutanPromosi({required Object urutan, required Object nextKelas}) => 'Urutan: ${urutan} | Promosi ke: ${nextKelas}';
	@override String get lulusAlumni => 'Lulus (Alumni)';
	@override String get belumAdaProgram => 'Belum ada data program';
	@override String programId({required Object id}) => 'ID: ${id}';
	@override String get tambahKelas => 'Tambah Kelas';
	@override String get editKelas => 'Edit Kelas';
	@override String get namaKelas => 'Nama Kelas';
	@override String get namaKelasHint => 'e.g. 7, 8, atau A, B';
	@override String get namaKelasRequired => 'Nama kelas harus diisi';
	@override String get urutanKelas => 'Urutan Kelas';
	@override String get urutanKelasHint => 'e.g. Angka urutan kelas untuk promosi';
	@override String get urutanRequired => 'Urutan harus diisi';
	@override String get urutanNumeric => 'Urutan harus berupa angka';
	@override String get kelasSelanjutnya => 'Kelas Selanjutnya';
	@override String get pilihKelasSelanjutnya => 'Pilih Kelas Selanjutnya';
	@override String get batal => 'Batal';
	@override String get simpan => 'Simpan';
	@override String gagalMenyimpan({required Object error}) => 'Gagal menyimpan: ${error}';
	@override String get hapusKelas => 'Hapus Kelas';
	@override String hapusKelasConfirm({required Object nama}) => 'Apakah Anda yakin ingin menghapus Kelas ${nama}? Tindakan ini tidak dapat dibatalkan.';
	@override String get hapus => 'Hapus';
	@override String get gagalMenghapusKelas => 'Gagal menghapus kelas';
	@override String get tambahProgram => 'Tambah Program';
	@override String get editProgram => 'Edit Program';
	@override String get kodeProgram => 'Kode Program';
	@override String get kodeProgramHint => 'e.g. R, T, atau TH';
	@override String get kodeProgramRequired => 'Kode program harus diisi';
	@override String get namaProgram => 'Nama Program';
	@override String get namaProgramHint => 'e.g. Reguler, Takhassus, atau Tahfidz';
	@override String get namaProgramRequired => 'Nama program harus diisi';
	@override String get hapusProgram => 'Hapus Program';
	@override String hapusProgramConfirm({required Object nama, required Object id}) => 'Apakah Anda yakin ingin menghapus program "${nama}" (${id})? Tindakan ini tidak dapat dibatalkan.';
	@override String get gagalMenghapusProgram => 'Gagal menghapus program';
	@override String get aturKelasProgram => 'Atur kelas & program';
}

// Path: superAdmin
class _TranslationsSuperAdminId implements TranslationsSuperAdminEn {
	_TranslationsSuperAdminId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get pickerTitle => 'Pilih Mode Akses';
	@override String get pickerSubtitle => 'Masuk sebagai';
	@override String get accessAsAdmin => 'Akses sebagai Admin';
	@override String get accessAsAdminDesc => 'Kelola guru, santri, halaqoh, dan target hafalan';
	@override String get accessAsGuru => 'Akses sebagai Guru';
	@override String get accessAsGuruDesc => 'Pilih guru dan masuk ke fitur absensi & hafalan';
	@override String get accessAsWali => 'Akses sebagai Wali Santri';
	@override String get accessAsWaliDesc => 'Pilih santri dan lihat progress & absensi mereka';
	@override String get viewActivityLog => 'Lihat Log Aktivitas';
	@override String modeLabel({required Object role, required Object name}) => 'Mode ${role}: ${name}';
	@override String get exitMode => 'Keluar';
	@override String get exitModeTooltip => 'Keluar dari mode impersonasi';
	@override String get guruPickerTitle => 'Pilih Guru';
	@override String get santriPickerTitle => 'Pilih Santri';
	@override String get searchGuru => 'Cari guru...';
	@override String get searchSantri => 'Cari santri...';
}

// Path: activityLog
class _TranslationsActivityLogId implements TranslationsActivityLogEn {
	_TranslationsActivityLogId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Log Aktivitas';
	@override String get filterRole => 'Filter Role';
	@override String get filterModule => 'Filter Modul';
	@override String get filterAction => 'Filter Aksi';
	@override String get filterDateFrom => 'Dari Tanggal';
	@override String get filterDateTo => 'Sampai Tanggal';
	@override String get allRoles => 'Semua Role';
	@override String get allModules => 'Semua Modul';
	@override String get allActions => 'Semua Aksi';
	@override String get empty => 'Belum ada log aktivitas';
	@override String get resetFilter => 'Reset Filter';
}

// Path: absensi.barcodeScanner
class _TranslationsAbsensiBarcodeScannerId implements TranslationsAbsensiBarcodeScannerEn {
	_TranslationsAbsensiBarcodeScannerId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String notMember({required Object nis}) => 'Santri dengan NIS ${nis} bukan anggota halaqoh Anda';
	@override String cameraError({required Object error}) => 'Gagal memuat kamera:\n${error}';
	@override String get clearPosition => 'Pastikan barcode berada dalam posisi yang jelas';
	@override String scannedSuccess({required Object name}) => '${name} hadir';
	@override String totalSantri({required Object count}) => 'Total ${count} Santri';
	@override String progress({required Object scanned, required Object total}) => '${scanned} / ${total}';
	@override String nisLabel({required Object nis}) => 'NIS: ${nis}';
}

// Path: absensi.mulaiAbsensi
class _TranslationsAbsensiMulaiAbsensiId implements TranslationsAbsensiMulaiAbsensiEn {
	_TranslationsAbsensiMulaiAbsensiId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get shubuh => 'Shubuh';
	@override String get dhuha => 'Dhuha';
	@override String get siang => 'Siang';
	@override String get soreAshar => 'Sore/Ashar';
	@override String get maghrib => 'Maghrib';
	@override String get markAllPresent => 'Tandai Semua Hadir';
}

// Path: detailAbsensiHariIni.sessions
class _TranslationsDetailAbsensiHariIniSessionsId implements TranslationsDetailAbsensiHariIniSessionsEn {
	_TranslationsDetailAbsensiHariIniSessionsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get pagi => 'Pagi';
	@override String get dhuha => 'Dhuha';
	@override String get siang => 'Siang';
	@override String get ashar => 'Ashar';
	@override String get malam => 'Malam';
}

// Path: laporanConfig.pdf
class _TranslationsLaporanConfigPdfId implements TranslationsLaporanConfigPdfEn {
	_TranslationsLaporanConfigPdfId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get shubuh => 'Shubuh';
	@override String get dhuha => 'Dhuha';
	@override String get siang => 'Siang';
	@override String get ashar => 'Ashar';
	@override String get maghrib => 'Maghrib';
	@override String get presentCode => 'H';
	@override String get sickCode => 'S';
	@override String get permitCode => 'I';
	@override String get absentCode => 'A';
	@override String get systemName => 'MyHalaqoh — Sistem Manajemen Halaqoh';
	@override String pageLabel({required Object page, required Object total}) => 'Halaman ${page} dari ${total}';
	@override String get titleAttendance => 'Laporan Kehadiran Santri';
	@override String get titleHalaqohRecap => 'Laporan Rekapitulasi Absensi Halaqoh';
	@override String get titleMemorization => 'Laporan Capaian Hafalan Santri';
	@override String printedAt({required Object date}) => 'Dicetak: ${date}';
	@override String get studentInfo => 'Informasi Santri';
	@override String get halaqohInfo => 'Informasi Halaqoh';
	@override String get studentName => 'Nama Santri';
	@override String get nameHeader => 'Nama';
	@override String get kehadiranHeader => 'Kehadiran';
	@override String get maxHeader => 'Max';
	@override String get hdrHeader => 'Hdr';
	@override String get nis => 'NIS';
	@override String get halaqoh => 'Halaqoh';
	@override String get pembimbing => 'Pembimbing';
	@override String get musyrif => 'Musyrif';
	@override String get program => 'Program';
	@override String get reportType => 'Jenis Laporan';
	@override String get summaryAttendance => 'Ringkasan Kehadiran';
	@override String get summaryMemorization => 'Ringkasan Capaian';
	@override String get present => 'Hadir';
	@override String get sick => 'Sakit';
	@override String get permit => 'Izin';
	@override String get absent => 'Alfa';
	@override String get ziyadah => 'Ziyadah';
	@override String get murajaah => 'Muraja\'ah';
	@override String get attendanceRate => 'Tingkat Kehadiran';
	@override String get avgScore => 'Nilai Rata-rata';
	@override String totalScheduled({required Object hadir, required Object total}) => '${hadir} dari ${total} sesi terjadwal';
	@override String get dailyDetailTitle => 'Detail Kehadiran Harian';
	@override String get setoranDetailTitle => 'Detail Setoran Hafalan';
	@override late final _TranslationsLaporanConfigPdfPredikatId predikat = _TranslationsLaporanConfigPdfPredikatId._(_root);
	@override String weeksLabel({required Object index, required Object start, required Object end}) => 'Pekan ke-${index}  (${start} – ${end})';
	@override String get no => 'No.';
	@override String get dateHeader => 'Hari, Tanggal';
	@override String get dayHeader => 'Hari';
	@override String get typeHeader => 'Tipe';
	@override String get dateShort => 'Tanggal';
	@override String get surahAyatHeader => 'Surah / Ayat';
	@override String get baruCode => 'Baru';
	@override String get ulangCode => 'Ulang';
	@override String get ziyadahLabel => 'Ziyadah (Hafalan Baru)';
	@override String get murajaahLabel => 'Muraja\'ah (Ulang)';
	@override String get juzHeader => 'Juz';
	@override String get surahDetailHeader => 'Detail Surat';
	@override String get kelancaranHeader => 'Kelancaran';
	@override String get tajwidHeader => 'Tajwid';
	@override String get avgHeader => 'Rata-rata';
	@override String get predikatHeader => 'Predikat';
	@override String get hadirLabel => 'Hadir';
	@override String get sakitLabel => 'Sakit';
	@override String get izinLabel => 'Izin';
	@override String get alfaLabel => 'Alfa';
	@override String get keteranganLabel => 'Keterangan';
	@override String get legenda => 'Legenda';
	@override String get noSession => 'Tidak ada sesi';
	@override String get statusLegenda => 'H = Hadir  |  S = Sakit  |  I = Izin  |  A = Alfa';
	@override String get predikatLegenda => 'Mumtaz: 85 - 100  |  Jayyid: 70 - 84  |  Maqbul: < 70';
	@override String pekanShort({required Object index}) => 'Pekan ke-${index}';
}

// Path: laporanConfig.pdf.predikat
class _TranslationsLaporanConfigPdfPredikatId implements TranslationsLaporanConfigPdfPredikatEn {
	_TranslationsLaporanConfigPdfPredikatId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get mumtaz => 'Mumtaz';
	@override String get jayyid => 'Jayyid';
	@override String get maqbul => 'Maqbul';
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
			case 'dashboard.santriCountDynamic': return ({required Object count}) => '${count} santri';
			case 'dashboard.guruCountDynamic': return ({required Object count}) => '${count} guru';
			case 'dashboard.halaqohCountDynamic': return ({required Object count}) => '${count} halaqoh';
			case 'santri.title': return 'Data Santri';
			case 'santri.searchHint': return 'Cari Santri';
			case 'santri.showCount': return ({required Object count}) => 'Menampilkan ${count} Santri';
			case 'santri.identitas': return 'IDENTITAS';
			case 'santri.kelas': return 'KELAS';
			case 'santri.aksi': return 'AKSI';
			case 'santri.filter': return 'Filter';
			case 'santri.all': return 'Semua';
			case 'santri.noAccountError': return 'Santri ini belum memiliki akun yang terhubung.';
			case 'santri.resetPasswordTitle': return 'Reset Password';
			case 'santri.resetPasswordConfirm': return ({required Object name}) => 'Apakah Anda yakin ingin mereset password untuk ${name}? Password akan dikembalikan ke default "generasi554".';
			case 'santri.resetPasswordButton': return 'Ya, Reset';
			case 'santri.resetPasswordSuccess': return 'Password berhasil direset ke "generasi554".';
			case 'santri.hideAlumniTooltip': return ({required Object count}) => 'Sembunyikan Alumni (${count})';
			case 'santri.showAlumniTooltip': return ({required Object count}) => 'Tampilkan Alumni (${count})';
			case 'santri.processUpgradeTooltip': return 'Proses Kenaikan Kelas';
			case 'santri.noActiveSantri': return 'Tidak ada santri aktif untuk diproses.';
			case 'santri.upgradeClass': return 'Naik Kelas';
			case 'santri.emptyList': return 'Belum ada data santri';
			case 'santri.upgradeClassConfirmMessage': return ({required Object naikCount, required Object alumniCount, required Object tahunAjaran}) => 'Proses ini akan:\n• Menaikkan kelas ${naikCount} santri\n• Mengarsipkan ${alumniCount} santri kelas 12 sebagai alumni\n• Memperbarui target hafalan ke tahun ajaran ${tahunAjaran}\n\nTindakan ini tidak dapat dibatalkan. Lanjutkan?';
			case 'santri.upgradeClassSuccessMessage': return ({required Object naikCount, required Object alumniCount}) => 'Kenaikan kelas berhasil diproses. ${naikCount} santri naik kelas, ${alumniCount} alumni baru.';
			case 'santri.upgradeClassProcessTitle': return 'Proses Kenaikan Kelas';
			case 'santri.upgradeClassProcessSubtitle': return 'Semua santri aktif akan dinaikkan kelasnya';
			case 'santri.newSchoolYear': return 'Tahun Ajaran Baru';
			case 'santri.upgradeClassWarning': return 'Tindakan ini tidak dapat dibatalkan. Pastikan data sudah benar sebelum memproses.';
			case 'santri.upgradeClassEffectsTitle': return 'Yang akan terjadi';
			case 'santri.upgradeClassEffectNaik': return ({required Object count}) => '${count} santri aktif akan naik kelas';
			case 'santri.upgradeClassEffectAlumni': return ({required Object count}) => '${count} santri kelas 12 diarsipkan sebagai alumni';
			case 'santri.upgradeClassEffectTarget': return 'Target hafalan semua kelas diperbarui';
			case 'santri.upgradeClassEffectDataSafe': return 'Data hafalan & halaqoh tidak berubah';
			case 'santri.upgradeClassEffectAttendanceSafe': return 'Riwayat absensi tidak berubah';
			case 'santri.nisExistsError': return ({required Object nis}) => 'Santri dengan NIS ${nis} sudah terdaftar di sistem.';
			case 'santri.kelasRequired': return 'Kelas wajib dipilih';
			case 'santri.editTitle': return 'Edit Data Santri';
			case 'santri.nisRequired': return 'NIS wajib diisi';
			case 'santri.nameRequired': return 'Nama wajib diisi';
			case 'guru.title': return 'Data Guru';
			case 'guru.searchHint': return 'Cari Guru';
			case 'guru.showCount': return ({required Object count}) => 'Menampilkan ${count} Guru';
			case 'guru.identitas': return 'IDENTITAS';
			case 'guru.aksi': return 'AKSI';
			case 'guru.filter': return 'Filter';
			case 'guru.noAccountError': return 'Guru ini belum memiliki akun yang terhubung.';
			case 'guru.resetPasswordTitle': return 'Reset Password';
			case 'guru.resetPasswordConfirm': return ({required Object name}) => 'Apakah Anda yakin ingin mereset password untuk ${name}? Password akan dikembalikan ke default "generasi554".';
			case 'guru.resetPasswordButton': return 'Ya, Reset';
			case 'guru.resetPasswordSuccess': return 'Password berhasil direset ke "generasi554".';
			case 'guru.emptyList': return 'Belum ada data guru';
			case 'guru.nipExistsError': return ({required Object nip}) => 'Guru dengan NIP ${nip} sudah terdaftar di sistem.';
			case 'guru.editTitle': return 'Edit Data Guru';
			case 'guru.nipRequired': return 'NIP wajib diisi';
			case 'guru.nipDigitsError': return 'NIP harus 12 atau 13 digit';
			case 'guru.nameRequired': return 'Nama wajib diisi';
			case 'guru.phoneDigitsError': return 'Nomor HP harus 10-13 digit (jika diisi)';
			case 'guru.programHalaqohLabel': return 'Program Halaqoh';
			case 'guru.chooseProgramHint': return 'Pilih Program';
			case 'guru.programRequired': return 'Program wajib dipilih';
			case 'halaqoh.title': return 'Data Halaqoh';
			case 'halaqoh.searchHint': return 'Cari Halaqoh';
			case 'halaqoh.showCount': return ({required Object count}) => 'Menampilkan ${count} Halaqoh';
			case 'halaqoh.sort': return 'Urutkan';
			case 'halaqoh.santriCount': return ({required Object count}) => '${count} Santri';
			case 'halaqoh.kelasLabel': return ({required Object kelas}) => 'Kelas ${kelas}';
			case 'halaqoh.all': return 'Semua';
			case 'halaqoh.kelasProgramLabel': return ({required Object kelas, required Object program}) => 'Kelas ${kelas}${program}';
			case 'halaqoh.emptyList': return 'Belum ada data halaqoh';
			case 'targetHafalan.title': return 'Target Hafalan';
			case 'targetHafalan.reguler': return 'REGULER';
			case 'targetHafalan.takhassus': return 'TAKHASSUS';
			case 'targetHafalan.infoText': return 'Atur target hafalan untuk setiap kelas, target akan diterapkan untuk seluruh santri pada kelas tersebut.';
			case 'targetHafalan.infoTextNew': return 'Kurikulum hafalan sesuai program pesantren. Semester aktif dapat diatur di sini, sedangkan Tahun Ajaran diperbarui melalui Kenaikan Kelas.';
			case 'targetHafalan.kelasLabel': return 'Kelas';
			case 'targetHafalan.smp': return 'SMP';
			case 'targetHafalan.semesterAktif': return 'Semester Aktif';
			case 'targetHafalan.belumDitetapkan': return 'Belum ditetapkan';
			case 'targetHafalan.semester1': return 'Semester 1';
			case 'targetHafalan.semester2': return 'Semester 2';
			case 'targetHafalan.periodeUTS': return 'UTS';
			case 'targetHafalan.periodeUAS': return 'UAS';
			case 'targetHafalan.tipeIdadTahsin': return 'I\'dad Tahsin';
			case 'targetHafalan.tipeDauroh': return 'Dauroh';
			case 'targetHafalan.tipeMurajaah': return 'Muraja\'ah';
			case 'targetHafalan.tipeUAT': return 'UAT (Ujian Akhir Tahfidz)';
			case 'targetHafalan.editPengaturan': return 'Edit Pengaturan';
			case 'targetHafalan.sma': return 'SMA';
			case 'targetHafalan.kelasTitleJenjang': return ({required Object kelas, required Object jenjang}) => 'Kelas ${kelas} ${jenjang}';
			case 'targetHafalan.taSemLabel': return ({required Object ta, required Object sem}) => 'TA: ${ta} • Sem: ${sem}';
			case 'targetHafalan.semesterNumber': return ({required Object number}) => 'SEMESTER ${number}';
			case 'targetHafalan.tipeZiyadah': return 'Ziyadah';
			case 'editTarget.title': return 'Pengaturan Target Kelas';
			case 'editTarget.tahunAjaran': return 'TAHUN AJARAN';
			case 'editTarget.semesterAktif': return 'SEMESTER AKTIF';
			case 'editTarget.pilihSemester': return 'Pilih Semester yang Sedang Berjalan';
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
			case 'addData.uploadExcel': return 'Upload File CSV';
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
			case 'addData.bulkTapUpload': return 'Tap untuk upload file CSV';
			case 'addData.bulkFormat': return 'Format .csv (Maks. 5MB)';
			case 'addData.bulkUploadButton': return 'Upload Sekarang';
			case 'addData.bulkErrorFileRead': return 'Gagal membaca file. Coba pilih file lain.';
			case 'addData.bulkFileReady': return ({required Object name}) => 'File siap diproses: ${name}';
			case 'addData.bulkStatusReading': return 'Membaca file...';
			case 'addData.bulkErrorFileEmpty': return 'File kosong atau tidak memiliki baris data!';
			case 'addData.bulkErrorNoValidRows': return 'Tidak ada baris data yang valid untuk diunggah!';
			case 'addData.bulkStatusProcessing': return ({required Object count}) => 'Memproses ${count} baris...';
			case 'addData.bulkStatusSaving': return ({required Object current, required Object total}) => 'Menyimpan ${current} / ${total} ke server...';
			case 'addData.bulkFinishedTitle': return 'Selesai!';
			case 'addData.bulkSuccess': return 'Sukses';
			case 'addData.bulkFailed': return 'Gagal';
			case 'addData.bulkGuruFailNote': return 'Catatan: Data yang gagal disimpan kemungkinan disebabkan oleh Nomor Induk Pegawai (NIP) yang sudah terdaftar di sistem.';
			case 'addData.bulkSantriFailNote': return 'Catatan: Data yang gagal disimpan kemungkinan disebabkan oleh Nomor Induk Siswa (NIS) yang sudah terdaftar di sistem.';
			case 'addHalaqoh.title': return 'Tambah Halaqoh Baru';
			case 'addHalaqoh.namaHalaqoh': return 'Nama Halaqoh';
			case 'addHalaqoh.namaHalaqohHint': return 'Contoh: Halaqoh 7A';
			case 'addHalaqoh.kelas': return 'Kelas';
			case 'addHalaqoh.kelasHint': return 'Kelas';
			case 'addHalaqoh.program': return 'Program';
			case 'addHalaqoh.programHint': return 'Program';
			case 'addHalaqoh.pengampu': return 'Pengampu (Guru)';
			case 'addHalaqoh.pengampuHint': return 'Cari nama pengampu...';
			case 'addHalaqoh.daftarSantri': return 'Daftar Santri';
			case 'addHalaqoh.tambahSantri': return '+ Tambah Santri';
			case 'addHalaqoh.nis': return 'NIS';
			case 'addHalaqoh.namaSantri': return 'NAMA SANTRI';
			case 'addHalaqoh.aksi': return 'AKSI';
			case 'addHalaqoh.totalTerpilih': return ({required Object count}) => 'Total: ${count} Santri terpilih';
			case 'addHalaqoh.simpanHalaqoh': return 'SIMPAN HALAQOH';
			case 'addHalaqoh.maxSantriReached': return ({required Object max}) => 'Halaqoh sudah mencapai batas maksimum ${max} santri.';
			case 'addHalaqoh.deleteSantriTitle': return 'Hapus Santri?';
			case 'addHalaqoh.deleteSantriMessage': return 'Apakah Anda yakin ingin menghapus santri ini dari halaqoh?';
			case 'addHalaqoh.validationEmptyFields': return 'Lengkapi nama dan pengampu halaqoh';
			case 'addHalaqoh.guruFilteredNotice': return ({required Object count}) => '* ${count} guru disembunyikan karena telah mengampu halaqoh lain.';
			case 'addHalaqoh.santriLimitCounter': return ({required Object count, required Object max}) => '${count}/${max} santri';
			case 'selectSantri.title': return 'Pilih Santri';
			case 'selectSantri.searchHint': return 'Cari nama atau NIS santri...';
			case 'selectSantri.filter': return 'FILTER';
			case 'selectSantri.countLabel': return ({required Object count}) => '${count} Santri';
			case 'selectSantri.nis': return 'NIS';
			case 'selectSantri.nama': return 'NAMA';
			case 'selectSantri.kelas': return 'KELAS';
			case 'selectSantri.tambahkanButton': return ({required Object count}) => 'TAMBAHKAN (${count}) SANTRI';
			case 'selectSantri.allClasses': return 'Semua Kelas';
			case 'selectSantri.allPrograms': return 'Semua Program';
			case 'selectSantri.maxSantriNotice': return ({required Object max}) => 'Maksimal ${max} santri per halaqoh. Hapus salah satu santri sebelum menambah yang baru.';
			case 'selectSantri.assignedElsewhereNotice': return ({required Object count}) => '(${count} sudah di halaqoh lain)';
			case 'selectSantri.slotLimitCounter': return ({required Object count, required Object max}) => '${count}/${max} santri';
			case 'selectSantri.emptyList': return 'Tidak ada santri';
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
			case 'guruDashboard.belumAdaSetoran': return 'Belum ada setoran';
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
			case 'myHalaqohScreen.noHalaqohAssigned': return 'Anda belum ditugaskan ke Halaqoh manapun.';
			case 'myHalaqohScreen.santriNotFound': return 'Santri tidak ditemukan.';
			case 'myHalaqohScreen.programReguler': return 'Reguler';
			case 'myHalaqohScreen.programTakhassus': return 'Takhassus';
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
			case 'absensi.barcodeScanner.notMember': return ({required Object nis}) => 'Santri dengan NIS ${nis} bukan anggota halaqoh Anda';
			case 'absensi.barcodeScanner.cameraError': return ({required Object error}) => 'Gagal memuat kamera:\n${error}';
			case 'absensi.barcodeScanner.clearPosition': return 'Pastikan barcode berada dalam posisi yang jelas';
			case 'absensi.barcodeScanner.scannedSuccess': return ({required Object name}) => '${name} hadir';
			case 'absensi.barcodeScanner.totalSantri': return ({required Object count}) => 'Total ${count} Santri';
			case 'absensi.barcodeScanner.progress': return ({required Object scanned, required Object total}) => '${scanned} / ${total}';
			case 'absensi.barcodeScanner.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'absensi.mulaiAbsensi.shubuh': return 'Shubuh';
			case 'absensi.mulaiAbsensi.dhuha': return 'Dhuha';
			case 'absensi.mulaiAbsensi.siang': return 'Siang';
			case 'absensi.mulaiAbsensi.soreAshar': return 'Sore/Ashar';
			case 'absensi.mulaiAbsensi.maghrib': return 'Maghrib';
			case 'absensi.mulaiAbsensi.markAllPresent': return 'Tandai Semua Hadir';
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
			case 'riwayatAbsensi.belumAdaData': return 'Belum ada data absensi bulan ini';
			case 'riwayatAbsensi.abbrTakhassus.0': return 'P';
			case 'riwayatAbsensi.abbrTakhassus.1': return 'D';
			case 'riwayatAbsensi.abbrTakhassus.2': return 'S';
			case 'riwayatAbsensi.abbrTakhassus.3': return 'A';
			case 'riwayatAbsensi.abbrTakhassus.4': return 'M';
			case 'riwayatAbsensi.abbrReguler.0': return 'P';
			case 'riwayatAbsensi.abbrReguler.1': return 'M';
			case 'riwayatAbsensi.error': return ({required Object message}) => 'Error: ${message}';
			case 'riwayatAbsensi.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'riwayatAbsensi.belumTerdaftarHalaqoh': return 'Belum Terdaftar Halaqoh';
			case 'riwayatAbsensi.sessionKeterangan': return 'Keterangan Sesi';
			case 'riwayatAbsensi.sessionPagiShubuh': return 'Pagi (Shubuh)';
			case 'riwayatAbsensi.sessionDhuha': return 'Dhuha';
			case 'riwayatAbsensi.sessionSiang': return 'Siang';
			case 'riwayatAbsensi.sessionSoreAshar': return 'Sore (Ashar)';
			case 'riwayatAbsensi.sessionMalamMaghrib': return 'Malam (Maghrib)';
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
			case 'kalenderAbsensi.sessionsTakhassus.0': return '1. Shubuh';
			case 'kalenderAbsensi.sessionsTakhassus.1': return '2. Dhuha';
			case 'kalenderAbsensi.sessionsTakhassus.2': return '3. Siang';
			case 'kalenderAbsensi.sessionsTakhassus.3': return '4. Ashar';
			case 'kalenderAbsensi.sessionsTakhassus.4': return '5. Maghrib';
			case 'kalenderAbsensi.sessionsReguler.0': return 'Pagi (Kiri)';
			case 'kalenderAbsensi.sessionsReguler.1': return 'Malam (Kanan)';
			case 'kalenderAbsensi.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'kalenderAbsensi.sakit': return 'Sakit';
			case 'kalenderAbsensi.izin': return 'Izin';
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
			case 'absensiHalaqoh.swipeHint': return 'Geser baris tanggal ke kiri/kanan untuk melihat data per hari';
			case 'detailAbsensiHariIni.title': return 'Detail Absensi Hari Ini';
			case 'detailAbsensiHariIni.hadir': return 'Hadir';
			case 'detailAbsensiHariIni.sakit': return 'Sakit';
			case 'detailAbsensiHariIni.izin': return 'Izin';
			case 'detailAbsensiHariIni.alfa': return 'Alfa';
			case 'detailAbsensiHariIni.belumAbsen': return 'Belum Absen';
			case 'detailAbsensiHariIni.belumDiabsen': return 'Belum absen';
			case 'detailAbsensiHariIni.daftarKehadiranSantri': return 'Daftar Kehadiran Santri';
			case 'detailAbsensiHariIni.saveSuccess': return 'Absensi berhasil disimpan!';
			case 'detailAbsensiHariIni.saveFailed': return 'Gagal menyimpan absensi';
			case 'detailAbsensiHariIni.warningBelumTitle': return 'Ada Santri Belum Diabsen';
			case 'detailAbsensiHariIni.warningBelumBody': return ({required Object count}) => 'Masih ada ${count} santri yang belum ditentukan statusnya.\n\nSantri tersebut tidak akan tercatat dalam data absensi jika Anda tetap menyimpan.';
			case 'detailAbsensiHariIni.keepSaving': return 'Tetap Simpan';
			case 'detailAbsensiHariIni.completeFirst': return 'Lengkapi Dulu';
			case 'detailAbsensiHariIni.warningDuplicateTitle': return 'Data Sudah Ada';
			case 'detailAbsensiHariIni.warningDuplicateBody': return ({required Object session, required Object date}) => 'Data absensi untuk sesi ${session} pada tanggal ${date} sudah ada. Apakah Anda ingin menimpa data tersebut?';
			case 'detailAbsensiHariIni.cancel': return 'Batal';
			case 'detailAbsensiHariIni.overwrite': return 'Timpa';
			case 'detailAbsensiHariIni.sessionsTakhassus.0': return 'Pagi';
			case 'detailAbsensiHariIni.sessionsTakhassus.1': return 'Dhuha';
			case 'detailAbsensiHariIni.sessionsTakhassus.2': return 'Siang';
			case 'detailAbsensiHariIni.sessionsTakhassus.3': return 'Sore';
			case 'detailAbsensiHariIni.sessionsTakhassus.4': return 'Malam';
			case 'detailAbsensiHariIni.sessionsReguler.0': return 'Pagi';
			case 'detailAbsensiHariIni.sessionsReguler.1': return 'Malam';
			case 'detailAbsensiHariIni.sessions.pagi': return 'Pagi';
			case 'detailAbsensiHariIni.sessions.dhuha': return 'Dhuha';
			case 'detailAbsensiHariIni.sessions.siang': return 'Siang';
			case 'detailAbsensiHariIni.sessions.ashar': return 'Ashar';
			case 'detailAbsensiHariIni.sessions.malam': return 'Malam';
			case 'hafalan.cariSantri': return 'Cari Santri';
			case 'hafalan.daftarSantri': return 'Daftar Santri';
			case 'hafalan.santriCount': return ({required Object count}) => '${count} Santri';
			case 'hafalan.riwayatHafalan': return 'Riwayat Hafalan';
			case 'hafalan.inputHafalan': return 'Input Hafalan';
			case 'hafalan.santriNotFound': return 'Santri tidak ditemukan.';
			case 'hafalan.targetLabel': return ({required Object target}) => 'Target: ${target}';
			case 'hafalan.successSave': return 'Hafalan berhasil disimpan!';
			case 'hafalan.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'inputHafalanForm.nama': return ({required Object name}) => 'Nama: ${name}';
			case 'inputHafalanForm.ziyadah': return 'ZIYADAH';
			case 'inputHafalanForm.murajaah': return 'MURAJAAH';
			case 'inputHafalanForm.formulirHafalan': return 'Formulir Hafalan';
			case 'inputHafalanForm.pilihSurat': return 'Pilih Surat';
			case 'inputHafalanForm.ayatAwal': return 'Ayat Awal';
			case 'inputHafalanForm.ayatAkhir': return 'Ayat Akhir';
			case 'inputHafalanForm.juz': return 'Juz';
			case 'inputHafalanForm.penilaian': return 'Penilaian';
			case 'inputHafalanForm.kelancaran': return 'Kelancaran';
			case 'inputHafalanForm.tajwid': return 'Tajwid';
			case 'inputHafalanForm.simpan': return 'SIMPAN';
			case 'inputHafalanForm.batal': return 'BATAL';
			case 'inputHafalanForm.pilihDaftarSurat': return 'Pilih Daftar Surat';
			case 'inputHafalanForm.pilihSatuAtauLebihSurat': return 'Pilih satu atau lebih surat';
			case 'inputHafalanForm.semua': return 'Semua';
			case 'inputHafalanForm.juzLabel': return ({required Object juz}) => 'Juz ${juz}';
			case 'inputHafalanForm.cariNamaSurat': return 'Cari nama surat...';
			case 'inputHafalanForm.konfirmasiPilihanCount': return ({required Object count}) => 'KONFIRMASI PILIHAN (${count})';
			case 'inputHafalanForm.konfirmasiPilihan': return 'KONFIRMASI PILIHAN';
			case 'inputHafalanForm.title': return 'Input Hafalan';
			case 'inputHafalanForm.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'inputHafalanForm.tanggalSetoran': return 'Tanggal Setoran';
			case 'inputHafalanForm.tambahSurat': return 'Tambah Surat';
			case 'inputHafalanForm.skalaPenilaian': return 'Skala 1-100';
			case 'inputHafalanForm.errPilihMinimalSatuSurah': return 'Pilih minimal satu surah';
			case 'inputHafalanForm.errWajibDiisi1Sampai100': return 'Wajib diisi antara 1 sampai 100';
			case 'inputHafalanForm.juzNumbers': return ({required Object juz}) => 'Juz ${juz}';
			case 'inputHafalanForm.semuaAyat': return 'Semua Ayat';
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
			case 'riwayatHafalanSantri.ayatRange': return ({required Object start, required Object end}) => 'Ayat ${start} - ${end}';
			case 'riwayatHafalanSantri.suratCount': return ({required Object count}) => '${count} surat';
			case 'riwayatHafalanSantri.filterSemuaTipe': return 'Semua Tipe';
			case 'riwayatHafalanSantri.filterHafalanBaru': return 'Hafalan Baru';
			case 'riwayatHafalanSantri.filterMurajaah': return 'Muraja\'ah';
			case 'riwayatHafalanSantri.belumAdaDataBulanIni': return 'Belum ada data hafalan bulan ini';
			case 'riwayatHafalanSantri.tidakAdaHafalanFilter': return 'Tidak ada hafalan untuk filter ini';
			case 'riwayatHafalanSantri.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'riwayatHafalanSantri.deleteSuccess': return 'Data hafalan berhasil dihapus!';
			case 'riwayatHafalanSantri.deleteFailed': return 'Gagal menghapus data hafalan.';
			case 'progressHafalanPerJuz.title': return 'Progress Hafalan';
			case 'progressHafalanPerJuz.targetHafalan': return 'Target Hafalan';
			case 'progressHafalanPerJuz.pilihJuz': return 'Pilih Juz untuk melihat detail progress per surat';
			case 'progressHafalanPerJuz.ayatSelesai': return ({required Object completed, required Object total}) => '${completed} dari ${total} Ayat Selesai';
			case 'progressHafalanPerJuz.juzLabel': return ({required Object juz}) => 'Juz ${juz}';
			case 'progressHafalanPerJuz.kelasLabel': return ({required Object kelas}) => 'Kelas ${kelas}';
			case 'progressHafalanPerJuz.tambahTargetHafalan': return 'Tambah Target Hafalan';
			case 'progressHafalanPerJuz.warningBanner': return ({required Object juzLabels}) => 'Perhatian: ${juzLabels} belum diselesaikan. Pastikan santri tetap menyelesaikan target hafalan semester ini. Anda tetap dapat menambah target baru, namun target yang sudah ditetapkan wajib diselesaikan terlebih dahulu.';
			case 'progressHafalanPerJuz.cariJuz': return 'Cari Juz (contoh: Juz 1)';
			case 'progressHafalanPerJuz.surahCount': return ({required Object count}) => '${count} Surat';
			case 'progressHafalanPerJuz.targetBelumSelesai': return 'Target Belum Selesai';
			case 'progressHafalanPerJuz.confirmAddExtraJuzMessage': return ({required Object juzLabels, required Object nextJuz}) => '${juzLabels} belum diselesaikan semester ini.\n\nIngatkan santri untuk tetap menyelesaikan target yang sudah ditetapkan. Apakah Anda yakin ingin menambahkan Juz ${nextJuz} sebagai target tambahan?';
			case 'progressHafalanPerJuz.batal': return 'Batal';
			case 'progressHafalanPerJuz.yaTambahkan': return 'Ya, Tambahkan';
			case 'progressHafalanPerJuz.successAddTarget': return ({required Object juz}) => 'Juz ${juz} ditambahkan sebagai target';
			case 'progressHafalanPerJuz.failedSaveTarget': return 'Gagal menyimpan target, coba lagi';
			case 'progressHafalanPerJuz.tutup': return 'Tutup';
			case 'progressHafalanPerJuz.teacherCanAddHint': return 'Ketuk + untuk menambah target juz secara manual';
			case 'progressHafalanPerJuz.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'progressHafalanPerJuz.ayatCompletedInfo': return ({required Object completed, required Object total}) => '${completed} dari ${total} Ayat Selesai';
			case 'progressHafalanPerJuz.percent': return ({required Object percent}) => '${percent} %';
			case 'progressHafalanPerSurat.title': return 'Progress Per Surat';
			case 'progressHafalanPerSurat.detailJuz': return ({required Object juz}) => 'Detail Hafalan Juz ${juz}';
			case 'progressHafalanPerSurat.ayatDari': return ({required Object memorized, required Object total}) => 'Ayat ${memorized} dari ${total}';
			case 'progressHafalanPerSurat.selesai': return 'Selesai';
			case 'progressHafalanPerSurat.dalamProses': return 'Dalam Proses';
			case 'progressHafalanPerSurat.belumDimulai': return 'Belum Dimulai';
			case 'progressHafalanPerSurat.unknownSurah': return 'Tidak Diketahui';
			case 'progressHafalanPerSurat.juzTitle': return ({required Object juz}) => 'Juz ${juz}';
			case 'progressHafalanPerSurat.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'progressHafalanPerSurat.ayatCount': return ({required Object count}) => '${count} Ayat';
			case 'progressHafalanPerSurat.percent': return ({required Object percent}) => '${percent}%';
			case 'mutabaahSantri.title': return 'Mutaba\'ah Santri';
			case 'mutabaahSantri.hafalanBaru': return 'Hafalan Baru';
			case 'mutabaahSantri.murajaah': return 'Muraja\'ah';
			case 'mutabaahSantri.hari': return 'HARI';
			case 'mutabaahSantri.tgl': return 'TGL';
			case 'mutabaahSantri.surat': return 'SURAT';
			case 'mutabaahSantri.ayat': return 'AYAT';
			case 'mutabaahSantri.nilai': return 'NILAI';
			case 'mutabaahSantri.dayNames.0': return 'AHA';
			case 'mutabaahSantri.dayNames.1': return 'SEN';
			case 'mutabaahSantri.dayNames.2': return 'SEL';
			case 'mutabaahSantri.dayNames.3': return 'RAB';
			case 'mutabaahSantri.dayNames.4': return 'KAM';
			case 'mutabaahSantri.dayNames.5': return 'JUM';
			case 'mutabaahSantri.dayNames.6': return 'SAB';
			case 'mutabaahSantri.belumAdaHafalanBaru': return 'Belum ada hafalan baru';
			case 'mutabaahSantri.belumAdaMurajaah': return 'Belum ada muraja\'ah';
			case 'mutabaahSantri.suratCount': return ({required Object count}) => '${count} surat';
			case 'guruProfile.editProfile': return 'Edit Profile';
			case 'guruProfile.ubahPassword': return 'Ubah Password';
			case 'guruProfile.pengaturan': return 'Pengaturan';
			case 'guruProfile.tentangAplikasi': return 'Tentang Aplikasi';
			case 'guruProfile.keluar': return 'Keluar';
			case 'guruProfile.guruHalaqoh': return 'Guru Halaqoh';
			case 'guruProfile.appVersion': return ({required Object version}) => 'MyHalaqoh App v${version}';
			case 'guruProfile.loading': return 'Memuat...';
			case 'guruProfile.pengampu': return ({required Object halaqoh}) => 'Pengampu ${halaqoh}';
			case 'guruProfile.nipLabel': return ({required Object nip}) => 'NIP: ${nip}';
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
			case 'editProfile.pengampu': return ({required Object halaqoh}) => 'Pengampu ${halaqoh}';
			case 'editProfile.successMessage': return 'Profil berhasil diperbarui';
			case 'editProfile.failedMessage': return 'Gagal memperbarui profil';
			case 'editProfile.tryAgain': return 'Coba Lagi';
			case 'editProfile.saving': return 'Menyimpan...';
			case 'editProfile.nis': return 'NIS';
			case 'editProfile.kelas': return 'Kelas';
			case 'editProfile.program': return 'Program';
			case 'editProfile.kontakWali': return 'Kontak Wali';
			case 'editProfile.namaWali': return 'Nama Wali';
			case 'editProfile.hubungan': return 'Hubungan';
			case 'editProfile.pilihHubungan': return 'Pilih hubungan';
			case 'editProfile.hubunganOptions.0': return 'Ayah';
			case 'editProfile.hubunganOptions.1': return 'Ibu';
			case 'editProfile.hubunganOptions.2': return 'Saudara';
			case 'ubahPassword.title': return 'Ubah Password';
			case 'ubahPassword.subtitle': return 'Silakan masukkan kata sandi baru Anda untuk meningkatkan keamanan akun.';
			case 'ubahPassword.kataSandiLama': return 'Kata Sandi Lama';
			case 'ubahPassword.kataSandiBaru': return 'Kata Sandi Baru';
			case 'ubahPassword.konfirmasiKataSandiBaru': return 'Konfirmasi Kata Sandi Baru';
			case 'ubahPassword.syaratKeamanan': return 'SYARAT KEAMANAN';
			case 'ubahPassword.minimal8Karakter': return 'Minimal 8 karakter';
			case 'ubahPassword.kombinasiHurufDanAngka': return 'Kombinasi huruf dan angka';
			case 'ubahPassword.ubahKataSandi': return 'Ubah Kata Sandi';
			case 'ubahPassword.successMessage': return 'Password berhasil diubah';
			case 'ubahPassword.failedMessage': return 'Gagal mengubah password';
			case 'ubahPassword.errOldPasswordRequired': return 'Password lama wajib diisi';
			case 'ubahPassword.errNewPasswordRequired': return 'Password baru wajib diisi';
			case 'ubahPassword.errMin8Chars': return 'Minimal 8 karakter';
			case 'ubahPassword.errLetterNumberCombo': return 'Harus kombinasi huruf dan angka';
			case 'ubahPassword.errConfirmRequired': return 'Konfirmasi password wajib diisi';
			case 'ubahPassword.errMismatch': return 'Password tidak cocok';
			case 'ubahPassword.processing': return 'Memproses...';
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
			case 'waliSantriDashboard.loading': return 'Memuat...';
			case 'waliSantriDashboard.notRegisteredHalaqoh': return 'Belum terdaftar di Halaqoh mana pun';
			case 'waliSantriDashboard.nis': return ({required Object nis}) => 'NIS: ${nis}';
			case 'waliSantriDashboard.guru': return ({required Object name}) => 'Guru: ${name}';
			case 'waliSantriDashboard.extraMemorization': return 'Hafalan Tambahan (Ekstra)';
			case 'waliSantriDashboard.juzList': return ({required Object juz}) => 'Juz: ${juz}';
			case 'waliSantriDashboard.extraJuzTarget': return ({required Object count}) => 'Tambahan : ${count} Juz';
			case 'waliSantriDashboard.halaqohInfo': return ({required Object kelas, required Object halaqoh}) => 'Kelas ${kelas} | ${halaqoh}';
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
			case 'WaliSantriPengaturanScreen.notifikasi': return 'Notifikasi';
			case 'WaliSantriPengaturanScreen.notifikasiAktif': return 'Aktif';
			case 'WaliSantriPengaturanScreen.notifikasiNonAktif': return 'Nonaktif';
			case 'WaliSantriPengaturanScreen.notifikasiDialogTitle': return 'Aktifkan Notifikasi';
			case 'WaliSantriPengaturanScreen.notifikasiDialogMessage': return 'Izin notifikasi belum diberikan. Buka Pengaturan HP Anda, aktifkan izin notifikasi untuk aplikasi ini, lalu kembali dan coba lagi.';
			case 'WaliSantriPengaturanScreen.bukaSettingHp': return 'Buka Pengaturan';
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
			case 'tentangAplikasiScreen.title': return 'Tentang Aplikasi';
			case 'tentangAplikasiScreen.appName': return 'MyHalaqoh';
			case 'tentangAplikasiScreen.tagline': return 'Platform Digital Manajemen Halaqoh';
			case 'tentangAplikasiScreen.version': return 'Versi';
			case 'tentangAplikasiScreen.sectionTentang': return 'Tentang MyHalaqoh';
			case 'tentangAplikasiScreen.deskripsi1': return 'MyHalaqoh adalah platform digital terpadu yang dirancang khusus untuk membantu pengelolaan halaqoh di lingkungan pesantren secara efisien, transparan, dan mudah diakses.';
			case 'tentangAplikasiScreen.deskripsi2': return ({required Object pesantren}) => 'Dikembangkan khusus untuk ${pesantren}, aplikasi ini menghubungkan Admin, Guru, dan Wali Santri dalam satu ekosistem digital yang terintegrasi.';
			case 'tentangAplikasiScreen.sectionFitur': return 'Fitur Unggulan';
			case 'tentangAplikasiScreen.fiturAbsensiJudul': return 'Absensi QR Code';
			case 'tentangAplikasiScreen.fiturAbsensiDesc': return 'Rekam kehadiran santri dengan cepat menggunakan barcode scanner terintegrasi.';
			case 'tentangAplikasiScreen.fiturHafalanJudul': return 'Hafalan Al-Quran';
			case 'tentangAplikasiScreen.fiturHafalanDesc': return 'Pantau progress hafalan santri per juz dan per surat secara real-time.';
			case 'tentangAplikasiScreen.fiturNotifJudul': return 'Notifikasi Otomatis';
			case 'tentangAplikasiScreen.fiturNotifDesc': return 'Informasi absensi dan hafalan dikirim langsung ke Wali Santri via push notification.';
			case 'tentangAplikasiScreen.fiturMultiRoleJudul': return 'Multi-Role Dashboard';
			case 'tentangAplikasiScreen.fiturMultiRoleDesc': return 'Tampilan dan fitur yang disesuaikan untuk Admin, Guru, dan Wali Santri.';
			case 'tentangAplikasiScreen.fiturOfflineJudul': return 'Mode Offline';
			case 'tentangAplikasiScreen.fiturOfflineDesc': return 'Absensi dan hafalan tetap bisa direkam meskipun tanpa koneksi internet.';
			case 'tentangAplikasiScreen.sectionInfo': return 'Informasi Aplikasi';
			case 'tentangAplikasiScreen.infoNamaApp': return 'Nama Aplikasi';
			case 'tentangAplikasiScreen.infoVersi': return 'Versi';
			case 'tentangAplikasiScreen.infoPlatform': return 'Platform';
			case 'tentangAplikasiScreen.infoLembaga': return 'Lembaga';
			case 'tentangAplikasiScreen.infoPlatformValue': return 'Android';
			case 'tentangAplikasiScreen.sectionKontak': return 'Kontak & Dukungan';
			case 'tentangAplikasiScreen.kontakDeskripsi': return 'Jika Anda memerlukan bantuan teknis atau memiliki pertanyaan seputar aplikasi, silakan hubungi administrator melalui WhatsApp.';
			case 'tentangAplikasiScreen.kontakButton': return 'Hubungi Admin via WhatsApp';
			case 'tentangAplikasiScreen.footer': return 'Dibuat dengan ❤️ untuk kemajuan pendidikan pesantren';
			case 'tentangAplikasiScreen.copyright': return '© 2026 MyHalaqoh. All rights reserved.';
			case 'general.warning': return 'Peringatan';
			case 'general.close': return 'Tutup';
			case 'general.saving': return 'Menyimpan...';
			case 'general.done': return 'Selesai';
			case 'general.active': return 'AKTIF';
			case 'general.confirmation': return 'Konfirmasi';
			case 'general.yesProcess': return 'Ya, Proses';
			case 'calendar.months.0': return 'Januari';
			case 'calendar.months.1': return 'Februari';
			case 'calendar.months.2': return 'Maret';
			case 'calendar.months.3': return 'April';
			case 'calendar.months.4': return 'Mei';
			case 'calendar.months.5': return 'Juni';
			case 'calendar.months.6': return 'Juli';
			case 'calendar.months.7': return 'Agustus';
			case 'calendar.months.8': return 'September';
			case 'calendar.months.9': return 'Oktober';
			case 'calendar.months.10': return 'November';
			case 'calendar.months.11': return 'Desember';
			case 'calendar.daysAbbr.0': return 'SEN';
			case 'calendar.daysAbbr.1': return 'SEL';
			case 'calendar.daysAbbr.2': return 'RAB';
			case 'calendar.daysAbbr.3': return 'KAM';
			case 'calendar.daysAbbr.4': return 'JUM';
			case 'calendar.daysAbbr.5': return 'SAB';
			case 'calendar.daysAbbr.6': return 'AHA';
			case 'calendar.daysAbbrSundayFirst.0': return 'AHA';
			case 'calendar.daysAbbrSundayFirst.1': return 'SEN';
			case 'calendar.daysAbbrSundayFirst.2': return 'SEL';
			case 'calendar.daysAbbrSundayFirst.3': return 'RAB';
			case 'calendar.daysAbbrSundayFirst.4': return 'KAM';
			case 'calendar.daysAbbrSundayFirst.5': return 'JUM';
			case 'calendar.daysAbbrSundayFirst.6': return 'SAB';
			case 'laporanConfig.titleAbsensi': return 'Unduh Laporan Absensi';
			case 'laporanConfig.titleHafalan': return 'Unduh Laporan Hafalan';
			case 'laporanConfig.titleHalaqoh': return 'Rekap Absensi Halaqoh';
			case 'laporanConfig.subtitleAbsensi': return 'Pilih periode & konfigurasi laporan PDF santri.';
			case 'laporanConfig.subtitleHafalan': return 'Pilih periode & konfigurasi laporan PDF santri.';
			case 'laporanConfig.subtitleHalaqoh': return 'Pilih periode untuk mengunduh rekapitulasi satu halaqoh penuh.';
			case 'laporanConfig.timeRange': return 'Rentang Waktu';
			case 'laporanConfig.weekly': return 'Mingguan';
			case 'laporanConfig.monthly': return 'Bulanan';
			case 'laporanConfig.custom': return 'Kustom';
			case 'laporanConfig.semester': return 'Semester';
			case 'laporanConfig.selectDateRange': return 'Pilih Rentang Tanggal';
			case 'laporanConfig.startDate': return 'Tanggal Awal';
			case 'laporanConfig.endDate': return 'Tanggal Akhir';
			case 'laporanConfig.selectDateHint': return 'Pilih tanggal';
			case 'laporanConfig.chooseStartDate': return 'Pilih Tanggal Awal';
			case 'laporanConfig.chooseEndDate': return 'Pilih Tanggal Akhir';
			case 'laporanConfig.btnSelect': return 'Pilih';
			case 'laporanConfig.btnCancel': return 'Batal';
			case 'laporanConfig.totalDaysSelected': return ({required Object days}) => 'Total ${days} hari dipilih';
			case 'laporanConfig.reportPeriod': return 'Periode Laporan';
			case 'laporanConfig.daysShort': return ({required Object days}) => '${days} hr';
			case 'laporanConfig.btnGeneratePdf': return 'Buat Laporan PDF';
			case 'laporanConfig.btnGenerateRecapPdf': return 'Buat Rekapan PDF';
			case 'laporanConfig.generatingReport': return 'Membuat laporan...';
			case 'laporanConfig.readyTitle': return 'Laporan Siap!';
			case 'laporanConfig.readyRecapTitle': return 'Rekapan Siap!';
			case 'laporanConfig.readySubtitle': return 'PDF berhasil dibuat. Pratinjau atau bagikan sekarang.';
			case 'laporanConfig.attendanceReport': return 'Laporan Absensi';
			case 'laporanConfig.recapAttendance': return 'Rekap Absensi';
			case 'laporanConfig.memorizationReport': return 'Laporan Hafalan';
			case 'laporanConfig.btnPreview': return 'Pratinjau';
			case 'laporanConfig.btnShare': return 'Bagikan';
			case 'laporanConfig.btnCreateNewReport': return 'Buat laporan baru';
			case 'laporanConfig.btnCreateNewRecap': return 'Buat rekapan baru';
			case 'laporanConfig.errGenerate': return ({required Object error}) => 'Gagal membuat laporan: ${error}';
			case 'laporanConfig.errPreview': return ({required Object error}) => 'Gagal membuka pratinjau: ${error}';
			case 'laporanConfig.errShare': return ({required Object error}) => 'Gagal berbagi laporan: ${error}';
			case 'laporanConfig.pdf.shubuh': return 'Shubuh';
			case 'laporanConfig.pdf.dhuha': return 'Dhuha';
			case 'laporanConfig.pdf.siang': return 'Siang';
			case 'laporanConfig.pdf.ashar': return 'Ashar';
			case 'laporanConfig.pdf.maghrib': return 'Maghrib';
			case 'laporanConfig.pdf.presentCode': return 'H';
			case 'laporanConfig.pdf.sickCode': return 'S';
			case 'laporanConfig.pdf.permitCode': return 'I';
			case 'laporanConfig.pdf.absentCode': return 'A';
			case 'laporanConfig.pdf.systemName': return 'MyHalaqoh — Sistem Manajemen Halaqoh';
			case 'laporanConfig.pdf.pageLabel': return ({required Object page, required Object total}) => 'Halaman ${page} dari ${total}';
			case 'laporanConfig.pdf.titleAttendance': return 'Laporan Kehadiran Santri';
			case 'laporanConfig.pdf.titleHalaqohRecap': return 'Laporan Rekapitulasi Absensi Halaqoh';
			case 'laporanConfig.pdf.titleMemorization': return 'Laporan Capaian Hafalan Santri';
			case 'laporanConfig.pdf.printedAt': return ({required Object date}) => 'Dicetak: ${date}';
			case 'laporanConfig.pdf.studentInfo': return 'Informasi Santri';
			case 'laporanConfig.pdf.halaqohInfo': return 'Informasi Halaqoh';
			case 'laporanConfig.pdf.studentName': return 'Nama Santri';
			case 'laporanConfig.pdf.nameHeader': return 'Nama';
			case 'laporanConfig.pdf.kehadiranHeader': return 'Kehadiran';
			case 'laporanConfig.pdf.maxHeader': return 'Max';
			case 'laporanConfig.pdf.hdrHeader': return 'Hdr';
			case 'laporanConfig.pdf.nis': return 'NIS';
			case 'laporanConfig.pdf.halaqoh': return 'Halaqoh';
			case 'laporanConfig.pdf.pembimbing': return 'Pembimbing';
			case 'laporanConfig.pdf.musyrif': return 'Musyrif';
			case 'laporanConfig.pdf.program': return 'Program';
			case 'laporanConfig.pdf.reportType': return 'Jenis Laporan';
			case 'laporanConfig.pdf.summaryAttendance': return 'Ringkasan Kehadiran';
			case 'laporanConfig.pdf.summaryMemorization': return 'Ringkasan Capaian';
			case 'laporanConfig.pdf.present': return 'Hadir';
			case 'laporanConfig.pdf.sick': return 'Sakit';
			case 'laporanConfig.pdf.permit': return 'Izin';
			case 'laporanConfig.pdf.absent': return 'Alfa';
			case 'laporanConfig.pdf.ziyadah': return 'Ziyadah';
			case 'laporanConfig.pdf.murajaah': return 'Muraja\'ah';
			case 'laporanConfig.pdf.attendanceRate': return 'Tingkat Kehadiran';
			case 'laporanConfig.pdf.avgScore': return 'Nilai Rata-rata';
			case 'laporanConfig.pdf.totalScheduled': return ({required Object hadir, required Object total}) => '${hadir} dari ${total} sesi terjadwal';
			case 'laporanConfig.pdf.dailyDetailTitle': return 'Detail Kehadiran Harian';
			case 'laporanConfig.pdf.setoranDetailTitle': return 'Detail Setoran Hafalan';
			case 'laporanConfig.pdf.predikat.mumtaz': return 'Mumtaz';
			case 'laporanConfig.pdf.predikat.jayyid': return 'Jayyid';
			case 'laporanConfig.pdf.predikat.maqbul': return 'Maqbul';
			case 'laporanConfig.pdf.weeksLabel': return ({required Object index, required Object start, required Object end}) => 'Pekan ke-${index}  (${start} – ${end})';
			case 'laporanConfig.pdf.no': return 'No.';
			case 'laporanConfig.pdf.dateHeader': return 'Hari, Tanggal';
			case 'laporanConfig.pdf.dayHeader': return 'Hari';
			case 'laporanConfig.pdf.typeHeader': return 'Tipe';
			case 'laporanConfig.pdf.dateShort': return 'Tanggal';
			case 'laporanConfig.pdf.surahAyatHeader': return 'Surah / Ayat';
			case 'laporanConfig.pdf.baruCode': return 'Baru';
			case 'laporanConfig.pdf.ulangCode': return 'Ulang';
			case 'laporanConfig.pdf.ziyadahLabel': return 'Ziyadah (Hafalan Baru)';
			case 'laporanConfig.pdf.murajaahLabel': return 'Muraja\'ah (Ulang)';
			case 'laporanConfig.pdf.juzHeader': return 'Juz';
			case 'laporanConfig.pdf.surahDetailHeader': return 'Detail Surat';
			case 'laporanConfig.pdf.kelancaranHeader': return 'Kelancaran';
			case 'laporanConfig.pdf.tajwidHeader': return 'Tajwid';
			case 'laporanConfig.pdf.avgHeader': return 'Rata-rata';
			case 'laporanConfig.pdf.predikatHeader': return 'Predikat';
			case 'laporanConfig.pdf.hadirLabel': return 'Hadir';
			case 'laporanConfig.pdf.sakitLabel': return 'Sakit';
			case 'laporanConfig.pdf.izinLabel': return 'Izin';
			case 'laporanConfig.pdf.alfaLabel': return 'Alfa';
			case 'laporanConfig.pdf.keteranganLabel': return 'Keterangan';
			case 'laporanConfig.pdf.legenda': return 'Legenda';
			case 'laporanConfig.pdf.noSession': return 'Tidak ada sesi';
			case 'laporanConfig.pdf.statusLegenda': return 'H = Hadir  |  S = Sakit  |  I = Izin  |  A = Alfa';
			case 'laporanConfig.pdf.predikatLegenda': return 'Mumtaz: 85 - 100  |  Jayyid: 70 - 84  |  Maqbul: < 70';
			case 'laporanConfig.pdf.pekanShort': return ({required Object index}) => 'Pekan ke-${index}';
			case 'kelasProgram.title': return 'Kelola Kelas & Program';
			case 'kelasProgram.kelasTab': return 'Kelas';
			case 'kelasProgram.programTab': return 'Program';
			case 'kelasProgram.belumAdaKelas': return 'Belum ada data kelas';
			case 'kelasProgram.kelasNama': return ({required Object nama}) => 'Kelas ${nama}';
			case 'kelasProgram.urutanPromosi': return ({required Object urutan, required Object nextKelas}) => 'Urutan: ${urutan} | Promosi ke: ${nextKelas}';
			case 'kelasProgram.lulusAlumni': return 'Lulus (Alumni)';
			case 'kelasProgram.belumAdaProgram': return 'Belum ada data program';
			case 'kelasProgram.programId': return ({required Object id}) => 'ID: ${id}';
			case 'kelasProgram.tambahKelas': return 'Tambah Kelas';
			case 'kelasProgram.editKelas': return 'Edit Kelas';
			case 'kelasProgram.namaKelas': return 'Nama Kelas';
			case 'kelasProgram.namaKelasHint': return 'e.g. 7, 8, atau A, B';
			case 'kelasProgram.namaKelasRequired': return 'Nama kelas harus diisi';
			case 'kelasProgram.urutanKelas': return 'Urutan Kelas';
			case 'kelasProgram.urutanKelasHint': return 'e.g. Angka urutan kelas untuk promosi';
			case 'kelasProgram.urutanRequired': return 'Urutan harus diisi';
			case 'kelasProgram.urutanNumeric': return 'Urutan harus berupa angka';
			case 'kelasProgram.kelasSelanjutnya': return 'Kelas Selanjutnya';
			case 'kelasProgram.pilihKelasSelanjutnya': return 'Pilih Kelas Selanjutnya';
			case 'kelasProgram.batal': return 'Batal';
			case 'kelasProgram.simpan': return 'Simpan';
			case 'kelasProgram.gagalMenyimpan': return ({required Object error}) => 'Gagal menyimpan: ${error}';
			case 'kelasProgram.hapusKelas': return 'Hapus Kelas';
			case 'kelasProgram.hapusKelasConfirm': return ({required Object nama}) => 'Apakah Anda yakin ingin menghapus Kelas ${nama}? Tindakan ini tidak dapat dibatalkan.';
			case 'kelasProgram.hapus': return 'Hapus';
			case 'kelasProgram.gagalMenghapusKelas': return 'Gagal menghapus kelas';
			case 'kelasProgram.tambahProgram': return 'Tambah Program';
			case 'kelasProgram.editProgram': return 'Edit Program';
			case 'kelasProgram.kodeProgram': return 'Kode Program';
			case 'kelasProgram.kodeProgramHint': return 'e.g. R, T, atau TH';
			case 'kelasProgram.kodeProgramRequired': return 'Kode program harus diisi';
			case 'kelasProgram.namaProgram': return 'Nama Program';
			case 'kelasProgram.namaProgramHint': return 'e.g. Reguler, Takhassus, atau Tahfidz';
			case 'kelasProgram.namaProgramRequired': return 'Nama program harus diisi';
			case 'kelasProgram.hapusProgram': return 'Hapus Program';
			case 'kelasProgram.hapusProgramConfirm': return ({required Object nama, required Object id}) => 'Apakah Anda yakin ingin menghapus program "${nama}" (${id})? Tindakan ini tidak dapat dibatalkan.';
			case 'kelasProgram.gagalMenghapusProgram': return 'Gagal menghapus program';
			case 'kelasProgram.aturKelasProgram': return 'Atur kelas & program';
			case 'superAdmin.pickerTitle': return 'Pilih Mode Akses';
			case 'superAdmin.pickerSubtitle': return 'Masuk sebagai';
			case 'superAdmin.accessAsAdmin': return 'Akses sebagai Admin';
			case 'superAdmin.accessAsAdminDesc': return 'Kelola guru, santri, halaqoh, dan target hafalan';
			case 'superAdmin.accessAsGuru': return 'Akses sebagai Guru';
			case 'superAdmin.accessAsGuruDesc': return 'Pilih guru dan masuk ke fitur absensi & hafalan';
			case 'superAdmin.accessAsWali': return 'Akses sebagai Wali Santri';
			case 'superAdmin.accessAsWaliDesc': return 'Pilih santri dan lihat progress & absensi mereka';
			case 'superAdmin.viewActivityLog': return 'Lihat Log Aktivitas';
			case 'superAdmin.modeLabel': return ({required Object role, required Object name}) => 'Mode ${role}: ${name}';
			case 'superAdmin.exitMode': return 'Keluar';
			case 'superAdmin.exitModeTooltip': return 'Keluar dari mode impersonasi';
			case 'superAdmin.guruPickerTitle': return 'Pilih Guru';
			case 'superAdmin.santriPickerTitle': return 'Pilih Santri';
			case 'superAdmin.searchGuru': return 'Cari guru...';
			case 'superAdmin.searchSantri': return 'Cari santri...';
			case 'activityLog.title': return 'Log Aktivitas';
			case 'activityLog.filterRole': return 'Filter Role';
			case 'activityLog.filterModule': return 'Filter Modul';
			case 'activityLog.filterAction': return 'Filter Aksi';
			case 'activityLog.filterDateFrom': return 'Dari Tanggal';
			case 'activityLog.filterDateTo': return 'Sampai Tanggal';
			case 'activityLog.allRoles': return 'Semua Role';
			case 'activityLog.allModules': return 'Semua Modul';
			case 'activityLog.allActions': return 'Semua Aksi';
			case 'activityLog.empty': return 'Belum ada log aktivitas';
			case 'activityLog.resetFilter': return 'Reset Filter';
			default: return null;
		}
	}
}

