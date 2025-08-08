import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = "https://fertiopti-python-dfpx.onrender.com";
class Get {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class MlApi {


  Future<void> trainMl() async {
    final url = Uri.parse('$apiUrl/train');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Model trained successfully');
      } else {
        print('Failed to train model. Status code: ${response.statusCode}');
        throw Exception('Failed to train model');
      }
    } catch (e) {
      print('Error during training: $e');
      throw Exception('Error during training');
    }
  }

  // Method to get predictions from the ML model
  Future<Map<String, dynamic>> mlPredict() async {
    final url = Uri.parse('$apiUrl/predict');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Prediction fetched successfully');

        // Decode the JSON response
        final Map<String, dynamic> data = json.decode(response.body);

        // Extracting data from the response
        if (data.containsKey('Fertilizer') && data.containsKey('NPK_values_needed')) {
          String fertilizer = data['Fertilizer'];
          List<List<double>> npkValues = List<List<double>>.from(
            data['NPK_values_needed'].map(
                    (item) => List<double>.from(item)
            ),
          );

          // Prepare the response to be returned
          return {
            'Fertilizer': fertilizer,
            'NPK_values_needed': npkValues,
          };
        } else {
          throw Exception('Unexpected response structure');
        }
      } else {
        print('Failed to fetch prediction. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch prediction');
      }
    } catch (e) {
      print('Error during prediction: $e');
      throw Exception('Error during prediction');
    }
  }
}
class Gemini {
  Future<String> makeApiRequest(String Question) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      return 'API key is missing';
    }
    // else {print('API KEY: $apiKey'); }

    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': Question}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // print(response.body);
        // Adjust this according to the actual response structure
        final extractedText = responseBody['candidates']?[0]['content']?['parts']?[0]['text'] ?? 'No text found in response';
        return extractedText;
      } else {
        return 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      return 'Request failed with error: $e';
    }
  }
 
  Future<String> makeApiRequestForRecommendations(String Question) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      return 'API key is missing';
    }
    // else {print('API KEY: $apiKey'); }

    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': Question}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // print(response.body);
        // Adjust this according to the actual response structure
        final extractedText = responseBody['candidates']?[0]['content']?['parts']?[0]['text'] ?? 'No text found in response';
        return extractedText;
      } else {
        return 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      return 'Request failed with error: $e';
    }
  }
}
class Irrigation{
  Future<String> fetchMotorStatus() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/motor_status'));

      if (response.statusCode == 200) {
        // Successfully retrieved motor status
        final responseData = jsonDecode(response.body);
        print('Motor status: ${responseData['motor_status']}');

        // Return true if motor status is 'ON', else return false
        return responseData['motor_status'];
      } else {
        // Handle error responses
        print('Failed to fetch motor status: ${response.body}');
        return 'OFF';
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred: $e');
      return "OFF"; // Return false in case of an exception
    }
  }
  Future<void> updateMotorStatusON() async {

    // Create the request body
    final Map<String, dynamic> requestBody = {
      'motor_status': 'ON',
      'control': "user",
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/motor'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(requestBody), // Convert the request body to JSON
      );

      if (response.statusCode == 201) {
        // Successfully inserted
        final responseData = jsonDecode(response.body);
        print('Motor status inserted: ${responseData['data']}');
      } else if (response.statusCode == 400) {
        // Motor status already exists or invalid
        final errorData = jsonDecode(response.body);
        print('Error: ${errorData['error']}');
      } else {
        // Other errors
        print('Failed to update motor status: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred: $e');
    }
  }
  Future<void> updateMotorStatusOFF() async {

    // Create the request body
    final Map<String, dynamic> requestBody = {
      'motor_status': 'OFF',
      'control': "user",
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/motor'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(requestBody), // Convert the request body to JSON
      );

      if (response.statusCode == 201) {
        // Successfully inserted
        final responseData = jsonDecode(response.body);
        print('Motor status inserted: ${responseData['data']}');
      } else if (response.statusCode == 400) {
        // Motor status already exists or invalid
        final errorData = jsonDecode(response.body);
        print('Error: ${errorData['error']}');
      } else {
        // Other errors
        print('Failed to update motor status: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred: $e');
    }
  }
}