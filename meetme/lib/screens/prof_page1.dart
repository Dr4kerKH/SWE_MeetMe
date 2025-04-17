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

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      final classes = await ApiService.getMyClasses();
      setState(() {
        _classList = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to  classes: $e")),
      );*/
    }
  }


  void _showClassDetailsDialog(BuildContext context, String className, String professorName, String joinCode, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'By $professorName',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Join Code: $joinCode',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
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
    final TextEditingController classController = TextEditingController();
    final TextEditingController professorController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Class Creation',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
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
                  fontSize: 16,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,                
                child: Text(
                  'Class Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              TextField(
                controller: classController,
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
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Professor Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              TextField(
                controller: professorController,
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
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Class Description',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).shadowColor,               
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
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
                  hintText: '',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
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
              onPressed: () async {
                final className = classController.text.trim();
                final professorName = professorController.text.trim();
                final description = descriptionController.text.trim();

                if (className.isEmpty || professorName.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in all fields',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop(); // Close form dialog
                await Future.delayed(Duration(milliseconds: 100));

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  await ApiService.createClass(
                    courseName: className,
                    professorName: professorName,
                    courseDescription: description,
                  );

                  if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // ✅ Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Class created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  await _fetchClasses();
                } catch (e) {
                  if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // ✅ Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create class: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Classes', 
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).shadowColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_rounded, color: Theme.of(context).shadowColor, size: 25,),
                        onPressed: () => _classAdder(context),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Classes',
                    hintStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                    fontFamily: 'Poppins',
                    ),
                    prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).shadowColor,
                    ),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  onChanged: (value) {
                    // Add search logic here
                  },
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
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
                                      backgroundColor: Theme.of(context).secondaryHeaderColor,
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
                                          cls['professor_name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          cls['course_description'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => _showClassDetailsDialog(
                                      context,
                                      cls['course_name'] ?? '',
                                      cls['professor_name'] ?? '',
                                      cls['course_code'] ?? '',
                                      cls['course_description'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}