class BuildingModel {
  final String buildingId;
  final String buildingName;
  final int totalRooms;
  final int roomsOn;
  final int roomsOff;
  final int onlineDevices;
  final int offlineDevices;
  final double estimatedEnergyUsage;
  final List<int> floors;

  BuildingModel({
    required this.buildingId,
    required this.buildingName,
    required this.totalRooms,
    required this.roomsOn,
    required this.roomsOff,
    required this.onlineDevices,
    required this.offlineDevices,
    required this.estimatedEnergyUsage,
    required this.floors,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      buildingId: json['buildingId'] as String,
      buildingName: json['buildingName'] as String,
      totalRooms: json['totalRooms'] as int,
      roomsOn: json['roomsOn'] as int,
      roomsOff: json['roomsOff'] as int,
      onlineDevices: json['onlineDevices'] as int,
      offlineDevices: json['offlineDevices'] as int,
      estimatedEnergyUsage: (json['estimatedEnergyUsage'] as num).toDouble(),
      floors: List<int>.from(json['floors'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildingId': buildingId,
      'buildingName': buildingName,
      'totalRooms': totalRooms,
      'roomsOn': roomsOn,
      'roomsOff': roomsOff,
      'onlineDevices': onlineDevices,
      'offlineDevices': offlineDevices,
      'estimatedEnergyUsage': estimatedEnergyUsage,
      'floors': floors,
    };
  }

  BuildingModel copyWith({
    String? buildingId,
    String? buildingName,
    int? totalRooms,
    int? roomsOn,
    int? roomsOff,
    int? onlineDevices,
    int? offlineDevices,
    double? estimatedEnergyUsage,
    List<int>? floors,
  }) {
    return BuildingModel(
      buildingId: buildingId ?? this.buildingId,
      buildingName: buildingName ?? this.buildingName,
      totalRooms: totalRooms ?? this.totalRooms,
      roomsOn: roomsOn ?? this.roomsOn,
      roomsOff: roomsOff ?? this.roomsOff,
      onlineDevices: onlineDevices ?? this.onlineDevices,
      offlineDevices: offlineDevices ?? this.offlineDevices,
      estimatedEnergyUsage: estimatedEnergyUsage ?? this.estimatedEnergyUsage,
      floors: floors ?? this.floors,
    );
  }
}
