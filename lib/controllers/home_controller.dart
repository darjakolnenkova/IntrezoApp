import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../services/shared_prefs_service.dart';
import '../models/job.dart';

class HomeController extends ChangeNotifier {
  final FirestoreService _fs;
  final SharedPrefsService _prefs;

  List<String> filters = ['Newest', 'Oldest', 'Salary ↑', 'Salary ↓'];
  String selectedFilter = 'Newest';
  Set<String> savedIds = {};

  HomeController({
    FirestoreService? firestoreService,
    SharedPrefsService? sharedPrefsService,
  })  : _fs = firestoreService ?? FirestoreService(),
        _prefs = sharedPrefsService ?? SharedPrefsService() {
    _init();
  }

  Future<void> _init() async {
    savedIds = await _prefs.loadSavedJobs();
    notifyListeners();
  }

  Future<void> toggleFavorite(String jobId) async {
    if (savedIds.contains(jobId)) {
      savedIds.remove(jobId);
    } else {
      savedIds.add(jobId);
    }
    await _prefs.saveJobs(savedIds);
    notifyListeners();
  }

  Stream<List<Job>> get jobsStream {
    switch (selectedFilter) {
      case 'Oldest':
        return _fs.getJobs(orderBy: 'createdAt', descending: false);
      case 'Salary ↑':
        return _fs.getJobs(orderBy: 'salary', descending: false);
      case 'Salary ↓':
        return _fs.getJobs(orderBy: 'salary', descending: true);
      case 'Newest':
      default:
        return _fs.getJobs(orderBy: 'createdAt', descending: true);
    }
  }

  void selectFilter(int index) {
    final f = filters[index];
    selectedFilter = f;
    filters.removeAt(index);
    filters.insert(0, f);
    notifyListeners();
  }
}
