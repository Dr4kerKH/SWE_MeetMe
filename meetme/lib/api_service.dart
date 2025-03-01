import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://192.168.x.x:8000'; // Replace with your IP to run Backend on here for physical devices to connect
  static const String baseUrl = 'http://localhost:8000'; // Use localhost for local testing within a machine

  // Create an account (either professor or student)
  static Future<void> createAccount(String email, String username, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
        "role": role, // "professor" or "student"
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create account');
    }
  }

  // User login (Returns user details if successful)
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expected to return user details (e.g., token, role)
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // Get list of all classes
  static Future<List<dynamic>> getClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/classes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((className) => className.toString()).toList();
    } else {
      throw Exception('Failed to load class details');
    }
  }

  // Get details of a specific class by course_id
  static Future<Map<String, dynamic>> getClassDetails(String courseId) async {
    final response = await http.get(Uri.parse('$baseUrl/classes/$courseId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load class details');
    }
  }

  // Get all appointments
  static Future<List<dynamic>> getAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  // Create an appointment
  static Future<void> createAppointment({
    required String studentName,
    required String studentEmail,
    required String courseId,
    required String courseName,
    required String professorName,
    required DateTime dateTime,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "student_name": studentName,
        "student_email": studentEmail,
        "course_id": courseId,
        "course_name": courseName,
        "professor_name": professorName,
        "appointment_date": dateTime.toIso8601String(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create appointment');
    }
  }
}
