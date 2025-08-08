import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class SoilDataChart extends StatefulWidget {
  @override
  _SoilDataChartState createState() => _SoilDataChartState();
}

class _SoilDataChartState extends State<SoilDataChart> {
  // Simulated sensor data (same as home page)
  double _simulatedSoilMoisture = 500.0;
  double _simulatedTemperature = 25.0;
  double _simulatedHumidity = 50.0;
  Random _random = Random();
  DateTime _lastSensorUpdate = DateTime.now();
  Timer? _dataUpdateTimer;
  
  // Store historical data for the chart
  List<SensorDataModel> _sensorDataHistory = [];

  @override
  void initState() {
    super.initState();
    // Force landscape orientation on page load
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Initialize with first data point
    _generateSimulatedData();
    
    // Update data every 3 seconds (same as home page)
    _dataUpdateTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _generateSimulatedData();
    });
  }

  @override
  void dispose() {
    // Reset to system's default orientation when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _dataUpdateTimer?.cancel();
    super.dispose();
  }

  void _generateSimulatedData() {
    setState(() {
      // Small incremental changes (1-5% of range) - same as home page
      _simulatedSoilMoisture =
          (_simulatedSoilMoisture + (_random.nextDouble() * 40 - 20))
              .clamp(200.0, 1000.0);
      _simulatedTemperature =
          (_simulatedTemperature + (_random.nextDouble() * 2 - 1))
              .clamp(20.0, 40.0);
      _simulatedHumidity =
          (_simulatedHumidity + (_random.nextDouble() * 5 - 2.5))
              .clamp(30.0, 100.0);
      
      _lastSensorUpdate = DateTime.now();
      
      // Add to history (limit to 50 points for performance)
      _sensorDataHistory.add(SensorDataModel(
        sensorId: 'simulated',
        soilMoisture: _simulatedSoilMoisture,
        temperature: _simulatedTemperature,
        humidity: _simulatedHumidity,
        timestamp: _lastSensorUpdate,
        fieldId: '69',
      ));
      
      if (_sensorDataHistory.length > 50) {
        _sensorDataHistory.removeAt(0);
      }
    });
  }

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.green,
    appBar: AppBar(
      title: const Text('Live Sensor Data'),
      backgroundColor: Colors.green,
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Chart - takes full available space
          _sensorDataHistory.isNotEmpty
              ? SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    title: AxisTitle(text: 'Timestamp'),
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Value'),
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                  ),
                  series: <LineSeries<SensorDataModel, DateTime>>[
                    LineSeries<SensorDataModel, DateTime>(
                      dataSource: _sensorDataHistory,
                      xValueMapper: (SensorDataModel data, _) => data.timestamp,
                      yValueMapper: (SensorDataModel data, _) => data.soilMoisture / 10,
                      name: 'Soil Moisture',
                      color: Colors.blue,
                    ),
                    LineSeries<SensorDataModel, DateTime>(
                      dataSource: _sensorDataHistory,
                      xValueMapper: (SensorDataModel data, _) => data.timestamp,
                      yValueMapper: (SensorDataModel data, _) => data.temperature,
                      name: 'Temperature',
                      color: Colors.red,
                    ),
                    LineSeries<SensorDataModel, DateTime>(
                      dataSource: _sensorDataHistory,
                      xValueMapper: (SensorDataModel data, _) => data.timestamp,
                      yValueMapper: (SensorDataModel data, _) => data.humidity,
                      name: 'Humidity',
                      color: Colors.yellow,
                    ),
                  ],
                )
              : const Center(child: Text('No data available')),
          
          // Combined container for both legend and details in top-right
          Positioned(
            top: 8, // Below app bar
            right: 8, // Right edge of screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Legend
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          const Text('Soil Moisture (÷10)'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('Temperature (°C)'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 8),
                          const Text('Humidity (%)'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Current values
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last updated: ${DateFormat('h:mm:ss a').format(_lastSensorUpdate)}',
                        style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('Soil: ${_simulatedSoilMoisture.round()}'),
                      Text('Temp: ${_simulatedTemperature.toStringAsFixed(1)}°C'),
                      Text('Humidity: ${_simulatedHumidity.round()}%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

// SensorDataModel class (same as your home page)
class SensorDataModel {
  final String sensorId;
  final double soilMoisture;
  final double temperature;
  final double humidity;
  final DateTime timestamp;
  final String fieldId;

  SensorDataModel({
    required this.sensorId,
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
    required this.fieldId,
  });
}