class WeatherDataModel {
  final String id;
  final String fieldName;
  final String location;
  final double windSpeed;
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  WeatherDataModel({
    required this.id,
    required this.fieldName,
    required this.location,
    required this.windSpeed,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

    factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      id: json['id'],
      fieldName: json['field_name'],
      location: json['location'],
      windSpeed: (json['wind_speed'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}