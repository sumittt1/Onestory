enum EnergyPeriod {
  daily,
  weekly,
  monthly,
}

class EnergyDataPoint {
  final DateTime date;
  final double usage;
  final double? estimatedSaved;

  EnergyDataPoint({
    required this.date,
    required this.usage,
    this.estimatedSaved,
  });

  factory EnergyDataPoint.fromJson(Map<String, dynamic> json) {
    return EnergyDataPoint(
      date: DateTime.parse(json['date'] as String),
      usage: (json['usage'] as num).toDouble(),
      estimatedSaved: json['estimatedSaved'] != null
          ? (json['estimatedSaved'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'usage': usage,
      'estimatedSaved': estimatedSaved,
    };
  }
}

class EnergyUsageModel {
  final String id;
  final String zoneId;
  final EnergyPeriod period;
  final List<EnergyDataPoint> dataPoints;
  final double totalUsage;
  final double totalEstimatedSaved;
  final double averageUsage;

  EnergyUsageModel({
    required this.id,
    required this.zoneId,
    required this.period,
    required this.dataPoints,
    required this.totalUsage,
    required this.totalEstimatedSaved,
    required this.averageUsage,
  });

  factory EnergyUsageModel.fromJson(Map<String, dynamic> json) {
    return EnergyUsageModel(
      id: json['id'] as String,
      zoneId: json['zoneId'] as String,
      period: EnergyPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => EnergyPeriod.daily,
      ),
      dataPoints: (json['dataPoints'] as List)
          .map((e) => EnergyDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalUsage: (json['totalUsage'] as num).toDouble(),
      totalEstimatedSaved: (json['totalEstimatedSaved'] as num).toDouble(),
      averageUsage: (json['averageUsage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zoneId': zoneId,
      'period': period.name,
      'dataPoints': dataPoints.map((e) => e.toJson()).toList(),
      'totalUsage': totalUsage,
      'totalEstimatedSaved': totalEstimatedSaved,
      'averageUsage': averageUsage,
    };
  }
}
