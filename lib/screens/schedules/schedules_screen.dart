import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../widgets/common/widgets.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  @override
  Widget build(BuildContext context) {
    final schedules = MockDataProvider.getSchedules();

    return AppShell(
      selectedIndex: 4,
      title: 'Schedules',
      subtitle: 'Manage automated power schedules',
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              children: [
                ...schedules.map(
                  (schedule) => _buildScheduleCard(context, schedule),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            right: AppTheme.spacingMedium,
            bottom: AppTheme.spacingMedium,
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add schedule dialog (mock)')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Schedule'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, ScheduleModel schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    StatusBadge(isEnabled: schedule.isEnabled),
                    const SizedBox(width: AppTheme.spacingSmall),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit schedule (mock)')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppTheme.errorColor,
                      onPressed: () {
                        ConfirmationDialog.show(
                          context: context,
                          title: 'Delete Schedule',
                          message: 'Are you sure you want to delete this schedule?',
                          isDestructive: true,
                        ).then((confirmed) {
                          if (confirmed == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Schedule deleted (mock)')),
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            if (schedule.description != null)
              Text(
                schedule.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            const SizedBox(height: AppTheme.spacingSmall),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  schedule.assignedZone,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.repeat, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  _getRepeatText(schedule.repeat),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRepeatText(ScheduleRepeat repeat) {
    switch (repeat) {
      case ScheduleRepeat.none:
        return 'One-time';
      case ScheduleRepeat.daily:
        return 'Daily';
      case ScheduleRepeat.weekly:
        return 'Weekly';
      case ScheduleRepeat.weekend:
        return 'Weekends';
      case ScheduleRepeat.weekdays:
        return 'Weekdays';
    }
  }
}
