import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtech/admin/dashboard.dart';

class ModuleScreen extends StatefulWidget {
  final String courseId;

  const ModuleScreen({Key? key, required this.courseId, required Null Function() onBackPressed}) : super(key: key);

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  String? selectedModuleId;
  String? selectedModuleName;
  List<Map<String, dynamic>> lessons = [];

  // Fetch modules
  Future<List<Map<String, dynamic>>> _fetchModules() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('modules')
        .get();

    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc['name'],
            })
        .toList();
  }

  // Fetch lessons for a module
  Future<void> _fetchLessons(String moduleId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('lessons')
        .get();

    setState(() {
      lessons = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'url': doc['url'],
              })
          .toList();
    });
  }

  // Add a lesson
  Future<void> _addLesson(String moduleId, String name, String url) async {
    final lessonData = {'name': name, 'url': url};
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('lessons')
        .add(lessonData);

    // Fetch the updated list of lessons after adding a new lesson
    _fetchLessons(moduleId);
  }

  // Add a module
  Future<void> _addModule(String name) async {
    final moduleData = {'name': name};
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('modules')
        .add(moduleData);

    // Refresh the module list
    setState(() {});
  }

  // Delete a course
  Future<void> _deleteCourse() async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete) {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .delete();
      // Navigate back to course list or home screen
      Navigator.of(context).pop();
    }
  }

  // Show dialog to add lesson
  void _showAddLessonDialog(BuildContext context, String moduleId) {
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
                  _addLesson(moduleId, name, url);
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

  // Show dialog to add module
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

  // Edit a module
  void _editModule(BuildContext context, String moduleId, String currentName) {
    final TextEditingController _nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Module'),
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
                  FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.courseId)
                      .collection('modules')
                      .doc(moduleId)
                      .update({'name': name});
                  setState(() {});
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a module name')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  // Edit a lesson
  void _editLesson(BuildContext context, String moduleId, String lessonId, String currentName, String currentUrl) {
    final TextEditingController _nameController = TextEditingController(text: currentName);
    final TextEditingController _urlController = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Lesson'),
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
                  FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.courseId)
                      .collection('modules')
                      .doc(moduleId)
                      .collection('lessons')
                      .doc(lessonId)
                      .update({'name': name, 'url': url});
                  setState(() {});
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter both name and URL')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  // Delete a lesson
  Future<void> _deleteLesson(String moduleId, String lessonId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Lesson'),
          content: const Text('Are you sure you want to delete this lesson?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete) {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('modules')
          .doc(moduleId)
          .collection('lessons')
          .doc(lessonId)
          .delete();
      _fetchLessons(moduleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()), // Navigates to the AdminCourse page
      );
    },
  ),
  title: const Text('Admin Course'), // Title of the page
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _showAddModuleDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Add Module'),
                ),
                ElevatedButton(
                  onPressed: _deleteCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Delete Course'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dropdown for module selection
            FutureBuilder<List<Map<String, dynamic>>>( 
              future: _fetchModules(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No modules available'));
                }

                final modules = snapshot.data!;
                return DropdownButton<String>(
                  value: selectedModuleId,
                  hint: const Text('Select a Module'),
                  isExpanded: true,
                  items: modules.map((module) {
                    return DropdownMenuItem<String>(
                      value: module['id'],
                      child: Text(module['name'], style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedModuleId = value;
                      selectedModuleName = modules.firstWhere((module) => module['id'] == value)['name'];
                    });
                    if (value != null) {
                      _fetchLessons(value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 20),

            // Display lessons for the selected module
            if (selectedModuleId != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => _showAddLessonDialog(context, selectedModuleId!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Create Lesson'),
                  ),
                  const SizedBox(height: 20),

                  // Display lessons in a ListView
                  if (lessons.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 8,
                          child: ListTile(
                            title: Text(lesson['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            subtitle: Text(lesson['url'], style: const TextStyle(fontSize: 14)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _editLesson(
                                    context,
                                    selectedModuleId!,
                                    lesson['id'],
                                    lesson['name'],
                                    lesson['url'],
                                  ),
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                ),
                              TextButton(
  onPressed: () => _deleteLesson(selectedModuleId!, lesson['id']),
  child: Row(
    children: const [
      Icon(Icons.delete, color: Colors.red, size: 24),
      SizedBox(width: 8), // Optional: Adds spacing between the icon and text
      Text('Delete', style: TextStyle(color: Colors.red)),
    ],
  ),
)

                                
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  if (lessons.isEmpty)
                    const Text('No lessons available', style: TextStyle(fontSize: 16)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

