import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class StudentPage2 extends StatefulWidget {
  const StudentPage2({super.key});

  @override
  State<StudentPage2> createState() => _StudentPage2State();
}

class _StudentPage2State extends State<StudentPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: DatePicker(
                DateTime.now(),
                //controller: _datePickerController,
                height: 120,
                width: 60,
                initialSelectedDate:  DateTime.now(),
                selectionColor: const Color.fromARGB(255, 250, 101, 101),
                selectedTextColor: const Color.fromARGB(255, 255, 255, 255),
                locale: 'en_US',
                daysCount: 14,
                onDateChange: (date) {
                  setState(() {
                  });
                },
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}