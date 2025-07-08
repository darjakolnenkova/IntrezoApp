import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF001A31),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _NavItem(
            icon: Icons.search,
            label: 'Search',
          ),
          _NavItem(
            icon: Icons.bookmark_border,
            label: 'Favorites',
          ),
          _NavItem(
            icon: Icons.phone_outlined,
            label: 'Сontact',
          ),
          _NavItem(
            icon: Icons.menu,
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 34,
          color: Color(0xFFD8D3CD),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFD8D3CD),
          ),
        ),
      ],
    );
  }
}
