import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/domain/streak_calculator.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

void main() {
  final today = d(2026, 11, 7);

  group('currentStreak', () {
    test('is 0 with no check-ins', () {
      expect(StreakCalculator.currentStreak({}, today), 0);
    });

    test('counts today only', () {
      expect(StreakCalculator.currentStreak({today}, today), 1);
    });

    test('keeps the streak alive if only yesterday is checked', () {
      final checkIns = {d(2026, 11, 6), d(2026, 11, 5)};
      expect(StreakCalculator.currentStreak(checkIns, today), 2);
    });

    test('is 0 if the last check-in was 2+ days ago', () {
      expect(StreakCalculator.currentStreak({d(2026, 11, 4)}, today), 0);
    });

    test('stops at a gap', () {
      final checkIns = {d(2026, 11, 7), d(2026, 11, 6), d(2026, 11, 4)};
      expect(StreakCalculator.currentStreak(checkIns, today), 2);
    });

    test('works across a month boundary', () {
      final checkIns = {d(2026, 11, 1), d(2026, 10, 31), d(2026, 10, 30)};
      expect(StreakCalculator.currentStreak(checkIns, d(2026, 11, 1)), 3);
    });

    test('works across a year boundary', () {
      final checkIns = {d(2026, 1, 1), d(2025, 12, 31)};
      expect(StreakCalculator.currentStreak(checkIns, d(2026, 1, 1)), 2);
    });
  });

  group('longestStreak', () {
    test('is 0 with no check-ins', () {
      expect(StreakCalculator.longestStreak({}), 0);
    });

    test('is 1 for a single day', () {
      expect(StreakCalculator.longestStreak({today}), 1);
    });

    test('finds a longest run that is not the current one', () {
      final checkIns = {
        d(2026, 10, 1), d(2026, 10, 2), d(2026, 10, 3), d(2026, 10, 4),
        d(2026, 11, 7),
      };
      expect(StreakCalculator.longestStreak(checkIns), 4);
    });

    test('handles a daylight-saving boundary', () {
      // US clocks change on 2026-03-08 and 2026-11-01.
      final checkIns = {d(2026, 3, 7), d(2026, 3, 8), d(2026, 3, 9)};
      expect(StreakCalculator.longestStreak(checkIns), 3);
    });
  });
}