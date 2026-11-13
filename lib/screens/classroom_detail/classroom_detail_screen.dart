import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../state/dashboard_provider.dart';
import '../../widgets/common/widgets.dart';

class ClassroomDetailScreen extends StatefulWidget {
  final String roomId;

  const ClassroomDetailScreen({
    super.key,
    required this.roomId,
  });

  @override
  State<ClassroomDetailScreen> createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          final room = provider.rooms.firstWhere(
            (r) => r.roomId == widget.roomId,
            orElse: () => provider.rooms.first,
          );

          final building = provider.buildings.firstWhere(
            (b) => b.buildingId == room.buildingId,
            orElse: () => provider.buildings.first,
          );

          return Column(
            children: [
              AppHeader(
                title: room.roomName,
                subtitle: '${building.buildingName} • Floor ${room.floor}',
                showBackButton: true,
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRoomInfoCard(context, room),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildMainPowerCard(context, room, provider),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildDeviceControls(context, room, provider),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildEnergySection(context, room),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildActivitySection(context, room),
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

  Widget _buildRoomInfoCard(BuildContext context, RoomModel room) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Room Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                StatusBadge(onlineStatus: room.onlineStatus),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildInfoRow('Room ID', room.roomId),
            _buildInfoRow('Device ID', room.deviceId),
            _buildInfoRow('Building', room.buildingId),
            _buildInfoRow('Floor', '${room.floor}'),
            _buildInfoRow(
              'Last Updated',
              DateFormat('MMM dd, yyyy • HH:mm').format(room.lastUpdated),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPowerCard(BuildContext context, RoomModel room, DashboardProvider provider) {
    return PowerControlCard(
      title: 'Classroom Power',
      status: room.powerStatus,
      onToggle: () {
        provider.toggleRoomPower(room.roomId);
      },
    );
  }

  Widget _buildDeviceControls(BuildContext context, RoomModel room, DashboardProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Controls',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildDeviceControlRow(
              context,
              'Lights',
              Icons.lightbulb,
              room.lightsStatus,
              () {
                _toggleDevice(room, RoomSubDevice.lights, provider);
              },
            ),
            const Divider(),
            _buildDeviceControlRow(
              context,
              'Fans',
              Icons.air,
              room.fansStatus,
              () {
                _toggleDevice(room, RoomSubDevice.fans, provider);
              },
            ),
            const Divider(),
            _buildDeviceControlRow(
              context,
              'Projector',
              Icons.videocam,
              room.projectorStatus,
              () {
                _toggleDevice(room, RoomSubDevice.projector, provider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceControlRow(
    BuildContext context,
    String label,
    IconData icon,
    PowerStatus status,
    VoidCallback onToggle,
  ) {
    final isOn = status == PowerStatus.on;

    return ListTile(
      leading: Icon(
        icon,
        color: isOn ? AppTheme.successColor : AppTheme.textHint,
      ),
      title: Text(label),
      trailing: Switch(
        value: isOn,
        onChanged: (_) {
          onToggle();
        },
      ),
    );
  }

  Future<void> _toggleDevice(
    RoomModel room,
    RoomSubDevice device,
    DashboardProvider provider,
  ) async {
    await provider.toggleRoomSubDevice(room.roomId, device);
  }

  Widget _buildEnergySection(BuildContext context, RoomModel room) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy Usage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildEnergyRow(
              'Current Usage',
              '${room.estimatedEnergyUsage.toStringAsFixed(1)} kWh',
              Icons.bolt,
            ),
            _buildEnergyRow(
              'Total ON Time',
              '${room.totalOnTime.inHours}h ${room.totalOnTime.inMinutes % 60}m',
              Icons.access_time,
            ),
            _buildEnergyRow(
              'Estimated Daily',
              '${(room.estimatedEnergyUsage * 8).toStringAsFixed(1)} kWh',
              Icons.today,
            ),
            _buildEnergyRow(
              'Estimated Monthly',
              '${(room.estimatedEnergyUsage * 8 * 22).toStringAsFixed(1)} kWh',
              Icons.calendar_month,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Text(label),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          const Text(
            '(Est.)',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context, RoomModel room) {
    final activities = MockDataProvider.getActivityLogs()
        .where((log) => log.targetId == room.roomId)
        .take(5)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            if (activities.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppTheme.spacingMedium),
                child: Text(
                  'No recent activity',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              )
            else
              ...activities.map((activity) => _buildActivityTile(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(ActivityLogModel activity) {
    return ListTile(
      dense: true,
      leading: const CircleAvatar(
        radius: 16,
        child: Icon(Icons.person, size: 16),
      ),
      title: Text(activity.userName),
      subtitle: Text(_getActionText(activity.action)),
      trailing: Text(
        DateFormat('HH:mm').format(activity.timestamp),
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  String _getActionText(ActionType action) {
    switch (action) {
      case ActionType.turnOn:
        return 'Turned ON power';
      case ActionType.turnOff:
        return 'Turned OFF power';
      case ActionType.emergencyShutdown:
        return 'Emergency shutdown';
      case ActionType.buildingShutdown:
        return 'Building shutdown';
      case ActionType.scheduledShutdown:
        return 'Scheduled shutdown';
      case ActionType.deviceOffline:
        return 'Device went offline';
      case ActionType.deviceOnline:
        return 'Device came online';
      case ActionType.other:
        return 'Other action';
    }
  }
}
