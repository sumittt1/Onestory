enum DeviceType {
  mainPower,
  lights,
  fans,
  projector,
  otherLoad,
}

enum PowerStatus {
  on,
  off,
}

enum OnlineStatus {
  online,
  offline,
}

class DeviceModel {
  final String deviceId;
  final String roomId;
  final DeviceType deviceType;
  final PowerStatus powerStatus;
  final OnlineStatus onlineStatus;
  final DateTime lastUpdated;

  DeviceModel({
    required this.deviceId,
    required this.roomId,
    required this.deviceType,
    required this.powerStatus,
    required this.onlineStatus,
    required this.lastUpdated,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId'] as String,
      roomId: json['roomId'] as String,
      deviceType: DeviceType.values.firstWhere(
        (e) => e.name == json['deviceType'],
        orElse: () => DeviceType.otherLoad,
      ),
      powerStatus: PowerStatus.values.firstWhere(
        (e) => e.name == json['powerStatus'],
        orElse: () => PowerStatus.off,
      ),
      onlineStatus: OnlineStatus.values.firstWhere(
        (e) => e.name == json['onlineStatus'],
        orElse: () => OnlineStatus.offline,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'roomId': roomId,
      'deviceType': deviceType.name,
      'powerStatus': powerStatus.name,
      'onlineStatus': onlineStatus.name,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  DeviceModel copyWith({
    String? deviceId,
    String? roomId,
    DeviceType? deviceType,
    PowerStatus? powerStatus,
    OnlineStatus? onlineStatus,
    DateTime? lastUpdated,
  }) {
    return DeviceModel(
      deviceId: deviceId ?? this.deviceId,
      roomId: roomId ?? this.roomId,
      deviceType: deviceType ?? this.deviceType,
      powerStatus: powerStatus ?? this.powerStatus,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
