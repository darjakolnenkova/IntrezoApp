import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class InviteController extends ChangeNotifier {
  final String inviteText =
      'Need a job in Estonia? With Intrezo – access verified job listings, '
      'get help with your paperwork, and enjoy support every step of the way. '
      'Download the app or visit https://intrezo.ee to start working today!';

  Future<void> inviteFriends() async {
    try {
      await SharePlus.instance.share(ShareParams(text: inviteText));
    } catch (e) {
      debugPrint('Ошибка шеринга: \$e');
    }
  }
}