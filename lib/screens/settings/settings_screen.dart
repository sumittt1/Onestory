import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 8,
      title: 'Settings',
      subtitle: 'Application preferences',
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        children: [
                _buildSettingsSection(
                  context,
                  'Profile',
                  [
                    _buildSettingsTile(
                      context,
                      'Edit Profile',
                      Icons.person,
                      () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      'Change Password',
                      Icons.lock,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change password (mock)')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                _buildSettingsSection(
                  context,
                  'Notifications',
                  [
                    _buildSwitchTile(
                      context,
                      'Push Notifications',
                      'Receive push notifications',
                      true,
                      (value) {},
                    ),
                    _buildSwitchTile(
                      context,
                      'Email Alerts',
                      'Receive email alerts for critical events',
                      true,
                      (value) {},
                    ),
                    _buildSwitchTile(
                      context,
                      'Energy Reports',
                      'Weekly energy usage reports',
                      false,
                      (value) {},
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                _buildSettingsSection(
                  context,
                  'Appearance',
                  [
                    _buildSwitchTile(
                      context,
                      'Dark Mode',
                      'Use dark theme',
                      false,
                      (value) {},
                    ),
                    _buildSettingsTile(
                      context,
                      'Language',
                      Icons.language,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Language selection (mock)')),
                        );
                      },
                      trailing: const Text('English'),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                _buildSettingsSection(
                  context,
                  'System',
                  [
                    _buildSettingsTile(
                      context,
                      'MQTT Connection',
                      Icons.cloud,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('MQTT connection settings (Phase 2)'),
                          ),
                        );
                      },
                      trailing: const StatusBadge(isEnabled: false),
                    ),
                    _buildSettingsTile(
                      context,
                      'Device Configuration',
                      Icons.devices,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Device configuration (Phase 2)'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      'Backup & Restore',
                      Icons.backup,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Backup (mock)')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                _buildSettingsSection(
                  context,
                  'About',
                  [
                    _buildSettingsTile(
                      context,
                      'Version',
                      Icons.info,
                      null,
                      trailing: const Text('1.0.0'),
                      enabled: false,
                    ),
                    _buildSettingsTile(
                      context,
                      'About OneStory',
                      Icons.description,
                      () {
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingSmall,
            vertical: AppTheme.spacingSmall,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback? onTap, {
    Widget? trailing,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: enabled ? onTap : null,
      enabled: enabled,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About OneStory'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OneStory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: AppTheme.spacingSmall),
            Text('Centralized Smart Energy Management System'),
            SizedBox(height: AppTheme.spacingMedium),
            Text('Version: 1.0.0'),
            Text('Phase 1: Frontend Foundation'),
            SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Designed for educational institutions to manage classroom energy efficiently.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
