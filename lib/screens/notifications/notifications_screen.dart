import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../state/dashboard_provider.dart';
import '../../widgets/common/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 7,
      title: 'Notifications',
      subtitle: 'System alerts and updates',
      headerActions: [
        TextButton(
          onPressed: () {
            context.read<DashboardProvider>().markAllNotificationsAsRead();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All notifications marked as read')),
            );
          },
          child: const Text('Mark all read'),
        ),
      ],
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          final notifications = provider.notifications;

          if (notifications.isEmpty) {
            return const EmptyState(
              title: 'No notifications',
              subtitle: 'You\'re all caught up!',
              icon: Icons.notifications_none,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationCard(
                notification: notification,
                onTap: () {
                  provider.markNotificationAsRead(notification.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      color: notification.isRead
          ? null
          : AppTheme.primaryColor.withValues(alpha: 0.05),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy • HH:mm')
                  .format(notification.timestamp),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
        trailing: notification.isUrgent
            ? const Icon(Icons.warning, color: AppTheme.errorColor)
            : null,
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.deviceOffline:
        return AppTheme.errorColor;
      case NotificationType.classroomLeftOn:
        return AppTheme.warningColor;
      case NotificationType.energyAlert:
        return AppTheme.infoColor;
      case NotificationType.scheduledShutdown:
        return AppTheme.primaryColor;
      case NotificationType.systemAlert:
        return AppTheme.successColor;
      case NotificationType.deviceOnline:
        return AppTheme.successColor;
      case NotificationType.other:
        return AppTheme.textSecondary;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.deviceOffline:
        return Icons.wifi_off;
      case NotificationType.classroomLeftOn:
        return Icons.access_time;
      case NotificationType.energyAlert:
        return Icons.bolt;
      case NotificationType.scheduledShutdown:
        return Icons.schedule;
      case NotificationType.systemAlert:
        return Icons.info;
      case NotificationType.deviceOnline:
        return Icons.wifi;
      case NotificationType.other:
        return Icons.notifications;
    }
  }
}
