// lib/screens/reminder_list_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import 'add_reminder_screen.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text('${reminder.description} - ${reminder.time}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(reminderProvider.notifier).deleteReminder(reminder.id);
              },
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddReminderScreen(existingReminder: reminder),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddReminderScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
