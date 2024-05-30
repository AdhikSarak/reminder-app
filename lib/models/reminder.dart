// lib/models/reminder.dart
enum Priority { High, Medium, Low }

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final Priority priority;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.priority = Priority.Medium,
  });
}
