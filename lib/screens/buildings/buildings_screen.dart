import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/responsive/breakpoints.dart';
import '../../models/models.dart';
import '../../state/dashboard_provider.dart';
import '../../widgets/common/widgets.dart';

class BuildingsScreen extends StatefulWidget {
  const BuildingsScreen({super.key});

  @override
  State<BuildingsScreen> createState() => _BuildingsScreenState();
}

class _BuildingsScreenState extends State<BuildingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 2,
      title: 'Buildings',
      subtitle: 'Manage building-level controls',
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingState(message: 'Loading buildings...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: _buildBuildingsGrid(context, provider.buildings, provider),
          );
        },
      ),
    );
  }

  Widget _buildBuildingsGrid(BuildContext context, List<BuildingModel> buildings, DashboardProvider provider) {
    final crossAxisCount = Breakpoints.isMobile(context) ? 1 : (Breakpoints.isTablet(context) ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppTheme.spacingMedium,
        crossAxisSpacing: AppTheme.spacingMedium,
        childAspectRatio: 1.5,
      ),
      itemCount: buildings.length,
      itemBuilder: (context, index) {
        final building = buildings[index];
        return _buildBuildingCard(context, building, provider);
      },
    );
  }

  Widget _buildBuildingCard(BuildContext context, BuildingModel building, DashboardProvider provider) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '${AppRoutes.buildingDetail}/${building.buildingId}');
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.business,
                    size: 32,
                    color: AppTheme.primaryColor,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSmall,
                      vertical: AppTheme.spacingXSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: Text(
                      building.buildingId,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Text(
                building.buildingName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Row(
                children: [
                  _buildStatItem('Total', '${building.totalRooms}'),
                  const SizedBox(width: AppTheme.spacingMedium),
                  _buildStatItem('ON', '${building.roomsOn}', AppTheme.successColor),
                  const SizedBox(width: AppTheme.spacingMedium),
                  _buildStatItem('OFF', '${building.roomsOff}', AppTheme.errorColor),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Row(
                children: [
                  Icon(Icons.wifi, size: 16, color: AppTheme.successColor),
                  const SizedBox(width: 4),
                  Text(
                    '${building.onlineDevices} Online',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Icon(Icons.wifi_off, size: 16, color: AppTheme.errorColor),
                  const SizedBox(width: 4),
                  Text(
                    '${building.offlineDevices} Offline',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${building.estimatedEnergyUsage.toStringAsFixed(1)} kWh',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Text(
                        'Estimated',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/building/${building.buildingId}');
                    },
                    child: const Text('View'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
