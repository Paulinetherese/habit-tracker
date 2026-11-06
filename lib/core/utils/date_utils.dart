/// Strips the time so two timestamps on the same calendar day are equal.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// The calendar day before [d]. Uses the DateTime constructor (not
/// subtract(Duration)) so daylight-saving changes can't cause an off-by-one.
DateTime previousDay(DateTime d) => DateTime(d.year, d.month, d.day - 1);

/// Whole calendar days from [a] to [b].
int daysBetween(DateTime a, DateTime b) => DateTime.utc(b.year, b.month, b.day)
    .difference(DateTime.utc(a.year, a.month, a.day))
    .inDays;

/// "2026-11-07", used as the Firestore check-in document ID.
String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime parseDateKey(String key) {
  final p = key.split('-');
  return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}