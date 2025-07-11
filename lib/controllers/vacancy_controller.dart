import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/vacancy.dart';
import 'saved_jobs_controller.dart';

class VacancyController extends ChangeNotifier {
  final String vacancyId;
  final SavedJobsController savedJobsCtrl;
  final _col = FirebaseFirestore.instance.collection('jobs');

  Vacancy? vacancy;
  bool isLoading = true;
  String? error;
  bool isSaved = false;

  VacancyController({
    required this.vacancyId,
    required this.savedJobsCtrl,
  }) {
    _load();
  }

  Future<void> _load() async {
    try {
      final snap = await _col.doc(vacancyId).get();
      if (!snap.exists) throw 'Vacancy not found';
      vacancy = Vacancy.fromDoc(snap);

      isSaved = savedJobsCtrl.savedIds.contains(vacancyId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    await savedJobsCtrl.toggle(vacancyId);
    isSaved = savedJobsCtrl.savedIds.contains(vacancyId);
    notifyListeners();
  }
}