// lib/controllers/splash_controller.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Контроллер сплэша: проверяет, был ли первый запуск приложения.
class SplashController extends ChangeNotifier {
  /// Проверяет, первый ли это запуск, и ставит флаг в SharedPreferences.
  Future<bool> checkFirstLaunch() async {
    // Делаем задержку, чтобы сплэш был виден
    await Future.delayed(const Duration(milliseconds: 3000));

    final prefs = await SharedPreferences.getInstance();

    // Временно сбрасываем флаг, чтобы каждый запуск выдавал онбординг:
    // await prefs.remove('seenOnboarding');

    final seen = prefs.getBool('seenOnboarding') ?? false;

    if (!seen) {
      // Сохраняем, что онбординг уже показывали
      await prefs.setBool('seenOnboarding', true);
    }
    // Возвращаем true, если нужно показать онбординг (то есть если ещё не видели)
    return !seen;
  }
}