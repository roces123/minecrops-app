// lib/main.dart
import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineCrops',
      theme: ThemeData(
        // Retain your theme setup
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B8E23)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
