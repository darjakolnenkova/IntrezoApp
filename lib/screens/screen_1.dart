import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF001A31),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Image.asset(
              'assets/images/logo.jpg',
              width: size.width * 0.8,
              height: size.height * 0.25, // ограничение по высоте
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
