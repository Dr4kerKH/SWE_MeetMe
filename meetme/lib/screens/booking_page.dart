// lib/screens/booking_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'confirmation_page.dart'; // Import confirmation page

class BookingAppointmentPage extends StatefulWidget {
  const BookingAppointmentPage({super.key});

  @override
  State<BookingAppointmentPage> createState() => _BookingAppointmentPageState();
}

class _BookingAppointmentPageState extends State<BookingAppointmentPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Calendar controller
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduling an Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar View
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 20),

            // Time Picker
            ElevatedButton(
              onPressed: () {
                if (_selectedDate == null || _selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date and time.'),
                    ),
                  );
                } else {
                  // Provide dynamic or static values for the following fields
                  String studentName = 'John Doe'; // Replace with actual student name
                  String studentEmail = 'johndoe@example.com'; // Replace with actual student email
                  String courseId = 'CS101'; // Replace with actual course ID
                  String courseName = 'Intro to Computer Science'; // Replace with actual course name
                  String professorName = 'Prof. Smith'; // Replace with actual professor name

                  // Navigate to confirmation screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmationPage(
                        selectedDate: _selectedDate!,
                        selectedTime: _selectedTime!,
                        studentName: studentName,
                        studentEmail: studentEmail,
                        courseId: courseId,
                        courseName: courseName,
                        professorName: professorName,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
