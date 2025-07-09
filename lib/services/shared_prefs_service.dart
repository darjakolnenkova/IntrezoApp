import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const _keySaved = 'saved_jobs';

  Future<Set<String>> loadSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySaved)?.toSet() ?? {};
  }

  Future<void> saveJobs(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySaved, ids.toList());
  }
}