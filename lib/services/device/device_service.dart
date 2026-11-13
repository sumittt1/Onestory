import '../../models/models.dart';

enum RoomSubDevice { lights, fans, projector }

abstract class DeviceService {
  Future<void> turnOnRoom(String roomId);
  Future<void> turnOffRoom(String roomId);
  Future<void> turnOnDevice(String deviceId);
  Future<void> turnOffDevice(String deviceId);
  Future<RoomModel?> getRoomStatus(String roomId);
  Future<DeviceModel?> getDeviceStatus(String deviceId);
  Future<List<RoomModel>> getAllRooms();
  Future<List<BuildingModel>> getAllBuildings();
  Stream<RoomModel> watchRoomStatus(String roomId);
  Stream<DeviceModel> watchDeviceStatus(String deviceId);
  Future<void> emergencyShutdown(String buildingId);
  Future<void> turnOffFloor(String buildingId, int floor);
  Future<void> toggleRoomSubDevice(String roomId, RoomSubDevice device);
}
