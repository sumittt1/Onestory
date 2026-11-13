import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../state/auth_provider.dart';
import '../../widgets/common/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser ?? MockDataProvider.getUsers().first;

          return Column(
            children: [
              AppHeader(
                title: 'Profile',
                subtitle: 'User information',
                showBackButton: true,
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    children: [
                      _buildProfileHeader(context, user),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildProfileDetails(context, user),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildAssignedZones(context, user),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildActions(context, authProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXLarge),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                user.name.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacingXSmall),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            _buildRoleBadge(user.role),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(UserRole role) {
    String label;
    Color color;

    switch (role) {
      case UserRole.admin:
        label = 'Administrator';
        color = AppTheme.errorColor;
        break;
      case UserRole.faculty:
        label = 'Faculty Member';
        color = AppTheme.primaryColor;
        break;
      case UserRole.staff:
        label = 'Staff Member';
        color = AppTheme.infoColor;
        break;
      case UserRole.student:
        label = 'Student';
        color = AppTheme.successColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildDetailRow('User ID', user.id),
            _buildDetailRow('Email', user.email),
            _buildDetailRow('Name', user.name),
            _buildDetailRow('Role', user.role.name.toUpperCase()),
            _buildDetailRow('Status', user.isActive ? 'Active' : 'Inactive'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedZones(BuildContext context, UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned Zones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMedium),
            if (user.assignedZones.isEmpty)
              const Text(
                'No zones assigned',
                style: TextStyle(color: AppTheme.textSecondary),
              )
            else
              Wrap(
                spacing: AppTheme.spacingSmall,
                runSpacing: AppTheme.spacingSmall,
                children: user.assignedZones.map((zone) {
                  return Chip(
                    label: Text(zone),
                    avatar: const Icon(Icons.location_on, size: 16),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, AuthProvider authProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile (mock)')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorColor),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppTheme.errorColor),
              ),
              onTap: () {
                ConfirmationDialog.show(
                  context: context,
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  confirmText: 'Logout',
                ).then((confirmed) {
                  if (confirmed == true) {
                    authProvider.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
