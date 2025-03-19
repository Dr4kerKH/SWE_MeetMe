import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import 'package:table_calendar/table_calendar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'screens/stu_page1.dart';
import 'screens/stu_page2.dart';
import 'screens/stu_page3.dart';
import 'screens/stu_page4.dart';
import 'screens/stu_page5.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
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
      ),*/
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
            },
            children: [
              StudentPage1(),
              StudentPage2(),
              StudentPage3(),
              StudentPage4(),
              StudentPage5(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.97),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 5,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: const Color.fromARGB(255, 0, 0, 0),
                dotColor: const Color.fromARGB(255, 179, 179, 179),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
        child: GNav(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          gap: 8,
          padding: EdgeInsets.all(16),
          selectedIndex: _bottomNavIndex,
          onTabChange: (index) {
            setState(() {
              _bottomNavIndex = index;
              _controller.animateToPage(
                index,
                duration: Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home_filled,
              text: 'Home',
              iconActiveColor: Color.fromARGB(255, 0, 0, 0),
              iconColor: Color.fromARGB(255, 179, 179, 179),
              ),
            GButton(
              icon: Icons.dashboard_customize_rounded, 
              text: 'Calendar',
              iconActiveColor: Color.fromARGB(255, 0, 0, 0),
              iconColor: Color.fromARGB(255, 179, 179, 179),
              ),
            GButton(
              icon: Icons.add_circle_rounded, 
              text: 'Appointment',
              iconActiveColor: Color.fromARGB(255, 0, 0, 0),
              iconColor: Color.fromARGB(255, 179, 179, 179),
            ),
            GButton(
              icon: Icons.message_rounded, 
              text: 'Chat',
              iconActiveColor: Color.fromARGB(255, 0, 0, 0),
              iconColor: Color.fromARGB(255, 179, 179, 179),
              ),  
            GButton(
              icon: Icons.person_rounded, 
              text: 'Profile',
              iconActiveColor: Color.fromARGB(255, 0, 0, 0),
              iconColor: Color.fromARGB(255, 179, 179, 179),
              ),  
          ],
        ),
      ),
    );
  }
}