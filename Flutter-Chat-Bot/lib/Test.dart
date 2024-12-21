import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class TestScreen extends StatelessWidget {
  final gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final response = await gemini.text('Hello!');
              print('Gemini Response: $response');
            } catch (e) {
              print('Test message error: $e');
            }
          },
          child: Text('Test Gemini Connection'),
        ),
      ),
    );
  }
}