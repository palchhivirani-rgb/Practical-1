import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const CourseManagementApp());
}

class Course {
  final String name;
  final String faculty;
  final String duration;
  final String fees;
  final String description;

  Course({
    required this.name,
    required this.faculty,
    required this.duration,
    required this.fees,
    required this.description,
  });
}

class CourseManagementApp extends StatelessWidget {
  const CourseManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// 2 & 3. Splash Screen with 10 seconds timer
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      // 4. Navigate to Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            Icon(Icons.menu_book, size: 120, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Course Manager Pro',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
            Text("Starting in 10s...", style: TextStyle(color: Colors.white70)),
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
  final List<Course> _courses = [];

  void _addCourse(Course course) {
    setState(() {
      _courses.add(course);
    });
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      CourseFormScreen(onCourseAdded: _addCourse),
      CourseListScreen(courses: _courses),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add Course'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Courses'),
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
            Icon(Icons.auto_stories, size: 100, color: Colors.teal),
            SizedBox(height: 20),
            Text(
              'Welcome to Course Management',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Manage your curriculum efficiently with our easy-to-use platform.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 7, 8 & 9. Course Form with Fields and Validation
class CourseFormScreen extends StatefulWidget {
  final Function(Course) onCourseAdded;
  const CourseFormScreen({super.key, required this.onCourseAdded});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _facultyController = TextEditingController();
  final _durationController = TextEditingController();
  final _feesController = TextEditingController();
  final _descController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // 10. Save course info
      widget.onCourseAdded(Course(
        name: _nameController.text,
        faculty: _facultyController.text,
        duration: _durationController.text,
        fees: _feesController.text,
        description: _descController.text,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course Added Successfully!')),
      );

      _nameController.clear();
      _facultyController.clear();
      _durationController.clear();
      _feesController.clear();
      _descController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Course Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter course name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _facultyController,
                decoration: const InputDecoration(labelText: 'Faculty Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter faculty name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (e.g. 6 Months)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter duration' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _feesController,
                decoration: const InputDecoration(labelText: 'Fees', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter fees' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  child: const Text('Submit Course'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 11. Course List Screen with ListView
class CourseListScreen extends StatelessWidget {
  final List<Course> courses;
  const CourseListScreen({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course List')),
      body: courses.isEmpty
          ? const Center(child: Text('No courses available.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  tileColor: Colors.teal.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Faculty: ${course.faculty}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  // 12. onTap functionality
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(course: course),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// 13. Course Details in a Card View
class CourseDetailScreen extends StatelessWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    course.name.toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ),
                const Divider(height: 40),
                _infoRow(Icons.person, 'Faculty:', course.faculty),
                _infoRow(Icons.timer, 'Duration:', course.duration),
                _infoRow(Icons.currency_rupee, 'Fees:', course.fees),
                const SizedBox(height: 20),
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(course.description, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
