import 'package:shared_preferences/shared_preferences.dart';

class SplashController {
  /// Ждём, проверяем флаг, устанавливаем его и возвращаем, был ли это первый запуск
  Future<bool> checkFirstLaunch() async {
    // Делаем задержку для показа Splash
    await Future.delayed(const Duration(milliseconds: 3000));

    final prefs = await SharedPreferences.getInstance();

    // Временно сбрасываем флаг, чтобы каждый запуск выдавал онбординг:
    // await prefs.remove('seenOnboarding');

    final seen = prefs.getBool('seenOnboarding') ?? false;

    if (!seen) {
      // первый запуск — запомним, что уже видели онбординг
      await prefs.setBool('seenOnboarding', true);
    }
    return !seen;
  }
}
