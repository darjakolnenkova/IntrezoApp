// lib/views/about_view.dart
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A31),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'About us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      // содержимое страницы
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/about.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            // Заголовок раздела
            const Text(
              'Who We Are',
              style: TextStyle(
                color: Color(0xFF001A31),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Первый абзац
            const Text(
              'At Intrezo OÜ, we believe in making job searching simple, '
                  'efficient, and accessible for everyone. Our mission is to '
                  'connect job seekers with the right opportunities through a '
                  'user-friendly mobile application, where you can easily browse, '
                  'save, and apply for vacancies.',
              style: TextStyle(
                color: Color(0xFF001A31),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Второй абзац
            const Text(
              'With a commitment to transparency and innovation, we strive to '
                  'provide up-to-date job listings and a seamless experience for '
                  'people looking to take the next step in their careers. Whether '
                  'you’re starting out or searching for your next big opportunity, '
                  'Intrezo OÜ is here to help you find the perfect match.',
              style: TextStyle(
                color: Color(0xFF001A31),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Третий абзац
            const Text(
              'Thank you for choosing our app as your trusted partner in your '
                  'job search journey.',
              style: TextStyle(
                color: Color(0xFF001A31),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
