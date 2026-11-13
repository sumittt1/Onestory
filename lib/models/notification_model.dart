enum NotificationType {
  deviceOffline,
  deviceOnline,
  classroomLeftOn,
  energyAlert,
  scheduledShutdown,
  systemAlert,
  other,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String? targetId;
  final DateTime timestamp;
  final bool isRead;
  final bool isUrgent;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.targetId,
    required this.timestamp,
    required this.isRead,
    required this.isUrgent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.other,
      ),
      targetId: json['targetId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
      isUrgent: json['isUrgent'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'targetId': targetId,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isUrgent': isUrgent,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? targetId,
    DateTime? timestamp,
    bool? isRead,
    bool? isUrgent,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }
}
