import 'package:flutter/material.dart';
import 'package:intrezo/views/faq_view.dart';
import 'package:provider/provider.dart';

import 'package:intrezo/views/about_view.dart';
import 'package:intrezo/controllers/invite_controller.dart';
import 'package:intrezo/views/settings_view.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  static const _menuItems = <_MenuItem>[
    _MenuItem(
      title: 'Document templates',
      icon: Icons.description_outlined,
    ),
    _MenuItem(
      title: 'FAQ',
      icon: Icons.help_outline,
    ),
    _MenuItem(
      title: 'About us',
      icon: Icons.info_outline,
    ),
    _MenuItem(
      title: 'Invite friends',
      icon: Icons.person_add_alt_1_outlined,
    ),
    _MenuItem(
      title: 'Settings',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Забираем контроллер один раз на весь экран
    final inviteCtl = context.read<InviteController>();

    return Scaffold(
      backgroundColor: const Color(0xFFD8D3CD),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            return _MenuTile(
              item: item,
              onTap: () {
                switch (item.title) {
                  case 'About us':
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutView()),
                    );
                    break;
                  case 'Invite friends':
                    inviteCtl.inviteFriends();
                    break;
                  case 'Settings':
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsView()),
                    );
                    break;
                // case 'Document templates':
                //   Navigator.of(context).push(/* … */);
                //   break;
                 case 'FAQ':
                   Navigator.of(context).push(
                     MaterialPageRoute(builder: (_) => const FaqView()),
                   );
                   break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  const _MenuItem({required this.title, required this.icon});
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(item.icon, color: const Color(0xFF001A31), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Color(0xFF001A31),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF001A31)),
          ],
        ),
      ),
    );
  }
}
