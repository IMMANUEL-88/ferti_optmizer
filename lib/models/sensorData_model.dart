class SensorDataModel {
  final String sensorId;
  final String fieldId;
  final double soilMoisture;
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  SensorDataModel({
    required this.sensorId,
    required this.fieldId,
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      sensorId: json['sensor_id'],
      fieldId: json['field_id'],
      soilMoisture: (json['soil_moisture'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  static Map<String, double> calculateDailyAverages(List<SensorDataModel> data) {
    if (data.isEmpty) {
      return {
        'avgSoilMoisture': 0.0,
        'avgTemperature': 0.0,
        'avgHumidity': 0.0,
      };
    }

    double totalSoilMoisture = 0.0;
    double totalTemperature = 0.0;
    double totalHumidity = 0.0;

    for (var item in data) {
      totalSoilMoisture += item.soilMoisture;
      totalTemperature += item.temperature;
      totalHumidity += item.humidity;
    }

    int count = data.length;
    return {
      'avgSoilMoisture': totalSoilMoisture / count,
      'avgTemperature': totalTemperature / count,
      'avgHumidity': totalHumidity / count,
    };
  }
}