import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../services/shared_prefs_service.dart';
import '../models/job.dart';

enum FilterOption { newest, oldest }

extension FilterOptionExt on FilterOption {
  String get label {
    switch (this) {
      case FilterOption.oldest:
        return 'Oldest';
      case FilterOption.newest:
        return 'Newest';
    }
  }
}

class HomeController extends ChangeNotifier {
  final FirestoreService _fs;
  final SharedPrefsService _prefs;

  FilterOption selectedFilter = FilterOption.newest;
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
    if (!savedIds.remove(jobId)) {
      savedIds.add(jobId);
    }
    await _prefs.saveJobs(savedIds);
    notifyListeners();
  }

  Stream<List<Job>> get jobsStream {
    if (selectedFilter == FilterOption.oldest) {
      return _fs.getJobs(orderBy: 'createdAt', descending: false);
    } else {
      return _fs.getJobs(orderBy: 'createdAt', descending: true);
    }
  }

  void selectFilter(FilterOption option) {
    if (option != selectedFilter) {
      selectedFilter = option;
      notifyListeners();
    }
  }
}
