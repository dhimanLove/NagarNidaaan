import 'package:flutter/material.dart';
import 'package:travia/Pages/onboarding.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travia',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFEEF0F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B2EFF),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}