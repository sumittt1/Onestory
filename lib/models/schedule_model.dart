enum ScheduleRepeat {
  none,
  daily,
  weekly,
  weekend,
  weekdays,
}

class ScheduleModel {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String assignedZone;
  final ScheduleRepeat repeat;
  final bool isEnabled;
  final String? description;

  ScheduleModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.assignedZone,
    required this.repeat,
    required this.isEnabled,
    this.description,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      assignedZone: json['assignedZone'] as String,
      repeat: ScheduleRepeat.values.firstWhere(
        (e) => e.name == json['repeat'],
        orElse: () => ScheduleRepeat.none,
      ),
      isEnabled: json['isEnabled'] as bool,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'assignedZone': assignedZone,
      'repeat': repeat.name,
      'isEnabled': isEnabled,
      'description': description,
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    String? assignedZone,
    ScheduleRepeat? repeat,
    bool? isEnabled,
    String? description,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      assignedZone: assignedZone ?? this.assignedZone,
      repeat: repeat ?? this.repeat,
      isEnabled: isEnabled ?? this.isEnabled,
      description: description ?? this.description,
    );
  }
}
