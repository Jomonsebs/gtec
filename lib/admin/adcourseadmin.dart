import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtech/admin/modulesadmin.dart';

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




