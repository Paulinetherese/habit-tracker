import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_tracker/core/utils/date_utils.dart';

import 'habit.dart';

class HabitRepository {
  HabitRepository(this._db, this._uid);
  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _habits =>
      _db.collection('users').doc(_uid).collection('habits');

  Stream<List<Habit>> watchHabits() {
    return _habits.orderBy('createdAt').snapshots().map(
          (snap) => snap.docs
              .map(Habit.fromDoc)
              .where((h) => !h.archived) // filtered here to avoid a Firestore index
              .toList(),
        );
  }

  Future<void> addHabit({
    required String name,
    String? emoji,
    required int colorValue,
  }) {
    return _habits.add({
      'name': name,
      'emoji': emoji,
      'colorValue': colorValue,
      'archived': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Archive instead of delete, so a habit's check-in history isn't orphaned.
  Future<void> archiveHabit(String habitId) =>
      _habits.doc(habitId).update({'archived': true});

  Stream<Set<DateTime>> watchCheckIns(String habitId) {
    return _habits.doc(habitId).collection('checkins').snapshots().map(
          (snap) => snap.docs.map((d) => parseDateKey(d.id)).toSet(),
        );
  }

  /// The doc ID is the date, so checking the same day twice can't duplicate.
  Future<void> setCheckIn(String habitId, DateTime day, bool checked) {
    final ref = _habits.doc(habitId).collection('checkins').doc(dateKey(day));
    return checked
        ? ref.set({'checkedAt': FieldValue.serverTimestamp()})
        : ref.delete();
  }
}