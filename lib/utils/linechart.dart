import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherLineChart extends StatelessWidget {
  final List<FlSpot> weatherSpots;
  final List<IconData> weatherIcons; // Add icons list for weather representation

  WeatherLineChart({super.key, required this.weatherSpots, required this.weatherIcons});

  final List<Color> gradientColors = [Colors.red, Colors.orange];

  // Custom method to display both icon and time label at the bottom
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );

    // Mapping time periods to icons
    Icon weatherIcon;
    switch (value.toInt()) {
      case 0:
        weatherIcon = Icon(weatherIcons[0], color: Colors.white, size: 16);
        break;
      case 6:
        weatherIcon = Icon(weatherIcons[1], color: Colors.white, size: 16);
        break;
      case 12:
        weatherIcon = Icon(weatherIcons[2], color: Colors.white, size: 16);
        break;
      case 18:
        weatherIcon = Icon(weatherIcons[3], color: Colors.white, size: 16);
        break;
      case 23:
        weatherIcon = Icon(weatherIcons[4], color: Colors.white, size: 16);
        break;
      default:
        weatherIcon = const Icon(Icons.wb_sunny, color: Colors.transparent); // No icon for other times
        break;
    }

    // Time labels
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('00:00', style: style);
        break;
      case 6:
        text = const Text('06:00', style: style);
        break;
      case 12:
        text = const Text('12:00', style: style);
        break;
      case 18:
        text = const Text('18:00', style: style);
        break;
      case 23:
        text = const Text('23:00', style: style);
        break;
      default:
        text = const Text('', style: style); // Hide for unimportant values
        break;
    }

    // Stack weather icon above the time text
    return Column(
      children: [
        weatherIcon,
        const SizedBox(height: 4), // Add some spacing between icon and label
        text,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.transparent,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.transparent,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, // Reduce the interval to have more time labels
              reservedSize: 45, // Increased size to accommodate icons
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Remove left axis titles
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.transparent),
        ),
        minX: 0,
        maxX: 23,
        minY: 10,
        maxY: 40,
        lineBarsData: [
          LineChartBarData(
            spots: weatherSpots,
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, _) => true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.orange,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()}°C', // Display the temperature above each point
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
