import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_navigation.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/responsive/breakpoints.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../state/dashboard_provider.dart';
import '../../widgets/common/widgets.dart';
import '../../widgets/charts/energy_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  EnergyPeriod _selectedPeriod = EnergyPeriod.daily;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      title: 'Dashboard',
      subtitle: 'Overview of campus energy management',
      body: _buildDashboardContent(context),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingState(message: 'Loading dashboard...');
        }

        if (provider.errorMessage != null) {
          return ErrorState(
            title: 'Error',
            subtitle: provider.errorMessage,
            onRetry: () => provider.loadData(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(context, provider),
              const SizedBox(height: AppTheme.spacingLarge),
              _buildEnergyChartSection(context, provider),
              const SizedBox(height: AppTheme.spacingLarge),
              _buildRoomStatusSection(context, provider),
              const SizedBox(height: AppTheme.spacingLarge),
              _buildQuickActions(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context, DashboardProvider provider) {
    final crossAxisCount = Breakpoints.isMobile(context) ? 2 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: AppTheme.spacingMedium,
      crossAxisSpacing: AppTheme.spacingMedium,
      childAspectRatio: Breakpoints.isMobile(context) ? 1.5 : 1.8,
      children: [
        StatCard(
          title: 'Total Rooms',
          value: '${provider.totalRooms}',
          icon: Icons.class_outlined,
          color: AppTheme.primaryColor,
        ),
        StatCard(
          title: 'Rooms ON',
          value: '${provider.roomsOn}',
          icon: Icons.power_settings_new,
          color: AppTheme.successColor,
        ),
        StatCard(
          title: 'Rooms OFF',
          value: '${provider.roomsOff}',
          icon: Icons.power_off,
          color: AppTheme.errorColor,
        ),
        StatCard(
          title: 'Active Devices',
          value: '${provider.activeDevices}',
          icon: Icons.devices,
          color: AppTheme.infoColor,
        ),
        StatCard(
          title: 'Est. Energy Usage',
          value: '${provider.totalEnergyUsage.toStringAsFixed(1)} kWh',
          icon: Icons.bolt,
          color: AppTheme.warningColor,
          subtitle: 'Estimated',
        ),
        StatCard(
          title: 'Online Devices',
          value: '${provider.onlineDevices}',
          icon: Icons.wifi,
          color: AppTheme.successColor,
        ),
        StatCard(
          title: 'Offline Devices',
          value: '${provider.offlineDevices}',
          icon: Icons.wifi_off,
          color: AppTheme.errorColor,
        ),
        StatCard(
          title: 'Alerts',
          value: '${provider.unreadNotifications}',
          icon: Icons.notifications,
          color: AppTheme.errorColor,
          onTap: () => AppNavigation.goToIndex(context, 7),
        ),
      ],
    );
  }

  Widget _buildEnergyChartSection(
      BuildContext context, DashboardProvider provider) {
    final energyData = MockDataProvider.getEnergyUsage();
    final selectedData = energyData.firstWhere(
      (e) => e.period == _selectedPeriod,
      orElse: () => energyData.first,
    );

    return EnergyChart(
      energyData: selectedData,
      selectedPeriod: _selectedPeriod,
      onPeriodChanged: (period) {
        setState(() {
          _selectedPeriod = period;
        });
      },
    );
  }

  Widget _buildRoomStatusSection(
      BuildContext context, DashboardProvider provider) {
    final rooms = provider.rooms.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Room Status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () => AppNavigation.goToIndex(context, 1),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Breakpoints.isMobile(context) ? 1 : 3,
            mainAxisSpacing: AppTheme.spacingMedium,
            crossAxisSpacing: AppTheme.spacingMedium,
            childAspectRatio: Breakpoints.isMobile(context) ? 2.5 : 2.0,
          ),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return _buildRoomCard(context, room, provider);
          },
        ),
      ],
    );
  }

  Widget _buildRoomCard(
      BuildContext context, RoomModel room, DashboardProvider provider) {
    final building = provider.buildings.firstWhere(
      (b) => b.buildingId == room.buildingId,
      orElse: () => provider.buildings.first,
    );

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
              context, '${AppRoutes.classroomDetail}/${room.roomId}');
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      room.roomName,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(onlineStatus: room.onlineStatus),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${building.buildingName} • F${room.floor}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.power_settings_new,
                    size: 12,
                    color: room.powerStatus == PowerStatus.on
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      room.powerStatus == PowerStatus.on ? 'ON' : 'OFF',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${room.estimatedEnergyUsage.toStringAsFixed(1)} kWh',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 24,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.toggleRoomPower(room.roomId);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        room.powerStatus == PowerStatus.on ? 'OFF' : 'ON',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, DashboardProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Wrap(
              spacing: AppTheme.spacingMedium,
              runSpacing: AppTheme.spacingMedium,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.close, size: 18),
                  label: const Text('Turn Off Floor'),
                  onPressed: () => _showFloorDialog(context, provider),
                ),
                ActionChip(
                  avatar: const Icon(Icons.business, size: 18),
                  label: const Text('Turn Off Building'),
                  onPressed: () => _showBuildingDialog(context, provider),
                ),
                ActionChip(
                  avatar: const Icon(Icons.class_, size: 18),
                  label: const Text('View All Rooms'),
                  onPressed: () => AppNavigation.goToIndex(context, 1),
                ),
                ActionChip(
                  avatar: const Icon(Icons.warning, size: 18),
                  label: const Text('Emergency Shutdown'),
                  backgroundColor: AppTheme.errorColor.withValues(alpha: 0.1),
                  onPressed: () => _showEmergencyDialog(context, provider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFloorDialog(BuildContext context, DashboardProvider provider) {
    String? selectedBuildingId =
        provider.buildings.isNotEmpty ? provider.buildings.first.buildingId : null;
    int? selectedFloor;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final building = provider.buildings.firstWhere(
            (b) => b.buildingId == selectedBuildingId,
            orElse: () => provider.buildings.first,
          );
          final floors = building.floors;

          return AlertDialog(
            title: const Text('Turn Off Floor'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedBuildingId,
                  decoration: const InputDecoration(
                    labelText: 'Select Building',
                  ),
                  items: provider.buildings.map((b) {
                    return DropdownMenuItem(
                      value: b.buildingId,
                      child: Text(b.buildingName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedBuildingId = value;
                      selectedFloor = null;
                    });
                  },
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                DropdownButtonFormField<int>(
                  value: selectedFloor,
                  decoration: const InputDecoration(
                    labelText: 'Select Floor',
                  ),
                  items: floors.map((floor) {
                    return DropdownMenuItem(
                      value: floor,
                      child: Text('Floor $floor'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedFloor = value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: selectedBuildingId != null && selectedFloor != null
                    ? () async {
                        Navigator.pop(dialogContext);
                        await provider.turnOffFloor(
                          selectedBuildingId!,
                          selectedFloor!,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Floor $selectedFloor shutdown complete',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Turn Off'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBuildingDialog(BuildContext context, DashboardProvider provider) {
    String? selectedBuildingId =
        provider.buildings.isNotEmpty ? provider.buildings.first.buildingId : null;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Turn Off Building'),
            content: DropdownButtonFormField<String>(
              value: selectedBuildingId,
              decoration: const InputDecoration(
                labelText: 'Select Building',
              ),
              items: provider.buildings.map((building) {
                return DropdownMenuItem(
                  value: building.buildingId,
                  child: Text(building.buildingName),
                );
              }).toList(),
              onChanged: (value) {
                setDialogState(() => selectedBuildingId = value);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: selectedBuildingId != null
                    ? () async {
                        final buildingId = selectedBuildingId!;
                        final name = provider.buildings
                            .firstWhere((b) => b.buildingId == buildingId)
                            .buildingName;
                        Navigator.pop(dialogContext);
                        await provider.emergencyShutdown(buildingId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name shutdown complete'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Turn Off'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context, DashboardProvider provider) {
    String? selectedBuildingId =
        provider.buildings.isNotEmpty ? provider.buildings.first.buildingId : null;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Emergency Shutdown'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This will immediately turn off all power in the selected building.',
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                DropdownButtonFormField<String>(
                  value: selectedBuildingId,
                  decoration: const InputDecoration(
                    labelText: 'Select Building',
                  ),
                  items: provider.buildings.map((building) {
                    return DropdownMenuItem(
                      value: building.buildingId,
                      child: Text(building.buildingName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedBuildingId = value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: selectedBuildingId != null
                    ? () async {
                        final buildingId = selectedBuildingId!;
                        Navigator.pop(dialogContext);
                        await provider.emergencyShutdown(buildingId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Emergency shutdown complete'),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Emergency Shutdown'),
              ),
            ],
          );
        },
      ),
    );
  }
}
