import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/habits/providers/habit_providers.dart';

Future<void> showHabitFormSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const HabitFormSheet(),
  );
}

class HabitFormSheet extends ConsumerStatefulWidget {
  const HabitFormSheet({super.key});

  @override
  ConsumerState<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends ConsumerState<HabitFormSheet> {
  static const _colors = [
    Colors.teal,
    Colors.indigo,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.green,
  ];

  final _nameCtrl = TextEditingController();
  final _emojiCtrl = TextEditingController();
  Color _color = _colors.first;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final emoji = _emojiCtrl.text.trim();
    await ref.read(habitRepositoryProvider)?.addHabit(
          name: name,
          emoji: emoji.isEmpty ? null : emoji,
          colorValue: _color.toARGB32(),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New habit', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Habit name',
              hintText: 'e.g. Drink water',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emojiCtrl,
            decoration: const InputDecoration(
              labelText: 'Emoji (optional)',
              hintText: '💧',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              for (final c in _colors)
                GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: CircleAvatar(
                    backgroundColor: c,
                    radius: 16,
                    child: _color == c
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: const Text('Add habit'),
          ),
        ],
      ),
    );
  }
}