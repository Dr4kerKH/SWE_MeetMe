import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../api_service.dart';

class ProfessorPage2 extends StatefulWidget {
  const ProfessorPage2({super.key});

  @override
  State<ProfessorPage2> createState() => _ProfessorPage2State();
}

class _ProfessorPage2State extends State<ProfessorPage2> {
  List<Map<String, dynamic>> _classList = [];
  List<Map<String, dynamic>> _filteredClassList = [];
  bool _isLoading = true;

  Color _getClassColor(String className) {
    // Use the hash of the class name to generate a consistent color
    final hash = className.hashCode;
    // Create a color with a fixed saturation and brightness but varying hue
    return HSLColor.fromAHSL(
      1.0, // Alpha
      (hash % 360).toDouble(), // Hue (0-360)
      0.4, // Saturation (0-1)
      0.5, // Lightness (0-1)
    ).toColor();
  }

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      final classes = await ApiService.getMyClasses();
      classes.sort((a, b) => (a['course_name'] ?? '')
          .toString()
          .toLowerCase()
          .compareTo((b['course_name'] ?? '').toString().toLowerCase()));

      setState(() {
        _classList = classes;
        _filteredClassList = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Future<void> _appointmentAdder(
      BuildContext context, Map<String, dynamic> classInfo) {
    DateTime selectedDate = DateTime.now();
    Set<TimeOfDay> selectedTimes = {};

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Avaliable Time for Appointment',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Multiple Time Slots',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 2.0,
                        children: List.generate(16, (index) {
                          final startTime = TimeOfDay(
                              hour: 10 + (index ~/ 2),
                              minute: (index % 2) * 30);
                          final endTime = TimeOfDay(
                              hour: startTime.hour,
                              minute: startTime.minute + 29);
                          // Check if this time is in our selected times
                          final isSelected = selectedTimes.contains(startTime);
                          return ElevatedButton(
                            onPressed: () {
                              setStateDialog(() {
                                if (isSelected) {
                                  selectedTimes.remove(startTime);
                                } else {
                                  selectedTimes.add(startTime);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context).hintColor,
                              foregroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              '${(startTime.hour > 12 ? '0' : '')}${startTime.format(context).replaceFirst(' AM', '').replaceFirst(' PM', '')} - ${(endTime.hour > 12 ? '0' : '')}${endTime.format(context).replaceFirst(' AM', 'am').replaceFirst(' PM', 'pm')}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (selectedTimes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            '${selectedTimes.length} time slots selected',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                    ],
                  ),
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
                      'Set Time',
                      style: TextStyle(
                        color: Theme.of(context).shadowColor,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      // Convert selectedTimes (TimeOfDay) to List<String> like '08:00am'
                      List<String> timeStrings = selectedTimes.map((time) {
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day,
                            time.hour, time.minute);
                        return TimeOfDay.fromDateTime(dt)
                            .format(context)
                            .replaceFirst(' AM', 'am')
                            .replaceFirst(' PM', 'pm');
                      }).toList();
                      await ApiService.setAvaliableTime(
                        classInfo['course_code'], // <-- fixed here
                        timeStrings,
                      );
                      Navigator.of(context).pop(); // Close dialog after setting
                    },
                  ),
                ],
              );
            },
          );
        });
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
                  height: 120,
                  width: 60,
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
            const Text('Setect Time for Appointments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : _classList.isEmpty
                      ? Center(child: Text('No classes available'))
                      : ListView.builder(
                          padding: EdgeInsets.all(12),
                          itemCount: _classList.length,
                          itemBuilder: (context, index) {
                            final cls = _classList[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _getClassColor(cls['course_name'] ?? ''),
                                  radius: 32,
                                ),
                                title: Text(
                                  cls['course_name'] ?? 'Unnamed Class',
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
                                      'by ${cls['professor_name'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _appointmentAdder(context, cls),
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
