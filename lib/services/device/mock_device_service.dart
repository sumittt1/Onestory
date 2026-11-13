import 'dart:async';
import '../../models/models.dart';
import 'device_service.dart';

class MockDeviceService implements DeviceService {
  final Map<String, RoomModel> _rooms = {};
  final Map<String, BuildingModel> _buildings = {};
  final Map<String, DeviceModel> _devices = {};
  final Map<String, StreamController<RoomModel>> _roomControllers = {};
  final Map<String, StreamController<DeviceModel>> _deviceControllers = {};

  MockDeviceService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final buildings = [
      BuildingModel(
        buildingId: 'BLD-001',
        buildingName: 'Main Building',
        totalRooms: 8,
        roomsOn: 5,
        roomsOff: 3,
        onlineDevices: 8,
        offlineDevices: 0,
        estimatedEnergyUsage: 125.5,
        floors: [1, 2, 3],
      ),
      BuildingModel(
        buildingId: 'BLD-002',
        buildingName: 'Engineering Block',
        totalRooms: 10,
        roomsOn: 7,
        roomsOff: 3,
        onlineDevices: 10,
        offlineDevices: 0,
        estimatedEnergyUsage: 156.8,
        floors: [1, 2, 3, 4],
      ),
      BuildingModel(
        buildingId: 'BLD-003',
        buildingName: 'Administrative Block',
        totalRooms: 6,
        roomsOn: 4,
        roomsOff: 2,
        onlineDevices: 6,
        offlineDevices: 0,
        estimatedEnergyUsage: 89.3,
        floors: [1, 2],
      ),
      BuildingModel(
        buildingId: 'BLD-004',
        buildingName: 'Computer Science Block',
        totalRooms: 8,
        roomsOn: 6,
        roomsOff: 2,
        onlineDevices: 8,
        offlineDevices: 0,
        estimatedEnergyUsage: 134.2,
        floors: [1, 2, 3],
      ),
      BuildingModel(
        buildingId: 'BLD-005',
        buildingName: 'Library',
        totalRooms: 4,
        roomsOn: 3,
        roomsOff: 1,
        onlineDevices: 4,
        offlineDevices: 0,
        estimatedEnergyUsage: 67.8,
        floors: [1, 2],
      ),
    ];

    for (var building in buildings) {
      _buildings[building.buildingId] = building;
    }

    final rooms = [
      RoomModel(
        roomId: 'C101',
        roomName: 'C101',
        buildingId: 'BLD-001',
        floor: 1,
        deviceId: 'device-C101',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 12.5,
        totalOnTime: const Duration(hours: 6),
      ),
      RoomModel(
        roomId: 'C102',
        roomName: 'C102',
        buildingId: 'BLD-001',
        floor: 1,
        deviceId: 'device-C102',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 11.8,
        totalOnTime: const Duration(hours: 5),
      ),
      RoomModel(
        roomId: 'C103',
        roomName: 'C103',
        buildingId: 'BLD-001',
        floor: 1,
        deviceId: 'device-C103',
        powerStatus: PowerStatus.off,
        lightsStatus: PowerStatus.off,
        fansStatus: PowerStatus.off,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 0.0,
        totalOnTime: const Duration(hours: 4),
      ),
      RoomModel(
        roomId: 'C104',
        roomName: 'C104',
        buildingId: 'BLD-001',
        floor: 2,
        deviceId: 'device-C104',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.on,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 15.2,
        totalOnTime: const Duration(hours: 7),
      ),
      RoomModel(
        roomId: 'C105',
        roomName: 'C105',
        buildingId: 'BLD-001',
        floor: 2,
        deviceId: 'device-C105',
        powerStatus: PowerStatus.off,
        lightsStatus: PowerStatus.off,
        fansStatus: PowerStatus.off,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 0.0,
        totalOnTime: const Duration(hours: 3),
      ),
      RoomModel(
        roomId: 'C201',
        roomName: 'C201',
        buildingId: 'BLD-002',
        floor: 1,
        deviceId: 'device-C201',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 13.5,
        totalOnTime: const Duration(hours: 5),
      ),
      RoomModel(
        roomId: 'C202',
        roomName: 'C202',
        buildingId: 'BLD-002',
        floor: 1,
        deviceId: 'device-C202',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 14.1,
        totalOnTime: const Duration(hours: 6),
      ),
      RoomModel(
        roomId: 'Lab1',
        roomName: 'Lab 1',
        buildingId: 'BLD-002',
        floor: 2,
        deviceId: 'device-Lab1',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.on,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 18.7,
        totalOnTime: const Duration(hours: 8),
      ),
      RoomModel(
        roomId: 'Lab2',
        roomName: 'Lab 2',
        buildingId: 'BLD-002',
        floor: 2,
        deviceId: 'device-Lab2',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 17.3,
        totalOnTime: const Duration(hours: 7),
      ),
      RoomModel(
        roomId: 'Lab3',
        roomName: 'Lab 3',
        buildingId: 'BLD-002',
        floor: 3,
        deviceId: 'device-Lab3',
        powerStatus: PowerStatus.off,
        lightsStatus: PowerStatus.off,
        fansStatus: PowerStatus.off,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 0.0,
        totalOnTime: const Duration(hours: 2),
      ),
      RoomModel(
        roomId: 'A101',
        roomName: 'A101',
        buildingId: 'BLD-003',
        floor: 1,
        deviceId: 'device-A101',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 10.2,
        totalOnTime: const Duration(hours: 4),
      ),
      RoomModel(
        roomId: 'A102',
        roomName: 'A102',
        buildingId: 'BLD-003',
        floor: 1,
        deviceId: 'device-A102',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 11.5,
        totalOnTime: const Duration(hours: 5),
      ),
      RoomModel(
        roomId: 'CS101',
        roomName: 'CS101',
        buildingId: 'BLD-004',
        floor: 1,
        deviceId: 'device-CS101',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.on,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 16.8,
        totalOnTime: const Duration(hours: 7),
      ),
      RoomModel(
        roomId: 'CS102',
        roomName: 'CS102',
        buildingId: 'BLD-004',
        floor: 1,
        deviceId: 'device-CS102',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 15.4,
        totalOnTime: const Duration(hours: 6),
      ),
      RoomModel(
        roomId: 'L101',
        roomName: 'L101',
        buildingId: 'BLD-005',
        floor: 1,
        deviceId: 'device-L101',
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        projectorStatus: PowerStatus.off,
        onlineStatus: OnlineStatus.online,
        lastUpdated: DateTime.now(),
        estimatedEnergyUsage: 8.9,
        totalOnTime: const Duration(hours: 8),
      ),
    ];

    for (var room in rooms) {
      _rooms[room.roomId] = room;
      _devices[room.deviceId] = DeviceModel(
        deviceId: room.deviceId,
        roomId: room.roomId,
        deviceType: DeviceType.mainPower,
        powerStatus: room.powerStatus,
        onlineStatus: room.onlineStatus,
        lastUpdated: room.lastUpdated,
      );
    }
  }

  @override
  Future<void> turnOnRoom(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final room = _rooms[roomId];
    if (room != null) {
      final updatedRoom = room.copyWith(
        powerStatus: PowerStatus.on,
        lightsStatus: PowerStatus.on,
        fansStatus: PowerStatus.on,
        lastUpdated: DateTime.now(),
      );
      _rooms[roomId] = updatedRoom;
      _devices[room.deviceId] = _devices[room.deviceId]!.copyWith(
        powerStatus: PowerStatus.on,
        lastUpdated: DateTime.now(),
      );
      _notifyRoomUpdate(roomId, updatedRoom);
    }
  }

  @override
  Future<void> turnOffRoom(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final room = _rooms[roomId];
    if (room != null) {
      final updatedRoom = room.copyWith(
        powerStatus: PowerStatus.off,
        lightsStatus: PowerStatus.off,
        fansStatus: PowerStatus.off,
        projectorStatus: PowerStatus.off,
        lastUpdated: DateTime.now(),
      );
      _rooms[roomId] = updatedRoom;
      _devices[room.deviceId] = _devices[room.deviceId]!.copyWith(
        powerStatus: PowerStatus.off,
        lastUpdated: DateTime.now(),
      );
      _notifyRoomUpdate(roomId, updatedRoom);
    }
  }

  @override
  Future<void> turnOnDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final device = _devices[deviceId];
    if (device != null) {
      final updatedDevice = device.copyWith(
        powerStatus: PowerStatus.on,
        lastUpdated: DateTime.now(),
      );
      _devices[deviceId] = updatedDevice;
      _notifyDeviceUpdate(deviceId, updatedDevice);
    }
  }

  @override
  Future<void> turnOffDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final device = _devices[deviceId];
    if (device != null) {
      final updatedDevice = device.copyWith(
        powerStatus: PowerStatus.off,
        lastUpdated: DateTime.now(),
      );
      _devices[deviceId] = updatedDevice;
      _notifyDeviceUpdate(deviceId, updatedDevice);
    }
  }

  @override
  Future<RoomModel?> getRoomStatus(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _rooms[roomId];
  }

  @override
  Future<DeviceModel?> getDeviceStatus(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _devices[deviceId];
  }

  @override
  Future<List<RoomModel>> getAllRooms() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _rooms.values.toList();
  }

  @override
  Future<List<BuildingModel>> getAllBuildings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _buildings.values.toList();
  }

  @override
  Stream<RoomModel> watchRoomStatus(String roomId) {
    if (!_roomControllers.containsKey(roomId)) {
      _roomControllers[roomId] = StreamController<RoomModel>.broadcast();
    }
    return _roomControllers[roomId]!.stream;
  }

  @override
  Stream<DeviceModel> watchDeviceStatus(String deviceId) {
    if (!_deviceControllers.containsKey(deviceId)) {
      _deviceControllers[deviceId] = StreamController<DeviceModel>.broadcast();
    }
    return _deviceControllers[deviceId]!.stream;
  }

  @override
  Future<void> emergencyShutdown(String buildingId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    for (var room in _rooms.values) {
      if (room.buildingId == buildingId) {
        final updatedRoom = room.copyWith(
          powerStatus: PowerStatus.off,
          lightsStatus: PowerStatus.off,
          fansStatus: PowerStatus.off,
          projectorStatus: PowerStatus.off,
          lastUpdated: DateTime.now(),
        );
        _rooms[room.roomId] = updatedRoom;
        _devices[room.deviceId] = _devices[room.deviceId]!.copyWith(
          powerStatus: PowerStatus.off,
          lastUpdated: DateTime.now(),
        );
        _notifyRoomUpdate(room.roomId, updatedRoom);
      }
    }
  }

  @override
  Future<void> toggleRoomSubDevice(String roomId, RoomSubDevice device) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final room = _rooms[roomId];
    if (room == null) return;

    RoomModel updatedRoom;
    switch (device) {
      case RoomSubDevice.lights:
        final next = room.lightsStatus == PowerStatus.on
            ? PowerStatus.off
            : PowerStatus.on;
        updatedRoom = room.copyWith(
          lightsStatus: next,
          lastUpdated: DateTime.now(),
        );
      case RoomSubDevice.fans:
        final next = room.fansStatus == PowerStatus.on
            ? PowerStatus.off
            : PowerStatus.on;
        updatedRoom = room.copyWith(
          fansStatus: next,
          lastUpdated: DateTime.now(),
        );
      case RoomSubDevice.projector:
        final next = room.projectorStatus == PowerStatus.on
            ? PowerStatus.off
            : PowerStatus.on;
        updatedRoom = room.copyWith(
          projectorStatus: next,
          lastUpdated: DateTime.now(),
        );
    }

    _rooms[roomId] = updatedRoom;
    _notifyRoomUpdate(roomId, updatedRoom);
  }

  @override
  Future<void> turnOffFloor(String buildingId, int floor) async {
    await Future.delayed(const Duration(milliseconds: 600));
    for (var room in _rooms.values) {
      if (room.buildingId == buildingId && room.floor == floor) {
        final updatedRoom = room.copyWith(
          powerStatus: PowerStatus.off,
          lightsStatus: PowerStatus.off,
          fansStatus: PowerStatus.off,
          projectorStatus: PowerStatus.off,
          lastUpdated: DateTime.now(),
        );
        _rooms[room.roomId] = updatedRoom;
        _devices[room.deviceId] = _devices[room.deviceId]!.copyWith(
          powerStatus: PowerStatus.off,
          lastUpdated: DateTime.now(),
        );
        _notifyRoomUpdate(room.roomId, updatedRoom);
      }
    }
  }

  void _notifyRoomUpdate(String roomId, RoomModel room) {
    if (_roomControllers.containsKey(roomId)) {
      _roomControllers[roomId]!.add(room);
    }
  }

  void _notifyDeviceUpdate(String deviceId, DeviceModel device) {
    if (_deviceControllers.containsKey(deviceId)) {
      _deviceControllers[deviceId]!.add(device);
    }
  }

  void dispose() {
    for (var controller in _roomControllers.values) {
      controller.close();
    }
    for (var controller in _deviceControllers.values) {
      controller.close();
    }
  }
}
