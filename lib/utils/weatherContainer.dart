import 'package:agri_connect/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package


class WeatherIcon extends StatelessWidget {
  const WeatherIcon({
    super.key,
    required this.time,
    required this.temp,
    required this.weatherCode,
  });

  final int weatherCode;
  final String time;
  final double? temp; // Make temp nullable

  // Define the asset maps as instance variables
  static const Map<int, String> weatherCodeToDayAsset = {
    0: EImages.clearsky,
    1: EImages.mainlyclear,
    2: EImages.partlycloudy,
    3: EImages.overcast,
    45: EImages.fog,
    51: EImages.lightrain,
    53: EImages.moderaterain,
    55: EImages.heavyrain,
    61: EImages.showers,
    63: EImages.thunderstorm,
    80: EImages.snowflurries,
    81: EImages.lightsnow,
    82: EImages.moderatesnow,
    85: EImages.heavysnow,
    90: EImages.heavysnow,
    95: EImages.heavysnow, // Add all relevant weather codes here
  };

  static const Map<int, String> weatherCodeToNightAsset = {
    0: EImages.clearskynight,
    1: EImages.mainlyclear,
    2: EImages.partlycloudynight,
    3: EImages.overcast,
    45: EImages.fog,
    51: EImages.lightrainnight,
    53: EImages.moderaterainnight,
    55: EImages.heavyrain,
    61: EImages.showers,
    63: EImages.thunderstorm,
    80: EImages.snowflurries,
    81: EImages.lightsnow,
    82: EImages.moderatesnow,
    85: EImages.heavysnow,
    90: EImages.heavysnow,
    95: EImages.heavysnow, // Add all relevant weather codes here
  };

  @override
  Widget build(BuildContext context) {
    // Determine the correct asset based on weather code and time
    final asset = _getAssetBasedOnTime(weatherCode, time);

    return Container(
      height: 130,
      width: 92,
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white60, fontSize: 12),
            ),
            SizedBox(height: 52, child: Lottie.asset(asset)),
            temp != null
                ? Text(
              '${temp!.toStringAsFixed(1)}°C', // Display temperature
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            )
                : Shimmer.fromColors(
              baseColor: Colors.white54,
              highlightColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white54,
                ),
                width: 50,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine the appropriate asset
  String _getAssetBasedOnTime(int weatherCode, String time) {
    // Define the start and end times for night
    const nightStart = TimeOfDay(hour: 19, minute: 0); // 07:00 PM
    const nightEnd = TimeOfDay(hour: 5, minute: 0); // 05:00 AM

    // Parse the provided time string to TimeOfDay
    final parsedTime = _parseTimeOfDay(time);

    // Check if the parsed time falls within the night range
    if ((parsedTime.hour >= nightStart.hour || parsedTime.hour < nightEnd.hour)) {
      return weatherCodeToNightAsset[weatherCode] ?? EImages.loader; // Nighttime assets
    } else {
      return weatherCodeToDayAsset[weatherCode] ?? EImages.loader; // Daytime assets
    }
  }

  // Helper function to parse time string into TimeOfDay
  TimeOfDay _parseTimeOfDay(String time) {
    final timeParts = time.split(' ');
    final timeNumbers = timeParts[0].split(':');
    int hour = int.parse(timeNumbers[0]);
    final minute = int.parse(timeNumbers[1]);

    // Adjust for AM/PM
    if (timeParts[1] == 'PM' && hour != 12) hour += 12;
    if (timeParts[1] == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }
}