import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'screens/prof_page1.dart';
import 'screens/prof_page2.dart';
import 'screens/prof_page3.dart';
import 'screens/prof_page4.dart';
import 'main.dart';
//import 'screens/stu_page5.dart';

class ProfessorHomePage extends StatefulWidget {
  const ProfessorHomePage({super.key});

  @override
  State<ProfessorHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProfessorHomePage> {
  final PageController _controller = PageController();
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon:
              Icon(Icons.account_circle, color: Theme.of(context).shadowColor),
          onPressed: () {
            // Handle user profile action
          },
        ),
        title: Text(
          'Meet Me',
          style: TextStyle(
            color: Theme.of(context).shadowColor,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded,
                color: Theme.of(context).shadowColor),
            onPressed: () {
              // Handle logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
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
              ProfessorPage1(),
              ProfessorPage2(),
              ProfessorPage3(),
              ProfessorPage4(),
              //ProfessorPage5(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.97),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Theme.of(context).shadowColor,
                dotColor: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
        child: GNav(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          tabs: [
            GButton(
              icon: Icons.home_rounded,
              //text: 'Home',
              iconActiveColor: Theme.of(context).shadowColor,
              iconColor: Theme.of(context).hintColor,
            ),
            GButton(
              icon: Icons.dashboard_customize_rounded,
              //text: 'Appointments',
              iconActiveColor: Theme.of(context).shadowColor,
              iconColor: Theme.of(context).hintColor,
            ),
            GButton(
              icon: Icons.bento_rounded,
              //text: 'Calendar',
              iconActiveColor: Theme.of(context).shadowColor,
              iconColor: Theme.of(context).hintColor,
            ),
            GButton(
              icon: Icons.add_comment,
              //text: 'Chat',
              iconActiveColor: Theme.of(context).shadowColor,
              iconColor: Theme.of(context).hintColor,
            ),
            /*GButton(
              icon: Icons.person_rounded, 
              text: 'Profile',
              iconActiveColor: Theme.of(context).shadowColor,
              iconColor: Theme.of(context).hintColor,
              ), */
          ],
        ),
      ),
    );
  }
}
