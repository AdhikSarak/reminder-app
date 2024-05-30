// lib/providers/reminder_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/reminder.dart';

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  ReminderNotifier() : super([]);

  void addReminder(Reminder reminder) {
    state = [...state, reminder];
  }

  void editReminder(Reminder reminder) {
    state = state.map((r) => r.id == reminder.id ? reminder : r).toList();
  }

  void deleteReminder(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  List<Reminder> get remindersByPriority {
    return [...state]..sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }
}

final reminderProvider = StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  return ReminderNotifier();
});
