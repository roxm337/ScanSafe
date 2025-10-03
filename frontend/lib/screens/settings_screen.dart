import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/layout/custom_card.dart';
import '../components/buttons/custom_elevated_button.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Theme settings
            CustomCard(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.brightness_6,
                    title: 'Theme',
                    subtitle: 'Light, Dark, or System',
                    onTap: () {
                      // Show theme selection dialog
                      _showThemeDialog(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage app notifications',
                    onTap: () {
                      // Navigate to notification settings
                      Get.snackbar('Coming Soon', 'Notification settings will be available in the next update');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Privacy & Security
            CustomCard(
              child: _buildSettingsItem(
                context: context,
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Review our privacy practices',
                onTap: () {
                  Get.snackbar('Privacy Policy', 'Privacy policy content would be shown here');
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // App info
            CustomCard(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About App',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.rate_review,
                    title: 'Rate App',
                    subtitle: 'Share your feedback',
                    onTap: () {
                      Get.snackbar('Rate Our App', 'Would you like to rate our app?');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Choose Theme',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text('Light'),
              value: ThemeMode.light,
              groupValue: Theme.of(context).brightness == Brightness.light ? ThemeMode.light : 
                         Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.system,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  Get.changeThemeMode(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('Dark'),
              value: ThemeMode.dark,
              groupValue: Theme.of(context).brightness == Brightness.light ? ThemeMode.light : 
                         Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.system,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  Get.changeThemeMode(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('System'),
              value: ThemeMode.system,
              groupValue: Theme.of(context).brightness == Brightness.light ? ThemeMode.light : 
                         Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.system,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  Get.changeThemeMode(value);
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About ScanSafe',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.shield,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ScanSafe v1.0.0',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your trusted product safety scanner',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}