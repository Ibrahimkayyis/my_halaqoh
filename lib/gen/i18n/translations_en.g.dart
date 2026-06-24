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
	late final TranslationsDialogsEn dialogs = TranslationsDialogsEn.internal(_root);
	late final TranslationsMasterDataSettingsEn masterDataSettings = TranslationsMasterDataSettingsEn.internal(_root);
	late final TranslationsTentangAplikasiScreenEn tentangAplikasiScreen = TranslationsTentangAplikasiScreenEn.internal(_root);
	late final TranslationsGeneralEn general = TranslationsGeneralEn.internal(_root);
	late final TranslationsCalendarEn calendar = TranslationsCalendarEn.internal(_root);
	late final TranslationsLaporanConfigEn laporanConfig = TranslationsLaporanConfigEn.internal(_root);
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

	/// en: 'Total Students'
	String get totalSantri => 'Total Students';

	/// en: 'Total Teachers'
	String get totalGuru => 'Total Teachers';

	/// en: 'Total Halaqoh'
	String get totalHalaqoh => 'Total Halaqoh';

	/// en: 'Main Menu'
	String get menuUtama => 'Main Menu';

	/// en: 'Manage Students'
	String get kelolaSantri => 'Manage Students';

	/// en: 'Manage Teachers'
	String get kelolaGuru => 'Manage Teachers';

	/// en: 'Manage Halaqoh'
	String get kelolaHalaqoh => 'Manage Halaqoh';

	/// en: 'Manage Target'
	String get kelolaTarget => 'Manage Target';

	/// en: '261 Students'
	String get santriCount => '261 Students';

	/// en: '28 Teachers'
	String get guruCount => '28 Teachers';

	/// en: '20 Halaqoh'
	String get halaqohCount => '20 Halaqoh';

	/// en: 'Per Class'
	String get perKelas => 'Per Class';

	/// en: '$count students'
	String santriCountDynamic({required Object count}) => '${count} students';

	/// en: '$count teachers'
	String guruCountDynamic({required Object count}) => '${count} teachers';

	/// en: '$count halaqoh'
	String halaqohCountDynamic({required Object count}) => '${count} halaqoh';
}

// Path: santri
class TranslationsSantriEn {
	TranslationsSantriEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Student Data'
	String get title => 'Student Data';

	/// en: 'Search Students'
	String get searchHint => 'Search Students';

	/// en: 'Showing $count Students'
	String showCount({required Object count}) => 'Showing ${count} Students';

	/// en: 'IDENTITY'
	String get identitas => 'IDENTITY';

	/// en: 'CLASS'
	String get kelas => 'CLASS';

	/// en: 'ACTION'
	String get aksi => 'ACTION';

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'All'
	String get all => 'All';

	/// en: 'This student does not have a connected account.'
	String get noAccountError => 'This student does not have a connected account.';

	/// en: 'Reset Password'
	String get resetPasswordTitle => 'Reset Password';

	/// en: 'Are you sure you want to reset password for $name? The password will be reverted to default "generasi554".'
	String resetPasswordConfirm({required Object name}) => 'Are you sure you want to reset password for ${name}? The password will be reverted to default "generasi554".';

	/// en: 'Yes, Reset'
	String get resetPasswordButton => 'Yes, Reset';

	/// en: 'Password successfully reset to "generasi554".'
	String get resetPasswordSuccess => 'Password successfully reset to "generasi554".';

	/// en: 'Hide Alumni ($count)'
	String hideAlumniTooltip({required Object count}) => 'Hide Alumni (${count})';

	/// en: 'Show Alumni ($count)'
	String showAlumniTooltip({required Object count}) => 'Show Alumni (${count})';

	/// en: 'Process Class Upgrade'
	String get processUpgradeTooltip => 'Process Class Upgrade';

	/// en: 'No active students to process.'
	String get noActiveSantri => 'No active students to process.';

	/// en: 'Upgrade Class'
	String get upgradeClass => 'Upgrade Class';

	/// en: 'No student data available'
	String get emptyList => 'No student data available';

	/// en: 'This process will: • Upgrade grade of $naikCount active students • Archive $alumniCount grade 12 students as alumni • Update memorization targets to school year $tahunAjaran This action cannot be undone. Continue?'
	String upgradeClassConfirmMessage({required Object naikCount, required Object alumniCount, required Object tahunAjaran}) => 'This process will:\n• Upgrade grade of ${naikCount} active students\n• Archive ${alumniCount} grade 12 students as alumni\n• Update memorization targets to school year ${tahunAjaran}\n\nThis action cannot be undone. Continue?';

	/// en: 'Class promotion successfully processed. $naikCount students upgraded class, $alumniCount new alumni.'
	String upgradeClassSuccessMessage({required Object naikCount, required Object alumniCount}) => 'Class promotion successfully processed. ${naikCount} students upgraded class, ${alumniCount} new alumni.';

	/// en: 'Process Class Promotion'
	String get upgradeClassProcessTitle => 'Process Class Promotion';

	/// en: 'All active students will be promoted to the next grade'
	String get upgradeClassProcessSubtitle => 'All active students will be promoted to the next grade';

	/// en: 'New School Year'
	String get newSchoolYear => 'New School Year';

	/// en: 'This action cannot be undone. Make sure the data is correct before processing.'
	String get upgradeClassWarning => 'This action cannot be undone. Make sure the data is correct before processing.';

	/// en: 'What will happen'
	String get upgradeClassEffectsTitle => 'What will happen';

	/// en: '$count active students will promote grade'
	String upgradeClassEffectNaik({required Object count}) => '${count} active students will promote grade';

	/// en: '$count grade 12 students archived as alumni'
	String upgradeClassEffectAlumni({required Object count}) => '${count} grade 12 students archived as alumni';

	/// en: 'All classes' memorization targets updated'
	String get upgradeClassEffectTarget => 'All classes\' memorization targets updated';

	/// en: 'Memorization & halaqoh data will not change'
	String get upgradeClassEffectDataSafe => 'Memorization & halaqoh data will not change';

	/// en: 'Attendance history will not change'
	String get upgradeClassEffectAttendanceSafe => 'Attendance history will not change';

	/// en: 'Student with NIS $nis is already registered.'
	String nisExistsError({required Object nis}) => 'Student with NIS ${nis} is already registered.';

	/// en: 'Class must be selected'
	String get kelasRequired => 'Class must be selected';

	/// en: 'Edit Student Data'
	String get editTitle => 'Edit Student Data';

	/// en: 'NIS is required'
	String get nisRequired => 'NIS is required';

	/// en: 'Name is required'
	String get nameRequired => 'Name is required';
}

// Path: guru
class TranslationsGuruEn {
	TranslationsGuruEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Teacher Data'
	String get title => 'Teacher Data';

	/// en: 'Search Teachers'
	String get searchHint => 'Search Teachers';

	/// en: 'Showing $count Teachers'
	String showCount({required Object count}) => 'Showing ${count} Teachers';

	/// en: 'IDENTITY'
	String get identitas => 'IDENTITY';

	/// en: 'ACTION'
	String get aksi => 'ACTION';

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'This teacher does not have a connected account.'
	String get noAccountError => 'This teacher does not have a connected account.';

	/// en: 'Reset Password'
	String get resetPasswordTitle => 'Reset Password';

	/// en: 'Are you sure you want to reset password for $name? The password will be reverted to default "generasi554".'
	String resetPasswordConfirm({required Object name}) => 'Are you sure you want to reset password for ${name}? The password will be reverted to default "generasi554".';

	/// en: 'Yes, Reset'
	String get resetPasswordButton => 'Yes, Reset';

	/// en: 'Password successfully reset to "generasi554".'
	String get resetPasswordSuccess => 'Password successfully reset to "generasi554".';

	/// en: 'No teacher data available'
	String get emptyList => 'No teacher data available';

	/// en: 'Teacher with NIP $nip is already registered.'
	String nipExistsError({required Object nip}) => 'Teacher with NIP ${nip} is already registered.';

	/// en: 'Edit Teacher Data'
	String get editTitle => 'Edit Teacher Data';

	/// en: 'NIP is required'
	String get nipRequired => 'NIP is required';

	/// en: 'NIP must be 12 or 13 digits'
	String get nipDigitsError => 'NIP must be 12 or 13 digits';

	/// en: 'Name is required'
	String get nameRequired => 'Name is required';

	/// en: 'Phone number must be 10-13 digits (if filled)'
	String get phoneDigitsError => 'Phone number must be 10-13 digits (if filled)';

	/// en: 'Halaqoh Program'
	String get programHalaqohLabel => 'Halaqoh Program';

	/// en: 'Select Program'
	String get chooseProgramHint => 'Select Program';

	/// en: 'Program must be selected'
	String get programRequired => 'Program must be selected';
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

	/// en: '$count Students'
	String santriCount({required Object count}) => '${count} Students';

	/// en: 'Class $kelas'
	String kelasLabel({required Object kelas}) => 'Class ${kelas}';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Class $kelas$program'
	String kelasProgramLabel({required Object kelas, required Object program}) => 'Class ${kelas}${program}';

	/// en: 'No halaqoh data available'
	String get emptyList => 'No halaqoh data available';
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

	/// en: 'Memorization curriculum based on boarding school program. The active semester is set here, while the Academic Year is updated via Class Promotion.'
	String get infoTextNew => 'Memorization curriculum based on boarding school program. The active semester is set here, while the Academic Year is updated via Class Promotion.';

	/// en: 'Class'
	String get kelasLabel => 'Class';

	/// en: 'SMP'
	String get smp => 'SMP';

	/// en: 'Active Semester'
	String get semesterAktif => 'Active Semester';

	/// en: 'Not Set'
	String get belumDitetapkan => 'Not Set';

	/// en: 'Semester 1'
	String get semester1 => 'Semester 1';

	/// en: 'Semester 2'
	String get semester2 => 'Semester 2';

	/// en: 'Midterm'
	String get periodeUTS => 'Midterm';

	/// en: 'Finals'
	String get periodeUAS => 'Finals';

	/// en: 'I'dad Tahsin'
	String get tipeIdadTahsin => 'I\'dad Tahsin';

	/// en: 'Dauroh'
	String get tipeDauroh => 'Dauroh';

	/// en: 'Review (Muraja'ah)'
	String get tipeMurajaah => 'Review (Muraja\'ah)';

	/// en: 'Final Tahfidz Exam'
	String get tipeUAT => 'Final Tahfidz Exam';

	/// en: 'Edit Settings'
	String get editPengaturan => 'Edit Settings';

	/// en: 'SMA'
	String get sma => 'SMA';

	/// en: 'Grade $kelas $jenjang'
	String kelasTitleJenjang({required Object kelas, required Object jenjang}) => 'Grade ${kelas} ${jenjang}';

	/// en: 'AY: $ta • Sem: $sem'
	String taSemLabel({required Object ta, required Object sem}) => 'AY: ${ta} • Sem: ${sem}';

	/// en: 'SEMESTER $number'
	String semesterNumber({required Object number}) => 'SEMESTER ${number}';

	/// en: 'Ziyadah'
	String get tipeZiyadah => 'Ziyadah';
}

// Path: editTarget
class TranslationsEditTargetEn {
	TranslationsEditTargetEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Class Target Settings'
	String get title => 'Class Target Settings';

	/// en: 'ACADEMIC YEAR'
	String get tahunAjaran => 'ACADEMIC YEAR';

	/// en: 'ACTIVE SEMESTER'
	String get semesterAktif => 'ACTIVE SEMESTER';

	/// en: 'Select Active Semester'
	String get pilihSemester => 'Select Active Semester';

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

	/// en: 'Students'
	String get santri => 'Students';

	/// en: 'Teacher'
	String get guru => 'Teacher';

	/// en: 'Halaqoh'
	String get halaqoh => 'Halaqoh';

	/// en: 'Target'
	String get target => 'Target';

	/// en: 'Settings'
	String get pengaturan => 'Settings';
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

	/// en: 'Upload CSV File'
	String get uploadExcel => 'Upload CSV File';

	/// en: 'Import large amounts of data from a file'
	String get uploadExcelDesc => 'Import large amounts of data from a file';

	/// en: 'Add Student Manual'
	String get addSantriManual => 'Add Student Manual';

	/// en: 'Add Teacher Manual'
	String get addGuruManual => 'Add Teacher Manual';

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

	/// en: 'Tap to upload CSV file'
	String get bulkTapUpload => 'Tap to upload CSV file';

	/// en: 'Format .csv (Max. 5MB)'
	String get bulkFormat => 'Format .csv (Max. 5MB)';

	/// en: 'Upload Now'
	String get bulkUploadButton => 'Upload Now';

	/// en: 'Failed to read file. Please select another file.'
	String get bulkErrorFileRead => 'Failed to read file. Please select another file.';

	/// en: 'File ready to process: $name'
	String bulkFileReady({required Object name}) => 'File ready to process: ${name}';

	/// en: 'Reading file...'
	String get bulkStatusReading => 'Reading file...';

	/// en: 'File is empty or has no data rows!'
	String get bulkErrorFileEmpty => 'File is empty or has no data rows!';

	/// en: 'No valid data rows to upload!'
	String get bulkErrorNoValidRows => 'No valid data rows to upload!';

	/// en: 'Processing $count rows...'
	String bulkStatusProcessing({required Object count}) => 'Processing ${count} rows...';

	/// en: 'Saving $current / $total to server...'
	String bulkStatusSaving({required Object current, required Object total}) => 'Saving ${current} / ${total} to server...';

	/// en: 'Done! Success: $success, Failed: $fail (Failed data is usually due to NIP already registered)'
	String bulkGuruFinished({required Object success, required Object fail}) => 'Done! Success: ${success}, Failed: ${fail}\n(Failed data is usually due to NIP already registered)';

	/// en: 'Done! Success: $success, Failed: $fail (Failed data is usually due to NIS already registered)'
	String bulkSantriFinished({required Object success, required Object fail}) => 'Done! Success: ${success}, Failed: ${fail}\n(Failed data is usually due to NIS already registered)';
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

	/// en: 'Class'
	String get kelasHint => 'Class';

	/// en: 'Program'
	String get program => 'Program';

	/// en: 'Program'
	String get programHint => 'Program';

	/// en: 'Instructor (Teacher)'
	String get pengampu => 'Instructor (Teacher)';

	/// en: 'Search instructor name...'
	String get pengampuHint => 'Search instructor name...';

	/// en: 'Student List'
	String get daftarSantri => 'Student List';

	/// en: '+ Add Student'
	String get tambahSantri => '+ Add Student';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'STUDENT NAME'
	String get namaSantri => 'STUDENT NAME';

	/// en: 'ACTION'
	String get aksi => 'ACTION';

	/// en: 'Total: $count Students selected'
	String totalTerpilih({required Object count}) => 'Total: ${count} Students selected';

	/// en: 'SAVE HALAQOH'
	String get simpanHalaqoh => 'SAVE HALAQOH';

	/// en: 'Halaqoh has reached the maximum limit of $max students.'
	String maxSantriReached({required Object max}) => 'Halaqoh has reached the maximum limit of ${max} students.';

	/// en: 'Delete Student?'
	String get deleteSantriTitle => 'Delete Student?';

	/// en: 'Are you sure you want to delete this student from halaqoh?'
	String get deleteSantriMessage => 'Are you sure you want to delete this student from halaqoh?';

	/// en: 'Please complete halaqoh name and instructor'
	String get validationEmptyFields => 'Please complete halaqoh name and instructor';

	/// en: '* $count teachers hidden because they are teaching another halaqoh.'
	String guruFilteredNotice({required Object count}) => '* ${count} teachers hidden because they are teaching another halaqoh.';

	/// en: '$count/$max students'
	String santriLimitCounter({required Object count, required Object max}) => '${count}/${max} students';
}

// Path: selectSantri
class TranslationsSelectSantriEn {
	TranslationsSelectSantriEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select Student'
	String get title => 'Select Student';

	/// en: 'Search name or NIS...'
	String get searchHint => 'Search name or NIS...';

	/// en: 'FILTER'
	String get filter => 'FILTER';

	/// en: '$count Students'
	String countLabel({required Object count}) => '${count} Students';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'NAME'
	String get nama => 'NAME';

	/// en: 'CLASS'
	String get kelas => 'CLASS';

	/// en: 'ADD ($count) STUDENTS'
	String tambahkanButton({required Object count}) => 'ADD (${count}) STUDENTS';

	/// en: 'All Classes'
	String get allClasses => 'All Classes';

	/// en: 'All Programs'
	String get allPrograms => 'All Programs';

	/// en: 'Maximum of $max students per halaqoh. Remove one student before adding a new one.'
	String maxSantriNotice({required Object max}) => 'Maximum of ${max} students per halaqoh. Remove one student before adding a new one.';

	/// en: '($count already in another halaqoh)'
	String assignedElsewhereNotice({required Object count}) => '(${count} already in another halaqoh)';

	/// en: '$count/$max students'
	String slotLimitCounter({required Object count, required Object max}) => '${count}/${max} students';

	/// en: 'No students found'
	String get emptyList => 'No students found';
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

	/// en: '$current/$total Students'
	String santriCount({required Object current, required Object total}) => '${current}/${total} Students';

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

	/// en: 'No submissions yet'
	String get belumAdaSetoran => 'No submissions yet';
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

	/// en: '$count Students'
	String santriCount({required Object count}) => '${count} Students';

	/// en: 'Grade $kelas'
	String kelas({required Object kelas}) => 'Grade ${kelas}';

	/// en: 'Program: $program'
	String program({required Object program}) => 'Program: ${program}';

	/// en: 'Target: $count Juz ($range)'
	String target({required Object count, required Object range}) => 'Target: ${count} Juz (${range})';

	/// en: 'Total: $count Students'
	String total({required Object count}) => 'Total: ${count} Students';

	/// en: 'Ustadz Kayyis'
	String get pengampu => 'Ustadz Kayyis';

	/// en: '$completed Juz completed of $target Juz'
	String progressText({required Object completed, required Object target}) => '${completed} Juz completed of ${target} Juz';

	/// en: 'You have not been assigned to any Halaqoh.'
	String get noHalaqohAssigned => 'You have not been assigned to any Halaqoh.';

	/// en: 'Student not found.'
	String get santriNotFound => 'Student not found.';

	/// en: 'Regular'
	String get programReguler => 'Regular';

	/// en: 'Takhassus'
	String get programTakhassus => 'Takhassus';
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

	late final TranslationsAbsensiBarcodeScannerEn barcodeScanner = TranslationsAbsensiBarcodeScannerEn.internal(_root);
	late final TranslationsAbsensiMulaiAbsensiEn mulaiAbsensi = TranslationsAbsensiMulaiAbsensiEn.internal(_root);
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

	/// en: 'No attendance data for this month'
	String get belumAdaData => 'No attendance data for this month';

	List<String> get abbrTakhassus => [
		'M',
		'D',
		'N',
		'A',
		'E',
	];
	List<String> get abbrReguler => [
		'M',
		'E',
	];

	/// en: 'Error: $message'
	String error({required Object message}) => 'Error: ${message}';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';

	/// en: 'Not Registered in Halaqoh'
	String get belumTerdaftarHalaqoh => 'Not Registered in Halaqoh';

	/// en: 'Session Info'
	String get sessionKeterangan => 'Session Info';

	/// en: 'Morning (Shubuh)'
	String get sessionPagiShubuh => 'Morning (Shubuh)';

	/// en: 'Dhuha'
	String get sessionDhuha => 'Dhuha';

	/// en: 'Noon'
	String get sessionSiang => 'Noon';

	/// en: 'Afternoon (Ashar)'
	String get sessionSoreAshar => 'Afternoon (Ashar)';

	/// en: 'Night (Maghrib)'
	String get sessionMalamMaghrib => 'Night (Maghrib)';
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

	List<String> get sessionsTakhassus => [
		'1. Shubuh',
		'2. Dhuha',
		'3. Noon',
		'4. Ashar',
		'5. Maghrib',
	];
	List<String> get sessionsReguler => [
		'Morning (Left)',
		'Night (Right)',
	];

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';

	/// en: 'Sick'
	String get sakit => 'Sick';

	/// en: 'Excused'
	String get izin => 'Excused';
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

	/// en: 'Swipe date row left/right to view daily data'
	String get swipeHint => 'Swipe date row left/right to view daily data';
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

	/// en: 'Attendance successfully saved!'
	String get saveSuccess => 'Attendance successfully saved!';

	/// en: 'Failed to save attendance'
	String get saveFailed => 'Failed to save attendance';

	/// en: 'Some Students Not Recorded'
	String get warningBelumTitle => 'Some Students Not Recorded';

	/// en: 'There are still $count students whose status has not been set. Those students will not be recorded in attendance data if you keep saving.'
	String warningBelumBody({required Object count}) => 'There are still ${count} students whose status has not been set.\n\nThose students will not be recorded in attendance data if you keep saving.';

	/// en: 'Save Anyway'
	String get keepSaving => 'Save Anyway';

	/// en: 'Complete First'
	String get completeFirst => 'Complete First';

	/// en: 'Data Already Exists'
	String get warningDuplicateTitle => 'Data Already Exists';

	/// en: 'Attendance data for session $session on date $date already exists. Do you want to overwrite it?'
	String warningDuplicateBody({required Object session, required Object date}) => 'Attendance data for session ${session} on date ${date} already exists. Do you want to overwrite it?';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Overwrite'
	String get overwrite => 'Overwrite';

	List<String> get sessionsTakhassus => [
		'Morning',
		'Dhuha',
		'Noon',
		'Afternoon',
		'Night',
	];
	List<String> get sessionsReguler => [
		'Morning',
		'Night',
	];
	late final TranslationsDetailAbsensiHariIniSessionsEn sessions = TranslationsDetailAbsensiHariIniSessionsEn.internal(_root);
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

	/// en: 'Student not found.'
	String get santriNotFound => 'Student not found.';

	/// en: 'Target: $target'
	String targetLabel({required Object target}) => 'Target: ${target}';

	/// en: 'Memorization successfully saved!'
	String get successSave => 'Memorization successfully saved!';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';
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

	/// en: 'Fluency'
	String get kelancaran => 'Fluency';

	/// en: 'Scale 1-100'
	String get skalaPenilaian => 'Scale 1-100';

	/// en: 'Tajwid'
	String get tajwid => 'Tajwid';

	/// en: 'SAVE'
	String get simpan => 'SAVE';

	/// en: 'CANCEL'
	String get batal => 'CANCEL';

	/// en: 'Select Surah List'
	String get pilihDaftarSurat => 'Select Surah List';

	/// en: 'Select one or more surahs'
	String get pilihSatuAtauLebihSurat => 'Select one or more surahs';

	/// en: 'All'
	String get semua => 'All';

	/// en: 'Juz $juz'
	String juzLabel({required Object juz}) => 'Juz ${juz}';

	/// en: 'Search surah name...'
	String get cariNamaSurat => 'Search surah name...';

	/// en: 'CONFIRM SELECTION ($count)'
	String konfirmasiPilihanCount({required Object count}) => 'CONFIRM SELECTION (${count})';

	/// en: 'CONFIRM SELECTION'
	String get konfirmasiPilihan => 'CONFIRM SELECTION';

	/// en: 'Input Memorization'
	String get title => 'Input Memorization';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';

	/// en: 'Deposit Date'
	String get tanggalSetoran => 'Deposit Date';

	/// en: 'Add Surah'
	String get tambahSurat => 'Add Surah';

	/// en: 'Select at least one surah'
	String get errPilihMinimalSatuSurah => 'Select at least one surah';

	/// en: 'Required between 1 and 100'
	String get errWajibDiisi1Sampai100 => 'Required between 1 and 100';

	/// en: 'Juz $juz'
	String juzNumbers({required Object juz}) => 'Juz ${juz}';

	/// en: 'All Verses'
	String get semuaAyat => 'All Verses';
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

	/// en: 'Verse $start - $end'
	String ayatRange({required Object start, required Object end}) => 'Verse ${start} - ${end}';

	/// en: '$count surahs'
	String suratCount({required Object count}) => '${count} surahs';

	/// en: 'All Types'
	String get filterSemuaTipe => 'All Types';

	/// en: 'New Memorization'
	String get filterHafalanBaru => 'New Memorization';

	/// en: 'Review'
	String get filterMurajaah => 'Review';

	/// en: 'No memorization data for this month'
	String get belumAdaDataBulanIni => 'No memorization data for this month';

	/// en: 'No memorization for this filter'
	String get tidakAdaHafalanFilter => 'No memorization for this filter';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';

	/// en: 'Memorization data successfully deleted!'
	String get deleteSuccess => 'Memorization data successfully deleted!';

	/// en: 'Failed to delete memorization data.'
	String get deleteFailed => 'Failed to delete memorization data.';
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

	/// en: '$completed of $total Verses Completed'
	String ayatSelesai({required Object completed, required Object total}) => '${completed} of ${total} Verses Completed';

	/// en: 'Juz $juz'
	String juzLabel({required Object juz}) => 'Juz ${juz}';

	/// en: 'Class $kelas'
	String kelasLabel({required Object kelas}) => 'Class ${kelas}';

	/// en: 'Add Memorization Target'
	String get tambahTargetHafalan => 'Add Memorization Target';

	/// en: 'Warning: $juzLabels has not been completed. Ensure the student completes the memorization target for this semester. You can still add new targets, but set targets must be completed first.'
	String warningBanner({required Object juzLabels}) => 'Warning: ${juzLabels} has not been completed. Ensure the student completes the memorization target for this semester. You can still add new targets, but set targets must be completed first.';

	/// en: 'Search Juz (e.g. Juz 1)'
	String get cariJuz => 'Search Juz (e.g. Juz 1)';

	/// en: '$count Surah'
	String surahCount({required Object count}) => '${count} Surah';

	/// en: 'Target Not Completed'
	String get targetBelumSelesai => 'Target Not Completed';

	/// en: '$juzLabels has not been completed this semester. Remind the student to complete the set targets. Are you sure you want to add Juz $nextJuz as an extra target?'
	String confirmAddExtraJuzMessage({required Object juzLabels, required Object nextJuz}) => '${juzLabels} has not been completed this semester.\n\nRemind the student to complete the set targets. Are you sure you want to add Juz ${nextJuz} as an extra target?';

	/// en: 'Cancel'
	String get batal => 'Cancel';

	/// en: 'Yes, Add'
	String get yaTambahkan => 'Yes, Add';

	/// en: 'Juz $juz added as a target'
	String successAddTarget({required Object juz}) => 'Juz ${juz} added as a target';

	/// en: 'Failed to save target, try again'
	String get failedSaveTarget => 'Failed to save target, try again';

	/// en: 'Close'
	String get tutup => 'Close';

	/// en: 'Tap + to add a juz target manually'
	String get teacherCanAddHint => 'Tap + to add a juz target manually';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';

	/// en: '$completed of $total Verses Completed'
	String ayatCompletedInfo({required Object completed, required Object total}) => '${completed} of ${total} Verses Completed';

	/// en: '$percent %'
	String percent({required Object percent}) => '${percent} %';
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

	/// en: 'Unknown'
	String get unknownSurah => 'Unknown';

	/// en: 'Juz $juz'
	String juzTitle({required Object juz}) => 'Juz ${juz}';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';

	/// en: '$count Verses'
	String ayatCount({required Object count}) => '${count} Verses';

	/// en: '$percent%'
	String percent({required Object percent}) => '${percent}%';
}

// Path: mutabaahSantri
class TranslationsMutabaahSantriEn {
	TranslationsMutabaahSantriEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Student Mutaba'ah'
	String get title => 'Student Mutaba\'ah';

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

	List<String> get dayNames => [
		'SUN',
		'MON',
		'TUE',
		'WED',
		'THU',
		'FRI',
		'SAT',
	];

	/// en: 'No new memorization yet'
	String get belumAdaHafalanBaru => 'No new memorization yet';

	/// en: 'No review yet'
	String get belumAdaMurajaah => 'No review yet';

	/// en: '$count surahs'
	String suratCount({required Object count}) => '${count} surahs';
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

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Teacher of $halaqoh'
	String pengampu({required Object halaqoh}) => 'Teacher of ${halaqoh}';

	/// en: 'NIP: $nip'
	String nipLabel({required Object nip}) => 'NIP: ${nip}';
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

	/// en: 'Teacher of $halaqoh'
	String pengampu({required Object halaqoh}) => 'Teacher of ${halaqoh}';

	/// en: 'Profile successfully updated'
	String get successMessage => 'Profile successfully updated';

	/// en: 'Failed to update profile'
	String get failedMessage => 'Failed to update profile';

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'Class'
	String get kelas => 'Class';

	/// en: 'Program'
	String get program => 'Program';

	/// en: 'Guardian Contact'
	String get kontakWali => 'Guardian Contact';

	/// en: 'Guardian Name'
	String get namaWali => 'Guardian Name';

	/// en: 'Relationship'
	String get hubungan => 'Relationship';

	/// en: 'Select relationship'
	String get pilihHubungan => 'Select relationship';

	List<String> get hubunganOptions => [
		'Father',
		'Mother',
		'Sibling',
	];
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

	/// en: 'Password successfully changed'
	String get successMessage => 'Password successfully changed';

	/// en: 'Failed to change password'
	String get failedMessage => 'Failed to change password';

	/// en: 'Old password is required'
	String get errOldPasswordRequired => 'Old password is required';

	/// en: 'New password is required'
	String get errNewPasswordRequired => 'New password is required';

	/// en: 'Minimum 8 characters'
	String get errMin8Chars => 'Minimum 8 characters';

	/// en: 'Must be a combination of letters and numbers'
	String get errLetterNumberCombo => 'Must be a combination of letters and numbers';

	/// en: 'Confirm password is required'
	String get errConfirmRequired => 'Confirm password is required';

	/// en: 'Passwords do not match'
	String get errMismatch => 'Passwords do not match';

	/// en: 'Processing...'
	String get processing => 'Processing...';
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

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Not registered in any Halaqoh yet'
	String get notRegisteredHalaqoh => 'Not registered in any Halaqoh yet';

	/// en: 'NIS: $nis'
	String nis({required Object nis}) => 'NIS: ${nis}';

	/// en: 'Teacher: $name'
	String guru({required Object name}) => 'Teacher: ${name}';

	/// en: 'Extra Memorization'
	String get extraMemorization => 'Extra Memorization';

	/// en: 'Juz: $juz'
	String juzList({required Object juz}) => 'Juz: ${juz}';

	/// en: 'Extra : $count Juz'
	String extraJuzTarget({required Object count}) => 'Extra : ${count} Juz';

	/// en: 'Class $kelas | $halaqoh'
	String halaqohInfo({required Object kelas, required Object halaqoh}) => 'Class ${kelas} | ${halaqoh}';
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

	/// en: 'Notifications'
	String get notifikasi => 'Notifications';

	/// en: 'Active'
	String get notifikasiAktif => 'Active';

	/// en: 'Inactive'
	String get notifikasiNonAktif => 'Inactive';

	/// en: 'Enable Notifications'
	String get notifikasiDialogTitle => 'Enable Notifications';

	/// en: 'Notification permission has not been granted. Open your Phone Settings, enable notification permission for this app, then come back and try again.'
	String get notifikasiDialogMessage => 'Notification permission has not been granted. Open your Phone Settings, enable notification permission for this app, then come back and try again.';

	/// en: 'Open Settings'
	String get bukaSettingHp => 'Open Settings';
}

// Path: dialogs
class TranslationsDialogsEn {
	TranslationsDialogsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete Data?'
	String get deleteTitle => 'Delete Data?';

	/// en: 'Are you sure you want to delete this data? This action cannot be undone and it will be permanently lost.'
	String get deleteMessage => 'Are you sure you want to delete this data? This action cannot be undone and it will be permanently lost.';

	/// en: 'Save Changes?'
	String get saveTitle => 'Save Changes?';

	/// en: 'Please ensure all entered data is correct before saving.'
	String get saveMessage => 'Please ensure all entered data is correct before saving.';

	/// en: 'Cancel'
	String get batal => 'Cancel';

	/// en: 'Delete'
	String get hapus => 'Delete';

	/// en: 'Save'
	String get simpan => 'Save';

	/// en: 'Log Out?'
	String get logoutTitle => 'Log Out?';

	/// en: 'Are you sure you want to log out from this account? You will need to log in again to use the app.'
	String get logoutMessage => 'Are you sure you want to log out from this account? You will need to log in again to use the app.';

	/// en: 'Log Out'
	String get keluar => 'Log Out';
}

// Path: masterDataSettings
class TranslationsMasterDataSettingsEn {
	TranslationsMasterDataSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'About App'
	String get tentangAplikasi => 'About App';

	/// en: 'Log Out'
	String get keluar => 'Log Out';

	/// en: 'Version {version}'
	String get appVersion => 'Version {version}';
}

// Path: tentangAplikasiScreen
class TranslationsTentangAplikasiScreenEn {
	TranslationsTentangAplikasiScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About App'
	String get title => 'About App';

	/// en: 'MyHalaqoh'
	String get appName => 'MyHalaqoh';

	/// en: 'Digital Halaqoh Management Platform'
	String get tagline => 'Digital Halaqoh Management Platform';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'About MyHalaqoh'
	String get sectionTentang => 'About MyHalaqoh';

	/// en: 'MyHalaqoh is an integrated digital platform specifically designed to help manage halaqoh in Islamic boarding school environments efficiently, transparently, and accessibly.'
	String get deskripsi1 => 'MyHalaqoh is an integrated digital platform specifically designed to help manage halaqoh in Islamic boarding school environments efficiently, transparently, and accessibly.';

	/// en: 'Developed specifically for $pesantren, this app connects Admins, Teachers, and Student Guardians in one integrated digital ecosystem.'
	String deskripsi2({required Object pesantren}) => 'Developed specifically for ${pesantren}, this app connects Admins, Teachers, and Student Guardians in one integrated digital ecosystem.';

	/// en: 'Key Features'
	String get sectionFitur => 'Key Features';

	/// en: 'QR Code Attendance'
	String get fiturAbsensiJudul => 'QR Code Attendance';

	/// en: 'Record student attendance quickly using an integrated barcode scanner.'
	String get fiturAbsensiDesc => 'Record student attendance quickly using an integrated barcode scanner.';

	/// en: 'Quran Memorization'
	String get fiturHafalanJudul => 'Quran Memorization';

	/// en: 'Track student memorization progress per juz and per surah in real-time.'
	String get fiturHafalanDesc => 'Track student memorization progress per juz and per surah in real-time.';

	/// en: 'Automatic Notifications'
	String get fiturNotifJudul => 'Automatic Notifications';

	/// en: 'Attendance and memorization information is sent directly to Student Guardians via push notification.'
	String get fiturNotifDesc => 'Attendance and memorization information is sent directly to Student Guardians via push notification.';

	/// en: 'Multi-Role Dashboard'
	String get fiturMultiRoleJudul => 'Multi-Role Dashboard';

	/// en: 'Views and features tailored for Admin, Teacher, and Student Guardian.'
	String get fiturMultiRoleDesc => 'Views and features tailored for Admin, Teacher, and Student Guardian.';

	/// en: 'Offline Mode'
	String get fiturOfflineJudul => 'Offline Mode';

	/// en: 'Attendance and memorization can still be recorded even without an internet connection.'
	String get fiturOfflineDesc => 'Attendance and memorization can still be recorded even without an internet connection.';

	/// en: 'App Information'
	String get sectionInfo => 'App Information';

	/// en: 'App Name'
	String get infoNamaApp => 'App Name';

	/// en: 'Version'
	String get infoVersi => 'Version';

	/// en: 'Platform'
	String get infoPlatform => 'Platform';

	/// en: 'Institution'
	String get infoLembaga => 'Institution';

	/// en: 'Android'
	String get infoPlatformValue => 'Android';

	/// en: 'Contact & Support'
	String get sectionKontak => 'Contact & Support';

	/// en: 'If you need technical assistance or have questions about the app, please contact the administrator via WhatsApp.'
	String get kontakDeskripsi => 'If you need technical assistance or have questions about the app, please contact the administrator via WhatsApp.';

	/// en: 'Contact Admin via WhatsApp'
	String get kontakButton => 'Contact Admin via WhatsApp';

	/// en: 'Made with ❤️ for the advancement of Islamic boarding school education'
	String get footer => 'Made with ❤️ for the advancement of Islamic boarding school education';

	/// en: '© 2026 MyHalaqoh. All rights reserved.'
	String get copyright => '© 2026 MyHalaqoh. All rights reserved.';
}

// Path: general
class TranslationsGeneralEn {
	TranslationsGeneralEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Warning'
	String get warning => 'Warning';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'ACTIVE'
	String get active => 'ACTIVE';

	/// en: 'Confirmation'
	String get confirmation => 'Confirmation';

	/// en: 'Yes, Process'
	String get yesProcess => 'Yes, Process';
}

// Path: calendar
class TranslationsCalendarEn {
	TranslationsCalendarEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	List<String> get months => [
		'January',
		'February',
		'March',
		'April',
		'May',
		'June',
		'July',
		'August',
		'September',
		'October',
		'November',
		'December',
	];
	List<String> get daysAbbr => [
		'MON',
		'TUE',
		'WED',
		'THU',
		'FRI',
		'SAT',
		'SUN',
	];
	List<String> get daysAbbrSundayFirst => [
		'SUN',
		'MON',
		'TUE',
		'WED',
		'THU',
		'FRI',
		'SAT',
	];
}

// Path: laporanConfig
class TranslationsLaporanConfigEn {
	TranslationsLaporanConfigEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Download Attendance Report'
	String get titleAbsensi => 'Download Attendance Report';

	/// en: 'Download Memorization Report'
	String get titleHafalan => 'Download Memorization Report';

	/// en: 'Halaqoh Attendance Recap'
	String get titleHalaqoh => 'Halaqoh Attendance Recap';

	/// en: 'Select period & configurations for student's PDF report.'
	String get subtitleAbsensi => 'Select period & configurations for student\'s PDF report.';

	/// en: 'Select period & configurations for student's PDF report.'
	String get subtitleHafalan => 'Select period & configurations for student\'s PDF report.';

	/// en: 'Select period to download full halaqoh recap.'
	String get subtitleHalaqoh => 'Select period to download full halaqoh recap.';

	/// en: 'Time Range'
	String get timeRange => 'Time Range';

	/// en: 'Weekly'
	String get weekly => 'Weekly';

	/// en: 'Monthly'
	String get monthly => 'Monthly';

	/// en: 'Custom'
	String get custom => 'Custom';

	/// en: 'Semester'
	String get semester => 'Semester';

	/// en: 'Select Date Range'
	String get selectDateRange => 'Select Date Range';

	/// en: 'Start Date'
	String get startDate => 'Start Date';

	/// en: 'End Date'
	String get endDate => 'End Date';

	/// en: 'Select date'
	String get selectDateHint => 'Select date';

	/// en: 'Select Start Date'
	String get chooseStartDate => 'Select Start Date';

	/// en: 'Select End Date'
	String get chooseEndDate => 'Select End Date';

	/// en: 'Select'
	String get btnSelect => 'Select';

	/// en: 'Cancel'
	String get btnCancel => 'Cancel';

	/// en: 'Total $days days selected'
	String totalDaysSelected({required Object days}) => 'Total ${days} days selected';

	/// en: 'Report Period'
	String get reportPeriod => 'Report Period';

	/// en: '$days days'
	String daysShort({required Object days}) => '${days} days';

	/// en: 'Generate PDF Report'
	String get btnGeneratePdf => 'Generate PDF Report';

	/// en: 'Generate PDF Recap'
	String get btnGenerateRecapPdf => 'Generate PDF Recap';

	/// en: 'Generating report...'
	String get generatingReport => 'Generating report...';

	/// en: 'Report Ready!'
	String get readyTitle => 'Report Ready!';

	/// en: 'Recap Ready!'
	String get readyRecapTitle => 'Recap Ready!';

	/// en: 'PDF successfully generated. Preview or share now.'
	String get readySubtitle => 'PDF successfully generated. Preview or share now.';

	/// en: 'Attendance Report'
	String get attendanceReport => 'Attendance Report';

	/// en: 'Attendance Recap'
	String get recapAttendance => 'Attendance Recap';

	/// en: 'Memorization Report'
	String get memorizationReport => 'Memorization Report';

	/// en: 'Preview'
	String get btnPreview => 'Preview';

	/// en: 'Share'
	String get btnShare => 'Share';

	/// en: 'Create new report'
	String get btnCreateNewReport => 'Create new report';

	/// en: 'Create new recap'
	String get btnCreateNewRecap => 'Create new recap';

	/// en: 'Failed to generate report: $error'
	String errGenerate({required Object error}) => 'Failed to generate report: ${error}';

	/// en: 'Failed to open preview: $error'
	String errPreview({required Object error}) => 'Failed to open preview: ${error}';

	/// en: 'Failed to share report: $error'
	String errShare({required Object error}) => 'Failed to share report: ${error}';

	late final TranslationsLaporanConfigPdfEn pdf = TranslationsLaporanConfigPdfEn.internal(_root);
}

// Path: absensi.barcodeScanner
class TranslationsAbsensiBarcodeScannerEn {
	TranslationsAbsensiBarcodeScannerEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Student with NIS $nis is not a member of your halaqoh'
	String notMember({required Object nis}) => 'Student with NIS ${nis} is not a member of your halaqoh';

	/// en: 'Failed to load camera: $error'
	String cameraError({required Object error}) => 'Failed to load camera:\n${error}';

	/// en: 'Ensure the barcode is in a clear position'
	String get clearPosition => 'Ensure the barcode is in a clear position';

	/// en: '$name present'
	String scannedSuccess({required Object name}) => '${name} present';

	/// en: 'Total $count Students'
	String totalSantri({required Object count}) => 'Total ${count} Students';

	/// en: '$scanned / $total'
	String progress({required Object scanned, required Object total}) => '${scanned} / ${total}';

	/// en: 'NIS: $nis'
	String nisLabel({required Object nis}) => 'NIS: ${nis}';
}

// Path: absensi.mulaiAbsensi
class TranslationsAbsensiMulaiAbsensiEn {
	TranslationsAbsensiMulaiAbsensiEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shubuh'
	String get shubuh => 'Shubuh';

	/// en: 'Dhuha'
	String get dhuha => 'Dhuha';

	/// en: 'Noon'
	String get siang => 'Noon';

	/// en: 'Afternoon/Ashar'
	String get soreAshar => 'Afternoon/Ashar';

	/// en: 'Maghrib'
	String get maghrib => 'Maghrib';

	/// en: 'Mark All Present'
	String get markAllPresent => 'Mark All Present';
}

// Path: detailAbsensiHariIni.sessions
class TranslationsDetailAbsensiHariIniSessionsEn {
	TranslationsDetailAbsensiHariIniSessionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Morning'
	String get pagi => 'Morning';

	/// en: 'Dhuha'
	String get dhuha => 'Dhuha';

	/// en: 'Noon'
	String get siang => 'Noon';

	/// en: 'Afternoon'
	String get ashar => 'Afternoon';

	/// en: 'Night'
	String get malam => 'Night';
}

// Path: laporanConfig.pdf
class TranslationsLaporanConfigPdfEn {
	TranslationsLaporanConfigPdfEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shubuh'
	String get shubuh => 'Shubuh';

	/// en: 'Dhuha'
	String get dhuha => 'Dhuha';

	/// en: 'Siang'
	String get siang => 'Siang';

	/// en: 'Ashar'
	String get ashar => 'Ashar';

	/// en: 'Maghrib'
	String get maghrib => 'Maghrib';

	/// en: 'H'
	String get presentCode => 'H';

	/// en: 'S'
	String get sickCode => 'S';

	/// en: 'I'
	String get permitCode => 'I';

	/// en: 'A'
	String get absentCode => 'A';

	/// en: 'MyHalaqoh — Halaqoh Management System'
	String get systemName => 'MyHalaqoh — Halaqoh Management System';

	/// en: 'Page $page of $total'
	String pageLabel({required Object page, required Object total}) => 'Page ${page} of ${total}';

	/// en: 'Student Attendance Report'
	String get titleAttendance => 'Student Attendance Report';

	/// en: 'Halaqoh Attendance Recap Report'
	String get titleHalaqohRecap => 'Halaqoh Attendance Recap Report';

	/// en: 'Student Memorization Progress Report'
	String get titleMemorization => 'Student Memorization Progress Report';

	/// en: 'Printed on: $date'
	String printedAt({required Object date}) => 'Printed on: ${date}';

	/// en: 'Student Information'
	String get studentInfo => 'Student Information';

	/// en: 'Halaqoh Information'
	String get halaqohInfo => 'Halaqoh Information';

	/// en: 'Student Name'
	String get studentName => 'Student Name';

	/// en: 'Name'
	String get nameHeader => 'Name';

	/// en: 'Attendance'
	String get kehadiranHeader => 'Attendance';

	/// en: 'Max'
	String get maxHeader => 'Max';

	/// en: 'Att'
	String get hdrHeader => 'Att';

	/// en: 'NIS'
	String get nis => 'NIS';

	/// en: 'Halaqoh'
	String get halaqoh => 'Halaqoh';

	/// en: 'Pembimbing'
	String get pembimbing => 'Pembimbing';

	/// en: 'Musyrif'
	String get musyrif => 'Musyrif';

	/// en: 'Program'
	String get program => 'Program';

	/// en: 'Report Type'
	String get reportType => 'Report Type';

	/// en: 'Attendance Summary'
	String get summaryAttendance => 'Attendance Summary';

	/// en: 'Memorization Summary'
	String get summaryMemorization => 'Memorization Summary';

	/// en: 'Present'
	String get present => 'Present';

	/// en: 'Sick'
	String get sick => 'Sick';

	/// en: 'Permit'
	String get permit => 'Permit';

	/// en: 'Absent'
	String get absent => 'Absent';

	/// en: 'Ziyadah'
	String get ziyadah => 'Ziyadah';

	/// en: 'Muraja'ah'
	String get murajaah => 'Muraja\'ah';

	/// en: 'Attendance Rate'
	String get attendanceRate => 'Attendance Rate';

	/// en: 'Average Score'
	String get avgScore => 'Average Score';

	/// en: '$hadir of $total scheduled sessions'
	String totalScheduled({required Object hadir, required Object total}) => '${hadir} of ${total} scheduled sessions';

	/// en: 'Daily Attendance Details'
	String get dailyDetailTitle => 'Daily Attendance Details';

	/// en: 'Memorization Deposit Details'
	String get setoranDetailTitle => 'Memorization Deposit Details';

	late final TranslationsLaporanConfigPdfPredikatEn predikat = TranslationsLaporanConfigPdfPredikatEn.internal(_root);

	/// en: 'Week $index ($start – $end)'
	String weeksLabel({required Object index, required Object start, required Object end}) => 'Week ${index}  (${start} – ${end})';

	/// en: 'No.'
	String get no => 'No.';

	/// en: 'Day, Date'
	String get dateHeader => 'Day, Date';

	/// en: 'Day'
	String get dayHeader => 'Day';

	/// en: 'Type'
	String get typeHeader => 'Type';

	/// en: 'Date'
	String get dateShort => 'Date';

	/// en: 'Surah / Ayah'
	String get surahAyatHeader => 'Surah / Ayah';

	/// en: 'New'
	String get baruCode => 'New';

	/// en: 'Review'
	String get ulangCode => 'Review';

	/// en: 'Ziyadah (New Memorization)'
	String get ziyadahLabel => 'Ziyadah (New Memorization)';

	/// en: 'Muraja'ah (Review)'
	String get murajaahLabel => 'Muraja\'ah (Review)';

	/// en: 'Juz'
	String get juzHeader => 'Juz';

	/// en: 'Surah Details'
	String get surahDetailHeader => 'Surah Details';

	/// en: 'Fluency'
	String get kelancaranHeader => 'Fluency';

	/// en: 'Tajwid'
	String get tajwidHeader => 'Tajwid';

	/// en: 'Average'
	String get avgHeader => 'Average';

	/// en: 'Grade'
	String get predikatHeader => 'Grade';

	/// en: 'Present'
	String get hadirLabel => 'Present';

	/// en: 'Sick'
	String get sakitLabel => 'Sick';

	/// en: 'Permit'
	String get izinLabel => 'Permit';

	/// en: 'Absent'
	String get alfaLabel => 'Absent';

	/// en: 'Remarks'
	String get keteranganLabel => 'Remarks';

	/// en: 'Legend'
	String get legenda => 'Legend';

	/// en: 'No session'
	String get noSession => 'No session';

	/// en: 'H = Present | S = Sick | I = Permit | A = Absent'
	String get statusLegenda => 'H = Present  |  S = Sick  |  I = Permit  |  A = Absent';

	/// en: 'Mumtaz: 85 - 100 | Jayyid: 70 - 84 | Maqbul: < 70'
	String get predikatLegenda => 'Mumtaz: 85 - 100  |  Jayyid: 70 - 84  |  Maqbul: < 70';

	/// en: 'Week $index'
	String pekanShort({required Object index}) => 'Week ${index}';
}

// Path: laporanConfig.pdf.predikat
class TranslationsLaporanConfigPdfPredikatEn {
	TranslationsLaporanConfigPdfPredikatEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mumtaz'
	String get mumtaz => 'Mumtaz';

	/// en: 'Jayyid'
	String get jayyid => 'Jayyid';

	/// en: 'Maqbul'
	String get maqbul => 'Maqbul';
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
			case 'dashboard.totalSantri': return 'Total Students';
			case 'dashboard.totalGuru': return 'Total Teachers';
			case 'dashboard.totalHalaqoh': return 'Total Halaqoh';
			case 'dashboard.menuUtama': return 'Main Menu';
			case 'dashboard.kelolaSantri': return 'Manage Students';
			case 'dashboard.kelolaGuru': return 'Manage Teachers';
			case 'dashboard.kelolaHalaqoh': return 'Manage Halaqoh';
			case 'dashboard.kelolaTarget': return 'Manage Target';
			case 'dashboard.santriCount': return '261 Students';
			case 'dashboard.guruCount': return '28 Teachers';
			case 'dashboard.halaqohCount': return '20 Halaqoh';
			case 'dashboard.perKelas': return 'Per Class';
			case 'dashboard.santriCountDynamic': return ({required Object count}) => '${count} students';
			case 'dashboard.guruCountDynamic': return ({required Object count}) => '${count} teachers';
			case 'dashboard.halaqohCountDynamic': return ({required Object count}) => '${count} halaqoh';
			case 'santri.title': return 'Student Data';
			case 'santri.searchHint': return 'Search Students';
			case 'santri.showCount': return ({required Object count}) => 'Showing ${count} Students';
			case 'santri.identitas': return 'IDENTITY';
			case 'santri.kelas': return 'CLASS';
			case 'santri.aksi': return 'ACTION';
			case 'santri.filter': return 'Filter';
			case 'santri.all': return 'All';
			case 'santri.noAccountError': return 'This student does not have a connected account.';
			case 'santri.resetPasswordTitle': return 'Reset Password';
			case 'santri.resetPasswordConfirm': return ({required Object name}) => 'Are you sure you want to reset password for ${name}? The password will be reverted to default "generasi554".';
			case 'santri.resetPasswordButton': return 'Yes, Reset';
			case 'santri.resetPasswordSuccess': return 'Password successfully reset to "generasi554".';
			case 'santri.hideAlumniTooltip': return ({required Object count}) => 'Hide Alumni (${count})';
			case 'santri.showAlumniTooltip': return ({required Object count}) => 'Show Alumni (${count})';
			case 'santri.processUpgradeTooltip': return 'Process Class Upgrade';
			case 'santri.noActiveSantri': return 'No active students to process.';
			case 'santri.upgradeClass': return 'Upgrade Class';
			case 'santri.emptyList': return 'No student data available';
			case 'santri.upgradeClassConfirmMessage': return ({required Object naikCount, required Object alumniCount, required Object tahunAjaran}) => 'This process will:\n• Upgrade grade of ${naikCount} active students\n• Archive ${alumniCount} grade 12 students as alumni\n• Update memorization targets to school year ${tahunAjaran}\n\nThis action cannot be undone. Continue?';
			case 'santri.upgradeClassSuccessMessage': return ({required Object naikCount, required Object alumniCount}) => 'Class promotion successfully processed. ${naikCount} students upgraded class, ${alumniCount} new alumni.';
			case 'santri.upgradeClassProcessTitle': return 'Process Class Promotion';
			case 'santri.upgradeClassProcessSubtitle': return 'All active students will be promoted to the next grade';
			case 'santri.newSchoolYear': return 'New School Year';
			case 'santri.upgradeClassWarning': return 'This action cannot be undone. Make sure the data is correct before processing.';
			case 'santri.upgradeClassEffectsTitle': return 'What will happen';
			case 'santri.upgradeClassEffectNaik': return ({required Object count}) => '${count} active students will promote grade';
			case 'santri.upgradeClassEffectAlumni': return ({required Object count}) => '${count} grade 12 students archived as alumni';
			case 'santri.upgradeClassEffectTarget': return 'All classes\' memorization targets updated';
			case 'santri.upgradeClassEffectDataSafe': return 'Memorization & halaqoh data will not change';
			case 'santri.upgradeClassEffectAttendanceSafe': return 'Attendance history will not change';
			case 'santri.nisExistsError': return ({required Object nis}) => 'Student with NIS ${nis} is already registered.';
			case 'santri.kelasRequired': return 'Class must be selected';
			case 'santri.editTitle': return 'Edit Student Data';
			case 'santri.nisRequired': return 'NIS is required';
			case 'santri.nameRequired': return 'Name is required';
			case 'guru.title': return 'Teacher Data';
			case 'guru.searchHint': return 'Search Teachers';
			case 'guru.showCount': return ({required Object count}) => 'Showing ${count} Teachers';
			case 'guru.identitas': return 'IDENTITY';
			case 'guru.aksi': return 'ACTION';
			case 'guru.filter': return 'Filter';
			case 'guru.noAccountError': return 'This teacher does not have a connected account.';
			case 'guru.resetPasswordTitle': return 'Reset Password';
			case 'guru.resetPasswordConfirm': return ({required Object name}) => 'Are you sure you want to reset password for ${name}? The password will be reverted to default "generasi554".';
			case 'guru.resetPasswordButton': return 'Yes, Reset';
			case 'guru.resetPasswordSuccess': return 'Password successfully reset to "generasi554".';
			case 'guru.emptyList': return 'No teacher data available';
			case 'guru.nipExistsError': return ({required Object nip}) => 'Teacher with NIP ${nip} is already registered.';
			case 'guru.editTitle': return 'Edit Teacher Data';
			case 'guru.nipRequired': return 'NIP is required';
			case 'guru.nipDigitsError': return 'NIP must be 12 or 13 digits';
			case 'guru.nameRequired': return 'Name is required';
			case 'guru.phoneDigitsError': return 'Phone number must be 10-13 digits (if filled)';
			case 'guru.programHalaqohLabel': return 'Halaqoh Program';
			case 'guru.chooseProgramHint': return 'Select Program';
			case 'guru.programRequired': return 'Program must be selected';
			case 'halaqoh.title': return 'Data Halaqoh';
			case 'halaqoh.searchHint': return 'Search Halaqoh';
			case 'halaqoh.showCount': return ({required Object count}) => 'Showing ${count} Halaqoh';
			case 'halaqoh.sort': return 'Sort';
			case 'halaqoh.santriCount': return ({required Object count}) => '${count} Students';
			case 'halaqoh.kelasLabel': return ({required Object kelas}) => 'Class ${kelas}';
			case 'halaqoh.all': return 'All';
			case 'halaqoh.kelasProgramLabel': return ({required Object kelas, required Object program}) => 'Class ${kelas}${program}';
			case 'halaqoh.emptyList': return 'No halaqoh data available';
			case 'targetHafalan.title': return 'Memorization Target';
			case 'targetHafalan.reguler': return 'REGULAR';
			case 'targetHafalan.takhassus': return 'TAKHASSUS';
			case 'targetHafalan.infoText': return 'Set memorization targets for each class, the target will be applied to all students in that class.';
			case 'targetHafalan.infoTextNew': return 'Memorization curriculum based on boarding school program. The active semester is set here, while the Academic Year is updated via Class Promotion.';
			case 'targetHafalan.kelasLabel': return 'Class';
			case 'targetHafalan.smp': return 'SMP';
			case 'targetHafalan.semesterAktif': return 'Active Semester';
			case 'targetHafalan.belumDitetapkan': return 'Not Set';
			case 'targetHafalan.semester1': return 'Semester 1';
			case 'targetHafalan.semester2': return 'Semester 2';
			case 'targetHafalan.periodeUTS': return 'Midterm';
			case 'targetHafalan.periodeUAS': return 'Finals';
			case 'targetHafalan.tipeIdadTahsin': return 'I\'dad Tahsin';
			case 'targetHafalan.tipeDauroh': return 'Dauroh';
			case 'targetHafalan.tipeMurajaah': return 'Review (Muraja\'ah)';
			case 'targetHafalan.tipeUAT': return 'Final Tahfidz Exam';
			case 'targetHafalan.editPengaturan': return 'Edit Settings';
			case 'targetHafalan.sma': return 'SMA';
			case 'targetHafalan.kelasTitleJenjang': return ({required Object kelas, required Object jenjang}) => 'Grade ${kelas} ${jenjang}';
			case 'targetHafalan.taSemLabel': return ({required Object ta, required Object sem}) => 'AY: ${ta} • Sem: ${sem}';
			case 'targetHafalan.semesterNumber': return ({required Object number}) => 'SEMESTER ${number}';
			case 'targetHafalan.tipeZiyadah': return 'Ziyadah';
			case 'editTarget.title': return 'Class Target Settings';
			case 'editTarget.tahunAjaran': return 'ACADEMIC YEAR';
			case 'editTarget.semesterAktif': return 'ACTIVE SEMESTER';
			case 'editTarget.pilihSemester': return 'Select Active Semester';
			case 'editTarget.simpanPerubahan': return 'Save Changes';
			case 'nav.dashboard': return 'Dashboard';
			case 'nav.santri': return 'Students';
			case 'nav.guru': return 'Teacher';
			case 'nav.halaqoh': return 'Halaqoh';
			case 'nav.target': return 'Target';
			case 'nav.pengaturan': return 'Settings';
			case 'addData.title': return 'Add Data';
			case 'addData.subtitle': return 'Choose your preferred data input method';
			case 'addData.inputManual': return 'Manual Input';
			case 'addData.inputManualDesc': return 'Fill in the form one by one in detail';
			case 'addData.uploadExcel': return 'Upload CSV File';
			case 'addData.uploadExcelDesc': return 'Import large amounts of data from a file';
			case 'addData.addSantriManual': return 'Add Student Manual';
			case 'addData.addGuruManual': return 'Add Teacher Manual';
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
			case 'addData.bulkTapUpload': return 'Tap to upload CSV file';
			case 'addData.bulkFormat': return 'Format .csv (Max. 5MB)';
			case 'addData.bulkUploadButton': return 'Upload Now';
			case 'addData.bulkErrorFileRead': return 'Failed to read file. Please select another file.';
			case 'addData.bulkFileReady': return ({required Object name}) => 'File ready to process: ${name}';
			case 'addData.bulkStatusReading': return 'Reading file...';
			case 'addData.bulkErrorFileEmpty': return 'File is empty or has no data rows!';
			case 'addData.bulkErrorNoValidRows': return 'No valid data rows to upload!';
			case 'addData.bulkStatusProcessing': return ({required Object count}) => 'Processing ${count} rows...';
			case 'addData.bulkStatusSaving': return ({required Object current, required Object total}) => 'Saving ${current} / ${total} to server...';
			case 'addData.bulkGuruFinished': return ({required Object success, required Object fail}) => 'Done! Success: ${success}, Failed: ${fail}\n(Failed data is usually due to NIP already registered)';
			case 'addData.bulkSantriFinished': return ({required Object success, required Object fail}) => 'Done! Success: ${success}, Failed: ${fail}\n(Failed data is usually due to NIS already registered)';
			case 'addHalaqoh.title': return 'Add New Halaqoh';
			case 'addHalaqoh.namaHalaqoh': return 'Halaqoh Name';
			case 'addHalaqoh.namaHalaqohHint': return 'Example: Halaqoh 7A';
			case 'addHalaqoh.kelas': return 'Class';
			case 'addHalaqoh.kelasHint': return 'Class';
			case 'addHalaqoh.program': return 'Program';
			case 'addHalaqoh.programHint': return 'Program';
			case 'addHalaqoh.pengampu': return 'Instructor (Teacher)';
			case 'addHalaqoh.pengampuHint': return 'Search instructor name...';
			case 'addHalaqoh.daftarSantri': return 'Student List';
			case 'addHalaqoh.tambahSantri': return '+ Add Student';
			case 'addHalaqoh.nis': return 'NIS';
			case 'addHalaqoh.namaSantri': return 'STUDENT NAME';
			case 'addHalaqoh.aksi': return 'ACTION';
			case 'addHalaqoh.totalTerpilih': return ({required Object count}) => 'Total: ${count} Students selected';
			case 'addHalaqoh.simpanHalaqoh': return 'SAVE HALAQOH';
			case 'addHalaqoh.maxSantriReached': return ({required Object max}) => 'Halaqoh has reached the maximum limit of ${max} students.';
			case 'addHalaqoh.deleteSantriTitle': return 'Delete Student?';
			case 'addHalaqoh.deleteSantriMessage': return 'Are you sure you want to delete this student from halaqoh?';
			case 'addHalaqoh.validationEmptyFields': return 'Please complete halaqoh name and instructor';
			case 'addHalaqoh.guruFilteredNotice': return ({required Object count}) => '* ${count} teachers hidden because they are teaching another halaqoh.';
			case 'addHalaqoh.santriLimitCounter': return ({required Object count, required Object max}) => '${count}/${max} students';
			case 'selectSantri.title': return 'Select Student';
			case 'selectSantri.searchHint': return 'Search name or NIS...';
			case 'selectSantri.filter': return 'FILTER';
			case 'selectSantri.countLabel': return ({required Object count}) => '${count} Students';
			case 'selectSantri.nis': return 'NIS';
			case 'selectSantri.nama': return 'NAME';
			case 'selectSantri.kelas': return 'CLASS';
			case 'selectSantri.tambahkanButton': return ({required Object count}) => 'ADD (${count}) STUDENTS';
			case 'selectSantri.allClasses': return 'All Classes';
			case 'selectSantri.allPrograms': return 'All Programs';
			case 'selectSantri.maxSantriNotice': return ({required Object max}) => 'Maximum of ${max} students per halaqoh. Remove one student before adding a new one.';
			case 'selectSantri.assignedElsewhereNotice': return ({required Object count}) => '(${count} already in another halaqoh)';
			case 'selectSantri.slotLimitCounter': return ({required Object count, required Object max}) => '${count}/${max} students';
			case 'selectSantri.emptyList': return 'No students found';
			case 'guruDashboard.greeting': return 'AHLAN WA SAHLAN';
			case 'guruDashboard.subtitle': return 'Begin Halaqoh With Prayers Together To Always Be Blessed';
			case 'guruDashboard.capaianHariIni': return 'Today\'s Achievement';
			case 'guruDashboard.kehadiranHariIni': return 'Attendance Today';
			case 'guruDashboard.setoranHafalan': return 'Hafalan Submission';
			case 'guruDashboard.santriCount': return ({required Object current, required Object total}) => '${current}/${total} Students';
			case 'guruDashboard.menuUtama': return 'Main Menu';
			case 'guruDashboard.myHalaqoh': return 'Halaqoh';
			case 'guruDashboard.scanAbsensi': return 'Scan Attendance';
			case 'guruDashboard.inputHafalan': return 'Input Hafalan';
			case 'guruDashboard.laporan': return 'Report';
			case 'guruDashboard.setoranTerakhir': return 'Recent Submissions';
			case 'guruDashboard.belumAdaSetoran': return 'No submissions yet';
			case 'guruNav.home': return 'Home';
			case 'guruNav.myHalaqoh': return 'Halaqoh';
			case 'guruNav.absensi': return 'Attendance';
			case 'guruNav.hafalan': return 'Hafalan';
			case 'guruNav.profile': return 'Profile';
			case 'myHalaqohScreen.title': return 'My Halaqoh';
			case 'myHalaqohScreen.searchHint': return 'Search name or NIS...';
			case 'myHalaqohScreen.daftarSantri': return 'Student List';
			case 'myHalaqohScreen.santriCount': return ({required Object count}) => '${count} Students';
			case 'myHalaqohScreen.kelas': return ({required Object kelas}) => 'Grade ${kelas}';
			case 'myHalaqohScreen.program': return ({required Object program}) => 'Program: ${program}';
			case 'myHalaqohScreen.target': return ({required Object count, required Object range}) => 'Target: ${count} Juz (${range})';
			case 'myHalaqohScreen.total': return ({required Object count}) => 'Total: ${count} Students';
			case 'myHalaqohScreen.pengampu': return 'Ustadz Kayyis';
			case 'myHalaqohScreen.progressText': return ({required Object completed, required Object target}) => '${completed} Juz completed of ${target} Juz';
			case 'myHalaqohScreen.noHalaqohAssigned': return 'You have not been assigned to any Halaqoh.';
			case 'myHalaqohScreen.santriNotFound': return 'Student not found.';
			case 'myHalaqohScreen.programReguler': return 'Regular';
			case 'myHalaqohScreen.programTakhassus': return 'Takhassus';
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
			case 'absensi.barcodeScanner.notMember': return ({required Object nis}) => 'Student with NIS ${nis} is not a member of your halaqoh';
			case 'absensi.barcodeScanner.cameraError': return ({required Object error}) => 'Failed to load camera:\n${error}';
			case 'absensi.barcodeScanner.clearPosition': return 'Ensure the barcode is in a clear position';
			case 'absensi.barcodeScanner.scannedSuccess': return ({required Object name}) => '${name} present';
			case 'absensi.barcodeScanner.totalSantri': return ({required Object count}) => 'Total ${count} Students';
			case 'absensi.barcodeScanner.progress': return ({required Object scanned, required Object total}) => '${scanned} / ${total}';
			case 'absensi.barcodeScanner.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'absensi.mulaiAbsensi.shubuh': return 'Shubuh';
			case 'absensi.mulaiAbsensi.dhuha': return 'Dhuha';
			case 'absensi.mulaiAbsensi.siang': return 'Noon';
			case 'absensi.mulaiAbsensi.soreAshar': return 'Afternoon/Ashar';
			case 'absensi.mulaiAbsensi.maghrib': return 'Maghrib';
			case 'absensi.mulaiAbsensi.markAllPresent': return 'Mark All Present';
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
			case 'riwayatAbsensi.belumAdaData': return 'No attendance data for this month';
			case 'riwayatAbsensi.abbrTakhassus.0': return 'M';
			case 'riwayatAbsensi.abbrTakhassus.1': return 'D';
			case 'riwayatAbsensi.abbrTakhassus.2': return 'N';
			case 'riwayatAbsensi.abbrTakhassus.3': return 'A';
			case 'riwayatAbsensi.abbrTakhassus.4': return 'E';
			case 'riwayatAbsensi.abbrReguler.0': return 'M';
			case 'riwayatAbsensi.abbrReguler.1': return 'E';
			case 'riwayatAbsensi.error': return ({required Object message}) => 'Error: ${message}';
			case 'riwayatAbsensi.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'riwayatAbsensi.belumTerdaftarHalaqoh': return 'Not Registered in Halaqoh';
			case 'riwayatAbsensi.sessionKeterangan': return 'Session Info';
			case 'riwayatAbsensi.sessionPagiShubuh': return 'Morning (Shubuh)';
			case 'riwayatAbsensi.sessionDhuha': return 'Dhuha';
			case 'riwayatAbsensi.sessionSiang': return 'Noon';
			case 'riwayatAbsensi.sessionSoreAshar': return 'Afternoon (Ashar)';
			case 'riwayatAbsensi.sessionMalamMaghrib': return 'Night (Maghrib)';
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
			case 'kalenderAbsensi.sessionsTakhassus.0': return '1. Shubuh';
			case 'kalenderAbsensi.sessionsTakhassus.1': return '2. Dhuha';
			case 'kalenderAbsensi.sessionsTakhassus.2': return '3. Noon';
			case 'kalenderAbsensi.sessionsTakhassus.3': return '4. Ashar';
			case 'kalenderAbsensi.sessionsTakhassus.4': return '5. Maghrib';
			case 'kalenderAbsensi.sessionsReguler.0': return 'Morning (Left)';
			case 'kalenderAbsensi.sessionsReguler.1': return 'Night (Right)';
			case 'kalenderAbsensi.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'kalenderAbsensi.sakit': return 'Sick';
			case 'kalenderAbsensi.izin': return 'Excused';
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
			case 'absensiHalaqoh.swipeHint': return 'Swipe date row left/right to view daily data';
			case 'detailAbsensiHariIni.title': return 'Today\'s Attendance Detail';
			case 'detailAbsensiHariIni.hadir': return 'Present';
			case 'detailAbsensiHariIni.sakit': return 'Sick';
			case 'detailAbsensiHariIni.izin': return 'Excused';
			case 'detailAbsensiHariIni.alfa': return 'Absent';
			case 'detailAbsensiHariIni.belumAbsen': return 'Not Yet';
			case 'detailAbsensiHariIni.belumDiabsen': return 'Not Recorded';
			case 'detailAbsensiHariIni.daftarKehadiranSantri': return 'Student Attendance List';
			case 'detailAbsensiHariIni.saveSuccess': return 'Attendance successfully saved!';
			case 'detailAbsensiHariIni.saveFailed': return 'Failed to save attendance';
			case 'detailAbsensiHariIni.warningBelumTitle': return 'Some Students Not Recorded';
			case 'detailAbsensiHariIni.warningBelumBody': return ({required Object count}) => 'There are still ${count} students whose status has not been set.\n\nThose students will not be recorded in attendance data if you keep saving.';
			case 'detailAbsensiHariIni.keepSaving': return 'Save Anyway';
			case 'detailAbsensiHariIni.completeFirst': return 'Complete First';
			case 'detailAbsensiHariIni.warningDuplicateTitle': return 'Data Already Exists';
			case 'detailAbsensiHariIni.warningDuplicateBody': return ({required Object session, required Object date}) => 'Attendance data for session ${session} on date ${date} already exists. Do you want to overwrite it?';
			case 'detailAbsensiHariIni.cancel': return 'Cancel';
			case 'detailAbsensiHariIni.overwrite': return 'Overwrite';
			case 'detailAbsensiHariIni.sessionsTakhassus.0': return 'Morning';
			case 'detailAbsensiHariIni.sessionsTakhassus.1': return 'Dhuha';
			case 'detailAbsensiHariIni.sessionsTakhassus.2': return 'Noon';
			case 'detailAbsensiHariIni.sessionsTakhassus.3': return 'Afternoon';
			case 'detailAbsensiHariIni.sessionsTakhassus.4': return 'Night';
			case 'detailAbsensiHariIni.sessionsReguler.0': return 'Morning';
			case 'detailAbsensiHariIni.sessionsReguler.1': return 'Night';
			case 'detailAbsensiHariIni.sessions.pagi': return 'Morning';
			case 'detailAbsensiHariIni.sessions.dhuha': return 'Dhuha';
			case 'detailAbsensiHariIni.sessions.siang': return 'Noon';
			case 'detailAbsensiHariIni.sessions.ashar': return 'Afternoon';
			case 'detailAbsensiHariIni.sessions.malam': return 'Night';
			case 'hafalan.cariSantri': return 'Search Student';
			case 'hafalan.daftarSantri': return 'Student List';
			case 'hafalan.santriCount': return ({required Object count}) => '${count} Students';
			case 'hafalan.riwayatHafalan': return 'Memorization History';
			case 'hafalan.inputHafalan': return 'Input Memorization';
			case 'hafalan.santriNotFound': return 'Student not found.';
			case 'hafalan.targetLabel': return ({required Object target}) => 'Target: ${target}';
			case 'hafalan.successSave': return 'Memorization successfully saved!';
			case 'hafalan.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'inputHafalanForm.nama': return ({required Object name}) => 'Name: ${name}';
			case 'inputHafalanForm.ziyadah': return 'ZIYADAH';
			case 'inputHafalanForm.murajaah': return 'MURAJAAH';
			case 'inputHafalanForm.formulirHafalan': return 'Memorization Form';
			case 'inputHafalanForm.pilihSurat': return 'Select Surah';
			case 'inputHafalanForm.ayatAwal': return 'Start Verse';
			case 'inputHafalanForm.ayatAkhir': return 'End Verse';
			case 'inputHafalanForm.juz': return 'Juz';
			case 'inputHafalanForm.penilaian': return 'Assessment';
			case 'inputHafalanForm.kelancaran': return 'Fluency';
			case 'inputHafalanForm.skalaPenilaian': return 'Scale 1-100';
			case 'inputHafalanForm.tajwid': return 'Tajwid';
			case 'inputHafalanForm.simpan': return 'SAVE';
			case 'inputHafalanForm.batal': return 'CANCEL';
			case 'inputHafalanForm.pilihDaftarSurat': return 'Select Surah List';
			case 'inputHafalanForm.pilihSatuAtauLebihSurat': return 'Select one or more surahs';
			case 'inputHafalanForm.semua': return 'All';
			case 'inputHafalanForm.juzLabel': return ({required Object juz}) => 'Juz ${juz}';
			case 'inputHafalanForm.cariNamaSurat': return 'Search surah name...';
			case 'inputHafalanForm.konfirmasiPilihanCount': return ({required Object count}) => 'CONFIRM SELECTION (${count})';
			case 'inputHafalanForm.konfirmasiPilihan': return 'CONFIRM SELECTION';
			case 'inputHafalanForm.title': return 'Input Memorization';
			case 'inputHafalanForm.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'inputHafalanForm.tanggalSetoran': return 'Deposit Date';
			case 'inputHafalanForm.tambahSurat': return 'Add Surah';
			case 'inputHafalanForm.errPilihMinimalSatuSurah': return 'Select at least one surah';
			case 'inputHafalanForm.errWajibDiisi1Sampai100': return 'Required between 1 and 100';
			case 'inputHafalanForm.juzNumbers': return ({required Object juz}) => 'Juz ${juz}';
			case 'inputHafalanForm.semuaAyat': return 'All Verses';
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
			case 'riwayatHafalanSantri.ayatRange': return ({required Object start, required Object end}) => 'Verse ${start} - ${end}';
			case 'riwayatHafalanSantri.suratCount': return ({required Object count}) => '${count} surahs';
			case 'riwayatHafalanSantri.filterSemuaTipe': return 'All Types';
			case 'riwayatHafalanSantri.filterHafalanBaru': return 'New Memorization';
			case 'riwayatHafalanSantri.filterMurajaah': return 'Review';
			case 'riwayatHafalanSantri.belumAdaDataBulanIni': return 'No memorization data for this month';
			case 'riwayatHafalanSantri.tidakAdaHafalanFilter': return 'No memorization for this filter';
			case 'riwayatHafalanSantri.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'riwayatHafalanSantri.deleteSuccess': return 'Memorization data successfully deleted!';
			case 'riwayatHafalanSantri.deleteFailed': return 'Failed to delete memorization data.';
			case 'progressHafalanPerJuz.title': return 'Memorization Progress';
			case 'progressHafalanPerJuz.targetHafalan': return 'Memorization Target';
			case 'progressHafalanPerJuz.pilihJuz': return 'Select Juz to view detailed progress per surah';
			case 'progressHafalanPerJuz.ayatSelesai': return ({required Object completed, required Object total}) => '${completed} of ${total} Verses Completed';
			case 'progressHafalanPerJuz.juzLabel': return ({required Object juz}) => 'Juz ${juz}';
			case 'progressHafalanPerJuz.kelasLabel': return ({required Object kelas}) => 'Class ${kelas}';
			case 'progressHafalanPerJuz.tambahTargetHafalan': return 'Add Memorization Target';
			case 'progressHafalanPerJuz.warningBanner': return ({required Object juzLabels}) => 'Warning: ${juzLabels} has not been completed. Ensure the student completes the memorization target for this semester. You can still add new targets, but set targets must be completed first.';
			case 'progressHafalanPerJuz.cariJuz': return 'Search Juz (e.g. Juz 1)';
			case 'progressHafalanPerJuz.surahCount': return ({required Object count}) => '${count} Surah';
			case 'progressHafalanPerJuz.targetBelumSelesai': return 'Target Not Completed';
			case 'progressHafalanPerJuz.confirmAddExtraJuzMessage': return ({required Object juzLabels, required Object nextJuz}) => '${juzLabels} has not been completed this semester.\n\nRemind the student to complete the set targets. Are you sure you want to add Juz ${nextJuz} as an extra target?';
			case 'progressHafalanPerJuz.batal': return 'Cancel';
			case 'progressHafalanPerJuz.yaTambahkan': return 'Yes, Add';
			case 'progressHafalanPerJuz.successAddTarget': return ({required Object juz}) => 'Juz ${juz} added as a target';
			case 'progressHafalanPerJuz.failedSaveTarget': return 'Failed to save target, try again';
			case 'progressHafalanPerJuz.tutup': return 'Close';
			case 'progressHafalanPerJuz.teacherCanAddHint': return 'Tap + to add a juz target manually';
			case 'progressHafalanPerJuz.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'progressHafalanPerJuz.ayatCompletedInfo': return ({required Object completed, required Object total}) => '${completed} of ${total} Verses Completed';
			case 'progressHafalanPerJuz.percent': return ({required Object percent}) => '${percent} %';
			case 'progressHafalanPerSurat.title': return 'Progress Per Surah';
			case 'progressHafalanPerSurat.detailJuz': return ({required Object juz}) => 'Memorization Detail Juz ${juz}';
			case 'progressHafalanPerSurat.ayatDari': return ({required Object memorized, required Object total}) => 'Ayat ${memorized} of ${total}';
			case 'progressHafalanPerSurat.selesai': return 'Completed';
			case 'progressHafalanPerSurat.dalamProses': return 'In Progress';
			case 'progressHafalanPerSurat.belumDimulai': return 'Not Started';
			case 'progressHafalanPerSurat.unknownSurah': return 'Unknown';
			case 'progressHafalanPerSurat.juzTitle': return ({required Object juz}) => 'Juz ${juz}';
			case 'progressHafalanPerSurat.nisLabel': return ({required Object nis}) => 'NIS: ${nis}';
			case 'progressHafalanPerSurat.ayatCount': return ({required Object count}) => '${count} Verses';
			case 'progressHafalanPerSurat.percent': return ({required Object percent}) => '${percent}%';
			case 'mutabaahSantri.title': return 'Student Mutaba\'ah';
			case 'mutabaahSantri.hafalanBaru': return 'New Memorization';
			case 'mutabaahSantri.murajaah': return 'Review';
			case 'mutabaahSantri.hari': return 'DAY';
			case 'mutabaahSantri.tgl': return 'DATE';
			case 'mutabaahSantri.surat': return 'SURAH';
			case 'mutabaahSantri.ayat': return 'AYAT';
			case 'mutabaahSantri.nilai': return 'SCORE';
			case 'mutabaahSantri.dayNames.0': return 'SUN';
			case 'mutabaahSantri.dayNames.1': return 'MON';
			case 'mutabaahSantri.dayNames.2': return 'TUE';
			case 'mutabaahSantri.dayNames.3': return 'WED';
			case 'mutabaahSantri.dayNames.4': return 'THU';
			case 'mutabaahSantri.dayNames.5': return 'FRI';
			case 'mutabaahSantri.dayNames.6': return 'SAT';
			case 'mutabaahSantri.belumAdaHafalanBaru': return 'No new memorization yet';
			case 'mutabaahSantri.belumAdaMurajaah': return 'No review yet';
			case 'mutabaahSantri.suratCount': return ({required Object count}) => '${count} surahs';
			case 'guruProfile.editProfile': return 'Edit Profile';
			case 'guruProfile.ubahPassword': return 'Change Password';
			case 'guruProfile.pengaturan': return 'Settings';
			case 'guruProfile.tentangAplikasi': return 'About App';
			case 'guruProfile.keluar': return 'Logout';
			case 'guruProfile.guruHalaqoh': return 'Halaqoh Teacher';
			case 'guruProfile.appVersion': return ({required Object version}) => 'MyHalaqoh App v${version}';
			case 'guruProfile.loading': return 'Loading...';
			case 'guruProfile.pengampu': return ({required Object halaqoh}) => 'Teacher of ${halaqoh}';
			case 'guruProfile.nipLabel': return ({required Object nip}) => 'NIP: ${nip}';
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
			case 'editProfile.pengampu': return ({required Object halaqoh}) => 'Teacher of ${halaqoh}';
			case 'editProfile.successMessage': return 'Profile successfully updated';
			case 'editProfile.failedMessage': return 'Failed to update profile';
			case 'editProfile.tryAgain': return 'Try Again';
			case 'editProfile.saving': return 'Saving...';
			case 'editProfile.nis': return 'NIS';
			case 'editProfile.kelas': return 'Class';
			case 'editProfile.program': return 'Program';
			case 'editProfile.kontakWali': return 'Guardian Contact';
			case 'editProfile.namaWali': return 'Guardian Name';
			case 'editProfile.hubungan': return 'Relationship';
			case 'editProfile.pilihHubungan': return 'Select relationship';
			case 'editProfile.hubunganOptions.0': return 'Father';
			case 'editProfile.hubunganOptions.1': return 'Mother';
			case 'editProfile.hubunganOptions.2': return 'Sibling';
			case 'ubahPassword.title': return 'Change Password';
			case 'ubahPassword.subtitle': return 'Please enter your new password to improve your account security.';
			case 'ubahPassword.kataSandiLama': return 'Old Password';
			case 'ubahPassword.kataSandiBaru': return 'New Password';
			case 'ubahPassword.konfirmasiKataSandiBaru': return 'Confirm New Password';
			case 'ubahPassword.syaratKeamanan': return 'SECURITY REQUIREMENTS';
			case 'ubahPassword.minimal8Karakter': return 'Minimum 8 characters';
			case 'ubahPassword.kombinasiHurufDanAngka': return 'Combination of letters and numbers';
			case 'ubahPassword.ubahKataSandi': return 'Change Password';
			case 'ubahPassword.successMessage': return 'Password successfully changed';
			case 'ubahPassword.failedMessage': return 'Failed to change password';
			case 'ubahPassword.errOldPasswordRequired': return 'Old password is required';
			case 'ubahPassword.errNewPasswordRequired': return 'New password is required';
			case 'ubahPassword.errMin8Chars': return 'Minimum 8 characters';
			case 'ubahPassword.errLetterNumberCombo': return 'Must be a combination of letters and numbers';
			case 'ubahPassword.errConfirmRequired': return 'Confirm password is required';
			case 'ubahPassword.errMismatch': return 'Passwords do not match';
			case 'ubahPassword.processing': return 'Processing...';
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
			case 'waliSantriDashboard.loading': return 'Loading...';
			case 'waliSantriDashboard.notRegisteredHalaqoh': return 'Not registered in any Halaqoh yet';
			case 'waliSantriDashboard.nis': return ({required Object nis}) => 'NIS: ${nis}';
			case 'waliSantriDashboard.guru': return ({required Object name}) => 'Teacher: ${name}';
			case 'waliSantriDashboard.extraMemorization': return 'Extra Memorization';
			case 'waliSantriDashboard.juzList': return ({required Object juz}) => 'Juz: ${juz}';
			case 'waliSantriDashboard.extraJuzTarget': return ({required Object count}) => 'Extra : ${count} Juz';
			case 'waliSantriDashboard.halaqohInfo': return ({required Object kelas, required Object halaqoh}) => 'Class ${kelas} | ${halaqoh}';
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
			case 'WaliSantriPengaturanScreen.notifikasi': return 'Notifications';
			case 'WaliSantriPengaturanScreen.notifikasiAktif': return 'Active';
			case 'WaliSantriPengaturanScreen.notifikasiNonAktif': return 'Inactive';
			case 'WaliSantriPengaturanScreen.notifikasiDialogTitle': return 'Enable Notifications';
			case 'WaliSantriPengaturanScreen.notifikasiDialogMessage': return 'Notification permission has not been granted. Open your Phone Settings, enable notification permission for this app, then come back and try again.';
			case 'WaliSantriPengaturanScreen.bukaSettingHp': return 'Open Settings';
			case 'dialogs.deleteTitle': return 'Delete Data?';
			case 'dialogs.deleteMessage': return 'Are you sure you want to delete this data? This action cannot be undone and it will be permanently lost.';
			case 'dialogs.saveTitle': return 'Save Changes?';
			case 'dialogs.saveMessage': return 'Please ensure all entered data is correct before saving.';
			case 'dialogs.batal': return 'Cancel';
			case 'dialogs.hapus': return 'Delete';
			case 'dialogs.simpan': return 'Save';
			case 'dialogs.logoutTitle': return 'Log Out?';
			case 'dialogs.logoutMessage': return 'Are you sure you want to log out from this account? You will need to log in again to use the app.';
			case 'dialogs.keluar': return 'Log Out';
			case 'masterDataSettings.title': return 'Settings';
			case 'masterDataSettings.tentangAplikasi': return 'About App';
			case 'masterDataSettings.keluar': return 'Log Out';
			case 'masterDataSettings.appVersion': return 'Version {version}';
			case 'tentangAplikasiScreen.title': return 'About App';
			case 'tentangAplikasiScreen.appName': return 'MyHalaqoh';
			case 'tentangAplikasiScreen.tagline': return 'Digital Halaqoh Management Platform';
			case 'tentangAplikasiScreen.version': return 'Version';
			case 'tentangAplikasiScreen.sectionTentang': return 'About MyHalaqoh';
			case 'tentangAplikasiScreen.deskripsi1': return 'MyHalaqoh is an integrated digital platform specifically designed to help manage halaqoh in Islamic boarding school environments efficiently, transparently, and accessibly.';
			case 'tentangAplikasiScreen.deskripsi2': return ({required Object pesantren}) => 'Developed specifically for ${pesantren}, this app connects Admins, Teachers, and Student Guardians in one integrated digital ecosystem.';
			case 'tentangAplikasiScreen.sectionFitur': return 'Key Features';
			case 'tentangAplikasiScreen.fiturAbsensiJudul': return 'QR Code Attendance';
			case 'tentangAplikasiScreen.fiturAbsensiDesc': return 'Record student attendance quickly using an integrated barcode scanner.';
			case 'tentangAplikasiScreen.fiturHafalanJudul': return 'Quran Memorization';
			case 'tentangAplikasiScreen.fiturHafalanDesc': return 'Track student memorization progress per juz and per surah in real-time.';
			case 'tentangAplikasiScreen.fiturNotifJudul': return 'Automatic Notifications';
			case 'tentangAplikasiScreen.fiturNotifDesc': return 'Attendance and memorization information is sent directly to Student Guardians via push notification.';
			case 'tentangAplikasiScreen.fiturMultiRoleJudul': return 'Multi-Role Dashboard';
			case 'tentangAplikasiScreen.fiturMultiRoleDesc': return 'Views and features tailored for Admin, Teacher, and Student Guardian.';
			case 'tentangAplikasiScreen.fiturOfflineJudul': return 'Offline Mode';
			case 'tentangAplikasiScreen.fiturOfflineDesc': return 'Attendance and memorization can still be recorded even without an internet connection.';
			case 'tentangAplikasiScreen.sectionInfo': return 'App Information';
			case 'tentangAplikasiScreen.infoNamaApp': return 'App Name';
			case 'tentangAplikasiScreen.infoVersi': return 'Version';
			case 'tentangAplikasiScreen.infoPlatform': return 'Platform';
			case 'tentangAplikasiScreen.infoLembaga': return 'Institution';
			case 'tentangAplikasiScreen.infoPlatformValue': return 'Android';
			case 'tentangAplikasiScreen.sectionKontak': return 'Contact & Support';
			case 'tentangAplikasiScreen.kontakDeskripsi': return 'If you need technical assistance or have questions about the app, please contact the administrator via WhatsApp.';
			case 'tentangAplikasiScreen.kontakButton': return 'Contact Admin via WhatsApp';
			case 'tentangAplikasiScreen.footer': return 'Made with ❤️ for the advancement of Islamic boarding school education';
			case 'tentangAplikasiScreen.copyright': return '© 2026 MyHalaqoh. All rights reserved.';
			case 'general.warning': return 'Warning';
			case 'general.close': return 'Close';
			case 'general.saving': return 'Saving...';
			case 'general.done': return 'Done';
			case 'general.active': return 'ACTIVE';
			case 'general.confirmation': return 'Confirmation';
			case 'general.yesProcess': return 'Yes, Process';
			case 'calendar.months.0': return 'January';
			case 'calendar.months.1': return 'February';
			case 'calendar.months.2': return 'March';
			case 'calendar.months.3': return 'April';
			case 'calendar.months.4': return 'May';
			case 'calendar.months.5': return 'June';
			case 'calendar.months.6': return 'July';
			case 'calendar.months.7': return 'August';
			case 'calendar.months.8': return 'September';
			case 'calendar.months.9': return 'October';
			case 'calendar.months.10': return 'November';
			case 'calendar.months.11': return 'December';
			case 'calendar.daysAbbr.0': return 'MON';
			case 'calendar.daysAbbr.1': return 'TUE';
			case 'calendar.daysAbbr.2': return 'WED';
			case 'calendar.daysAbbr.3': return 'THU';
			case 'calendar.daysAbbr.4': return 'FRI';
			case 'calendar.daysAbbr.5': return 'SAT';
			case 'calendar.daysAbbr.6': return 'SUN';
			case 'calendar.daysAbbrSundayFirst.0': return 'SUN';
			case 'calendar.daysAbbrSundayFirst.1': return 'MON';
			case 'calendar.daysAbbrSundayFirst.2': return 'TUE';
			case 'calendar.daysAbbrSundayFirst.3': return 'WED';
			case 'calendar.daysAbbrSundayFirst.4': return 'THU';
			case 'calendar.daysAbbrSundayFirst.5': return 'FRI';
			case 'calendar.daysAbbrSundayFirst.6': return 'SAT';
			case 'laporanConfig.titleAbsensi': return 'Download Attendance Report';
			case 'laporanConfig.titleHafalan': return 'Download Memorization Report';
			case 'laporanConfig.titleHalaqoh': return 'Halaqoh Attendance Recap';
			case 'laporanConfig.subtitleAbsensi': return 'Select period & configurations for student\'s PDF report.';
			case 'laporanConfig.subtitleHafalan': return 'Select period & configurations for student\'s PDF report.';
			case 'laporanConfig.subtitleHalaqoh': return 'Select period to download full halaqoh recap.';
			case 'laporanConfig.timeRange': return 'Time Range';
			case 'laporanConfig.weekly': return 'Weekly';
			case 'laporanConfig.monthly': return 'Monthly';
			case 'laporanConfig.custom': return 'Custom';
			case 'laporanConfig.semester': return 'Semester';
			case 'laporanConfig.selectDateRange': return 'Select Date Range';
			case 'laporanConfig.startDate': return 'Start Date';
			case 'laporanConfig.endDate': return 'End Date';
			case 'laporanConfig.selectDateHint': return 'Select date';
			case 'laporanConfig.chooseStartDate': return 'Select Start Date';
			case 'laporanConfig.chooseEndDate': return 'Select End Date';
			case 'laporanConfig.btnSelect': return 'Select';
			case 'laporanConfig.btnCancel': return 'Cancel';
			case 'laporanConfig.totalDaysSelected': return ({required Object days}) => 'Total ${days} days selected';
			case 'laporanConfig.reportPeriod': return 'Report Period';
			case 'laporanConfig.daysShort': return ({required Object days}) => '${days} days';
			case 'laporanConfig.btnGeneratePdf': return 'Generate PDF Report';
			case 'laporanConfig.btnGenerateRecapPdf': return 'Generate PDF Recap';
			case 'laporanConfig.generatingReport': return 'Generating report...';
			case 'laporanConfig.readyTitle': return 'Report Ready!';
			case 'laporanConfig.readyRecapTitle': return 'Recap Ready!';
			case 'laporanConfig.readySubtitle': return 'PDF successfully generated. Preview or share now.';
			case 'laporanConfig.attendanceReport': return 'Attendance Report';
			case 'laporanConfig.recapAttendance': return 'Attendance Recap';
			case 'laporanConfig.memorizationReport': return 'Memorization Report';
			case 'laporanConfig.btnPreview': return 'Preview';
			case 'laporanConfig.btnShare': return 'Share';
			case 'laporanConfig.btnCreateNewReport': return 'Create new report';
			case 'laporanConfig.btnCreateNewRecap': return 'Create new recap';
			case 'laporanConfig.errGenerate': return ({required Object error}) => 'Failed to generate report: ${error}';
			case 'laporanConfig.errPreview': return ({required Object error}) => 'Failed to open preview: ${error}';
			case 'laporanConfig.errShare': return ({required Object error}) => 'Failed to share report: ${error}';
			case 'laporanConfig.pdf.shubuh': return 'Shubuh';
			case 'laporanConfig.pdf.dhuha': return 'Dhuha';
			case 'laporanConfig.pdf.siang': return 'Siang';
			case 'laporanConfig.pdf.ashar': return 'Ashar';
			case 'laporanConfig.pdf.maghrib': return 'Maghrib';
			case 'laporanConfig.pdf.presentCode': return 'H';
			case 'laporanConfig.pdf.sickCode': return 'S';
			case 'laporanConfig.pdf.permitCode': return 'I';
			case 'laporanConfig.pdf.absentCode': return 'A';
			case 'laporanConfig.pdf.systemName': return 'MyHalaqoh — Halaqoh Management System';
			case 'laporanConfig.pdf.pageLabel': return ({required Object page, required Object total}) => 'Page ${page} of ${total}';
			case 'laporanConfig.pdf.titleAttendance': return 'Student Attendance Report';
			case 'laporanConfig.pdf.titleHalaqohRecap': return 'Halaqoh Attendance Recap Report';
			case 'laporanConfig.pdf.titleMemorization': return 'Student Memorization Progress Report';
			case 'laporanConfig.pdf.printedAt': return ({required Object date}) => 'Printed on: ${date}';
			case 'laporanConfig.pdf.studentInfo': return 'Student Information';
			case 'laporanConfig.pdf.halaqohInfo': return 'Halaqoh Information';
			case 'laporanConfig.pdf.studentName': return 'Student Name';
			case 'laporanConfig.pdf.nameHeader': return 'Name';
			case 'laporanConfig.pdf.kehadiranHeader': return 'Attendance';
			case 'laporanConfig.pdf.maxHeader': return 'Max';
			case 'laporanConfig.pdf.hdrHeader': return 'Att';
			case 'laporanConfig.pdf.nis': return 'NIS';
			case 'laporanConfig.pdf.halaqoh': return 'Halaqoh';
			case 'laporanConfig.pdf.pembimbing': return 'Pembimbing';
			case 'laporanConfig.pdf.musyrif': return 'Musyrif';
			case 'laporanConfig.pdf.program': return 'Program';
			case 'laporanConfig.pdf.reportType': return 'Report Type';
			case 'laporanConfig.pdf.summaryAttendance': return 'Attendance Summary';
			case 'laporanConfig.pdf.summaryMemorization': return 'Memorization Summary';
			case 'laporanConfig.pdf.present': return 'Present';
			case 'laporanConfig.pdf.sick': return 'Sick';
			case 'laporanConfig.pdf.permit': return 'Permit';
			case 'laporanConfig.pdf.absent': return 'Absent';
			case 'laporanConfig.pdf.ziyadah': return 'Ziyadah';
			case 'laporanConfig.pdf.murajaah': return 'Muraja\'ah';
			case 'laporanConfig.pdf.attendanceRate': return 'Attendance Rate';
			case 'laporanConfig.pdf.avgScore': return 'Average Score';
			case 'laporanConfig.pdf.totalScheduled': return ({required Object hadir, required Object total}) => '${hadir} of ${total} scheduled sessions';
			case 'laporanConfig.pdf.dailyDetailTitle': return 'Daily Attendance Details';
			case 'laporanConfig.pdf.setoranDetailTitle': return 'Memorization Deposit Details';
			case 'laporanConfig.pdf.predikat.mumtaz': return 'Mumtaz';
			case 'laporanConfig.pdf.predikat.jayyid': return 'Jayyid';
			case 'laporanConfig.pdf.predikat.maqbul': return 'Maqbul';
			case 'laporanConfig.pdf.weeksLabel': return ({required Object index, required Object start, required Object end}) => 'Week ${index}  (${start} – ${end})';
			case 'laporanConfig.pdf.no': return 'No.';
			case 'laporanConfig.pdf.dateHeader': return 'Day, Date';
			case 'laporanConfig.pdf.dayHeader': return 'Day';
			case 'laporanConfig.pdf.typeHeader': return 'Type';
			case 'laporanConfig.pdf.dateShort': return 'Date';
			case 'laporanConfig.pdf.surahAyatHeader': return 'Surah / Ayah';
			case 'laporanConfig.pdf.baruCode': return 'New';
			case 'laporanConfig.pdf.ulangCode': return 'Review';
			case 'laporanConfig.pdf.ziyadahLabel': return 'Ziyadah (New Memorization)';
			case 'laporanConfig.pdf.murajaahLabel': return 'Muraja\'ah (Review)';
			case 'laporanConfig.pdf.juzHeader': return 'Juz';
			case 'laporanConfig.pdf.surahDetailHeader': return 'Surah Details';
			case 'laporanConfig.pdf.kelancaranHeader': return 'Fluency';
			case 'laporanConfig.pdf.tajwidHeader': return 'Tajwid';
			case 'laporanConfig.pdf.avgHeader': return 'Average';
			case 'laporanConfig.pdf.predikatHeader': return 'Grade';
			case 'laporanConfig.pdf.hadirLabel': return 'Present';
			case 'laporanConfig.pdf.sakitLabel': return 'Sick';
			case 'laporanConfig.pdf.izinLabel': return 'Permit';
			case 'laporanConfig.pdf.alfaLabel': return 'Absent';
			case 'laporanConfig.pdf.keteranganLabel': return 'Remarks';
			case 'laporanConfig.pdf.legenda': return 'Legend';
			case 'laporanConfig.pdf.noSession': return 'No session';
			case 'laporanConfig.pdf.statusLegenda': return 'H = Present  |  S = Sick  |  I = Permit  |  A = Absent';
			case 'laporanConfig.pdf.predikatLegenda': return 'Mumtaz: 85 - 100  |  Jayyid: 70 - 84  |  Maqbul: < 70';
			case 'laporanConfig.pdf.pekanShort': return ({required Object index}) => 'Week ${index}';
			default: return null;
		}
	}
}

