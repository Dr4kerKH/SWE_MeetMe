// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/booking_page.dart'; // Import the booking page screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Appointment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BookingAppointmentPage(),
    );
  }
}
