import 'device_model.dart';

class RoomModel {
  final String roomId;
  final String roomName;
  final String buildingId;
  final int floor;
  final String deviceId;
  final PowerStatus powerStatus;
  final PowerStatus lightsStatus;
  final PowerStatus fansStatus;
  final PowerStatus projectorStatus;
  final OnlineStatus onlineStatus;
  final DateTime lastUpdated;
  final double estimatedEnergyUsage;
  final Duration totalOnTime;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.buildingId,
    required this.floor,
    required this.deviceId,
    required this.powerStatus,
    required this.lightsStatus,
    required this.fansStatus,
    required this.projectorStatus,
    required this.onlineStatus,
    required this.lastUpdated,
    required this.estimatedEnergyUsage,
    required this.totalOnTime,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'] as String,
      roomName: json['roomName'] as String,
      buildingId: json['buildingId'] as String,
      floor: json['floor'] as int,
      deviceId: json['deviceId'] as String,
      powerStatus: PowerStatus.values.firstWhere(
        (e) => e.name == json['powerStatus'],
        orElse: () => PowerStatus.off,
      ),
      lightsStatus: PowerStatus.values.firstWhere(
        (e) => e.name == json['lightsStatus'],
        orElse: () => PowerStatus.off,
      ),
      fansStatus: PowerStatus.values.firstWhere(
        (e) => e.name == json['fansStatus'],
        orElse: () => PowerStatus.off,
      ),
      projectorStatus: PowerStatus.values.firstWhere(
        (e) => e.name == json['projectorStatus'],
        orElse: () => PowerStatus.off,
      ),
      onlineStatus: OnlineStatus.values.firstWhere(
        (e) => e.name == json['onlineStatus'],
        orElse: () => OnlineStatus.offline,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      estimatedEnergyUsage: (json['estimatedEnergyUsage'] as num).toDouble(),
      totalOnTime: Duration(minutes: json['totalOnTimeMinutes'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'buildingId': buildingId,
      'floor': floor,
      'deviceId': deviceId,
      'powerStatus': powerStatus.name,
      'lightsStatus': lightsStatus.name,
      'fansStatus': fansStatus.name,
      'projectorStatus': projectorStatus.name,
      'onlineStatus': onlineStatus.name,
      'lastUpdated': lastUpdated.toIso8601String(),
      'estimatedEnergyUsage': estimatedEnergyUsage,
      'totalOnTimeMinutes': totalOnTime.inMinutes,
    };
  }

  RoomModel copyWith({
    String? roomId,
    String? roomName,
    String? buildingId,
    int? floor,
    String? deviceId,
    PowerStatus? powerStatus,
    PowerStatus? lightsStatus,
    PowerStatus? fansStatus,
    PowerStatus? projectorStatus,
    OnlineStatus? onlineStatus,
    DateTime? lastUpdated,
    double? estimatedEnergyUsage,
    Duration? totalOnTime,
  }) {
    return RoomModel(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      buildingId: buildingId ?? this.buildingId,
      floor: floor ?? this.floor,
      deviceId: deviceId ?? this.deviceId,
      powerStatus: powerStatus ?? this.powerStatus,
      lightsStatus: lightsStatus ?? this.lightsStatus,
      fansStatus: fansStatus ?? this.fansStatus,
      projectorStatus: projectorStatus ?? this.projectorStatus,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      estimatedEnergyUsage: estimatedEnergyUsage ?? this.estimatedEnergyUsage,
      totalOnTime: totalOnTime ?? this.totalOnTime,
    );
  }
}
