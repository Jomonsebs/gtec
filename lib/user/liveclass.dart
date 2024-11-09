import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Userliveviewpage extends StatefulWidget {
  const Userliveviewpage({Key? key}) : super(key: key);

  @override
  _UserliveviewpageState createState() => _UserliveviewpageState();
}

class _UserliveviewpageState extends State<Userliveviewpage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch the courses allocated to the user
  Stream<QuerySnapshot> _getUserCourses(String userId) {
    return _firestore.collection('users').doc(userId).collection('courses').snapshots();
  }

  // Fetch the course name by courseId
  Future<String> _getCourseNameById(String courseId) async {
    try {
      DocumentSnapshot courseDoc = await _firestore.collection('courses').doc(courseId).get();
      return courseDoc.exists ? courseDoc['name'] ?? 'Unnamed Course' : 'Course Not Found';
    } catch (e) {
      print('Error fetching course name: $e');
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Allocated Courses'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Please log in to see your courses'),
        ),
      );
    }

    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Allocated Courses'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserCourses(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userCourses = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: userCourses.length,
              itemBuilder: (context, index) {
                final userCourse = userCourses[index];
                final courseId = userCourse['courseId'];

                return FutureBuilder<String>(
                  future: _getCourseNameById(courseId),
                  builder: (context, courseSnapshot) {
                    if (courseSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (courseSnapshot.hasData) {
                      final courseName = courseSnapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveScreenUser(courseId: courseId),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  courseName,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Text('Error fetching course name');
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LiveScreenUser extends StatelessWidget {
  final String courseId;

  const LiveScreenUser({required this.courseId, Key? key}) : super(key: key);

  // Fetch live classes for the specified course
  Stream<QuerySnapshot> _getLiveClasses(String courseId) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('live_classes')
        .snapshots();
  }

  // Open URL in browser or app
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Classes for Course'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getLiveClasses(courseId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final liveClasses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: liveClasses.length,
            itemBuilder: (context, index) {
              final liveClass = liveClasses[index];
              final liveClassName = liveClass['name'] ?? 'Unnamed Live Class';
              final zoomUrl = liveClass['zoom_url'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                child: ListTile(
                  title: Text(liveClassName),
                  onTap: () {
                    if (zoomUrl.isNotEmpty) {
                      _launchURL(zoomUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No Zoom URL available')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
