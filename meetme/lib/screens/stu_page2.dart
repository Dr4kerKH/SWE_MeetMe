import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class StudentPage2 extends StatefulWidget {
  const StudentPage2({super.key});

  @override
  State<StudentPage2> createState() => _StudentPage2State();
}

class _StudentPage2State extends State<StudentPage2> {
  Future<void> _appointmentAdder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController codeController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Book an Appointment',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please select the available time slot',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Wrap(
                spacing: screenWidth * 0.02,
                runSpacing: screenHeight * 0.005,
                children: List.generate(15, (index) {
                  final startTime = TimeOfDay(
                      hour: 10 + (index ~/ 2), minute: (index % 2) * 30);
                  final endTime = TimeOfDay(
                      hour: startTime.hour, minute: startTime.minute + 29);
                  return ElevatedButton(
                    onPressed: () {
                      // Handle time slot selection logic here
                      // Adding appointment here into database
                      // print('Selected time slot: ${startTime.format(context)} - ${endTime.format(context)}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).hintColor,
                      foregroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(
                      '${startTime.format(context).replaceFirst(' AM', '').replaceFirst(' PM', '')}-${endTime.format(context).replaceFirst(' AM', 'am').replaceFirst(' PM', 'pm')}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Register',
                style: TextStyle(
                  color: Theme.of(context).shadowColor,
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                ),
              ),
              onPressed: () {
                final classCode = codeController.text;
                if (classCode.isNotEmpty) {
                  // Handle class registration logic here
                  // Where it should search the class in DB and add it to classes' list
                  // print('Class registered with code: $classCode');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: DatePicker(
                  DateTime.now(),
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.15,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Theme.of(context).secondaryHeaderColor,
                  selectedTextColor: Theme.of(context).scaffoldBackgroundColor,
                  locale: 'en_US',
                  daysCount: 14,
                  onDateChange: (date) {
                    setState(() {});
                  },
                ),
              ),
            ),
            Text(
              'Scheduling Appointment',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(screenWidth * 0.03),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: ListTile(
                      title: Text(
                        'CS-133${index + 1}-Computer Science ${index + 1}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).shadowColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rob LeGrand',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).hintColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _appointmentAdder(context),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
