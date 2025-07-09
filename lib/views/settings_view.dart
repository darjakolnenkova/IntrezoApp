import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_controller.dart';
import '../controllers/saved_jobs_controller.dart';
import 'contact_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
        children: [
          // Language
          _SettingsCard(
            label: 'Language',
            child: ListTile(
              title: const Text('App language'),
              subtitle: Text(settings.currentLanguage),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // TODO: показать диалог выбора языка
                  settings.setLanguage('English');
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notifications
          _SettingsCard(
            label: 'Notifications',
            child: SwitchListTile(
              title: const Text('Enable notifications'),
              value: settings.notificationsEnabled,
              onChanged: settings.setNotificationsEnabled,
            ),
          ),

          const SizedBox(height: 16),

          // Favorites
          _SettingsCard(
            label: 'Favorites',
            child: ListTile(
              title: const Text('Clear saved favorites'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmClearFavorites(context, savedCtrl),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Terms & Policies
          _SettingsCard(
            label: 'Terms & Policies',
            child: Column(
              children: [
                ListTile(
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openUrl('https://intrezo.ee/terms'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openUrl('https://intrezo.ee/privacy'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Support
          _SettingsCard(
            label: 'Support',
            child: ListTile(
              title: const Text('Contact Us'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContactView()),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              '© 2025 Intrezo\nAll rights reserved',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All favorites removed')),
      );
    }
  }
}

/// Базовый контейнер-карта с заголовком
class _SettingsCard extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingsCard({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
