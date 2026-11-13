import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme.dart';
import '../../core/responsive/breakpoints.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../widgets/common/widgets.dart';

class ActivityLogsScreen extends StatefulWidget {
  const ActivityLogsScreen({super.key});

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  @override
  Widget build(BuildContext context) {
    final logs = MockDataProvider.getActivityLogs();

    return AppShell(
      selectedIndex: 6,
      title: 'Activity Logs',
      subtitle: 'View system audit trail',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Breakpoints.isMobile(context)
            ? _buildMobileList(context, logs)
            : _buildDesktopTable(context, logs),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<ActivityLogModel> logs) {
    return Column(
      children: logs.map((log) => _buildLogCard(context, log)).toList(),
    );
  }

  Widget _buildLogCard(BuildContext context, ActivityLogModel log) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 16),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(
                    log.userName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              _getActionText(log.action),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (log.targetName != null) ...[
              const SizedBox(height: 4),
              Text(
                log.targetName!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              DateFormat('MMM dd, yyyy • HH:mm').format(log.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<ActivityLogModel> logs) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Action')),
            DataColumn(label: Text('Target')),
            DataColumn(label: Text('Timestamp')),
          ],
          rows: logs.map((log) {
            return DataRow(
              cells: [
                DataCell(Text(log.userName)),
                DataCell(Text(_getActionText(log.action))),
                DataCell(Text(log.targetName ?? '-')),
                DataCell(Text(DateFormat('MMM dd, HH:mm').format(log.timestamp))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getActionText(ActionType action) {
    switch (action) {
      case ActionType.turnOn:
        return 'Turned ON';
      case ActionType.turnOff:
        return 'Turned OFF';
      case ActionType.emergencyShutdown:
        return 'Emergency Shutdown';
      case ActionType.buildingShutdown:
        return 'Building Shutdown';
      case ActionType.scheduledShutdown:
        return 'Scheduled Shutdown';
      case ActionType.deviceOffline:
        return 'Device Offline';
      case ActionType.deviceOnline:
        return 'Device Online';
      case ActionType.other:
        return 'Other Action';
    }
  }
}
