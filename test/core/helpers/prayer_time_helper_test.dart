import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/src/core/helpers/prayer_time_helper.dart';

void main() {
  group('PrayerTimeHelper — Prayer Times & Session Calculation', () {
    test('calculates valid prayer times for Surabaya coordinates', () {
      final testDate = DateTime(2026, 8, 3);
      final times = PrayerTimeHelper.getPrayerTimes(testDate);

      expect(times.fajr.isBefore(times.asr), isTrue);
      expect(times.asr.isBefore(times.maghrib), isTrue);
      expect(times.maghrib.isBefore(times.isha), isTrue);

      // Fajr should be around 04:00 - 05:00 WIB in Surabaya
      expect(times.fajr.hour, inInclusiveRange(4, 5));
      // Asr should be around 14:00 - 15:30 WIB
      expect(times.asr.hour, inInclusiveRange(14, 15));
      // Maghrib should be around 17:00 - 18:30 WIB
      expect(times.maghrib.hour, inInclusiveRange(17, 18));
      // Isha should be around 18:30 - 19:30 WIB
      expect(times.isha.hour, inInclusiveRange(18, 19));
    });

    test('calculates valid prayer times for all 365 days of 2026 and 2027', () {
      for (int year in [2026, 2027]) {
        for (int month = 1; month <= 12; month++) {
          final daysInMonth = DateTime(year, month + 1, 0).day;
          for (int day = 1; day <= daysInMonth; day++) {
            final testDate = DateTime(year, month, day);
            final times = PrayerTimeHelper.getPrayerTimes(testDate);

            // Verify order of prayer times
            expect(times.fajr.isBefore(times.asr), isTrue,
                reason: 'Fajr before Asr failed for $testDate');
            expect(times.asr.isBefore(times.maghrib), isTrue,
                reason: 'Asr before Maghrib failed for $testDate');
            expect(times.maghrib.isBefore(times.isha), isTrue,
                reason: 'Maghrib before Isha failed for $testDate');

            // Fajr between 03:30 and 05:30 in Surabaya
            expect(times.fajr.hour, inInclusiveRange(3, 5),
                reason: 'Fajr hour out of range for $testDate');
            // Asr between 14:00 and 16:00
            expect(times.asr.hour, inInclusiveRange(14, 16),
                reason: 'Asr hour out of range for $testDate');
            // Maghrib between 17:00 and 18:30
            expect(times.maghrib.hour, inInclusiveRange(17, 18),
                reason: 'Maghrib hour out of range for $testDate');
            // Isha between 18:00 and 19:45
            expect(times.isha.hour, inInclusiveRange(18, 19),
                reason: 'Isha hour out of range for $testDate');

            // Verify morning session at 06:00 is shubuh
            final at6am = DateTime(year, month, day, 6, 0);
            expect(
              PrayerTimeHelper.getCurrentSession(
                programType: 'reguler',
                now: at6am,
              ),
              equals('shubuh'),
              reason: '6:00 AM should be shubuh for $testDate',
            );
          }
        }
      }
    });

    group('Takhassus program (5 sessions)', () {
      test('resolves Dhuha at 08:15 (within 08:00 - 09:30)', () {
        final dhuhaTime = DateTime(2026, 8, 3, 8, 15);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'takhassus',
            now: dhuhaTime,
          ),
          equals('dhuha'),
        );
      });

      test('resolves Siang at 10:15 (within 10:00 - 11:00)', () {
        final siangTime = DateTime(2026, 8, 3, 10, 15);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'takhassus',
            now: siangTime,
          ),
          equals('siang'),
        );
      });

      test('gap between Dhuha and Siang (09:45) returns previous session dhuha', () {
        final gapTime = DateTime(2026, 8, 3, 9, 45);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'takhassus',
            now: gapTime,
          ),
          equals('dhuha'),
        );
      });

      test('exactly at start of Dhuha (08:00:00) returns dhuha', () {
        final exactStart = DateTime(2026, 8, 3, 8, 0, 0);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'takhassus',
            now: exactStart,
          ),
          equals('dhuha'),
        );
      });

      test('late at night (21:00) returns maghrib', () {
        final lateNight = DateTime(2026, 8, 3, 21, 0);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'takhassus',
            now: lateNight,
          ),
          equals('maghrib'),
        );
      });

      test('early morning before Shubuh (00:30) returns shubuh for Takhassus', () {
        final midnight = DateTime(2026, 8, 3, 0, 30);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'takhassus',
            now: midnight,
          ),
          equals('shubuh'),
        );
      });
    });

    group('Reguler program (2 sessions: shubuh & maghrib)', () {
      test('morning at 08:00 returns shubuh (after shubuh ends, before maghrib)', () {
        final morningTime = DateTime(2026, 8, 3, 8, 0);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'reguler',
            now: morningTime,
          ),
          equals('shubuh'),
        );
      });

      test('afternoon at 13:00 returns shubuh (gap returns latest session)', () {
        final afternoonTime = DateTime(2026, 8, 3, 13, 0);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'reguler',
            now: afternoonTime,
          ),
          equals('shubuh'),
        );
      });

      test('late night at 21:00 returns maghrib', () {
        final lateNight = DateTime(2026, 8, 3, 21, 0);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'reguler',
            now: lateNight,
          ),
          equals('maghrib'),
        );
      });

      test('early morning before Shubuh (00:30) returns maghrib for Reguler (yesterday session)', () {
        final midnight = DateTime(2026, 8, 3, 0, 30);
        expect(
          PrayerTimeHelper.getCurrentSession(
            programType: 'reguler',
            now: midnight,
          ),
          equals('maghrib'),
        );
      });
    });
  });
}
