// lib/views/main_screen.dart

import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_view.dart';
import 'saved_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  static const _screens = [
    HomeView(),
    SavedView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Общий AppBar для всех экранов
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A31),
        elevation: 0,
        toolbarHeight: 80,
        title: Image.asset(
          'assets/images/miniintrezo.png',
          width: 150,
          height: 150,
        ),
      ),
      // Переключаем контент, но не пересоздаём экраны
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        activeIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
