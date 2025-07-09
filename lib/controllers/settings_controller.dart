import 'package:flutter/foundation.dart';

class SettingsController extends ChangeNotifier {
  String _language = 'English';
  bool _notificationsEnabled = true;

  String get currentLanguage => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}
