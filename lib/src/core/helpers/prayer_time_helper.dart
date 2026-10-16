import 'dart:math' as math;

/// Pure-Dart accurate prayer time calculator for Surabaya.
///
/// Implements the MABIMS / Kemenag RI calculation method (Singapore standard):
/// - Fajr angle  : 20° below horizon
/// - Isha angle  : 18° below horizon
/// - Asr method  : Shafi'i (shadow factor = 1)
/// - Maghrib     : at sunset (-0.833° accounting for atmospheric refraction)
///
/// Location — Pesantren Surabaya:
/// Jl. Kejawan Putih Tambak VI No.1, Mulyorejo, Surabaya, Jawa Timur 60112
/// Latitude : -7.2798°  |  Longitude : 112.7967°  |  Timezone : UTC+7 (WIB)
///
/// Session windows mirror the admin web implementation (`prayer-times.ts`).
class PrayerTimeHelper {
  PrayerTimeHelper._();

  static const double _lat = -7.2798;
  static const double _lon = 112.7967;
  static const int _tzOffset = 7; // WIB: UTC+7

  // ── Trigonometric degree helpers ──────────────────────────────────────────

  static double _sinDeg(double deg) => math.sin(deg * math.pi / 180.0);
  static double _cosDeg(double deg) => math.cos(deg * math.pi / 180.0);
  static double _tanDeg(double deg) => math.tan(deg * math.pi / 180.0);
  static double _radToDeg(double rad) => rad * 180.0 / math.pi;

  // ── Julian Day & Solar Equations ──────────────────────────────────────────

  static double _julianDay(DateTime date) {
    int y = date.year;
    int m = date.month;
    final int d = date.day;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final int a = y ~/ 100;
    final int b = 2 - a + a ~/ 4;
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524.5;
  }

  /// Calculates solar declination (degrees), equation of time (minutes),
  /// and local solar noon (decimal hours in local standard time).
  static ({double dec, double eqTime, double noon}) _solarParams(DateTime date) {
    final double jd = _julianDay(date);
    final double d = jd - 2451545.0; // days since J2000.0

    final double g = (357.529 + 0.98560028 * d) % 360;
    final double q = (280.459 + 0.98564736 * d) % 360;

    final double l = (q + 1.915 * _sinDeg(g) + 0.020 * _sinDeg(2 * g)) % 360;
    final double e = 23.439 - 0.00000036 * d;

    // Right ascension: convert atan2 (-180..180) to [0, 360)
    double ra = _radToDeg(math.atan2(_cosDeg(e) * _sinDeg(l), _cosDeg(l)));
    ra = (ra % 360.0 + 360.0) % 360.0;

    // Declination
    final double dec =
        _radToDeg(math.asin((_sinDeg(e) * _sinDeg(l)).clamp(-1.0, 1.0)));

    // Equation of time (minutes): difference (q - ra), unwrapped to [-180, 180]
    double dDiff = (q - ra) % 360.0;
    if (dDiff > 180.0) dDiff -= 360.0;
    if (dDiff < -180.0) dDiff += 360.0;
    final double eqTime = dDiff * 4.0; // in minutes

    // Local solar noon (hours) = 12 - (lon - tz * 15) / 15 - eqTime / 60
    final double noon =
        12.0 - (_lon - _tzOffset * 15.0) / 15.0 - eqTime / 60.0;

    return (dec: dec, eqTime: eqTime, noon: noon);
  }

  /// Hour angle in degrees for a given solar altitude angle (elevation) in degrees.
  static double _hourAngle(double dec, double elevation) {
    final double num = _sinDeg(elevation) - _sinDeg(_lat) * _sinDeg(dec);
    final double den = _cosDeg(_lat) * _cosDeg(dec);
    return _radToDeg(math.acos((num / den).clamp(-1.0, 1.0)));
  }

  /// Converts decimal hours to a local [DateTime] on [date].
  static DateTime _hoursToDateTime(DateTime date, double decimalHours) {
    final int totalMinutes = (decimalHours * 60.0).round();
    final int h = (totalMinutes ~/ 60).clamp(0, 23);
    final int m = (totalMinutes % 60).clamp(0, 59);
    return DateTime(date.year, date.month, date.day, h, m);
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Returns estimated prayer times for [date] in Surabaya.
  static ({DateTime fajr, DateTime asr, DateTime maghrib, DateTime isha})
      getPrayerTimes(DateTime date) {
    final params = _solarParams(date);
    final double dec = params.dec;
    final double noon = params.noon;

    // Fajr: 20° below horizon (MABIMS)
    final double fajrHA = _hourAngle(dec, -20.0);
    final double fajrTime = noon - fajrHA / 15.0;

    // Asr: Shafi'i shadow factor = 1
    final double asrElev =
        _radToDeg(math.atan(1.0 / (1.0 + _tanDeg((_lat - dec).abs()))));
    final double asrHA = _hourAngle(dec, asrElev);
    final double asrTime = noon + asrHA / 15.0;

    // Maghrib: sunset at -0.833° (standard refraction + semi-diameter)
    final double maghribHA = _hourAngle(dec, -0.833);
    final double maghribTime = noon + maghribHA / 15.0;

    // Isha: 18° below horizon (MABIMS)
    final double ishaHA = _hourAngle(dec, -18.0);
    final double ishaTime = noon + ishaHA / 15.0;

    return (
      fajr: _hoursToDateTime(date, fajrTime),
      asr: _hoursToDateTime(date, asrTime),
      maghrib: _hoursToDateTime(date, maghribTime),
      isha: _hoursToDateTime(date, ishaTime),
    );
  }

  /// Returns the active session key for the current moment.
  ///
  /// [programType] must be either `'reguler'` or `'takhassus'`.
  /// [now] defaults to [DateTime.now()] if not provided.
  ///
  /// Resolution rules (mirrors admin web `getCurrentSessionForProgram`):
  /// - If [now] falls within a session window → returns that session.
  /// - If [now] is before the first session of the day:
  ///   - Reguler → `'maghrib'` (last session of the previous day)
  ///   - Takhassus → `'shubuh'` (first session of today)
  /// - If [now] falls in a gap between sessions or after the last session:
  ///   returns the last session whose start was before or at [now].
  static String getCurrentSession({
    required String programType,
    DateTime? now,
  }) {
    final DateTime dt = now ?? DateTime.now();
    final times = getPrayerTimes(dt);
    final boundaries = _getSessionBoundaries(programType, dt, times);

    // 1. Check if dt falls strictly inside any session window
    for (final b in boundaries) {
      if (!dt.isBefore(b.start) && dt.isBefore(b.end)) {
        return b.sesi;
      }
    }

    // 2. Before the first session of the day (before Shubuh)
    if (dt.isBefore(boundaries.first.start)) {
      return programType == 'takhassus' ? 'shubuh' : 'maghrib';
    }

    // 3. In a gap between sessions or after the last session:
    //    return the latest session that has already started (start <= now)
    String lastActive = boundaries.first.sesi;
    for (final b in boundaries) {
      if (!dt.isBefore(b.start)) {
        lastActive = b.sesi;
      }
    }
    return lastActive;
  }

  // ── Session boundary builder ───────────────────────────────────────────────

  static List<_SessionBoundary> _getSessionBoundaries(
    String programType,
    DateTime date,
    ({DateTime fajr, DateTime asr, DateTime maghrib, DateTime isha}) times,
  ) {
    // Shubuh : Fajr prayer time → 06:00
    final DateTime shubuhStart = times.fajr;
    final DateTime shubuhEnd =
        DateTime(date.year, date.month, date.day, 6, 0);

    // Maghrib : Maghrib prayer time → Isha prayer time
    final DateTime maghribStart = times.maghrib;
    final DateTime maghribEnd = times.isha;

    if (programType == 'reguler') {
      return [
        _SessionBoundary('shubuh', shubuhStart, shubuhEnd),
        _SessionBoundary('maghrib', maghribStart, maghribEnd),
      ];
    }

    // Takhassus — 5 sessions
    // Dhuha : 08:00 → 09:30 (fixed)
    final DateTime dhuhaStart =
        DateTime(date.year, date.month, date.day, 8, 0);
    final DateTime dhuhaEnd =
        DateTime(date.year, date.month, date.day, 9, 30);

    // Siang : 10:00 → 11:00 (fixed)
    final DateTime siangStart =
        DateTime(date.year, date.month, date.day, 10, 0);
    final DateTime siangEnd =
        DateTime(date.year, date.month, date.day, 11, 0);

    // Ashar : Asr prayer time → Asr + 1 hour
    final DateTime asharStart = times.asr;
    final DateTime asharEnd = times.asr.add(const Duration(hours: 1));

    return [
      _SessionBoundary('shubuh', shubuhStart, shubuhEnd),
      _SessionBoundary('dhuha', dhuhaStart, dhuhaEnd),
      _SessionBoundary('siang', siangStart, siangEnd),
      _SessionBoundary('ashar', asharStart, asharEnd),
      _SessionBoundary('maghrib', maghribStart, maghribEnd),
    ];
  }
}

// ── Internal model ────────────────────────────────────────────────────────────

class _SessionBoundary {
  const _SessionBoundary(this.sesi, this.start, this.end);

  final String sesi;
  final DateTime start;
  final DateTime end;
}
