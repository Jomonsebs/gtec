import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCourse extends StatefulWidget {
  const AdminCourse({Key? key}) : super(key: key);

  @override
  State<AdminCourse> createState() => _AdminCourseState();
}

class _AdminCourseState extends State<AdminCourse> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? selectedButton; // Track the pagination button selection state

  Future<void> _addCourse(String name, String description) async {
    try {
      final courseData = {
        'name': name,
        'description': description,
      };

      await _firestore.collection('courses').add(courseData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add course: $e')),
      );
    }
  }

  void _showAddCourseDialog() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String name = _nameController.text;
                final String description = _descriptionController.text;

                if (name.isNotEmpty && description.isNotEmpty) {
                  _addCourse(name, description);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Add Course'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Add Scroll View here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and 'Create Course' button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Courses',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Manage your courses here.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _showAddCourseDialog,
                    child: const Text('Create Course'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('courses').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final courses = snapshot.data!.docs;

                  // Display course count
                  Text(
                    '${courses.length} Courses',
                    style: Theme.of(context).textTheme.titleMedium,
                  );

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: courses.map((courseDoc) {
                      final course = courseDoc.data() as Map<String, dynamic>;
                      final courseId = courseDoc.id;

                      // Safely handle null values with default values
                      final String courseName = course['name'] ?? 'No Name';
                      final String courseDescription = course['description'] ?? 'No Description';

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModuleScreen(courseId: courseId),
                          ),
                        ),
                        child: Container(
                          width: 200,
                          height: 220,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
                                    color: Colors.blue,
                                    child: Center(
                                      child: Text(
                                        courseName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    courseDescription,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ModuleScreen extends StatelessWidget {
  final String courseId;

  const ModuleScreen({Key? key, required this.courseId}) : super(key: key);

  Future<void> _addModule(String name) async {
    final moduleData = {'name': name};
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('modules')
        .add(moduleData);
  }

  void _showAddModuleDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Module'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Module Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String name = _nameController.text;
                if (name.isNotEmpty) {
                  _addModule(name);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a module name')),
                  );
                }
              },
              child: const Text('Add Module'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modules'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and description
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Modules',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Manage your course modules here.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _showAddModuleDialog(context),
                    child: const Text('Create Module'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Module list with StreamBuilder
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('modules')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final modules = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      final module = modules[index].data() as Map<String, dynamic>;
                      final moduleName = module['name'] ?? 'No Name';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonScreen(
                                courseId: courseId,
                                moduleId: modules[index].id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                            title: Text(
                              moduleName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonScreen extends StatelessWidget {
  final String moduleId;
  final String courseId;

  const LessonScreen({Key? key, required this.moduleId, required this.courseId})
      : super(key: key);

  Future<void> _addLesson(String name, String url) async {
    final lessonData = {'name': name, 'url': url};
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('lessons')
        .add(lessonData);
  }

  void _showAddLessonDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Lesson'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Lesson Name'),
              ),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'Lesson URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String name = _nameController.text;
                final String url = _urlController.text;
                if (name.isNotEmpty && url.isNotEmpty) {
                  _addLesson(name, url);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter both name and URL')),
                  );
                }
              },
              child: const Text('Add Lesson'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and description
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lessons',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Manage your module lessons here.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _showAddLessonDialog(context),
                    child: const Text('Create Lesson'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Lesson list with StreamBuilder
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('modules')
                    .doc(moduleId)
                    .collection('lessons')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lessons = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index].data() as Map<String, dynamic>;
                      final lessonName = lesson['name'] ?? 'No Name';
                      final lessonUrl = lesson['url'] ?? 'No URL';

                      return GestureDetector(
                        onTap: () {
                          // You can implement lesson tap functionality here
                          // For example, open the URL in a browser
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                            title: Text(
                              lessonName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              lessonUrl,
                              style: const TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
