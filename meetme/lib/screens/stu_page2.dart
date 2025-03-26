import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class StudentPage2 extends StatefulWidget {
  const StudentPage2({super.key});

  @override
  State<StudentPage2> createState() => _StudentPage2State();
}

class _StudentPage2State extends State<StudentPage2> {
  


  Future<void> _appointmentAdder(BuildContext context) {
    
    final TextEditingController codeController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Book an Appointment',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
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
                fontSize: 16,
                color: Theme.of(context).shadowColor,
              ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 2.0,
                children: List.generate(15, (index) {
                  final startTime = TimeOfDay(hour: 10 + (index ~/ 2), minute: (index % 2) * 30);
                  final endTime = TimeOfDay(hour: startTime.hour, minute: startTime.minute + 29);
                  return ElevatedButton(
                    onPressed: () {
                      // Handle time slot selection logic here
                      // Adding appointment here into database
                      // print('Selected time slot: ${startTime.format(context)} - ${endTime.format(context)}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).hintColor,
                      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '${startTime.format(context).replaceFirst(' AM', '').replaceFirst(' PM', '')}-${endTime.format(context).replaceFirst(' AM', 'am').replaceFirst(' PM', 'pm')}',
                      style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      ),
                    ),
                  );
                }
                ),
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
                  fontSize: 16,
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
                  fontSize: 16,
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
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                selectionColor: Theme.of(context).primaryColor,
                selectedTextColor: Theme.of(context).scaffoldBackgroundColor,
                locale: 'en_US',
                daysCount: 14,
                onDateChange: (date) {
                  setState(() {
                  });
                },
              ),
            ),
            ),
            const Text('Scheduling Appointment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'CS-133${index + 1}-Computer Science ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                        subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          'Rob LeGrand',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).hintColor,
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
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}