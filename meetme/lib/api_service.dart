import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  
  // Change base URL accordingly
  static const String baseUrl = "http://10.0.2.2:8000"; // For Android emulator
  // static const String baseUrl = "http://localhost:8000"; // For iOS simulator or web
  
  //####################################################################################################
  static Future<void> createAccount(String email, String username, String password, String role) async {
    
    // Email format validation using RegEx
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (email.isEmpty) {
      throw Exception('Please enter an email address');
    }
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
    if (username.isEmpty) {
      throw Exception('Please enter a username');
    }
    if (password.isEmpty) {
      throw Exception('Please enter your password');
    }

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

    if (response.statusCode == 200 || response.statusCode == 201) {
        // Account created successfully
        return;
    } else {
      // Extract the error message from the response body
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to create account');
    }
  }

//###################################################################
  static Future<void> login(String email, String password) async {
    
    // Email format validation using RegEx
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (email.isEmpty) {
        throw Exception('Please enter an email address');
    }
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
    if (password.isEmpty) {
      throw Exception('Please enter your password');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['role']; // Return the role if login is successful
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail']); // Throw the error message from the backend
    }
  }

//##########################################################################
static Future<void> createClass({
  required String className,
  required String professorName,
  required String classDescription,
  required String classCode,
}) async {
  final url = Uri.parse('$baseUrl/classes');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'className': className,
      'professorName': professorName,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to create class: ${response.body}');
  }
}

//##########################################################################
  static Future<List<Map<String, dynamic>>> getClasses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/classes'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch classes: ${response.body}');
    }
  }

//##########################################################################
  static Future<Map<String, dynamic>> getClassById(String courseId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/classes/$courseId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch class: ${response.body}');
    }
  }

//#########################################################################
  static Future<void> createAppointment({
    required String studentName,
    required String studentEmail,
    required String courseId,
    required String courseName,
    required String professorName,
    required DateTime dateTime,
  }) async {
    final url = Uri.parse('$baseUrl/appointments');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'studentName': studentName,
        'studentEmail': studentEmail,
        'courseId': courseId,
        'courseName': courseName,
        'professorName': professorName,
        'appointment_date': dateTime.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create appointment');
    }
  }

//##########################################################################
  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/appointments'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch appointments: ${response.body}');
    }
  }

//##########################################################################
  static Future<void> deleteAppointment(String appointmentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/appointments/$appointmentId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment: ${response.body}');
    }
  }

//##########################################################################
  static Future<void> deleteClass(String courseId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/classes/$courseId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete class: ${response.body}');
    }
  }
}