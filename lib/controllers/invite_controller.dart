import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class InviteController extends ChangeNotifier {
  /// Текст и ссылка, которыми будем делиться
  final String inviteText = 'Need a job in Estonia? With Intrezo – access verified job listings, get help with your paperwork, and enjoy support every step of the way. Download the app or visit https://intrezo.ee to start working today!';

  /// Показывает системный Share Sheet
  Future<void> inviteFriends() async {
    try {
      await Share.share(inviteText);
    } catch (e) {
      debugPrint('Ошибка шеринга: $e');
    }
  }
}
