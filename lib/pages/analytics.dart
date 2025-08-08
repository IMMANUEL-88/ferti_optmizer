// import 'package:agri_connect/models/sensorData_model.dart';
// import 'package:agri_connect/providers/analyticsProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';

// class AnalyticsPage extends ConsumerWidget {
//   const AnalyticsPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final sensorDataList = ref.watch(sensorDataProvider); // Watch the sensor data provider

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       appBar: AppBar(
//         title: Text('Sensor Data Analytics', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
//       ),
//       body: sensorDataList.isEmpty
//           ? const Center(child: Text("No data available for today."))
//           : LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth > 800) {
//             // Web/Desktop Layout
//             return Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: _buildPieChart(sensorDataList),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: _buildSummary(sensorDataList),
//                 ),
//               ],
//             );
//           } else {
//             // Mobile Layout
//             return Column(
//               children: [
//                 Expanded(child: _buildPieChart(sensorDataList)),
//                 _buildSummary(sensorDataList),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildPieChart(List<SensorDataModel> data) {
//     final totalSoilMoisture = data.fold(0.0, (sum, item) => sum + item.soilMoisture);
//     final totalTemperature = data.fold(0.0, (sum, item) => sum + item.temperature);
//     final totalHumidity = data.fold(0.0, (sum, item) => sum + item.humidity);
//     final totalValues = totalSoilMoisture + totalTemperature + totalHumidity;

//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: PieChart(
//         PieChartData(
//           sections: [
//             PieChartSectionData(
//               value: (totalSoilMoisture / totalValues) * 100,
//               color: const Color(0xFFC8E6C9),
//               title: 'Soil Moisture\n${(totalSoilMoisture / totalValues * 100).toStringAsFixed(1)}%',
//               radius: 100,
//               titleStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             PieChartSectionData(
//               value: (totalTemperature / totalValues) * 100,
//               color: const Color(0xFFFFF9C4),
//               title: 'Temperature\n${(totalTemperature / totalValues * 100).toStringAsFixed(1)}%',
//               radius: 100,
//               titleStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             PieChartSectionData(
//               value: (totalHumidity / totalValues) * 100,
//               color: const Color(0xFFE0F7FA),
//               title: 'Humidity\n${(totalHumidity / totalValues * 100).toStringAsFixed(1)}%',
//               radius: 100,
//               titleStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//           sectionsSpace: 4, // Add spacing between the sections
//           centerSpaceRadius: 50, // Set a center space radius
//         ),
//       ),
//     );
//   }

//   Widget _buildSummary(List<SensorDataModel> data) {
//     if (data.isEmpty) {
//       return const Center(child: Text("No data available to summarize."));
//     }

//     final averages = SensorDataModel.calculateDailyAverages(data);
//     SensorDataModel latestData = data.last;

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Summary for Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           _buildSummaryRow("Soil Moisture", latestData.soilMoisture.toStringAsFixed(2), averages['avgSoilMoisture']!.toStringAsFixed(2), const Color(0xFFC8E6C9)),
//           _buildSummaryRow("Temperature", latestData.temperature.toStringAsFixed(2), averages['avgTemperature']!.toStringAsFixed(2), const Color(0xFFFFF9C4)),
//           _buildSummaryRow("Humidity", latestData.humidity.toStringAsFixed(2), averages['avgHumidity']!.toStringAsFixed(2), const Color(0xFFE0F7FA)),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String label, String currentValue, String avgValue, Color color) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 16)),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Row(
//             children: [
//               Text(
//                 "$currentValue / $avgValue",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
