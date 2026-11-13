enum ActionType {
  turnOn,
  turnOff,
  emergencyShutdown,
  buildingShutdown,
  scheduledShutdown,
  deviceOffline,
  deviceOnline,
  other,
}

class ActivityLogModel {
  final String id;
  final String userId;
  final String userName;
  final ActionType action;
  final String? targetId;
  final String? targetName;
  final String? buildingId;
  final DateTime timestamp;
  final String? notes;

  ActivityLogModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    this.targetId,
    this.targetName,
    this.buildingId,
    required this.timestamp,
    this.notes,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      action: ActionType.values.firstWhere(
        (e) => e.name == json['action'],
        orElse: () => ActionType.other,
      ),
      targetId: json['targetId'] as String?,
      targetName: json['targetName'] as String?,
      buildingId: json['buildingId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'action': action.name,
      'targetId': targetId,
      'targetName': targetName,
      'buildingId': buildingId,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }
}
