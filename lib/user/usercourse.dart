import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart'; // Correct import
import 'package:url_launcher/url_launcher.dart';

class UserAllocatedCoursesPage extends StatefulWidget {
  const UserAllocatedCoursesPage({Key? key}) : super(key: key);

  @override
  _UserAllocatedCoursesPageState createState() =>
      _UserAllocatedCoursesPageState();
}

class _UserAllocatedCoursesPageState extends State<UserAllocatedCoursesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> _getUserCourses(String userId) {
    return _firestore.collection('users').doc(userId).collection('courses').snapshots();
  }

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
                              builder: (context) => ModuleScreenUser(courseId: courseId),
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

class ModuleScreenUser extends StatelessWidget {
  final String courseId;

  ModuleScreenUser({required this.courseId});

  Stream<QuerySnapshot> _getModules(String courseId) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('modules')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Modules'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getModules(courseId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final modules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final moduleId = modules[index].id;
              final moduleName = modules[index]['name'] ?? 'Unnamed Module';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                child: ListTile(
                  title: Text(moduleName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonsScreenUser(courseId: courseId, moduleId: moduleId),
                      ),
                    );
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

class LessonsScreenUser extends StatelessWidget {
  final String moduleId;
  final String courseId;

  const LessonsScreenUser({Key? key, required this.moduleId, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index].data() as Map<String, dynamic>;
                final lessonName = lesson['name'] ?? 'No Name';
                final lessonUrl = lesson['url'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(url: lessonUrl),
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
                        lessonName,
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayerController.convertUrlToId(widget.url);

    // Initialize the controller with the correct parameter names
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _controller.close();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller, // Use YoutubePlayer instead of YoutubePlayerIFrame
          aspectRatio: 16 / 9,  // Optional: adjust aspect ratio if needed
        ),
      ),
    );
  }
}
