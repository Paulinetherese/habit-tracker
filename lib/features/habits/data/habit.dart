import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
    this.emoji,
    this.archived = false,
  });

  final String id;
  final String name;
  final String? emoji;
  final int colorValue;
  final DateTime createdAt;
  final bool archived;

  factory Habit.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final ts = data['createdAt'];
    return Habit(
      id: doc.id,
      name: data['name'] as String? ?? '',
      emoji: data['emoji'] as String?,
      colorValue: data['colorValue'] as int? ?? 0xFF009688,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
      archived: data['archived'] as bool? ?? false,
    );
  }
}