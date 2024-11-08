import 'package:flutter/material.dart';

class ModulesList extends StatelessWidget {
  final List<Map<String, String>> modules = [
    {'name': 'Module 1', 'description': 'Description of Module 1'},
    {'name': 'Module 2', 'description': 'Description of Module 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 16),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return ModuleItem(name: module['name']!, description: module['description']!);
      },
    );
  }
}

class ModuleItem extends StatefulWidget {
  final String name;
  final String description;

  const ModuleItem({required this.name, required this.description});

  @override
  _ModuleItemState createState() => _ModuleItemState();
}

class _ModuleItemState extends State<ModuleItem> {
  bool showLessons = false;
  final List<String> lessons = ['Lesson 1', 'Lesson 2', 'Lesson 3'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.name, style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(widget.description),
            trailing: Icon(showLessons ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                showLessons = !showLessons;
              });
            },
          ),
          if (showLessons)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                children: lessons.map((lesson) {
                  return ListTile(
                    title: Text(lesson),
                    onTap: () => Navigator.pushNamed(context, '/lesson', arguments: lesson),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}