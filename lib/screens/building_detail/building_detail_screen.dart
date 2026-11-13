import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../state/dashboard_provider.dart';
import '../../widgets/common/widgets.dart';

class BuildingDetailScreen extends StatefulWidget {
  final String buildingId;

  const BuildingDetailScreen({
    super.key,
    required this.buildingId,
  });

  @override
  State<BuildingDetailScreen> createState() => _BuildingDetailScreenState();
}

class _BuildingDetailScreenState extends State<BuildingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          final building = provider.buildings.firstWhere(
            (b) => b.buildingId == widget.buildingId,
            orElse: () => provider.buildings.first,
          );

          final buildingRooms = provider.rooms
              .where((r) => r.buildingId == widget.buildingId)
              .toList();

          return Column(
            children: [
              AppHeader(
                title: building.buildingName,
                subtitle: 'Building ID: ${building.buildingId}',
                showBackButton: true,
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildingOverviewCard(context, building),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildFloorOverview(context, buildingRooms),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildEnergySummary(context, building),
                      const SizedBox(height: AppTheme.spacingLarge),
                      _buildQuickActions(context, building, provider),
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

  Widget _buildingOverviewCard(BuildContext context, BuildingModel building) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Building Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOverviewStat('Total Rooms', '${building.totalRooms}', Icons.class_),
                _buildOverviewStat('Rooms ON', '${building.roomsOn}', Icons.power_settings_new, AppTheme.successColor),
                _buildOverviewStat('Rooms OFF', '${building.roomsOff}', Icons.power_off, AppTheme.errorColor),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOverviewStat('Online', '${building.onlineDevices}', Icons.wifi, AppTheme.successColor),
                _buildOverviewStat('Offline', '${building.offlineDevices}', Icons.wifi_off, AppTheme.errorColor),
                _buildOverviewStat('Floors', '${building.floors.length}', Icons.layers),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, IconData icon, [Color? color]) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color ?? AppTheme.primaryColor),
        const SizedBox(height: AppTheme.spacingXSmall),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color ?? AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFloorOverview(BuildContext context, List<RoomModel> rooms) {
    final floors = rooms.map((r) => r.floor).toSet().toList()..sort();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Floor Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            ...floors.map((floor) {
              final floorRooms = rooms.where((r) => r.floor == floor).toList();
              return _buildFloorCard(context, floor, floorRooms);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorCard(BuildContext context, int floor, List<RoomModel> rooms) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Floor $floor',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Wrap(
            spacing: AppTheme.spacingSmall,
            runSpacing: AppTheme.spacingSmall,
            children: rooms.map((room) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSmall,
                  vertical: AppTheme.spacingXSmall,
                ),
                decoration: BoxDecoration(
                  color: room.powerStatus == PowerStatus.on
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  border: Border.all(
                    color: room.powerStatus == PowerStatus.on
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: room.powerStatus == PowerStatus.on
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      room.roomName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: room.powerStatus == PowerStatus.on
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergySummary(BuildContext context, BuildingModel building) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMedium),
            _buildEnergyRow('Estimated Usage', '${building.estimatedEnergyUsage.toStringAsFixed(1)} kWh'),
            _buildEnergyRow('Rooms ON', '${building.roomsOn}'),
            _buildEnergyRow('Avg per Room', '${(building.estimatedEnergyUsage / building.totalRooms).toStringAsFixed(1)} kWh'),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, BuildingModel building, DashboardProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Wrap(
              spacing: AppTheme.spacingMedium,
              runSpacing: AppTheme.spacingMedium,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.power_off, size: 18),
                  label: const Text('Turn Off Building'),
                  onPressed: () {
                    ConfirmationDialog.show(
                      context: context,
                      title: 'Turn Off Building',
                      message: 'This will turn off all rooms in ${building.buildingName}. Are you sure?',
                      isDestructive: true,
                    ).then((confirmed) {
                      if (confirmed == true) {
                        provider.emergencyShutdown(building.buildingId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${building.buildingName} shutdown initiated')),
                        );
                      }
                    });
                  },
                ),
                ...building.floors.map((floor) {
                  return ActionChip(
                    avatar: const Icon(Icons.layers, size: 18),
                    label: Text('Floor $floor'),
                    onPressed: () {
                      ConfirmationDialog.show(
                        context: context,
                        title: 'Turn Off Floor $floor',
                        message: 'This will turn off all rooms on floor $floor. Are you sure?',
                        isDestructive: true,
                      ).then((confirmed) {
                        if (confirmed == true) {
                          provider.turnOffFloor(building.buildingId, floor);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Floor $floor shutdown initiated')),
                          );
                        }
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
