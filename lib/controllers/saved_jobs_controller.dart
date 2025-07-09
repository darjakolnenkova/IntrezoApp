import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_jobs.dart';

class SavedJobsController extends ChangeNotifier {
  final SavedJobs _model = SavedJobs();

  List<String> get savedIds => List.unmodifiable(_model.ids);

  SavedJobsController() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('saved_jobs') ?? [];
    _model.ids = list;
    notifyListeners();
  }

  Future<void> toggle(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_model.ids.contains(jobId)) {
      _model.ids.remove(jobId);
    } else {
      // новый ID в начало
      _model.ids.insert(0, jobId);
    }
    await prefs.setStringList('saved_jobs', _model.ids);
    notifyListeners();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    _model.ids.clear();
    await prefs.remove('saved_jobs');
    notifyListeners();
  }
}
