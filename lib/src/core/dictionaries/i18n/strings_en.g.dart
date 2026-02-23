///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsSplashEn splash = TranslationsSplashEn._(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsDashboardEn dashboard = TranslationsDashboardEn._(_root);
	late final TranslationsSantriEn santri = TranslationsSantriEn._(_root);
	late final TranslationsGuruEn guru = TranslationsGuruEn._(_root);
	late final TranslationsHalaqohEn halaqoh = TranslationsHalaqohEn._(_root);
	late final TranslationsTargetHafalanEn targetHafalan = TranslationsTargetHafalanEn._(_root);
	late final TranslationsEditTargetEn editTarget = TranslationsEditTargetEn._(_root);
	late final TranslationsNavEn nav = TranslationsNavEn._(_root);
	late final TranslationsAddDataEn addData = TranslationsAddDataEn._(_root);
	late final TranslationsAddHalaqohEn addHalaqoh = TranslationsAddHalaqohEn._(_root);
	late final TranslationsSelectSantriEn selectSantri = TranslationsSelectSantriEn._(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'MyHalaqoh'
	String get title => 'MyHalaqoh';

	/// en: 'Attendance'
	String get attendance => 'Attendance';

	/// en: 'Memorization'
	String get hafalan => 'Memorization';

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: splash
class TranslationsSplashEn {
	TranslationsSplashEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Halaqoh Management System'
	String get subtitle => 'Halaqoh Management System';

	/// en: 'v1.0.0'
	String get version => 'v1.0.0';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get loginTitle => 'Login';

	/// en: 'Sign in to your account'
	String get loginSubtitle => 'Sign in to your account';

	/// en: 'NIP / NIS'
	String get usernameLabel => 'NIP / NIS';

	/// en: 'Enter your NIP/NIS'
	String get usernameHint => 'Enter your NIP/NIS';

	/// en: 'PASSWORD'
	String get passwordLabel => 'PASSWORD';

	/// en: 'Enter your password'
	String get passwordHint => 'Enter your password';

	/// en: 'Forgot Password?'
	String get forgotPassword => 'Forgot Password?';

	/// en: 'LOGIN'
	String get loginButton => 'LOGIN';

	/// en: 'NIP/NIS and Password cannot be empty'
	String get validationEmpty => 'NIP/NIS and Password cannot be empty';

	/// en: 'Invalid credentials. Use admin/admin, NIP (13 digits), or NIS (12 digits).'
	String get validationInvalid => 'Invalid credentials. Use admin/admin, NIP (13 digits), or NIS (12 digits).';
}

// Path: dashboard
class TranslationsDashboardEn {
	TranslationsDashboardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome,'
	String get greeting => 'Welcome,';

	/// en: 'Admin'
	String get admin => 'Admin';

	/// en: 'Total Santri'
	String get totalSantri => 'Total Santri';

	/// en: 'Total Guru'
	String get totalGuru => 'Total Guru';

	/// en: 'Total Halaqoh'
	String get totalHalaqoh => 'Total Halaqoh';

	/// en: 'Main Menu'
	String get menuUtama => 'Main Menu';

	/// en: 'Manage Santri'
	String get kelolaSantri => 'Manage Santri';

	/// en: 'Manage Guru'
	String get kelolaGuru => 'Manage Guru';

	/// en: 'Manage Halaqoh'
	String get kelolaHalaqoh => 'Manage Halaqoh';

	/// en: 'Manage Target'
	String get kelolaTarget => 'Manage Target';

	/// en: '261 Santri'
	String get santriCount => '261 Santri';

	/// en: '28 Guru'
	String get guruCount => '28 Guru';

	/// en: '20 Halaqoh'
	String get halaqohCount => '20 Halaqoh';

	/// en: 'Per Class'
	String get perKelas => 'Per Class';
}

// Path: santri
class TranslationsSantriEn {
	TranslationsSantriEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Data Santri'
	String get title => 'Data Santri';

	/// en: 'Search Santri'
	String get searchHint => 'Search Santri';

	/// en: 'Showing $count Santri'
	String showCount({required Object count}) => 'Showing ${count} Santri';

	/// en: 'IDENTITY'
	String get identitas => 'IDENTITY';

	/// en: 'CLASS'
	String get kelas => 'CLASS';

	/// en: 'ACTION'
	String get aksi => 'ACTION';

	/// en: 'Filter'
	String get filter => 'Filter';
}

// Path: guru
class TranslationsGuruEn {
	TranslationsGuruEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Data Guru'
	String get title => 'Data Guru';

	/// en: 'Search Guru'
	String get searchHint => 'Search Guru';

	/// en: 'Showing $count Guru'
	String showCount({required Object count}) => 'Showing ${count} Guru';

	/// en: 'IDENTITY'
	String get identitas => 'IDENTITY';

	/// en: 'ACTION'
	String get aksi => 'ACTION';

	/// en: 'Filter'
	String get filter => 'Filter';
}

// Path: halaqoh
class TranslationsHalaqohEn {
	TranslationsHalaqohEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Data Halaqoh'
	String get title => 'Data Halaqoh';

	/// en: 'Search Halaqoh'
	String get searchHint => 'Search Halaqoh';

	/// en: 'Showing $count Halaqoh'
	String showCount({required Object count}) => 'Showing ${count} Halaqoh';

	/// en: 'Sort'
	String get sort => 'Sort';

	/// en: '$count Santri'
	String santriCount({required Object count}) => '${count} Santri';

	/// en: 'Class $kelas'
	String kelasLabel({required Object kelas}) => 'Class ${kelas}';
}

// Path: targetHafalan
class TranslationsTargetHafalanEn {
	TranslationsTargetHafalanEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memorization Target'
	String get title => 'Memorization Target';

	/// en: 'REGULAR'
	String get reguler => 'REGULAR';

	/// en: 'TAKHASSUS'
	String get takhassus => 'TAKHASSUS';

	/// en: 'Set memorization targets for each class, the target will be applied to all students in that class.'
	String get infoText => 'Set memorization targets for each class, the target will be applied to all students in that class.';

	/// en: 'Class'
	String get kelasLabel => 'Class';

	/// en: 'Target: $count Juz'
	String targetJuz({required Object count}) => 'Target: ${count} Juz';

	/// en: 'Juz $range'
	String juzRange({required Object range}) => 'Juz ${range}';

	/// en: 'SMP'
	String get smp => 'SMP';
}

// Path: editTarget
class TranslationsEditTargetEn {
	TranslationsEditTargetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Memorization Target'
	String get title => 'Edit Memorization Target';

	/// en: 'ACADEMIC YEAR'
	String get tahunAjaran => 'ACADEMIC YEAR';

	/// en: 'SELECT JUZ'
	String get pilihJuz => 'SELECT JUZ';

	/// en: 'TOTAL TARGET'
	String get totalTarget => 'TOTAL TARGET';

	/// en: '$count Juz'
	String totalJuz({required Object count}) => '${count} Juz';

	/// en: 'Save Changes'
	String get simpanPerubahan => 'Save Changes';
}

// Path: nav
class TranslationsNavEn {
	TranslationsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dashboard'
	String get dashboard => 'Dashboard';

	/// en: 'Santri'
	String get santri => 'Santri';

	/// en: 'Guru'
	String get guru => 'Guru';

	/// en: 'Halaqoh'
	String get halaqoh => 'Halaqoh';

	/// en: 'Target'
	String get target => 'Target';
}

// Path: addData
class TranslationsAddDataEn {
	TranslationsAddDataEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Data'
	String get title => 'Add Data';

	/// en: 'Choose your preferred data input method'
	String get subtitle => 'Choose your preferred data input method';

	/// en: 'Manual Input'
	String get inputManual => 'Manual Input';

	/// en: 'Fill in the form one by one in detail'
	String get inputManualDesc => 'Fill in the form one by one in detail';

	/// en: 'Upload Excel/CSV File'
	String get uploadExcel => 'Upload Excel/CSV File';

	/// en: 'Import large amounts of data from a file'
	String get uploadExcelDesc => 'Import large amounts of data from a file';

	/// en: 'Add Santri Manual'
	String get addSantriManual => 'Add Santri Manual';

	/// en: 'Add Guru Manual'
	String get addGuruManual => 'Add Guru Manual';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'Student ID Number'
	String get nisHint => 'Student ID Number';

	/// en: 'NIP'
	String get nip => 'NIP';

	/// en: 'Teacher ID Number'
	String get nipHint => 'Teacher ID Number';

	/// en: 'Full Name'
	String get namaLengkap => 'Full Name';

	/// en: 'Student full name'
	String get namaSantriHint => 'Student full name';

	/// en: 'Teacher full name'
	String get namaGuruHint => 'Teacher full name';

	/// en: 'Class'
	String get kelas => 'Class';

	/// en: 'Select Class'
	String get kelasHint => 'Select Class';

	/// en: 'Phone Number'
	String get nomorHp => 'Phone Number';

	/// en: 'Example: 08123456789'
	String get nomorHpHint => 'Example: 08123456789';

	/// en: 'Simpan'
	String get simpan => 'Simpan';

	/// en: 'Bulk Add Data'
	String get bulkTitle => 'Bulk Add Data';

	/// en: 'Import data automatically using an Excel file.'
	String get bulkSubtitle => 'Import data automatically using an Excel file.';

	/// en: 'Tap to upload Excel file'
	String get bulkTapUpload => 'Tap to upload Excel file';

	/// en: 'Format .xlsx or .csv (Max. 5MB)'
	String get bulkFormat => 'Format .xlsx or .csv (Max. 5MB)';

	/// en: 'Upload Now'
	String get bulkUploadButton => 'Upload Now';
}

// Path: addHalaqoh
class TranslationsAddHalaqohEn {
	TranslationsAddHalaqohEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add New Halaqoh'
	String get title => 'Add New Halaqoh';

	/// en: 'Halaqoh Name'
	String get namaHalaqoh => 'Halaqoh Name';

	/// en: 'Example: Halaqoh 7A'
	String get namaHalaqohHint => 'Example: Halaqoh 7A';

	/// en: 'Class'
	String get kelas => 'Class';

	/// en: 'Select Class'
	String get kelasHint => 'Select Class';

	/// en: 'Program'
	String get program => 'Program';

	/// en: 'Select Program'
	String get programHint => 'Select Program';

	/// en: 'Instructor (Teacher)'
	String get pengampu => 'Instructor (Teacher)';

	/// en: 'Search instructor name...'
	String get pengampuHint => 'Search instructor name...';

	/// en: 'Santri List'
	String get daftarSantri => 'Santri List';

	/// en: '+ Add Santri'
	String get tambahSantri => '+ Add Santri';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'STUDENT NAME'
	String get namaSantri => 'STUDENT NAME';

	/// en: 'ACTION'
	String get aksi => 'ACTION';

	/// en: 'Total: $count Santri selected'
	String totalTerpilih({required Object count}) => 'Total: ${count} Santri selected';

	/// en: 'SAVE HALAQOH'
	String get simpanHalaqoh => 'SAVE HALAQOH';
}

// Path: selectSantri
class TranslationsSelectSantriEn {
	TranslationsSelectSantriEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select Santri'
	String get title => 'Select Santri';

	/// en: 'Search name or NIS...'
	String get searchHint => 'Search name or NIS...';

	/// en: 'FILTER'
	String get filter => 'FILTER';

	/// en: '$count Santri'
	String countLabel({required Object count}) => '${count} Santri';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'NAME'
	String get nama => 'NAME';

	/// en: 'CLASS'
	String get kelas => 'CLASS';

	/// en: 'ADD ($count) SANTRI'
	String tambahkanButton({required Object count}) => 'ADD (${count}) SANTRI';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return 'MyHalaqoh';
			case 'app.attendance': return 'Attendance';
			case 'app.hafalan': return 'Memorization';
			case 'app.login': return 'Login';
			case 'app.logout': return 'Logout';
			case 'splash.subtitle': return 'Halaqoh Management System';
			case 'splash.version': return 'v1.0.0';
			case 'auth.loginTitle': return 'Login';
			case 'auth.loginSubtitle': return 'Sign in to your account';
			case 'auth.usernameLabel': return 'NIP / NIS';
			case 'auth.usernameHint': return 'Enter your NIP/NIS';
			case 'auth.passwordLabel': return 'PASSWORD';
			case 'auth.passwordHint': return 'Enter your password';
			case 'auth.forgotPassword': return 'Forgot Password?';
			case 'auth.loginButton': return 'LOGIN';
			case 'auth.validationEmpty': return 'NIP/NIS and Password cannot be empty';
			case 'auth.validationInvalid': return 'Invalid credentials. Use admin/admin, NIP (13 digits), or NIS (12 digits).';
			case 'dashboard.greeting': return 'Welcome,';
			case 'dashboard.admin': return 'Admin';
			case 'dashboard.totalSantri': return 'Total Santri';
			case 'dashboard.totalGuru': return 'Total Guru';
			case 'dashboard.totalHalaqoh': return 'Total Halaqoh';
			case 'dashboard.menuUtama': return 'Main Menu';
			case 'dashboard.kelolaSantri': return 'Manage Santri';
			case 'dashboard.kelolaGuru': return 'Manage Guru';
			case 'dashboard.kelolaHalaqoh': return 'Manage Halaqoh';
			case 'dashboard.kelolaTarget': return 'Manage Target';
			case 'dashboard.santriCount': return '261 Santri';
			case 'dashboard.guruCount': return '28 Guru';
			case 'dashboard.halaqohCount': return '20 Halaqoh';
			case 'dashboard.perKelas': return 'Per Class';
			case 'santri.title': return 'Data Santri';
			case 'santri.searchHint': return 'Search Santri';
			case 'santri.showCount': return ({required Object count}) => 'Showing ${count} Santri';
			case 'santri.identitas': return 'IDENTITY';
			case 'santri.kelas': return 'CLASS';
			case 'santri.aksi': return 'ACTION';
			case 'santri.filter': return 'Filter';
			case 'guru.title': return 'Data Guru';
			case 'guru.searchHint': return 'Search Guru';
			case 'guru.showCount': return ({required Object count}) => 'Showing ${count} Guru';
			case 'guru.identitas': return 'IDENTITY';
			case 'guru.aksi': return 'ACTION';
			case 'guru.filter': return 'Filter';
			case 'halaqoh.title': return 'Data Halaqoh';
			case 'halaqoh.searchHint': return 'Search Halaqoh';
			case 'halaqoh.showCount': return ({required Object count}) => 'Showing ${count} Halaqoh';
			case 'halaqoh.sort': return 'Sort';
			case 'halaqoh.santriCount': return ({required Object count}) => '${count} Santri';
			case 'halaqoh.kelasLabel': return ({required Object kelas}) => 'Class ${kelas}';
			case 'targetHafalan.title': return 'Memorization Target';
			case 'targetHafalan.reguler': return 'REGULAR';
			case 'targetHafalan.takhassus': return 'TAKHASSUS';
			case 'targetHafalan.infoText': return 'Set memorization targets for each class, the target will be applied to all students in that class.';
			case 'targetHafalan.kelasLabel': return 'Class';
			case 'targetHafalan.targetJuz': return ({required Object count}) => 'Target: ${count} Juz';
			case 'targetHafalan.juzRange': return ({required Object range}) => 'Juz ${range}';
			case 'targetHafalan.smp': return 'SMP';
			case 'editTarget.title': return 'Edit Memorization Target';
			case 'editTarget.tahunAjaran': return 'ACADEMIC YEAR';
			case 'editTarget.pilihJuz': return 'SELECT JUZ';
			case 'editTarget.totalTarget': return 'TOTAL TARGET';
			case 'editTarget.totalJuz': return ({required Object count}) => '${count} Juz';
			case 'editTarget.simpanPerubahan': return 'Save Changes';
			case 'nav.dashboard': return 'Dashboard';
			case 'nav.santri': return 'Santri';
			case 'nav.guru': return 'Guru';
			case 'nav.halaqoh': return 'Halaqoh';
			case 'nav.target': return 'Target';
			case 'addData.title': return 'Add Data';
			case 'addData.subtitle': return 'Choose your preferred data input method';
			case 'addData.inputManual': return 'Manual Input';
			case 'addData.inputManualDesc': return 'Fill in the form one by one in detail';
			case 'addData.uploadExcel': return 'Upload Excel/CSV File';
			case 'addData.uploadExcelDesc': return 'Import large amounts of data from a file';
			case 'addData.addSantriManual': return 'Add Santri Manual';
			case 'addData.addGuruManual': return 'Add Guru Manual';
			case 'addData.nis': return 'NIS';
			case 'addData.nisHint': return 'Student ID Number';
			case 'addData.nip': return 'NIP';
			case 'addData.nipHint': return 'Teacher ID Number';
			case 'addData.namaLengkap': return 'Full Name';
			case 'addData.namaSantriHint': return 'Student full name';
			case 'addData.namaGuruHint': return 'Teacher full name';
			case 'addData.kelas': return 'Class';
			case 'addData.kelasHint': return 'Select Class';
			case 'addData.nomorHp': return 'Phone Number';
			case 'addData.nomorHpHint': return 'Example: 08123456789';
			case 'addData.simpan': return 'Simpan';
			case 'addData.bulkTitle': return 'Bulk Add Data';
			case 'addData.bulkSubtitle': return 'Import data automatically using an Excel file.';
			case 'addData.bulkTapUpload': return 'Tap to upload Excel file';
			case 'addData.bulkFormat': return 'Format .xlsx or .csv (Max. 5MB)';
			case 'addData.bulkUploadButton': return 'Upload Now';
			case 'addHalaqoh.title': return 'Add New Halaqoh';
			case 'addHalaqoh.namaHalaqoh': return 'Halaqoh Name';
			case 'addHalaqoh.namaHalaqohHint': return 'Example: Halaqoh 7A';
			case 'addHalaqoh.kelas': return 'Class';
			case 'addHalaqoh.kelasHint': return 'Select Class';
			case 'addHalaqoh.program': return 'Program';
			case 'addHalaqoh.programHint': return 'Select Program';
			case 'addHalaqoh.pengampu': return 'Instructor (Teacher)';
			case 'addHalaqoh.pengampuHint': return 'Search instructor name...';
			case 'addHalaqoh.daftarSantri': return 'Santri List';
			case 'addHalaqoh.tambahSantri': return '+ Add Santri';
			case 'addHalaqoh.nis': return 'NIS';
			case 'addHalaqoh.namaSantri': return 'STUDENT NAME';
			case 'addHalaqoh.aksi': return 'ACTION';
			case 'addHalaqoh.totalTerpilih': return ({required Object count}) => 'Total: ${count} Santri selected';
			case 'addHalaqoh.simpanHalaqoh': return 'SAVE HALAQOH';
			case 'selectSantri.title': return 'Select Santri';
			case 'selectSantri.searchHint': return 'Search name or NIS...';
			case 'selectSantri.filter': return 'FILTER';
			case 'selectSantri.countLabel': return ({required Object count}) => '${count} Santri';
			case 'selectSantri.nis': return 'NIS';
			case 'selectSantri.nama': return 'NAME';
			case 'selectSantri.kelas': return 'CLASS';
			case 'selectSantri.tambahkanButton': return ({required Object count}) => 'ADD (${count}) SANTRI';
			default: return null;
		}
	}
}

