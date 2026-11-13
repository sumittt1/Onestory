import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/responsive/breakpoints.dart';
import '../../models/models.dart';
import '../../state/dashboard_provider.dart';
import '../../widgets/common/widgets.dart';

class ClassroomsScreen extends StatefulWidget {
  const ClassroomsScreen({super.key});

  @override
  State<ClassroomsScreen> createState() => _ClassroomsScreenState();
}

class _ClassroomsScreenState extends State<ClassroomsScreen> {
  final _searchController = TextEditingController();
  String _selectedBuilding = 'All';
  int _selectedFloor = 0;
  PowerStatus? _selectedPowerStatus;
  OnlineStatus? _selectedOnlineStatus;
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 1,
      title: 'Classrooms',
      subtitle: 'Manage classroom power and devices',
      headerActions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
          tooltip: _isGridView ? 'List View' : 'Grid View',
        ),
      ],
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingState(message: 'Loading classrooms...');
          }

          final filteredRooms = _filterRooms(provider.rooms);
          final buildings = provider.buildings;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              children: [
                _buildFilters(context, buildings),
                const SizedBox(height: AppTheme.spacingMedium),
                if (filteredRooms.isEmpty)
                  const EmptyState(
                    title: 'No classrooms found',
                    subtitle: 'Try adjusting your filters',
                    icon: Icons.search_off,
                  )
                else if (_isGridView)
                  _buildGridView(context, filteredRooms, provider)
                else
                  _buildListView(context, filteredRooms, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context, List<BuildingModel> buildings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search classrooms',
                hintText: 'Enter room name or ID',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Wrap(
              spacing: AppTheme.spacingMedium,
              runSpacing: AppTheme.spacingMedium,
              children: [
                DropdownButton<String>(
                  value: _selectedBuilding,
                  items: [
                    const DropdownMenuItem(value: 'All', child: Text('All Buildings')),
                    ...buildings.map((b) => DropdownMenuItem(
                      value: b.buildingId,
                      child: Text(b.buildingName),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedBuilding = value!;
                    });
                  },
                ),
                DropdownButton<int>(
                  value: _selectedFloor,
                  items: [
                    const DropdownMenuItem(value: 0, child: Text('All Floors')),
                    const DropdownMenuItem(value: 1, child: Text('Floor 1')),
                    const DropdownMenuItem(value: 2, child: Text('Floor 2')),
                    const DropdownMenuItem(value: 3, child: Text('Floor 3')),
                    const DropdownMenuItem(value: 4, child: Text('Floor 4')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFloor = value!;
                    });
                  },
                ),
                DropdownButton<PowerStatus?>(
                  value: _selectedPowerStatus,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Status')),
                    const DropdownMenuItem(value: PowerStatus.on, child: Text('ON')),
                    const DropdownMenuItem(value: PowerStatus.off, child: Text('OFF')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPowerStatus = value;
                    });
                  },
                ),
                DropdownButton<OnlineStatus?>(
                  value: _selectedOnlineStatus,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Connection')),
                    const DropdownMenuItem(value: OnlineStatus.online, child: Text('Online')),
                    const DropdownMenuItem(value: OnlineStatus.offline, child: Text('Offline')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOnlineStatus = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<RoomModel> _filterRooms(List<RoomModel> rooms) {
    return rooms.where((room) {
      final searchLower = _searchController.text.toLowerCase();
      final matchesSearch = room.roomName.toLowerCase().contains(searchLower) ||
          room.roomId.toLowerCase().contains(searchLower);
      final matchesBuilding = _selectedBuilding == 'All' || room.buildingId == _selectedBuilding;
      final matchesFloor = _selectedFloor == 0 || room.floor == _selectedFloor;
      final matchesPower = _selectedPowerStatus == null || room.powerStatus == _selectedPowerStatus;
      final matchesOnline = _selectedOnlineStatus == null || room.onlineStatus == _selectedOnlineStatus;

      return matchesSearch && matchesBuilding && matchesFloor && matchesPower && matchesOnline;
    }).toList();
  }

  Widget _buildGridView(BuildContext context, List<RoomModel> rooms, DashboardProvider provider) {
    final crossAxisCount = Breakpoints.isMobile(context) ? 1 : (Breakpoints.isTablet(context) ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppTheme.spacingMedium,
        crossAxisSpacing: AppTheme.spacingMedium,
        childAspectRatio: Breakpoints.isMobile(context) ? 2.2 : 2.0,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _buildRoomCard(context, room, provider);
      },
    );
  }

  Widget _buildListView(BuildContext context, List<RoomModel> rooms, DashboardProvider provider) {
    return Column(
      children: rooms.map((room) => _buildRoomListTile(context, room, provider)).toList(),
    );
  }

  Widget _buildRoomCard(BuildContext context, RoomModel room, DashboardProvider provider) {
    final building = provider.buildings.firstWhere(
      (b) => b.buildingId == room.buildingId,
      orElse: () => provider.buildings.first,
    );

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '${AppRoutes.classroomDetail}/${room.roomId}');
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
                  _buildStatusChip('Power', room.powerStatus == PowerStatus.on),
                  const SizedBox(width: 4),
                  _buildStatusChip('Lights', room.lightsStatus == PowerStatus.on),
                  const SizedBox(width: 4),
                  _buildStatusChip('Fans', room.fansStatus == PowerStatus.on),
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

  Widget _buildRoomListTile(BuildContext context, RoomModel room, DashboardProvider provider) {
    final building = provider.buildings.firstWhere(
      (b) => b.buildingId == room.buildingId,
      orElse: () => provider.buildings.first,
    );

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '${AppRoutes.classroomDetail}/${room.roomId}');
        },
        leading: CircleAvatar(
          backgroundColor: room.powerStatus == PowerStatus.on
              ? AppTheme.successColor
              : AppTheme.errorColor,
          child: Icon(
            room.powerStatus == PowerStatus.on ? Icons.power_settings_new : Icons.power_off,
            color: Colors.white,
          ),
        ),
        title: Text(room.roomName),
        subtitle: Text('${building.buildingName} • Floor ${room.floor}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(onlineStatus: room.onlineStatus),
            const SizedBox(width: AppTheme.spacingSmall),
            IconButton(
              icon: Icon(
                room.powerStatus == PowerStatus.on ? Icons.toggle_on : Icons.toggle_off,
                color: room.powerStatus == PowerStatus.on
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
              ),
              onPressed: () {
                provider.toggleRoomPower(room.roomId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isOn) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: isOn ? AppTheme.successColor.withOpacity(0.1) : AppTheme.textHint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Text(
        '$label: ${isOn ? 'ON' : 'OFF'}',
        style: TextStyle(
          fontSize: 12,
          color: isOn ? AppTheme.successColor : AppTheme.textHint,
        ),
      ),
    );
  }
}
