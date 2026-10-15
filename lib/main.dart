import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const StudentManagementApp());
}

class Student {
  final String name;
  final String enrollment;
  final String course;
  final String semester;

  Student({
    required this.name,
    required this.enrollment,
    required this.course,
    required this.semester,
  });
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// 1. Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3. Keep Splash Screen visible for 10 seconds
    Timer(const Duration(seconds: 10), () {
      // 4. Navigate to Home Screen (MainNavigation)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. Display application logo (using FlutterLogo as placeholder)
            const FlutterLogo(size: 150),
            const SizedBox(height: 20),
            const Text(
              'Student Management App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text("Loading... (10s)"),
          ],
        ),
      ),
    );
  }
}

// 5. Main Navigation with Bottom Bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Student> _students = [];

  void _addStudent(Student student) {
    setState(() {
      _students.add(student);
    });
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      StudentFormScreen(onStudentAdded: _addStudent),
      StudentListScreen(students: _students),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_business), label: 'Form'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
        ],
      ),
    );
  }
}

// 6. Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Welcome to Student Manager',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// 7 & 8. Student Form with Validation
class StudentFormScreen extends StatefulWidget {
  final Function(Student) onStudentAdded;
  const StudentFormScreen({super.key, required this.onStudentAdded});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _enrollmentController = TextEditingController();
  final _courseController = TextEditingController();
  final _semesterController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        name: _nameController.text,
        enrollment: _enrollmentController.text,
        course: _courseController.text,
        semester: _semesterController.text,
      );
      widget.onStudentAdded(newStudent);
      
      // Clear fields
      _nameController.clear();
      _enrollmentController.clear();
      _courseController.clear();
      _semesterController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student Data Saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Student Name'),
                validator: (value) => value!.isEmpty ? 'Enter Name' : null,
              ),
              TextFormField(
                controller: _enrollmentController,
                decoration: const InputDecoration(labelText: 'Enrollment Number'),
                validator: (value) => value!.isEmpty ? 'Enter Enrollment No' : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) => value!.isEmpty ? 'Enter Course' : null,
              ),
              TextFormField(
                controller: _semesterController,
                decoration: const InputDecoration(labelText: 'Semester'),
                validator: (value) => value!.isEmpty ? 'Enter Semester' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 10. Student List Screen (ListView)
class StudentListScreen extends StatelessWidget {
  final List<Student> students;
  const StudentListScreen({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: students.isEmpty
          ? const Center(child: Text('No students added yet.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(student.name[0])),
                  title: Text(student.name),
                  subtitle: Text('Enrollment: ${student.enrollment}'),
                  // 11. onTap functionality
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentDetailScreen(student: student),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// 12. Student Detail Screen (Card View)
class StudentDetailScreen extends StatelessWidget {
  final Student student;
  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.account_circle, size: 80, color: Colors.blue),
                ),
                const Divider(height: 30),
                _buildDetailRow('Name:', student.name),
                _buildDetailRow('Enrollment:', student.enrollment),
                _buildDetailRow('Course:', student.course),
                _buildDetailRow('Semester:', student.semester),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
