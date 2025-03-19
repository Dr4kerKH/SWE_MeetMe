import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class StudentPage3 extends StatefulWidget {
  const StudentPage3({super.key});

  @override
  State<StudentPage3> createState() => _StudentPage3State();
}

class _StudentPage3State extends State<StudentPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Meet Me',
          style: TextStyle(
            color: Color.fromARGB(255, 50, 50, 50),
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(
            children: [
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: DatePicker(
                DateTime.now(),
                height: 120,
                width: 60,
                initialSelectedDate: DateTime.now(),
                selectionColor: const Color.fromARGB(255, 250, 101, 101),
                selectedTextColor: const Color.fromARGB(255, 255, 255, 255),
                locale: 'en_US',
                daysCount: 14,
                onDateChange: (date) {
                  // New date selected
                  //print(date);
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}