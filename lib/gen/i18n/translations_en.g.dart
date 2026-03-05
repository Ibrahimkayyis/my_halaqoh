///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

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
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsSplashEn splash = TranslationsSplashEn.internal(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsDashboardEn dashboard = TranslationsDashboardEn.internal(_root);
	late final TranslationsSantriEn santri = TranslationsSantriEn.internal(_root);
	late final TranslationsGuruEn guru = TranslationsGuruEn.internal(_root);
	late final TranslationsHalaqohEn halaqoh = TranslationsHalaqohEn.internal(_root);
	late final TranslationsTargetHafalanEn targetHafalan = TranslationsTargetHafalanEn.internal(_root);
	late final TranslationsEditTargetEn editTarget = TranslationsEditTargetEn.internal(_root);
	late final TranslationsNavEn nav = TranslationsNavEn.internal(_root);
	late final TranslationsAddDataEn addData = TranslationsAddDataEn.internal(_root);
	late final TranslationsAddHalaqohEn addHalaqoh = TranslationsAddHalaqohEn.internal(_root);
	late final TranslationsSelectSantriEn selectSantri = TranslationsSelectSantriEn.internal(_root);
	late final TranslationsGuruDashboardEn guruDashboard = TranslationsGuruDashboardEn.internal(_root);
	late final TranslationsGuruNavEn guruNav = TranslationsGuruNavEn.internal(_root);
	late final TranslationsMyHalaqohScreenEn myHalaqohScreen = TranslationsMyHalaqohScreenEn.internal(_root);
	late final TranslationsDetailSantriEn detailSantri = TranslationsDetailSantriEn.internal(_root);
	late final TranslationsAbsensiEn absensi = TranslationsAbsensiEn.internal(_root);
	late final TranslationsRiwayatAbsensiEn riwayatAbsensi = TranslationsRiwayatAbsensiEn.internal(_root);
	late final TranslationsKalenderAbsensiEn kalenderAbsensi = TranslationsKalenderAbsensiEn.internal(_root);
	late final TranslationsAbsensiHalaqohEn absensiHalaqoh = TranslationsAbsensiHalaqohEn.internal(_root);
	late final TranslationsDetailAbsensiHariIniEn detailAbsensiHariIni = TranslationsDetailAbsensiHariIniEn.internal(_root);
	late final TranslationsHafalanEn hafalan = TranslationsHafalanEn.internal(_root);
	late final TranslationsInputHafalanFormEn inputHafalanForm = TranslationsInputHafalanFormEn.internal(_root);
	late final TranslationsRiwayatHafalanSantriEn riwayatHafalanSantri = TranslationsRiwayatHafalanSantriEn.internal(_root);
	late final TranslationsProgressHafalanPerJuzEn progressHafalanPerJuz = TranslationsProgressHafalanPerJuzEn.internal(_root);
	late final TranslationsProgressHafalanPerSuratEn progressHafalanPerSurat = TranslationsProgressHafalanPerSuratEn.internal(_root);
	late final TranslationsMutabaahSantriEn mutabaahSantri = TranslationsMutabaahSantriEn.internal(_root);
	late final TranslationsGuruProfileEn guruProfile = TranslationsGuruProfileEn.internal(_root);
	late final TranslationsEditProfileEn editProfile = TranslationsEditProfileEn.internal(_root);
	late final TranslationsUbahPasswordEn ubahPassword = TranslationsUbahPasswordEn.internal(_root);
	late final TranslationsPengaturanScreenEn pengaturanScreen = TranslationsPengaturanScreenEn.internal(_root);
	late final TranslationsWaliSantriDashboardEn waliSantriDashboard = TranslationsWaliSantriDashboardEn.internal(_root);
	late final TranslationsWaliSantriNavEn waliSantriNav = TranslationsWaliSantriNavEn.internal(_root);
	late final TranslationsWaliSantriPengaturanScreenEn WaliSantriPengaturanScreen = TranslationsWaliSantriPengaturanScreenEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

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
	TranslationsSplashEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Halaqoh Management System'
	String get subtitle => 'Halaqoh Management System';

	/// en: 'v1.0.0'
	String get version => 'v1.0.0';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn.internal(this._root);

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
	TranslationsDashboardEn.internal(this._root);

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
	TranslationsSantriEn.internal(this._root);

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
	TranslationsGuruEn.internal(this._root);

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
	TranslationsHalaqohEn.internal(this._root);

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
	TranslationsTargetHafalanEn.internal(this._root);

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
	TranslationsEditTargetEn.internal(this._root);

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
	TranslationsNavEn.internal(this._root);

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
	TranslationsAddDataEn.internal(this._root);

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
	TranslationsAddHalaqohEn.internal(this._root);

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
	TranslationsSelectSantriEn.internal(this._root);

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

// Path: guruDashboard
class TranslationsGuruDashboardEn {
	TranslationsGuruDashboardEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'AHLAN WA SAHLAN'
	String get greeting => 'AHLAN WA SAHLAN';

	/// en: 'Begin Halaqoh With Prayers Together To Always Be Blessed'
	String get subtitle => 'Begin Halaqoh With Prayers Together To Always Be Blessed';

	/// en: 'Today's Achievement'
	String get capaianHariIni => 'Today\'s Achievement';

	/// en: 'Attendance Today'
	String get kehadiranHariIni => 'Attendance Today';

	/// en: 'Hafalan Submission'
	String get setoranHafalan => 'Hafalan Submission';

	/// en: '$current/$total Santri'
	String santriCount({required Object current, required Object total}) => '${current}/${total} Santri';

	/// en: 'Main Menu'
	String get menuUtama => 'Main Menu';

	/// en: 'Halaqoh'
	String get myHalaqoh => 'Halaqoh';

	/// en: 'Scan Attendance'
	String get scanAbsensi => 'Scan Attendance';

	/// en: 'Input Hafalan'
	String get inputHafalan => 'Input Hafalan';

	/// en: 'Report'
	String get laporan => 'Report';

	/// en: 'Recent Submissions'
	String get setoranTerakhir => 'Recent Submissions';
}

// Path: guruNav
class TranslationsGuruNavEn {
	TranslationsGuruNavEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Halaqoh'
	String get myHalaqoh => 'Halaqoh';

	/// en: 'Attendance'
	String get absensi => 'Attendance';

	/// en: 'Hafalan'
	String get hafalan => 'Hafalan';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: myHalaqohScreen
class TranslationsMyHalaqohScreenEn {
	TranslationsMyHalaqohScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Halaqoh'
	String get title => 'My Halaqoh';

	/// en: 'Search name or NIS...'
	String get searchHint => 'Search name or NIS...';

	/// en: 'Student List'
	String get daftarSantri => 'Student List';

	/// en: '$count Santri'
	String santriCount({required Object count}) => '${count} Santri';

	/// en: 'Grade $kelas'
	String kelas({required Object kelas}) => 'Grade ${kelas}';

	/// en: 'Program: $program'
	String program({required Object program}) => 'Program: ${program}';

	/// en: 'Target: $count Juz ($range)'
	String target({required Object count, required Object range}) => 'Target: ${count} Juz (${range})';

	/// en: 'Total: $count Santri'
	String total({required Object count}) => 'Total: ${count} Santri';

	/// en: 'Ustadz Kayyis'
	String get pengampu => 'Ustadz Kayyis';

	/// en: '$completed Juz completed of $target Juz'
	String progressText({required Object completed, required Object target}) => '${completed} Juz completed of ${target} Juz';
}

// Path: detailSantri
class TranslationsDetailSantriEn {
	TranslationsDetailSantriEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Student Profile'
	String get title => 'Student Profile';

	/// en: 'ACADEMIC INFORMATION'
	String get informasiAkademik => 'ACADEMIC INFORMATION';

	/// en: 'Class'
	String get kelas => 'Class';

	/// en: 'Program'
	String get program => 'Program';

	/// en: 'Halaqoh'
	String get halaqoh => 'Halaqoh';

	/// en: 'Mentor'
	String get pembimbing => 'Mentor';

	/// en: 'MEMORIZATION PROGRESS'
	String get progressHafalan => 'MEMORIZATION PROGRESS';

	/// en: 'Total Memorization'
	String get totalHafalan => 'Total Memorization';

	/// en: '$done of $total Juz Certified'
	String sertifikasiInfo({required Object done, required Object total}) => '${done} of ${total} Juz Certified';

	/// en: 'Juz Certification'
	String get sertifikasiJuz => 'Juz Certification';
}

// Path: absensi
class TranslationsAbsensiEn {
	TranslationsAbsensiEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'START ATTENDANCE SESSION'
	String get mulaiSesi => 'START ATTENDANCE SESSION';

	/// en: 'Search Student'
	String get searchHint => 'Search Student';

	/// en: 'View Halaqoh Attendance'
	String get lihatAbsensiHalaqoh => 'View Halaqoh Attendance';

	/// en: 'View Today's Attendance Detail'
	String get lihatDetailHariIni => 'View Today\'s Attendance Detail';

	/// en: 'Student List'
	String get daftarSantri => 'Student List';

	/// en: '$count Students'
	String santriCount({required Object count}) => '${count} Students';

	/// en: 'ATTENDANCE HISTORY'
	String get riwayatAbsensi => 'ATTENDANCE HISTORY';

	/// en: 'Start Attendance Session'
	String get dialogTitle => 'Start Attendance Session';

	/// en: 'HALAQOH DATE'
	String get tanggalHalaqoh => 'HALAQOH DATE';

	/// en: 'SELECT SESSION'
	String get pilihSesi => 'SELECT SESSION';

	/// en: 'Shubuh'
	String get shubuh => 'Shubuh';

	/// en: 'Maghrib'
	String get maghrib => 'Maghrib';

	/// en: 'SCAN BARCODE'
	String get scanBarcode => 'SCAN BARCODE';

	/// en: 'Point camera at Student QR Code'
	String get scanInstruction => 'Point camera at Student QR Code';

	/// en: 'Name: $name'
	String nama({required Object name}) => 'Name: ${name}';

	/// en: 'NIS: $nis'
	String nis({required Object nis}) => 'NIS: ${nis}';

	/// en: 'ATTENDANCE STATUS'
	String get statusKehadiran => 'ATTENDANCE STATUS';

	/// en: 'Present'
	String get hadir => 'Present';

	/// en: 'Sick'
	String get sakit => 'Sick';

	/// en: 'Excused'
	String get izin => 'Excused';

	/// en: 'Absent'
	String get alfa => 'Absent';

	/// en: 'Notes (optional)'
	String get keterangan => 'Notes (optional)';

	/// en: 'CANCEL'
	String get batal => 'CANCEL';

	/// en: 'SAVE'
	String get simpan => 'SAVE';
}

// Path: riwayatAbsensi
class TranslationsRiwayatAbsensiEn {
	TranslationsRiwayatAbsensiEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Attendance History'
	String get title => 'Attendance History';

	/// en: 'Halaqoh $halaqoh - Class $kelas'
	String halaqohKelas({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Class ${kelas}';

	/// en: 'PRESENT'
	String get hadir => 'PRESENT';

	/// en: 'SICK'
	String get sakit => 'SICK';

	/// en: 'EXCUSED'
	String get izin => 'EXCUSED';

	/// en: 'ABSENT'
	String get alfa => 'ABSENT';

	/// en: 'MORNING'
	String get pagi => 'MORNING';

	/// en: 'NIGHT'
	String get mlm => 'NIGHT';

	/// en: 'Swipe to see all dates'
	String get geserHint => 'Swipe to see all dates';

	/// en: 'VIEW FULL ATTENDANCE CALENDAR'
	String get lihatKalender => 'VIEW FULL ATTENDANCE CALENDAR';

	/// en: 'Legend'
	String get keterangan => 'Legend';

	/// en: 'Present'
	String get hadirLabel => 'Present';

	/// en: 'Sick'
	String get sakitLabel => 'Sick';

	/// en: 'Absent'
	String get alphaLabel => 'Absent';

	/// en: 'Excused'
	String get izinLabel => 'Excused';

	/// en: 'DOWNLOAD ATTENDANCE REPORT'
	String get downloadLaporan => 'DOWNLOAD ATTENDANCE REPORT';
}

// Path: kalenderAbsensi
class TranslationsKalenderAbsensiEn {
	TranslationsKalenderAbsensiEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Attendance Calendar'
	String get title => 'Attendance Calendar';

	/// en: 'NIS: $nis • Halaqoh $halaqoh'
	String nisHalaqoh({required Object nis, required Object halaqoh}) => 'NIS: ${nis}  •  Halaqoh ${halaqoh}';

	/// en: 'Legend'
	String get keterangan => 'Legend';

	/// en: 'Present'
	String get hadirLabel => 'Present';

	/// en: 'Sick / Excused'
	String get sakitIzinLabel => 'Sick / Excused';

	/// en: 'Absent'
	String get alfaLabel => 'Absent';

	/// en: 'Not Yet'
	String get belumAbsen => 'Not Yet';

	/// en: 'Morning (Left)'
	String get pagiKiri => 'Morning (Left)';

	/// en: 'Night (Right)'
	String get malamKanan => 'Night (Right)';

	/// en: 'SUN'
	String get aha => 'SUN';

	/// en: 'MON'
	String get sen => 'MON';

	/// en: 'TUE'
	String get sel => 'TUE';

	/// en: 'WED'
	String get rab => 'WED';

	/// en: 'THU'
	String get kam => 'THU';

	/// en: 'FRI'
	String get jum => 'FRI';

	/// en: 'SAT'
	String get sab => 'SAT';
}

// Path: absensiHalaqoh
class TranslationsAbsensiHalaqohEn {
	TranslationsAbsensiHalaqohEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Halaqoh Attendance'
	String get title => 'Halaqoh Attendance';

	/// en: 'DATE / SESSION'
	String get tglSesi => 'DATE / SESSION';

	/// en: 'STUDENT'
	String get santri => 'STUDENT';

	/// en: 'Morning'
	String get pagi => 'Morning';

	/// en: 'Night'
	String get malam => 'Night';

	/// en: 'Dhuha 1'
	String get dhuha1 => 'Dhuha 1';

	/// en: 'Dhuha 2'
	String get dhuha2 => 'Dhuha 2';

	/// en: 'Afternoon'
	String get sore => 'Afternoon';

	/// en: 'Present'
	String get hadir => 'Present';

	/// en: 'Sick'
	String get sakit => 'Sick';

	/// en: 'Excused'
	String get izin => 'Excused';

	/// en: 'Absent'
	String get alfa => 'Absent';

	/// en: 'DOWNLOAD ATTENDANCE REPORT'
	String get downloadLaporan => 'DOWNLOAD ATTENDANCE REPORT';
}

// Path: detailAbsensiHariIni
class TranslationsDetailAbsensiHariIniEn {
	TranslationsDetailAbsensiHariIniEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today's Attendance Detail'
	String get title => 'Today\'s Attendance Detail';

	/// en: 'Present'
	String get hadir => 'Present';

	/// en: 'Sick'
	String get sakit => 'Sick';

	/// en: 'Excused'
	String get izin => 'Excused';

	/// en: 'Absent'
	String get alfa => 'Absent';

	/// en: 'Not Yet'
	String get belumAbsen => 'Not Yet';

	/// en: 'Not Recorded'
	String get belumDiabsen => 'Not Recorded';

	/// en: 'Student Attendance List'
	String get daftarKehadiranSantri => 'Student Attendance List';
}

// Path: hafalan
class TranslationsHafalanEn {
	TranslationsHafalanEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search Student'
	String get cariSantri => 'Search Student';

	/// en: 'Student List'
	String get daftarSantri => 'Student List';

	/// en: '$count Students'
	String santriCount({required Object count}) => '${count} Students';

	/// en: 'Memorization History'
	String get riwayatHafalan => 'Memorization History';

	/// en: 'Input Memorization'
	String get inputHafalan => 'Input Memorization';
}

// Path: inputHafalanForm
class TranslationsInputHafalanFormEn {
	TranslationsInputHafalanFormEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Name: $name'
	String nama({required Object name}) => 'Name: ${name}';

	/// en: 'ZIYADAH'
	String get ziyadah => 'ZIYADAH';

	/// en: 'MURAJAAH'
	String get murajaah => 'MURAJAAH';

	/// en: 'Memorization Form'
	String get formulirHafalan => 'Memorization Form';

	/// en: 'Select Surah'
	String get pilihSurat => 'Select Surah';

	/// en: 'Start Verse'
	String get ayatAwal => 'Start Verse';

	/// en: 'End Verse'
	String get ayatAkhir => 'End Verse';

	/// en: 'Juz'
	String get juz => 'Juz';

	/// en: 'Assessment'
	String get penilaian => 'Assessment';

	/// en: 'Fluency 1 - 100'
	String get kelancaran => 'Fluency 1 - 100';

	/// en: 'Tajwid 1 - 100'
	String get tajwid => 'Tajwid 1 - 100';

	/// en: 'SAVE'
	String get simpan => 'SAVE';

	/// en: 'CANCEL'
	String get batal => 'CANCEL';
}

// Path: riwayatHafalanSantri
class TranslationsRiwayatHafalanSantriEn {
	TranslationsRiwayatHafalanSantriEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memorization History'
	String get title => 'Memorization History';

	/// en: 'Halaqoh $halaqoh - Class $kelas'
	String halaqohKelas({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Class ${kelas}';

	/// en: 'Total New Memorization'
	String get totalHafalanBaru => 'Total New Memorization';

	/// en: 'Total Review'
	String get totalMurajaah => 'Total Review';

	/// en: 'All Types'
	String get semuaTipe => 'All Types';

	/// en: 'OPEN MUTABA'AH'
	String get bukaMutabaah => 'OPEN MUTABA\'AH';

	/// en: 'New Memorization'
	String get hafalanBaru => 'New Memorization';

	/// en: 'Review'
	String get murajaah => 'Review';

	/// en: 'VIEW PROGRESS PER SURAH'
	String get lihatProgress => 'VIEW PROGRESS PER SURAH';

	/// en: 'DOWNLOAD MEMORIZATION REPORT'
	String get downloadLaporan => 'DOWNLOAD MEMORIZATION REPORT';
}

// Path: progressHafalanPerJuz
class TranslationsProgressHafalanPerJuzEn {
	TranslationsProgressHafalanPerJuzEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memorization Progress'
	String get title => 'Memorization Progress';

	/// en: 'Memorization Target'
	String get targetHafalan => 'Memorization Target';

	/// en: 'Select Juz to view detailed progress per surah'
	String get pilihJuz => 'Select Juz to view detailed progress per surah';

	/// en: '$completed of $total Surah Completed'
	String suratSelesai({required Object completed, required Object total}) => '${completed} of ${total} Surah Completed';
}

// Path: progressHafalanPerSurat
class TranslationsProgressHafalanPerSuratEn {
	TranslationsProgressHafalanPerSuratEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Progress Per Surah'
	String get title => 'Progress Per Surah';

	/// en: 'Memorization Detail Juz $juz'
	String detailJuz({required Object juz}) => 'Memorization Detail Juz ${juz}';

	/// en: 'Ayat $memorized of $total'
	String ayatDari({required Object memorized, required Object total}) => 'Ayat ${memorized} of ${total}';

	/// en: 'Completed'
	String get selesai => 'Completed';

	/// en: 'In Progress'
	String get dalamProses => 'In Progress';

	/// en: 'Not Started'
	String get belumDimulai => 'Not Started';
}

// Path: mutabaahSantri
class TranslationsMutabaahSantriEn {
	TranslationsMutabaahSantriEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mutaba'ah Santri'
	String get title => 'Mutaba\'ah Santri';

	/// en: 'New Memorization'
	String get hafalanBaru => 'New Memorization';

	/// en: 'Review'
	String get murajaah => 'Review';

	/// en: 'DAY'
	String get hari => 'DAY';

	/// en: 'DATE'
	String get tgl => 'DATE';

	/// en: 'SURAH'
	String get surat => 'SURAH';

	/// en: 'AYAT'
	String get ayat => 'AYAT';

	/// en: 'SCORE'
	String get nilai => 'SCORE';
}

// Path: guruProfile
class TranslationsGuruProfileEn {
	TranslationsGuruProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Profile'
	String get editProfile => 'Edit Profile';

	/// en: 'Change Password'
	String get ubahPassword => 'Change Password';

	/// en: 'Settings'
	String get pengaturan => 'Settings';

	/// en: 'About App'
	String get tentangAplikasi => 'About App';

	/// en: 'Logout'
	String get keluar => 'Logout';

	/// en: 'Halaqoh Teacher'
	String get guruHalaqoh => 'Halaqoh Teacher';

	/// en: 'MyHalaqoh App v$version'
	String appVersion({required Object version}) => 'MyHalaqoh App v${version}';
}

// Path: editProfile
class TranslationsEditProfileEn {
	TranslationsEditProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Profile'
	String get title => 'Edit Profile';

	/// en: 'Edit Profile Photo'
	String get editFotoProfil => 'Edit Profile Photo';

	/// en: 'PERSONAL INFORMATION'
	String get informasiPribadi => 'PERSONAL INFORMATION';

	/// en: 'Full Name'
	String get namaLengkap => 'Full Name';

	/// en: 'NIP'
	String get nip => 'NIP';

	/// en: 'Position'
	String get jabatan => 'Position';

	/// en: 'CONTACT'
	String get kontak => 'CONTACT';

	/// en: 'Phone Number'
	String get nomorHp => 'Phone Number';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Save Changes'
	String get simpanPerubahan => 'Save Changes';
}

// Path: ubahPassword
class TranslationsUbahPasswordEn {
	TranslationsUbahPasswordEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Change Password'
	String get title => 'Change Password';

	/// en: 'Please enter your new password to improve your account security.'
	String get subtitle => 'Please enter your new password to improve your account security.';

	/// en: 'Old Password'
	String get kataSandiLama => 'Old Password';

	/// en: 'New Password'
	String get kataSandiBaru => 'New Password';

	/// en: 'Confirm New Password'
	String get konfirmasiKataSandiBaru => 'Confirm New Password';

	/// en: 'SECURITY REQUIREMENTS'
	String get syaratKeamanan => 'SECURITY REQUIREMENTS';

	/// en: 'Minimum 8 characters'
	String get minimal8Karakter => 'Minimum 8 characters';

	/// en: 'Combination of letters and numbers'
	String get kombinasiHurufDanAngka => 'Combination of letters and numbers';

	/// en: 'Change Password'
	String get ubahKataSandi => 'Change Password';
}

// Path: pengaturanScreen
class TranslationsPengaturanScreenEn {
	TranslationsPengaturanScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get bahasa => 'Language';

	/// en: 'Bahasa Indonesia'
	String get bahasaIndonesia => 'Bahasa Indonesia';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Select Language'
	String get pilihBahasa => 'Select Language';

	/// en: 'Theme'
	String get tema => 'Theme';

	/// en: 'Light'
	String get terangLight => 'Light';

	/// en: 'Dark'
	String get gelapDark => 'Dark';

	/// en: 'Select Theme'
	String get pilihTema => 'Select Theme';
}

// Path: waliSantriDashboard
class TranslationsWaliSantriDashboardEn {
	TranslationsWaliSantriDashboardEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memorization Progress'
	String get progressHafalan => 'Memorization Progress';

	/// en: 'Juz Completed'
	String get juzTerselesaikan => 'Juz Completed';

	/// en: 'Target : $target Juz'
	String target({required Object target}) => 'Target : ${target} Juz';

	/// en: 'Attendance'
	String get kehadiran => 'Attendance';

	/// en: 'Period: $periode'
	String periode({required Object periode}) => 'Period: ${periode}';

	/// en: 'Present'
	String get hadir => 'Present';

	/// en: 'Sick'
	String get sakit => 'Sick';

	/// en: 'Permit'
	String get izin => 'Permit';

	/// en: 'Absent'
	String get alpha => 'Absent';
}

// Path: waliSantriNav
class TranslationsWaliSantriNavEn {
	TranslationsWaliSantriNavEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Hafalan'
	String get hafalan => 'Hafalan';

	/// en: 'Attendance'
	String get absensi => 'Attendance';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: WaliSantriPengaturanScreen
class TranslationsWaliSantriPengaturanScreenEn {
	TranslationsWaliSantriPengaturanScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get bahasa => 'Language';

	/// en: 'Bahasa Indonesia'
	String get bahasaIndonesia => 'Bahasa Indonesia';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Select Language'
	String get pilihBahasa => 'Select Language';

	/// en: 'Theme'
	String get tema => 'Theme';

	/// en: 'Light'
	String get terangLight => 'Light';

	/// en: 'Dark'
	String get gelapDark => 'Dark';

	/// en: 'Select Theme'
	String get pilihTema => 'Select Theme';
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
			case 'guruDashboard.greeting': return 'AHLAN WA SAHLAN';
			case 'guruDashboard.subtitle': return 'Begin Halaqoh With Prayers Together To Always Be Blessed';
			case 'guruDashboard.capaianHariIni': return 'Today\'s Achievement';
			case 'guruDashboard.kehadiranHariIni': return 'Attendance Today';
			case 'guruDashboard.setoranHafalan': return 'Hafalan Submission';
			case 'guruDashboard.santriCount': return ({required Object current, required Object total}) => '${current}/${total} Santri';
			case 'guruDashboard.menuUtama': return 'Main Menu';
			case 'guruDashboard.myHalaqoh': return 'Halaqoh';
			case 'guruDashboard.scanAbsensi': return 'Scan Attendance';
			case 'guruDashboard.inputHafalan': return 'Input Hafalan';
			case 'guruDashboard.laporan': return 'Report';
			case 'guruDashboard.setoranTerakhir': return 'Recent Submissions';
			case 'guruNav.home': return 'Home';
			case 'guruNav.myHalaqoh': return 'Halaqoh';
			case 'guruNav.absensi': return 'Attendance';
			case 'guruNav.hafalan': return 'Hafalan';
			case 'guruNav.profile': return 'Profile';
			case 'myHalaqohScreen.title': return 'My Halaqoh';
			case 'myHalaqohScreen.searchHint': return 'Search name or NIS...';
			case 'myHalaqohScreen.daftarSantri': return 'Student List';
			case 'myHalaqohScreen.santriCount': return ({required Object count}) => '${count} Santri';
			case 'myHalaqohScreen.kelas': return ({required Object kelas}) => 'Grade ${kelas}';
			case 'myHalaqohScreen.program': return ({required Object program}) => 'Program: ${program}';
			case 'myHalaqohScreen.target': return ({required Object count, required Object range}) => 'Target: ${count} Juz (${range})';
			case 'myHalaqohScreen.total': return ({required Object count}) => 'Total: ${count} Santri';
			case 'myHalaqohScreen.pengampu': return 'Ustadz Kayyis';
			case 'myHalaqohScreen.progressText': return ({required Object completed, required Object target}) => '${completed} Juz completed of ${target} Juz';
			case 'detailSantri.title': return 'Student Profile';
			case 'detailSantri.informasiAkademik': return 'ACADEMIC INFORMATION';
			case 'detailSantri.kelas': return 'Class';
			case 'detailSantri.program': return 'Program';
			case 'detailSantri.halaqoh': return 'Halaqoh';
			case 'detailSantri.pembimbing': return 'Mentor';
			case 'detailSantri.progressHafalan': return 'MEMORIZATION PROGRESS';
			case 'detailSantri.totalHafalan': return 'Total Memorization';
			case 'detailSantri.sertifikasiInfo': return ({required Object done, required Object total}) => '${done} of ${total} Juz Certified';
			case 'detailSantri.sertifikasiJuz': return 'Juz Certification';
			case 'absensi.mulaiSesi': return 'START ATTENDANCE SESSION';
			case 'absensi.searchHint': return 'Search Student';
			case 'absensi.lihatAbsensiHalaqoh': return 'View Halaqoh Attendance';
			case 'absensi.lihatDetailHariIni': return 'View Today\'s Attendance Detail';
			case 'absensi.daftarSantri': return 'Student List';
			case 'absensi.santriCount': return ({required Object count}) => '${count} Students';
			case 'absensi.riwayatAbsensi': return 'ATTENDANCE HISTORY';
			case 'absensi.dialogTitle': return 'Start Attendance Session';
			case 'absensi.tanggalHalaqoh': return 'HALAQOH DATE';
			case 'absensi.pilihSesi': return 'SELECT SESSION';
			case 'absensi.shubuh': return 'Shubuh';
			case 'absensi.maghrib': return 'Maghrib';
			case 'absensi.scanBarcode': return 'SCAN BARCODE';
			case 'absensi.scanInstruction': return 'Point camera at Student QR Code';
			case 'absensi.nama': return ({required Object name}) => 'Name: ${name}';
			case 'absensi.nis': return ({required Object nis}) => 'NIS: ${nis}';
			case 'absensi.statusKehadiran': return 'ATTENDANCE STATUS';
			case 'absensi.hadir': return 'Present';
			case 'absensi.sakit': return 'Sick';
			case 'absensi.izin': return 'Excused';
			case 'absensi.alfa': return 'Absent';
			case 'absensi.keterangan': return 'Notes (optional)';
			case 'absensi.batal': return 'CANCEL';
			case 'absensi.simpan': return 'SAVE';
			case 'riwayatAbsensi.title': return 'Attendance History';
			case 'riwayatAbsensi.halaqohKelas': return ({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Class ${kelas}';
			case 'riwayatAbsensi.hadir': return 'PRESENT';
			case 'riwayatAbsensi.sakit': return 'SICK';
			case 'riwayatAbsensi.izin': return 'EXCUSED';
			case 'riwayatAbsensi.alfa': return 'ABSENT';
			case 'riwayatAbsensi.pagi': return 'MORNING';
			case 'riwayatAbsensi.mlm': return 'NIGHT';
			case 'riwayatAbsensi.geserHint': return 'Swipe to see all dates';
			case 'riwayatAbsensi.lihatKalender': return 'VIEW FULL ATTENDANCE CALENDAR';
			case 'riwayatAbsensi.keterangan': return 'Legend';
			case 'riwayatAbsensi.hadirLabel': return 'Present';
			case 'riwayatAbsensi.sakitLabel': return 'Sick';
			case 'riwayatAbsensi.alphaLabel': return 'Absent';
			case 'riwayatAbsensi.izinLabel': return 'Excused';
			case 'riwayatAbsensi.downloadLaporan': return 'DOWNLOAD ATTENDANCE REPORT';
			case 'kalenderAbsensi.title': return 'Attendance Calendar';
			case 'kalenderAbsensi.nisHalaqoh': return ({required Object nis, required Object halaqoh}) => 'NIS: ${nis}  •  Halaqoh ${halaqoh}';
			case 'kalenderAbsensi.keterangan': return 'Legend';
			case 'kalenderAbsensi.hadirLabel': return 'Present';
			case 'kalenderAbsensi.sakitIzinLabel': return 'Sick / Excused';
			case 'kalenderAbsensi.alfaLabel': return 'Absent';
			case 'kalenderAbsensi.belumAbsen': return 'Not Yet';
			case 'kalenderAbsensi.pagiKiri': return 'Morning (Left)';
			case 'kalenderAbsensi.malamKanan': return 'Night (Right)';
			case 'kalenderAbsensi.aha': return 'SUN';
			case 'kalenderAbsensi.sen': return 'MON';
			case 'kalenderAbsensi.sel': return 'TUE';
			case 'kalenderAbsensi.rab': return 'WED';
			case 'kalenderAbsensi.kam': return 'THU';
			case 'kalenderAbsensi.jum': return 'FRI';
			case 'kalenderAbsensi.sab': return 'SAT';
			case 'absensiHalaqoh.title': return 'Halaqoh Attendance';
			case 'absensiHalaqoh.tglSesi': return 'DATE / SESSION';
			case 'absensiHalaqoh.santri': return 'STUDENT';
			case 'absensiHalaqoh.pagi': return 'Morning';
			case 'absensiHalaqoh.malam': return 'Night';
			case 'absensiHalaqoh.dhuha1': return 'Dhuha 1';
			case 'absensiHalaqoh.dhuha2': return 'Dhuha 2';
			case 'absensiHalaqoh.sore': return 'Afternoon';
			case 'absensiHalaqoh.hadir': return 'Present';
			case 'absensiHalaqoh.sakit': return 'Sick';
			case 'absensiHalaqoh.izin': return 'Excused';
			case 'absensiHalaqoh.alfa': return 'Absent';
			case 'absensiHalaqoh.downloadLaporan': return 'DOWNLOAD ATTENDANCE REPORT';
			case 'detailAbsensiHariIni.title': return 'Today\'s Attendance Detail';
			case 'detailAbsensiHariIni.hadir': return 'Present';
			case 'detailAbsensiHariIni.sakit': return 'Sick';
			case 'detailAbsensiHariIni.izin': return 'Excused';
			case 'detailAbsensiHariIni.alfa': return 'Absent';
			case 'detailAbsensiHariIni.belumAbsen': return 'Not Yet';
			case 'detailAbsensiHariIni.belumDiabsen': return 'Not Recorded';
			case 'detailAbsensiHariIni.daftarKehadiranSantri': return 'Student Attendance List';
			case 'hafalan.cariSantri': return 'Search Student';
			case 'hafalan.daftarSantri': return 'Student List';
			case 'hafalan.santriCount': return ({required Object count}) => '${count} Students';
			case 'hafalan.riwayatHafalan': return 'Memorization History';
			case 'hafalan.inputHafalan': return 'Input Memorization';
			case 'inputHafalanForm.nama': return ({required Object name}) => 'Name: ${name}';
			case 'inputHafalanForm.ziyadah': return 'ZIYADAH';
			case 'inputHafalanForm.murajaah': return 'MURAJAAH';
			case 'inputHafalanForm.formulirHafalan': return 'Memorization Form';
			case 'inputHafalanForm.pilihSurat': return 'Select Surah';
			case 'inputHafalanForm.ayatAwal': return 'Start Verse';
			case 'inputHafalanForm.ayatAkhir': return 'End Verse';
			case 'inputHafalanForm.juz': return 'Juz';
			case 'inputHafalanForm.penilaian': return 'Assessment';
			case 'inputHafalanForm.kelancaran': return 'Fluency 1 - 100';
			case 'inputHafalanForm.tajwid': return 'Tajwid 1 - 100';
			case 'inputHafalanForm.simpan': return 'SAVE';
			case 'inputHafalanForm.batal': return 'CANCEL';
			case 'riwayatHafalanSantri.title': return 'Memorization History';
			case 'riwayatHafalanSantri.halaqohKelas': return ({required Object halaqoh, required Object kelas}) => 'Halaqoh ${halaqoh} - Class ${kelas}';
			case 'riwayatHafalanSantri.totalHafalanBaru': return 'Total New Memorization';
			case 'riwayatHafalanSantri.totalMurajaah': return 'Total Review';
			case 'riwayatHafalanSantri.semuaTipe': return 'All Types';
			case 'riwayatHafalanSantri.bukaMutabaah': return 'OPEN MUTABA\'AH';
			case 'riwayatHafalanSantri.hafalanBaru': return 'New Memorization';
			case 'riwayatHafalanSantri.murajaah': return 'Review';
			case 'riwayatHafalanSantri.lihatProgress': return 'VIEW PROGRESS PER SURAH';
			case 'riwayatHafalanSantri.downloadLaporan': return 'DOWNLOAD MEMORIZATION REPORT';
			case 'progressHafalanPerJuz.title': return 'Memorization Progress';
			case 'progressHafalanPerJuz.targetHafalan': return 'Memorization Target';
			case 'progressHafalanPerJuz.pilihJuz': return 'Select Juz to view detailed progress per surah';
			case 'progressHafalanPerJuz.suratSelesai': return ({required Object completed, required Object total}) => '${completed} of ${total} Surah Completed';
			case 'progressHafalanPerSurat.title': return 'Progress Per Surah';
			case 'progressHafalanPerSurat.detailJuz': return ({required Object juz}) => 'Memorization Detail Juz ${juz}';
			case 'progressHafalanPerSurat.ayatDari': return ({required Object memorized, required Object total}) => 'Ayat ${memorized} of ${total}';
			case 'progressHafalanPerSurat.selesai': return 'Completed';
			case 'progressHafalanPerSurat.dalamProses': return 'In Progress';
			case 'progressHafalanPerSurat.belumDimulai': return 'Not Started';
			case 'mutabaahSantri.title': return 'Mutaba\'ah Santri';
			case 'mutabaahSantri.hafalanBaru': return 'New Memorization';
			case 'mutabaahSantri.murajaah': return 'Review';
			case 'mutabaahSantri.hari': return 'DAY';
			case 'mutabaahSantri.tgl': return 'DATE';
			case 'mutabaahSantri.surat': return 'SURAH';
			case 'mutabaahSantri.ayat': return 'AYAT';
			case 'mutabaahSantri.nilai': return 'SCORE';
			case 'guruProfile.editProfile': return 'Edit Profile';
			case 'guruProfile.ubahPassword': return 'Change Password';
			case 'guruProfile.pengaturan': return 'Settings';
			case 'guruProfile.tentangAplikasi': return 'About App';
			case 'guruProfile.keluar': return 'Logout';
			case 'guruProfile.guruHalaqoh': return 'Halaqoh Teacher';
			case 'guruProfile.appVersion': return ({required Object version}) => 'MyHalaqoh App v${version}';
			case 'editProfile.title': return 'Edit Profile';
			case 'editProfile.editFotoProfil': return 'Edit Profile Photo';
			case 'editProfile.informasiPribadi': return 'PERSONAL INFORMATION';
			case 'editProfile.namaLengkap': return 'Full Name';
			case 'editProfile.nip': return 'NIP';
			case 'editProfile.jabatan': return 'Position';
			case 'editProfile.kontak': return 'CONTACT';
			case 'editProfile.nomorHp': return 'Phone Number';
			case 'editProfile.email': return 'Email';
			case 'editProfile.simpanPerubahan': return 'Save Changes';
			case 'ubahPassword.title': return 'Change Password';
			case 'ubahPassword.subtitle': return 'Please enter your new password to improve your account security.';
			case 'ubahPassword.kataSandiLama': return 'Old Password';
			case 'ubahPassword.kataSandiBaru': return 'New Password';
			case 'ubahPassword.konfirmasiKataSandiBaru': return 'Confirm New Password';
			case 'ubahPassword.syaratKeamanan': return 'SECURITY REQUIREMENTS';
			case 'ubahPassword.minimal8Karakter': return 'Minimum 8 characters';
			case 'ubahPassword.kombinasiHurufDanAngka': return 'Combination of letters and numbers';
			case 'ubahPassword.ubahKataSandi': return 'Change Password';
			case 'pengaturanScreen.title': return 'Settings';
			case 'pengaturanScreen.bahasa': return 'Language';
			case 'pengaturanScreen.bahasaIndonesia': return 'Bahasa Indonesia';
			case 'pengaturanScreen.english': return 'English';
			case 'pengaturanScreen.pilihBahasa': return 'Select Language';
			case 'pengaturanScreen.tema': return 'Theme';
			case 'pengaturanScreen.terangLight': return 'Light';
			case 'pengaturanScreen.gelapDark': return 'Dark';
			case 'pengaturanScreen.pilihTema': return 'Select Theme';
			case 'waliSantriDashboard.progressHafalan': return 'Memorization Progress';
			case 'waliSantriDashboard.juzTerselesaikan': return 'Juz Completed';
			case 'waliSantriDashboard.target': return ({required Object target}) => 'Target : ${target} Juz';
			case 'waliSantriDashboard.kehadiran': return 'Attendance';
			case 'waliSantriDashboard.periode': return ({required Object periode}) => 'Period: ${periode}';
			case 'waliSantriDashboard.hadir': return 'Present';
			case 'waliSantriDashboard.sakit': return 'Sick';
			case 'waliSantriDashboard.izin': return 'Permit';
			case 'waliSantriDashboard.alpha': return 'Absent';
			case 'waliSantriNav.home': return 'Home';
			case 'waliSantriNav.hafalan': return 'Hafalan';
			case 'waliSantriNav.absensi': return 'Attendance';
			case 'waliSantriNav.profile': return 'Profile';
			case 'WaliSantriPengaturanScreen.title': return 'Settings';
			case 'WaliSantriPengaturanScreen.bahasa': return 'Language';
			case 'WaliSantriPengaturanScreen.bahasaIndonesia': return 'Bahasa Indonesia';
			case 'WaliSantriPengaturanScreen.english': return 'English';
			case 'WaliSantriPengaturanScreen.pilihBahasa': return 'Select Language';
			case 'WaliSantriPengaturanScreen.tema': return 'Theme';
			case 'WaliSantriPengaturanScreen.terangLight': return 'Light';
			case 'WaliSantriPengaturanScreen.gelapDark': return 'Dark';
			case 'WaliSantriPengaturanScreen.pilihTema': return 'Select Theme';
			default: return null;
		}
	}
}

