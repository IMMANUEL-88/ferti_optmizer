import 'dart:convert';
import 'package:agri_connect/models/nutritionData_model.dart';
import 'package:agri_connect/models/weatherData_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sensorData_model.dart';
String globalMessage = '';
String ip ='https://fertiopti-hfq7.onrender.com';
class Get {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
class Api{
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }
  Future<bool> login(String email, String password) async {
    try {

      var url = Uri.parse('$ip/api/v1/auth/login');
      var body = jsonEncode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(response.body);
        if (data.containsKey('token')) {
          final prefs = await _getPrefs();
          final String token = data['token']?.toString() ?? '';
          final String userid = data['userId']?.toString() ?? '';
          final String username = data['username']?.toString() ?? '';
          final String email = data['email']?.toString() ?? '';
          final String? profileBase64 = data['profile'] as String?;

          await prefs.setString('userid', userid);
          await prefs.setString('username', username);
          await prefs.setString('email', email);
          await prefs.setString('token', token);

          if (profileBase64 != null) {
            try {
              await prefs.setString('profile', profileBase64);
              var profileBytes = base64.decode(profileBase64);
              data['profile'] = profileBytes;
            } catch (e) {
              print('Error decoding base64 profile: $e');
            }
          }

          globalMessage = '';
          return true;
        } else {
          globalMessage = 'No user data found in response';
          return false;
        }
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        globalMessage = errorData['message'] ?? 'Unknown error occurred';
        print(globalMessage);
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

}
class SensorDataService {
  final String apiUrl = "$ip/api/v1/sensor_data/getAllData";

  Future<List<SensorDataModel>> fetchSensorData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('data fetched');
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SensorDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sensor data');
    }
  }
}
class NutritionDataService {
  final String apiUrl = "$ip/api/v1/sensor_data/getAllNutritionData";

  Future<List<NutritionDataModel>> fetchSensorData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('data fetched');
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => NutritionDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sensor data');
    }
  }
}
class WeatherDataService {
  final String apiUrl = "$ip/api/v1/weather_data/getAllWeatherData";

  Future<List<WeatherDataModel>> fetchSensorData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('data fetched');
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => WeatherDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sensor data');
    }
  }
}