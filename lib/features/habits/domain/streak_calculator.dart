import 'package:habit_tracker/core/utils/date_utils.dart';

class StreakCalculator {
  /// Consecutive days ending today, or yesterday if today isn't checked yet
  /// (so the streak isn't shown as broken until the day actually ends).
  static int currentStreak(Set<DateTime> checkIns, DateTime today) {
    var day = dateOnly(today);
    if (!checkIns.contains(day)) day = previousDay(day);

    var streak = 0;
    while (checkIns.contains(day)) {
      streak++;
      day = previousDay(day);
    }
    return streak;
  }

  static int longestStreak(Set<DateTime> checkIns) {
    if (checkIns.isEmpty) return 0;
    final sorted = checkIns.toList()..sort();

    var longest = 1;
    var run = 1;
    for (var i = 1; i < sorted.length; i++) {
      run = daysBetween(sorted[i - 1], sorted[i]) == 1 ? run + 1 : 1;
      if (run > longest) longest = run;
    }
    return longest;
  }
}