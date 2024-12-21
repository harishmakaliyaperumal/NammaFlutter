import 'package:flutter/material.dart';
import 'package:flutter_chatbot/HomePage.dart';
import 'package:flutter_chatbot/SplashScreen.dart';
import 'package:flutter_chatbot/const.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dio/dio.dart';

import 'Test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio(BaseOptions(
    baseUrl: 'https://generativelanguage.googleapis.com',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    headers: {
      'Host': 'generativelanguage.googleapis.com',
    },
  ));

  try {
    // Test connection first
    final testResponse = await dio.get(
      '/v1beta/models',
      queryParameters: {'key': GEMINI_API_KEY},
    );
    print('Connection test successful: ${testResponse.statusCode}');

    // Initialize Gemini with basic configuration
    Gemini.init(
      apiKey: GEMINI_API_KEY,
      enableDebugging: true, // Enable debugging for more detailed logs
    );
    print('Gemini initialized successfully');
  } catch (e) {
    print('Connection error: $e');
    // Try alternate initialization if the test fails
    try {
      Gemini.init(
        apiKey: GEMINI_API_KEY,
        enableDebugging: true,
      );
      print('Alternate initialization successful');
    } catch (e2) {
      print('Alternate initialization failed: $e2');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage()
    );
  }
}