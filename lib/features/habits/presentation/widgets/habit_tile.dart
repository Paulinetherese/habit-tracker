import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/core/utils/date_utils.dart';
import 'package:habit_tracker/features/habits/data/habit.dart';
import 'package:habit_tracker/features/habits/domain/streak_calculator.dart';
import 'package:habit_tracker/features/habits/providers/habit_providers.dart';

class HabitTile extends ConsumerWidget {
  const HabitTile({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkIns = ref.watch(checkInsProvider(habit.id)).value ?? <DateTime>{};
    final today = dateOnly(DateTime.now());
    final doneToday = checkIns.contains(today);
    final streak = StreakCalculator.currentStreak(checkIns, today);
    final color = Color(habit.colorValue);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(habit.emoji ?? habit.name[0].toUpperCase()),
        ),
        title: Text(habit.name),
        subtitle: Text(streak > 0 ? '🔥 $streak day streak' : 'No streak yet'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: doneToday,
              activeColor: color,
              onChanged: (v) => ref
                  .read(habitRepositoryProvider)
                  ?.setCheckIn(habit.id, today, v ?? false),
            ),
            PopupMenuButton<String>(
              onSelected: (_) =>
                  ref.read(habitRepositoryProvider)?.archiveHabit(habit.id),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'archive', child: Text('Archive')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}