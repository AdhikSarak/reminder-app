// lib/screens/add_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../services/notification_service.dart';

class AddReminderScreen extends ConsumerStatefulWidget {
  final Reminder? existingReminder;

  AddReminderScreen({this.existingReminder});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _time = DateTime.now();
  Priority _priority = Priority.Medium;

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      _title = widget.existingReminder!.title;
      _description = widget.existingReminder!.description;
      _time = widget.existingReminder!.time;
      _priority = widget.existingReminder!.priority;
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newReminder = Reminder(
        id: widget.existingReminder?.id ?? Uuid().v4(),
        title: _title,
        description: _description,
        time: _time,
        priority: _priority,
      );
      if (widget.existingReminder != null) {
        ref.read(reminderProvider.notifier).editReminder(newReminder);
      } else {
        ref.read(reminderProvider.notifier).addReminder(newReminder);
      }
      NotificationService().scheduleNotification(newReminder);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _time,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = DateTime(picked.year, picked.month, picked.day, _time.hour, _time.minute);
      });
    }
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );
    if (timePicked != null) {
      setState(() {
        _time = DateTime(_time.year, _time.month, _time.day, timePicked.hour, timePicked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReminder == null ? 'Add Reminder' : 'Edit Reminder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Time: ${DateFormat('yyyy-MM-dd – kk:mm').format(_time)}"),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(context),
                  ),
                ],
              ),
              DropdownButtonFormField<Priority>(
                value: _priority,
                items: Priority.values
                    .map((priority) => DropdownMenuItem(value: priority, child: Text(priority.toString().split('.').last)))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value ?? Priority.Medium),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.existingReminder == null ? 'Add Reminder' : 'Edit Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
