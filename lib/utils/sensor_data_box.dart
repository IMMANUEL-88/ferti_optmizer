import 'package:flutter/material.dart';

class SensorData extends StatelessWidget {
  const SensorData({
    super.key,
    required this.sensorName,
    this.sensorActualValue,
    this.sensorAvgValue,
    required this.sensorIcon,
    required this.iconColor,
  });

  final String sensorName;
  final double? sensorActualValue;
  final double? sensorAvgValue;
  final IconData sensorIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    // Create the text value based on actual and average values
    String valueText = '';
    if (sensorActualValue != null && sensorAvgValue != null) {
      valueText = '${sensorActualValue?.toInt()} / ${sensorAvgValue?.toInt()}';
    } else if (sensorActualValue != null) {
      valueText = '${sensorActualValue?.toInt()}';
    } else if (sensorAvgValue != null) {
      valueText = '${sensorAvgValue?.toInt()}';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              sensorIcon,
              color: iconColor,
            ),
            const SizedBox(
              width: 1,
            ),
            Text(
              sensorName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          valueText,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
