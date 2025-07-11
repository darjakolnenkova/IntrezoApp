import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/contact_controller.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctl = context.read<ContactController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Блюр-контейнер с контактами
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'GET IN TOUCH',
                        style: TextStyle(
                          color: Color(0xFF001A31),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Need help? Get in touch quickly by email, phone, or messengers.',
                      style: TextStyle(
                        color: Color(0xFF001A31),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ctl.info.workingHours,
                      style: TextStyle(
                        color: Color(0xFF001A31),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 18, color: Color(0xFF001A31)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ctl.info.address,
                            style: TextStyle(
                              color: Color(0xFF001A31),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.mail_outline,
                            size: 18, color: Color(0xFF001A31)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: ctl.openEmail,
                          child: Text(
                            ctl.info.email,
                            style: TextStyle(
                              color: Color(0xFF001A31),
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined,
                            size: 18, color: Color(0xFF001A31)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ctl.info.phones.map((p) {
                            return GestureDetector(
                              onTap: () => ctl.openPhone(p),
                              child: Text(
                                p,
                                style: const TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Первая строка: WhatsApp и Viber
          Row(
            children: [
              // WhatsApp
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: ctl.openWhatsApp,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side:
                    const BorderSide(color: Color(0xFF1FCB4F), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  icon: Image.asset(
                    'assets/images/whatsapp.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: 'WhatsApp\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: 'Click to chat',
                          style: TextStyle(
                            color: Color(0xFF1FCB4F),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Viber
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: ctl.openViber,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side:
                    const BorderSide(color: Color(0xFF6655D0), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  icon: Image.asset(
                    'assets/images/viber.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: 'Viber\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: 'Click to chat',
                          style: TextStyle(
                            color: Color(0xFF6655D0),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              // Telegram
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: ctl.openTelegram,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF2AABEE), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  icon: Image.asset(
                    'assets/images/telegram.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: 'Telegram\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: 'Click to chat',
                          style: TextStyle(
                            color: Color(0xFF2AABEE),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Пустое место вместо второй кнопки
              const Expanded(child: SizedBox()),
            ],
          ),

        ],
      ),
    );
  }
}
