import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class StudentPage3 extends StatefulWidget {
  const StudentPage3({super.key});

  @override
  State<StudentPage3> createState() => _StudentPage3State();
}

class _StudentPage3State extends State<StudentPage3> {

  DateTime _selectedDate = DateTime.now();
  final DatePickerController _datePickerController = DatePickerController();
  final CalendarController _calendarController = CalendarController();

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
                controller: _datePickerController,
                height: 120,
                width: 60,
                initialSelectedDate:  _selectedDate,
                selectionColor: Theme.of(context).primaryColor,
                selectedTextColor: Theme.of(context).scaffoldBackgroundColor,
                locale: 'en_US',
                daysCount: 14,
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                    _calendarController.displayDate = _selectedDate;
                  });
                },
              ),
            ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 540,
                      child: SfCalendar(
                        controller: _calendarController,
                        viewHeaderStyle: ViewHeaderStyle(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          dateTextStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        headerHeight: 0,
                        todayHighlightColor: Theme.of(context).secondaryHeaderColor,
                        view: CalendarView.day,
                        initialDisplayDate: _selectedDate,
                        initialSelectedDate: _selectedDate,
                        dataSource: MeetingDataSource(getAppointments(_selectedDate)),
                        onViewChanged: (ViewChangedDetails details) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _selectedDate = details.visibleDates[0];
                              _datePickerController.animateToDate(_selectedDate);
                            });
                          });
                        },
                        appointmentBuilder: (context, details) {
                        final Appointment appointment = details.appointments.first;
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                appointment.subject,
                                style: TextStyle(
                                  color: Theme.of(context).shadowColor,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                        timeSlotViewSettings: TimeSlotViewSettings(
                          startHour: 8,
                          endHour: 20,
                          timeInterval: Duration(minutes: 60),
                          timeFormat: 'h:mm a',
                          timeIntervalHeight: 80,
                          allDayPanelColor: Theme.of(context).scaffoldBackgroundColor,
                          timeTextStyle: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Dummy data for appointments
// You can replace this with your own data source
// or fetch data from an API
List<Appointment> getAppointments(DateTime selectedDate) {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 17, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 1));
  meetings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'Meeting',
    color: const Color.fromARGB(90, 255, 0, 13),
    recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=3',
  ));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}