/// Tipe periode ujian dalam satu semester.
enum PeriodeUjian { uts, uas }

/// Tipe konten hafalan untuk satu periode ujian.
enum TipeHafalan {
  /// Hafalan baru (ziyadah)
  ziyadah,

  /// Mengulang hafalan lama
  murajaah,

  /// Persiapan / perbaikan bacaan (kelas awal)
  idadTahsin,

  /// Intensif hafalan kilat
  dauroh,

  /// Ujian Akhir Tahfidz — tidak ada target hafalan baru
  uat,
}

/// Target hafalan untuk satu periode ujian (UTS atau UAS).
class PeriodeTarget {
  /// Tipe konten hafalan pada periode ini.
  final TipeHafalan tipe;

  /// Nomor juz yang dicakup (kosong jika UAT / I'dad Tahsin / Dauroh).
  final List<int> juzList;

  /// Deskripsi konten, e.g. "Al-Mulk – Al-Muddatstsir 47".
  /// Null jika tidak ada deskripsi tambahan.
  final String? deskripsi;

  /// Fraksi beban hafalan per periode, e.g. "½ Juz", "¾ Juz".
  /// Null jika tidak berlaku (full juz atau non-hafalan).
  final String? fraksi;

  const PeriodeTarget({
    required this.tipe,
    this.juzList = const [],
    this.deskripsi,
    this.fraksi,
  });

  /// Apakah periode ini merupakan hafalan aktif (bukan UAT/I'dad/Dauroh)?
  bool get isAktifHafalan =>
      tipe != TipeHafalan.uat && tipe != TipeHafalan.idadTahsin;
}

/// Target hafalan untuk satu semester, berisi UTS dan UAS.
class SemesterTarget {
  final PeriodeTarget uts;
  final PeriodeTarget uas;

  const SemesterTarget({required this.uts, required this.uas});

  /// Gabungan semua juz yang dicakup di semester ini (unik, terurut).
  List<int> get allJuz {
    final set = <int>{...uts.juzList, ...uas.juzList};
    return set.toList()..sort();
  }

  int get totalJuz => allJuz.length;
}

/// Kurikulum lengkap untuk satu kombinasi kelas + program, berisi dua semester.
class KelasKurikulum {
  final String kelas;
  final String program;
  final SemesterTarget semester1;
  final SemesterTarget semester2;

  const KelasKurikulum({
    required this.kelas,
    required this.program,
    required this.semester1,
    required this.semester2,
  });

  SemesterTarget getSemester(int semester) =>
      semester == 1 ? semester1 : semester2;

  /// Gabungan semua juz target sepanjang tahun (unik, terurut).
  List<int> get allJuzTahun {
    final set = <int>{...semester1.allJuz, ...semester2.allJuz};
    return set.toList()..sort();
  }

  int get totalJuzTahun => allJuzTahun.length;
}

// ─── Konstanta Kurikulum ──────────────────────────────────────────────────────

/// Repositori statis kurikulum hafalan pesantren.
///
/// **Program Reguler** (5 Juz / 6 Tahun):
///   Pola SMP dan SMA simetris — kelas 7=10, 8=11, 9=12.
///
/// **Program Takhassus** (15 Juz / 6 Tahun):
///   Pola SMP dan SMA BERBEDA mulai kelas 8 (SMP) vs 11 (SMA).
class CurriculumData {
  const CurriculumData._();

  // ─── Lookup API ─────────────────────────────────────────────────────────────

  /// Ambil [KelasKurikulum] berdasarkan kelas ("7".."12") dan program
  /// ("Reguler" | "Takhassus"). Mengembalikan null jika tidak ditemukan.
  static KelasKurikulum? getKurikulum(String kelas, String program) {
    return _data[program]?[kelas];
  }

  /// Ambil [SemesterTarget] berdasarkan kelas, program, dan semester (1/2).
  static SemesterTarget? getSemesterTarget(
      String kelas, String program, int semester) {
    return getKurikulum(kelas, program)?.getSemester(semester);
  }

  /// Ambil [PeriodeTarget] berdasarkan kelas, program, semester, dan periode.
  static PeriodeTarget? getPeriodeTarget(
      String kelas, String program, int semester, PeriodeUjian periode) {
    final sem = getSemesterTarget(kelas, program, semester);
    if (sem == null) return null;
    return periode == PeriodeUjian.uts ? sem.uts : sem.uas;
  }

  // ─── Data Kurikulum ──────────────────────────────────────────────────────────

  static const Map<String, Map<String, KelasKurikulum>> _data = {
    'Reguler': _reguler,
    'Takhassus': _takhassus,
  };

  // ── Reguler ─────────────────────────────────────────────────────────────────
  // Kelas 7 & 10 : pola sama
  // Kelas 8 & 11 : pola sama
  // Kelas 9 & 12 : pola sama

  static const Map<String, KelasKurikulum> _reguler = {
    '7': _regulerKelas7,
    '8': _regulerKelas8,
    '9': _regulerKelas9,
    '10': _regulerKelas10,
    '11': _regulerKelas11,
    '12': _regulerKelas12,
  };

  static const _regulerKelas7 = KelasKurikulum(
    kelas: '7',
    program: 'Reguler',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.idadTahsin,
        deskripsi: "I'dad Tahsin",
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.idadTahsin,
        deskripsi: "I'dad Tahsin",
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [30],
        deskripsi: "An-Naba' – Al-A'la",
        fraksi: '½ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [30],
        deskripsi: 'Al-Ghasyiyah – An-Nas',
        fraksi: '½ Juz',
      ),
    ),
  );

  static const _regulerKelas8 = KelasKurikulum(
    kelas: '8',
    program: 'Reguler',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [29],
        deskripsi: 'Al-Mulk – Al-Muddatstsir 47',
        fraksi: '¾ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [29, 28],
        deskripsi: 'Al-Muddatstsir 48 – Al-Mursalat + Al-Mujadilah – Ash-Shaff 5',
        fraksi: '¾ Juz',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [28, 1],
        deskripsi: 'Ash-Shaff 6 – At-Tahrim + Al-Baqarah 1-37',
        fraksi: '¾ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [1],
        deskripsi: 'Al-Baqarah 38-141',
        fraksi: '¾ Juz',
      ),
    ),
  );

  static const _regulerKelas9 = KelasKurikulum(
    kelas: '9',
    program: 'Reguler',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [2],
        deskripsi: 'Al-Baqarah 142–202',
        fraksi: '½ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [2],
        deskripsi: 'Al-Baqarah 203–252',
        fraksi: '½ Juz',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.murajaah,
        juzList: [1, 2, 28, 29, 30],
        deskripsi: "Muraja'ah 5 Juz",
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.murajaah,
        juzList: [1, 2, 28, 29, 30],
        deskripsi: "Muraja'ah 5 Juz",
      ),
    ),
  );

  static const _regulerKelas10 = KelasKurikulum(
    kelas: '10',
    program: 'Reguler',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.idadTahsin,
        deskripsi: "I'dad Tahsin",
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.idadTahsin,
        deskripsi: "I'dad Tahsin",
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [30],
        deskripsi: "An-Naba' – Al-A'la",
        fraksi: '½ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [30],
        deskripsi: 'Al-Ghasyiyah – An-Nas',
        fraksi: '½ Juz',
      ),
    ),
  );

  static const _regulerKelas11 = KelasKurikulum(
    kelas: '11',
    program: 'Reguler',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [29],
        deskripsi: 'Al-Mulk – Al-Muddatstsir 47',
        fraksi: '¾ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [29, 28],
        deskripsi: 'Al-Muddatstsir 48 – Al-Mursalat + Al-Mujadilah – Ash-Shaff 5',
        fraksi: '¾ Juz',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [28, 1],
        deskripsi: 'Ash-Shaff 6 – At-Tahrim + Al-Baqarah 1-37',
        fraksi: '¾ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [1],
        deskripsi: 'Al-Baqarah 38-141',
        fraksi: '¾ Juz',
      ),
    ),
  );

  static const _regulerKelas12 = KelasKurikulum(
    kelas: '12',
    program: 'Reguler',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [2],
        deskripsi: 'Al-Baqarah 142–202',
        fraksi: '½ Juz',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [2],
        deskripsi: 'Al-Baqarah 203–252',
        fraksi: '½ Juz',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.murajaah,
        juzList: [1, 2, 28, 29, 30],
        deskripsi: "Muraja'ah 5 Juz",
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.murajaah,
        juzList: [1, 2, 28, 29, 30],
        deskripsi: "Muraja'ah 5 Juz",
      ),
    ),
  );

  // ── Takhassus ────────────────────────────────────────────────────────────────
  // Kelas 7 (SMP) & 10 (SMA) : pola sama
  // Kelas 8 (SMP) & 11 (SMA) : BERBEDA
  // Kelas 9 (SMP) & 12 (SMA) : BERBEDA

  static const Map<String, KelasKurikulum> _takhassus = {
    '7': _takhassusKelas7,
    '8': _takhassusKelas8Smp,
    '9': _takhassusKelas9Smp,
    '10': _takhassusKelas10Sma,
    '11': _takhassusKelas11Sma,
    '12': _takhassusKelas12Sma,
  };

  static const _takhassusKelas7 = KelasKurikulum(
    kelas: '7',
    program: 'Takhassus',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.dauroh,
        deskripsi: 'Dauroh',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [30],
        deskripsi: 'Juz 30',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [29],
        deskripsi: 'Juz 29',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [28],
        deskripsi: 'Juz 28',
      ),
    ),
  );

  static const _takhassusKelas10Sma = KelasKurikulum(
    kelas: '10',
    program: 'Takhassus',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.dauroh,
        deskripsi: 'Dauroh',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [30],
        deskripsi: 'Juz 30',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [29],
        deskripsi: 'Juz 29',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [28],
        deskripsi: 'Juz 28',
      ),
    ),
  );

  static const _takhassusKelas8Smp = KelasKurikulum(
    kelas: '8',
    program: 'Takhassus',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [27],
        deskripsi: 'Juz 27',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [26],
        deskripsi: 'Juz 26',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [25],
        deskripsi: 'Juz 25',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [24],
        deskripsi: 'Juz 24',
      ),
    ),
  );

  static const _takhassusKelas9Smp = KelasKurikulum(
    kelas: '9',
    program: 'Takhassus',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [23],
        deskripsi: 'Juz 23',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [22, 21],
        deskripsi: 'Juz 22 + 21',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.uat,
        deskripsi: 'UAT (Ujian Akhir Tahfidz)',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.uat,
        deskripsi: 'UAT (Ujian Akhir Tahfidz)',
      ),
    ),
  );

  static const _takhassusKelas11Sma = KelasKurikulum(
    kelas: '11',
    program: 'Takhassus',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [27, 26],
        deskripsi: 'Juz 27 + 26',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [25, 24],
        deskripsi: 'Juz 25 + 24',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [23, 22],
        deskripsi: 'Juz 23 + 22',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [21, 20],
        deskripsi: 'Juz 21 + 20',
      ),
    ),
  );

  static const _takhassusKelas12Sma = KelasKurikulum(
    kelas: '12',
    program: 'Takhassus',
    semester1: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [19, 18],
        deskripsi: 'Juz 19 + 18',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.ziyadah,
        juzList: [17, 16],
        deskripsi: 'Juz 17 + 16',
      ),
    ),
    semester2: SemesterTarget(
      uts: PeriodeTarget(
        tipe: TipeHafalan.uat,
        deskripsi: 'UAT (Ujian Akhir Tahfidz)',
      ),
      uas: PeriodeTarget(
        tipe: TipeHafalan.uat,
        deskripsi: 'UAT (Ujian Akhir Tahfidz)',
      ),
    ),
  );
}
