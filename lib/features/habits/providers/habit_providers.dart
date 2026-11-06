import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/auth/providers/auth_providers.dart';

import '../data/habit.dart';
import '../data/habit_repository.dart';

/// Null when logged out. Rebuilds automatically when the user changes.
final habitRepositoryProvider = Provider<HabitRepository?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return HabitRepository(FirebaseFirestore.instance, user.uid);
});

final habitsProvider = StreamProvider<List<Habit>>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  if (repo == null) return Stream.value(const <Habit>[]);
  return repo.watchHabits();
});

final checkInsProvider =
    StreamProvider.family<Set<DateTime>, String>((ref, habitId) {
  final repo = ref.watch(habitRepositoryProvider);
  if (repo == null) return Stream.value(<DateTime>{});
  return repo.watchCheckIns(habitId);
});