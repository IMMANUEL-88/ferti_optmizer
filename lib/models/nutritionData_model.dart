class NutritionDataModel {
  final String id;
  final String fieldId;
  final String soilType;
  final double phLevel;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final Map<String, double> otherNutrients;
  final DateTime timestamp;
  final String last_fertilizer;
  final String cropType;

  NutritionDataModel({
    required this.id,
    required this.fieldId,
    required this.soilType,
    required this.phLevel,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.otherNutrients,
    required this.timestamp,
    required this.last_fertilizer,
    required this.cropType,
  });

  // Factory constructor to create an instance from a JSON object
  factory NutritionDataModel.fromJson(Map<String, dynamic> json) {
    return NutritionDataModel(
      id: json['_id'],
      fieldId: json['field_id'],
      soilType: json['soil_type'],
      phLevel: (json['ph_level'] as num).toDouble(),
      nitrogen: json['nitrogen'],
      phosphorus: json['phosphorus'],
      potassium: json['potassium'],
      otherNutrients: Map<String, double>.from(json['other_nutrients']),
      timestamp: DateTime.parse(json['timestamp']),
      cropType: json['crop_type'],
      last_fertilizer: json['last_fertilizer']
    );
  }

  // Method to convert the model instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'field_id': fieldId,
      'soil_type': soilType,
      'ph_level': phLevel,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'other_nutrients': otherNutrients,
      'timestamp': timestamp.toIso8601String(),
      'crop_type': cropType,
      'last_fertilizer': last_fertilizer
    };
  }

  // You can also add methods to calculate averages for nutrients if needed.
  static Map<String, double> calculateAverageNutrients(List<NutritionDataModel> data) {
    if (data.isEmpty) {
      return {
        'avgNitrogen': 0.0,
        'avgPhosphorus': 0.0,
        'avgPotassium': 0.0,
      };
    }

    double totalNitrogen = 0.0;
    double totalPhosphorus = 0.0;
    double totalPotassium = 0.0;

    for (var item in data) {
      totalNitrogen += item.nitrogen;
      totalPhosphorus += item.phosphorus;
      totalPotassium += item.potassium;
    }

    int count = data.length;
    return {
      'avgNitrogen': totalNitrogen / count,
      'avgPhosphorus': totalPhosphorus / count,
      'avgPotassium': totalPotassium / count,
    };
  }
}
