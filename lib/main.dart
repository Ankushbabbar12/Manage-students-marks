import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Ankush Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to SQLite Ankush Flutter App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Student'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStudentPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Students'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewStudentsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Course'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCoursePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Courses'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewCoursesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Results'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewResultsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _feesPaidController = TextEditingController();

  void _addStudent(BuildContext context) async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    int feesPaid = int.tryParse(_feesPaidController.text) ?? 0;

    // Insert student into database
    await DatabaseHelper.instance.insertStudent({
      'firstName': firstName,
      'lastName': lastName,
      'feesPaid': feesPaid,
    });
    Navigator.pop(context); // Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _feesPaidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Fees Paid'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _addStudent(context),
              child: Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewStudentsPage extends StatefulWidget {
  @override
  _ViewStudentsPageState createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> {
  late Future<List<Map<String, dynamic>>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = DatabaseHelper.instance.queryAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Students'),
      ),
      body: FutureBuilder(
        future: _studentsFuture,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${students[index]['firstName']} ${students[index]['lastName']}'),
                  subtitle: Text('Fees Paid: ${students[index]['feesPaid']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final TextEditingController _courseNumberController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController = TextEditingController();

  void _addCourse(BuildContext context) async {
    String courseNumber = _courseNumberController.text;
    String courseName = _courseNameController.text;
    String courseDescription = _courseDescriptionController.text;

    // Insert course into database
    await DatabaseHelper.instance.insertCourse({
      'courseNumber': courseNumber,
      'courseName': courseName,
      'courseDescription': courseDescription,
    });
    Navigator.pop(context); // Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _courseNumberController,
              decoration: InputDecoration(labelText: 'Course Number'),
            ),
            TextFormField(
              controller: _courseNameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            TextFormField(
              controller: _courseDescriptionController,
              decoration: InputDecoration(labelText: 'Course Description'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _addCourse(context),
              child: Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewCoursesPage extends StatefulWidget {
  @override
  _ViewCoursesPageState createState() => _ViewCoursesPageState();
}

class _ViewCoursesPageState extends State<ViewCoursesPage> {
  late Future<List<Map<String, dynamic>>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = DatabaseHelper.instance.queryAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Courses'),
      ),
      body: FutureBuilder(
        future: _coursesFuture,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${courses[index]['courseNumber']} - ${courses[index]['courseName']}'),
                  subtitle: Text('Description: ${courses[index]['courseDescription']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ViewResultsPage extends StatefulWidget {
  @override
  _ViewResultsPageState createState() => _ViewResultsPageState();
}

class _ViewResultsPageState extends State<ViewResultsPage> {
  late Future<List<Map<String, dynamic>>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _resultsFuture = DatabaseHelper.instance.queryAllResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Results'),
      ),
      body: FutureBuilder(
        future: _resultsFuture,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> results = snapshot.data!;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${results[index]['studentId']} - ${results[index]['courseId']}'),
                  subtitle: Text('Grade: ${results[index]['grade']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'student_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
CREATE TABLE students (
id INTEGER PRIMARY KEY,
firstName TEXT,
lastName TEXT,
feesPaid INTEGER
)
''');

    await db.execute('''
CREATE TABLE courses (
courseNumber TEXT PRIMARY KEY,
courseName TEXT,
courseDescription TEXT
)
''');

    await db.execute('''
CREATE TABLE results (
id INTEGER PRIMARY KEY,
studentId INTEGER,
courseId TEXT,
grade TEXT
)
''');
  }

  Future<int> insertStudent(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('students', row);
  }

  Future<List<Map<String, dynamic>>> queryAllStudents() async {
    Database db = await instance.database;
    return await db.query('students');
  }

  Future<int> insertCourse(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('courses', row);
  }

  Future<List<Map<String, dynamic>>> queryAllCourses() async {
    Database db = await instance.database;
    return await db.query('courses');
  }

  Future<int> insertResult(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('results', row);
  }

  Future<List<Map<String, dynamic>>> queryAllResults() async {
    Database db = await instance.database;
    return await db.query('results');
  }
}
