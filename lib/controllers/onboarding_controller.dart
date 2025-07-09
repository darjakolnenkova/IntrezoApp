import 'package:flutter/material.dart';
import 'package:intrezo/views/main_screen.dart';

class OnboardingController {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Explore verified job opportunities",
      "subtitle":
      "Access only trusted and legal job offers from reliable employers – with clear terms, safe conditions, and full transparency.",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Apply in one click",
      "subtitle":
      "No complicated process – just a short form, and we’ll take it from there.",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Full support at every step of the way",
      "subtitle":
      "We provide full support with documents, visas, and relocation — making sure every step is simple, clear, and taken care of for you.",
    },
    {
      "image": "assets/images/onboarding1.png",
      "title": "Start a new life with confidence",
      "subtitle":
      "Secure an official job in Estonia with stable income and clear conditions.",
    },
  ];

  void onPageChanged(int index) {
    currentPage = index;
  }

  void next() {
    if (currentPage < data.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previous() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Переходим на главный экран и **очищаем стек**, чтобы нельзя было вернуться назад
  void getStarted(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
    );
  }
}

