// lib/views/splash_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/splash_controller.dart';
import 'onboarding_view.dart';
import 'main_screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Берём контроллер из провайдера
    final ctl = context.read<SplashController>();
    final showOnboarding = await ctl.checkFirstLaunch();
    if (!mounted) return;

    if (showOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF001A31),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Image.asset(
            'assets/images/logo.jpg',
            width: size.width * 0.8,
            height: size.height * 0.25,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
