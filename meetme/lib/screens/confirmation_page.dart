// lib/screens/confirmation_page.dart

import 'package:flutter/material.dart';
import '/api_service.dart'; // Import your ApiService to handle appointment booking

class ConfirmationPage extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String studentName;
  final String studentEmail;
  final String courseId;
  final String courseName;
  final String professorName;

  const ConfirmationPage({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.studentName,
    required this.studentEmail,
    required this.courseId,
    required this.courseName,
    required this.professorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Selected Time: ${selectedTime.format(context)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.createAppointment(
                    studentName: studentName,
                    studentEmail: studentEmail,
                    courseId: courseId,
                    courseName: courseName,
                    professorName: professorName,
                    dateTime: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment booked successfully!')),
                  );
                  Navigator.pop(context); // Return to the previous page
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
