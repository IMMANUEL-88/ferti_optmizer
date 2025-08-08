import 'dart:async';
import 'package:agri_connect/API/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_connect/models/sensorData_model.dart';

class SensorDataNotifier extends StateNotifier<List<SensorDataModel>> {
  Timer? _timer;

  SensorDataNotifier() : super([]) {
    _fetchDataContinuously();
  }

  // Fetch data periodically and append only today's data
  void _fetchDataContinuously() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final newData = await SensorDataService().fetchSensorData(); // Fetch new sensor data
        if (newData.isNotEmpty) {
          final todayData = _filterTodayData(newData);
          state = [...state, ...todayData];
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    });
  }

  // Filter out data that is not from today's date
  List<SensorDataModel> _filterTodayData(List<SensorDataModel> data) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return data.where((sensorData) {
      final dataDate = DateTime(sensorData.timestamp.year, sensorData.timestamp.month, sensorData.timestamp.day);
      return dataDate == today; // Only include data from today
    }).toList();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure the timer is canceled when not needed
    super.dispose();
  }
}

// Provider with autoDispose to stop API calls on page exit
final sensorDataProvider = StateNotifierProvider.autoDispose<SensorDataNotifier, List<SensorDataModel>>((ref) {
  final notifier = SensorDataNotifier();
  ref.onDispose(() {
    notifier.dispose();  // Dispose resources when the page is left
  });
  return notifier;
});
