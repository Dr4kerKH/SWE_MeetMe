import 'package:flutter/material.dart';
import '../api_service.dart';

class ProfessorPage1 extends StatefulWidget {
  const ProfessorPage1({super.key});

  @override
  State<ProfessorPage1> createState() => _ProfessorPage1State();
}

class _ProfessorPage1State extends State<ProfessorPage1> {
  List<Map<String, dynamic>> _classList = [];
  bool _isLoading = true;

  // Function to generate a color based on the class name
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
      // Sort the classes by course_name
      classes.sort((a, b) => (a['course_name'] ?? '')
          .toString()
          .toLowerCase()
          .compareTo((b['course_name'] ?? '').toString().toLowerCase()));
      setState(() {
        _classList = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to fetch classes: $e",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ),
      );
    }
  }

  void _showClassDetailsDialog(BuildContext context, String className,
      String professorName, String joinCode, String description) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                className,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.002),
              Text(
                'By $professorName',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.035,
                  color: Theme.of(context).hintColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Join Code: $joinCode',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _classAdder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController classController = TextEditingController();
    final TextEditingController professorController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Class Creation',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Please fill in the class informations',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Class Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.04,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              TextField(
                controller: classController,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).shadowColor,
                      width: 1.0,
                    ),
                  ),
                  hintText: '(Ex: CS-4399-Senior Project Design)',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.03,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Professor Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.04,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              TextField(
                controller: professorController,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).shadowColor,
                      width: 1.0,
                    ),
                  ),
                  hintText: '(Ex: Dr.Rafael)',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.03,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Class Description',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.04,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).shadowColor,
                      width: 1.0,
                    ),
                  ),
                  hintText: '(Ex: This is a senior project design class...)',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.03,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (classController.text.isNotEmpty &&
                    professorController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  try {
                    await ApiService.createClass(
                      courseName: classController.text,
                      professorName: professorController.text,
                      courseDescription: descriptionController.text,
                    );
                    Navigator.of(context).pop();
                    _fetchClasses();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to create class: $e",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please fill in all fields",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Create',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
                  color: Theme.of(context).shadowColor,
                ),
              ),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).shadowColor,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Classes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).shadowColor,
                          size: screenWidth * 0.08,
                        ),
                        onPressed: () => _classAdder(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _classList.isEmpty
                      ? Center(
                          child: Text(
                            'No classes found',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenWidth * 0.05,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          itemCount: _classList.length,
                          itemBuilder: (context, index) {
                            final classInfo = _classList[index];
                            return Card(
                              margin:
                                  EdgeInsets.only(bottom: screenHeight * 0.015),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              color: _getClassColor(
                                  classInfo['course_name'] ?? ''),
                              child: ListTile(
                                title: Text(
                                  classInfo['course_name'] ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  'By ${classInfo['professor_name'] ?? ''}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                onTap: () => _showClassDetailsDialog(
                                  context,
                                  classInfo['course_name'] ?? '',
                                  classInfo['professor_name'] ?? '',
                                  classInfo['join_code'] ?? '',
                                  classInfo['description'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
