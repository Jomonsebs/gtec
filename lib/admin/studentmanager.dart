import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRegisteredStudentsPage extends StatefulWidget {
  const AdminRegisteredStudentsPage({Key? key}) : super(key: key);

  @override
  _AdminRegisteredStudentsPageState createState() =>
      _AdminRegisteredStudentsPageState();
}

class _AdminRegisteredStudentsPageState
    extends State<AdminRegisteredStudentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedCourse;

  // Fetch all registered users with role 'user'
  Stream<QuerySnapshot> _getStudents() {
    return _firestore.collection('users').where('role', isEqualTo: 'user').snapshots();
  }

  // Fetch the name of a course by its ID
  Future<String> _getCourseNameById(String courseId) async {
    try {
      DocumentSnapshot courseDoc = await _firestore.collection('courses').doc(courseId).get();
      return courseDoc.exists ? courseDoc['name'] ?? 'Unnamed Course' : 'Course Not Found';
    } catch (e) {
      print('Error fetching course name: $e');
      return 'Error';
    }
  }

  // Add course to student
  Future<void> _addCourseToStudent(String uid, String courseId) async {
    try {
      await _firestore.collection('users').doc(uid).collection('courses').doc(courseId).set({
        'courseId': courseId,
        'enrollmentDate': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course added successfully!')));
    } catch (e) {
      print('Error adding course: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add course: $e')));
    }
  }

  // Remove course from student
  Future<void> _removeCourseFromStudent(String uid, String courseId) async {
    try {
      await _firestore.collection('users').doc(uid).collection('courses').doc(courseId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course removed successfully!')));
    } catch (e) {
      print('Error removing course: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove course: $e')));
    }
  }

  // Show dialog to select and add a course to a student
  Future<void> _showAddCourseDialog(BuildContext context, String studentUid) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Course to Add'),
          content: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('courses').snapshots(),
            builder: (context, courseSnapshot) {
              if (!courseSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final courses = courseSnapshot.data!.docs;
              List<String> courseNames = [];
              List<String> courseIds = [];
              for (var course in courses) {
                courseNames.add(course['name']);
                courseIds.add(course.id);
              }

              return DropdownButton<String>(
                hint: const Text('Select a Course'),
                value: selectedCourse,
                onChanged: (newValue) {
                  setState(() {
                    selectedCourse = newValue;
                  });
                },
                items: courseNames.map((courseName) {
                  return DropdownMenuItem<String>(
                    value: courseIds[courseNames.indexOf(courseName)], // Correctly use courseId
                    child: Text(courseName),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedCourse != null) {
                  _addCourseToStudent(studentUid, selectedCourse!);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Course'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to remove a course from a student
  Future<void> _showRemoveCourseDialog(BuildContext context, String studentUid) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Course to Remove'),
          content: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').doc(studentUid).collection('courses').snapshots(),
            builder: (context, studentCoursesSnapshot) {
              if (!studentCoursesSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final studentCourses = studentCoursesSnapshot.data!.docs;
              List<String> studentCourseNames = [];
              List<String> studentCourseIds = [];
              for (var studentCourse in studentCourses) {
                studentCourseNames.add(studentCourse['courseId']);
                studentCourseIds.add(studentCourse.id);
              }

              return DropdownButton<String>(
                hint: const Text('Select a Course'),
                value: selectedCourse,
                onChanged: (newValue) {
                  setState(() {
                    selectedCourse = newValue;
                  });
                },
                items: studentCourseIds.map((courseId) {
                  return DropdownMenuItem<String>(
                    value: courseId,
                    child: FutureBuilder<String>(
                      future: _getCourseNameById(courseId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text('Loading...');
                        }
                        if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        }
                        return const Text('Error');
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedCourse != null) {
                  _removeCourseFromStudent(studentUid, selectedCourse!);
                  Navigator.pop(context);
                }
              },
              child: const Text('Remove Course'),
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
        title: const Text('Registered Students'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index].data() as Map<String, dynamic>;
                final studentUid = students[index].id; // This is the user's UID
                final studentEmail = student['email'] ?? 'Unknown User';
                final studentName = student['name'] ?? 'No name'; 

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder<QuerySnapshot>(
                      future: _firestore.collection('users').doc(studentUid).collection('courses').get(),
                      builder: (context, courseSnapshot) {
                        if (!courseSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final studentCourses = courseSnapshot.data!.docs;
                        List<Future<String>> courseNames = [];
                        for (var studentCourse in studentCourses) {
                          final courseId = studentCourse['courseId'];
                          if (courseId != null) {
                            courseNames.add(_getCourseNameById(courseId));
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentEmail, style: Theme.of(context).textTheme.titleLarge),
                            Text('Name: $studentName', style: TextStyle(color: Colors.grey[600])),
                            FutureBuilder<List<String>>(
                              future: Future.wait(courseNames),
                              builder: (context, courseNamesSnapshot) {
                                if (courseNamesSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (courseNamesSnapshot.hasData) {
                                  final courseNamesList = courseNamesSnapshot.data ?? [];
                                  return Text('Enrolled in: ${courseNamesList.isNotEmpty ? courseNamesList.join(", ") : 'No courses'}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]));
                                } else {
                                  return const Text('Error loading courses');
                                }
                              },
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Course'),
                                  onPressed: () {
                                    _showAddCourseDialog(context, studentUid);
                                  },
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.remove),
                                  label: const Text('Remove Course'),
                                  onPressed: () {
                                    _showRemoveCourseDialog(context, studentUid);
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
