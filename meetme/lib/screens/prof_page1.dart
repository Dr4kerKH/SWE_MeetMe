import 'package:flutter/material.dart';

class ProfessorPage1 extends StatefulWidget {
  const ProfessorPage1({super.key});

  @override
  State<ProfessorPage1> createState() => _ProfessorPage1State();
}

class _ProfessorPage1State extends State<ProfessorPage1> {
  
  Future<void> _classAdder(BuildContext context) {
    
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
            'Class Registration',
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
                'Please enter the code provided by your teacher',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  hintText: 'Class Code Ex: ABCD1234',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  //Theme.of(context).primaryColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ]
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
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).shadowColor,
                            radius: 24,
                            backgroundImage: AssetImage('assets/logo-transparent-png.png'),
                          ),
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
                              SizedBox(height: 4),
                              Text(
                              '''This is a detailed description of the class.\n It will contain the more\n and more.''',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).hintColor,
                              ),
                              ),
                            ],
                            ),
                          onTap: () {

                          },
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