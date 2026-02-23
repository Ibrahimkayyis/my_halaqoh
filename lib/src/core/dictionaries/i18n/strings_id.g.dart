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
	@override String get passwordHint => 'Masukkan password anda';
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
			case 'auth.passwordHint': return 'Masukkan password anda';
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
			default: return null;
		}
	}
}

