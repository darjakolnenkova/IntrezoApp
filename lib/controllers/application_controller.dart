import 'package:flutter/foundation.dart';
import '../models/application.dart';
import '../services/firestore_service.dart';

class ApplicationController extends ChangeNotifier {
  final FirestoreService _fs;
  bool isSubmitting = false;
  String? error;

  ApplicationController({FirestoreService? firestoreService})
      : _fs = firestoreService ?? FirestoreService();

  Future<bool> submit(Application app) async {
    isSubmitting = true;
    error = null;
    notifyListeners();
    try {
      await _fs.submitApplication(app.toJson());
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
