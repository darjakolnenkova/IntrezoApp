import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact_info.dart';

class ContactController extends ChangeNotifier {
  /// Единственный экземпляр с «жёстко прописанной» инфо
  final ContactInfo info = const ContactInfo(
    address: 'Lelle tn 24, Tallinn Harjumaa 11318',
    email: 'info@intrezo.ee',
    phones: ['+372 5683 6668', '+372 6773 091'],
    workingHours: 'Monday – Friday\n9 am – 5 pm',
    whatsAppNumber: '+372 5683 6668',
    viberNumber: '+372 5683 6668',
    telegramUsername: 'Intrezo_hr',
  );

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $uri');
    }
  }

  /// Почта
  Future<void> openEmail() async {
    final uri = Uri(scheme: 'mailto', path: info.email);
    await _launch(uri);
  }

  /// Звонок по номеру
  Future<void> openPhone(String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    await _launch(uri);
  }

  /// WhatsApp
  Future<void> openWhatsApp() async {
    final digits = info.whatsAppNumber.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://api.whatsapp.com/send?phone=37256394644');
    await _launch(uri);
  }

  /// Viber
  Future<void> openViber() async {
    final digits = info.viberNumber.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('viber://chat?number=$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // fallback на веб-ссылку
      final fallback = Uri.parse('https://invite.viber.com/?number=37256934644');
      await _launch(fallback);
    }
  }

  Future<void> openTelegram() async {
    final username = info.telegramUsername;
    final uri = Uri.parse('https://t.me/Intrezo_hr');
    await _launch(uri);
  }
}
