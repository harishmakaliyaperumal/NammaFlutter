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
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
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
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text('நம்ம Alarm',),
          ],
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (selectedDateTime != null)
              Center(
                child: Text(
                  'Selected Time: ${selectedDateTime.toString()}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _pickDateTime(context),
              child: const Text(
                'Pick Date & Time',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _setAlarm,
              child: const Text(
                'Set Alarm',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Never miss an important moment!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}