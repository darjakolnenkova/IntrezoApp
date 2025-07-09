import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  /// Индекс активной вкладки (0-Search, 1-Favorites, 2-Сontact, 3-Menu)
  final int activeIndex;

  /// Колбэк нажатия: возвращает индекс той вкладки, которую нажали
  final ValueChanged<int>? onTap;

  const BottomNavBar({
    super.key,
    this.activeIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      {'icon': Icons.search,          'label': 'Search'},
      {'icon': Icons.bookmark_border, 'label': 'Favorites'},
      {'icon': Icons.phone_outlined,  'label': 'Сontact'},
      {'icon': Icons.menu,            'label': 'Menu'},
    ];

    return Container(
      color: const Color(0xFF001A31),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (i) {
          final data = items[i];
          final isActive = i == activeIndex;
          final color   = isActive ? Colors.orange : const Color(0xFFD8D3CD);
          return GestureDetector(
            onTap: () => onTap?.call(i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(data['icon'] as IconData, size: 34, color: color),
                const SizedBox(height: 5),
                Text(
                  data['label'] as String,
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}