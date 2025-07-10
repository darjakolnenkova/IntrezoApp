import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends ChangeNotifier {
  Future<bool> checkFirstLaunch() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    final prefs = await SharedPreferences.getInstance();

    // Временно сбрасываем флаг, чтобы каждый запуск выдавал онбординг:
    // await prefs.remove('seenOnboarding');

    final seen = prefs.getBool('seenOnboarding') ?? false;

    if (!seen) {
      await prefs.setBool('seenOnboarding', true);
    }
    return !seen;
  }
}