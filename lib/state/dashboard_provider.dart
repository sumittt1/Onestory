import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

class DashboardProvider with ChangeNotifier {
  final DeviceService _deviceService;

  List<RoomModel> _rooms = [];
  List<BuildingModel> _buildings = [];
  List<ActivityLogModel> _activityLogs = [];
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  DashboardProvider(this._deviceService);

  List<RoomModel> get rooms => _rooms;
  List<BuildingModel> get buildings => _buildings;
  List<ActivityLogModel> get activityLogs => _activityLogs;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalRooms => _rooms.length;
  int get roomsOn => _rooms.where((r) => r.powerStatus == PowerStatus.on).length;
  int get roomsOff => _rooms.where((r) => r.powerStatus == PowerStatus.off).length;
  int get activeDevices =>
      _rooms.where((r) => r.powerStatus == PowerStatus.on).length;
  int get onlineDevices =>
      _rooms.where((r) => r.onlineStatus == OnlineStatus.online).length;
  int get offlineDevices =>
      _rooms.where((r) => r.onlineStatus == OnlineStatus.offline).length;
  double get totalEnergyUsage =>
      _rooms.fold(0.0, (sum, r) => sum + r.estimatedEnergyUsage);
  int get unreadNotifications => _notifications.where((n) => !n.isRead).length;

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rooms = await _deviceService.getAllRooms();
      final buildings = await _deviceService.getAllBuildings();

      _rooms = rooms;
      _buildings = buildings;
      _syncBuildingStats();
      _activityLogs = MockDataProvider.getActivityLogs();
      _notifications = MockDataProvider.getNotifications();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load dashboard data';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshRoom(String roomId) async {
    final updatedRoom = await _deviceService.getRoomStatus(roomId);
    if (updatedRoom != null) {
      final index = _rooms.indexWhere((r) => r.roomId == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
        _syncBuildingStats();
        notifyListeners();
      }
    }
  }

  void _syncBuildingStats() {
    _buildings = _buildings.map((building) {
      final buildingRooms =
          _rooms.where((r) => r.buildingId == building.buildingId).toList();
      if (buildingRooms.isEmpty) return building;

      final roomsOn =
          buildingRooms.where((r) => r.powerStatus == PowerStatus.on).length;
      final online =
          buildingRooms.where((r) => r.onlineStatus == OnlineStatus.online).length;

      return building.copyWith(
        totalRooms: buildingRooms.length,
        roomsOn: roomsOn,
        roomsOff: buildingRooms.length - roomsOn,
        onlineDevices: online,
        offlineDevices: buildingRooms.length - online,
        estimatedEnergyUsage: buildingRooms.fold<double>(
          0.0,
          (sum, r) => sum + r.estimatedEnergyUsage,
        ),
      );
    }).toList();
  }

  Future<void> toggleRoomPower(String roomId) async {
    final room = _rooms.firstWhere((r) => r.roomId == roomId);

    if (room.powerStatus == PowerStatus.on) {
      await _deviceService.turnOffRoom(roomId);
    } else {
      await _deviceService.turnOnRoom(roomId);
    }

    await _refreshRoom(roomId);
  }

  Future<void> toggleRoomSubDevice(String roomId, RoomSubDevice device) async {
    await _deviceService.toggleRoomSubDevice(roomId, device);
    await _refreshRoom(roomId);
  }

  Future<void> emergencyShutdown(String buildingId) async {
    await _deviceService.emergencyShutdown(buildingId);
    await loadData();
  }

  Future<void> turnOffFloor(String buildingId, int floor) async {
    await _deviceService.turnOffFloor(buildingId, floor);
    await loadData();
  }

  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
