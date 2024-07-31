import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://lab.pixel6.co/api';

  static Future<Map<String, dynamic>> verifyPan(String pan) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-pan.php'),
      body: json.encode({'panNumber': pan}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to verify PAN');
    }
  }

  static Future<Map<String, dynamic>> getPostcodeDetails(
      String postcode) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/get-postcode-details.php'),
      body: json.encode({'postcode': postcode}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get postcode details');
    }
  }
}
