import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProfessorPage3 extends StatefulWidget {
  const ProfessorPage3({super.key});

  @override
  State<ProfessorPage3> createState() => _ProfessorPage3State();
}

class _ProfessorPage3State extends State<ProfessorPage3> {
  DateTime _selectedDate = DateTime.now();
  final DatePickerController _datePickerController = DatePickerController();
  final CalendarController _calendarController = CalendarController();

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
                  controller: _datePickerController,
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.15,
                  initialSelectedDate: _selectedDate,
                  selectionColor: Theme.of(context).secondaryHeaderColor,
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
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  children: [
                    Expanded(
                      child: SfCalendar(
                        controller: _calendarController,
                        viewHeaderStyle: ViewHeaderStyle(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          dateTextStyle: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        headerHeight: 0,
                        todayHighlightColor:
                            Theme.of(context).secondaryHeaderColor,
                        view: CalendarView.day,
                        initialDisplayDate: _selectedDate,
                        initialSelectedDate: _selectedDate,
                        dataSource:
                            MeetingDataSource(getAppointments(_selectedDate)),
                        onViewChanged: (ViewChangedDetails details) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _selectedDate = details.visibleDates[0];
                              _datePickerController
                                  .animateToDate(_selectedDate);
                            });
                          });
                        },
                        appointmentBuilder: (context, details) {
                          final Appointment appointment =
                              details.appointments.first;
                          return Material(
                            elevation: 4,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: Center(
                                child: Text(
                                  appointment.subject,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: screenWidth * 0.035,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
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
                          timeIntervalHeight: screenHeight * 0.1,
                          allDayPanelColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          timeTextStyle: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
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
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 17, 0, 0);
  final DateTime endTime = startTime.add(Duration(minutes: 29));
  meetings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'Meeting Details',
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
