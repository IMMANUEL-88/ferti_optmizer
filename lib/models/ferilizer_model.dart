class FertilizerModel {
  String fertilizer;
  List<List<double>> npkValues;

  FertilizerModel({
    required this.fertilizer,
    required this.npkValues,
  });

  // Factory constructor to create an instance from a JSON object
  factory FertilizerModel.fromJson(Map<String, dynamic> json) {
    return FertilizerModel(
      fertilizer: json['Fertilizer'],
      npkValues: (json['NPK_values'] as List)
          .map((npk) => List<double>.from(npk.map((value) => value.toDouble())))
          .toList(),
    );
  }

  // Method to convert the model instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'Fertilizer': fertilizer,
      'NPK_values': npkValues,
    };
  }

  // Get N (Nitrogen) value
  double getN() {
    return npkValues.isNotEmpty && npkValues[0].isNotEmpty ? npkValues[0][0] : 0.0;
  }

  // Get P (Phosphorus) value
  double getP() {
    return npkValues.isNotEmpty && npkValues[0].length > 1 ? npkValues[0][1] : 0.0;
  }

  // Get K (Potassium) value
  double getK() {
    return npkValues.isNotEmpty && npkValues[0].length > 2 ? npkValues[0][2] : 0.0;
  }
}
