/// Encodes the real per-weekday session schedule for each program type.
///
/// Reguler:
///   Mon–Thu → shubuh, maghrib          (2 sessions)
///   Fri     → maghrib                  (1 session)
///   Sat     → maghrib                  (1 session)
///   Sun     → shubuh                   (1 session)
///
/// Takhassus:
///   Mon–Thu → shubuh, dhuha, siang, ashar, maghrib  (5 sessions)
///   Fri     → shubuh                                (1 session)
///   Sat     → shubuh                                (1 session)
///   Sun     → maghrib                               (1 session)
class ScheduleHelper {
  const ScheduleHelper._();

  // ── Reguler per-weekday schedule ─────────────────────────────────────────

  static const _regulerMonThu = ['shubuh', 'maghrib'];
  static const _regulerFri = ['maghrib'];
  static const _regulerSat = ['maghrib'];
  static const _regulerSun = ['shubuh'];

  // ── Takhassus per-weekday schedule ───────────────────────────────────────

  static const _takhassusMonThu = [
    'shubuh',
    'dhuha',
    'siang',
    'ashar',
    'maghrib',
  ];
  static const _takhassusFri = ['shubuh'];
  static const _takhassusSat = ['shubuh'];
  static const _takhassusSun = ['maghrib'];

  // ── Public API ────────────────────────────────────────────────────────────

  /// Returns the list of session keys that are **scheduled** on [date]
  /// for [programType] (`'reguler'` or `'takhassus'`).
  ///
  /// [date] is compared by its [DateTime.weekday] value:
  ///   1 = Monday … 5 = Friday, 6 = Saturday, 7 = Sunday.
  static List<String> scheduledSessionsForDay(
    DateTime date,
    String programType,
  ) {
    final isTakhassus = programType.trim().toLowerCase() == 'takhassus';
    switch (date.weekday) {
      case DateTime.friday:
        return isTakhassus ? _takhassusFri : _regulerFri;
      case DateTime.saturday:
        return isTakhassus ? _takhassusSat : _regulerSat;
      case DateTime.sunday:
        return isTakhassus ? _takhassusSun : _regulerSun;
      default: // Mon–Thu
        return isTakhassus ? _takhassusMonThu : _regulerMonThu;
    }
  }

  /// Returns the **total** number of scheduled sessions across
  /// the inclusive date range [[start], [end]] for [programType].
  ///
  /// This replaces the naïve `dayCount × sessionsPerDay` formula.
  static int totalScheduledSessions(
    DateTime start,
    DateTime end,
    String programType,
  ) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    int total = 0;
    var current = s;
    while (!current.isAfter(e)) {
      total += scheduledSessionsForDay(current, programType).length;
      current = current.add(const Duration(days: 1));
    }
    return total;
  }
}
