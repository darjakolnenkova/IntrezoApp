import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/settings_controller.dart';
import '../controllers/saved_jobs_controller.dart';
import 'contact_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _confirmClearFavorites(
      BuildContext context, SavedJobsController ctrl) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete all favorites?'),
        content: const Text(
          'Are you sure you want to delete all favorites? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );

    if (yes == true) {
      await ctrl.clearAll();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('All favorites removed')));
    }
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF001A31),
      ),
    );
  }

  /// Добавили iconColor: чтобы можно было менять цвет иконки
  Widget _buildCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? const Color(0xFF001A31)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? const Color(0xFF001A31),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else
                const Icon(Icons.chevron_right, color: Color(0xFF001A31)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final savedCtrl = context.read<SavedJobsController>();

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
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        children: [
          _buildSectionTitle('Preferences'),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: settings.currentLanguage,
            onTap: () {
              settings.setLanguage('English');
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch(
              value: settings.notificationsEnabled,
              activeColor: const Color(0xFF001A31),
              onChanged: settings.setNotificationsEnabled,
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Account'),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.delete_outline,
            iconColor: Colors.red,
            title: 'Clear Saved Favorites',
            titleColor: Colors.red,
            onTap: () => _confirmClearFavorites(context, savedCtrl),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Legal'),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.article_outlined,
            title: 'Terms & Conditions',
            onTap: () => _openUrl('https://intrezo.ee'),
          ),
          const SizedBox(height: 8),
          _buildCard(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _openUrl('https://intrezo.ee/est/andmekaitsetingimused/'),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Support'),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.phone_outlined,
            title: 'Contact Us',
            onTap: () => _openUrl('https://intrezo.ee/en/contact/'),
          ),
          const SizedBox(height: 48),
          Center(
            child: Text(
              '© 2025 Intrezo\nAll rights reserved',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
