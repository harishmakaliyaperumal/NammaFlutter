import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(); // Initialize Alarm service
  runApp(const AlarmApp());
}

class AlarmApp extends StatelessWidget {
  const AlarmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlarmHomePage(),
    );
  }
}

class AlarmHomePage extends StatefulWidget {
  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  DateTime? selectedDateTime;

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _setAlarm() async {
    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time for the alarm.')),
      );
      return;
    }

    final alarmSettings = AlarmSettings(
      id: 42, // Unique ID for the alarm
      dateTime: selectedDateTime!,
      assetAudioPath: 'assets/alarmsound.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      notificationSettings: const NotificationSettings(
        title: 'Alarm!',
        body: 'It\'s time!',
        stopButton: 'Stop',
        icon: 'notification_icon', // Optional, replace with your app icon
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm has been set!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Alarm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedDateTime != null)
              Text('Selected Time: ${selectedDateTime.toString()}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDateTime(context),
              child: const Text('Pick Date & Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setAlarm,
              child: const Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}