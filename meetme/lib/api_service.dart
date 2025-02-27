import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.x.x:8000'; // Replace with your IP

  static Future<List<dynamic>> getAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  static Future<void> createAppointment(String clientName, String providerName, DateTime dateTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "client_name": clientName,
        "provider_name": providerName,
        "appointment_date": dateTime.toIso8601String(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create appointment');
    }
  }
}
