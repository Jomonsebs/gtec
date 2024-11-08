import 'package:flutter/material.dart';

import 'package:gtech/adminpanel.dart';
import 'package:gtech/coursehome.dart';
import 'package:gtech/modules.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedContent = 'Course Content';
  TextEditingController searchController = TextEditingController();

  void updateContent(String newContent) {
    setState(() {
      selectedContent = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Sidebar(
                  onMenuItemSelected: updateContent,
                  searchController: searchController),
              Expanded(
                child: ContentArea(
                  selectedContent: selectedContent,
                  searchController: searchController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final Function(String) onMenuItemSelected;
  final TextEditingController searchController;

  Sidebar({required this.onMenuItemSelected, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width < 700 ? double.infinity : 300,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserCard(),
            SizedBox(height: 20),
            SearchField(searchController: searchController),
            SizedBox(height: 20),
            // Make only MainMenu scrollable
            Expanded(
              child: SingleChildScrollView(
                child: MainMenu(onMenuItemSelected: onMenuItemSelected),
              ),
            ),
            SidebarButton(
              icon: Icons.settings,
              text: 'Settings',
              isSelected: false, // Update this if needed
              onTap: () => onMenuItemSelected('Settings'),
            ),
            SidebarButton(
              icon: Icons.logout,
              text: 'Sign Out',
              isSelected: false, // Update this if needed
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Adminpanel()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Icon on the left
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),

            // Information on the right
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  'Mishal Mehroof',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                // Email
                Text(
                  'Mishalgtec@gtec.com',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 8),

                // Role Badge
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    'Super Admin',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 66, 72, 80),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController searchController;

  SearchField({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blueGrey,
          ),
          labelText: 'Search...',
          labelStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color.fromARGB(255, 6, 7, 8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final Function(String) onMenuItemSelected;

  MainMenu({required this.onMenuItemSelected});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String selectedMenu = '';

  void updateSelectedMenu(String newMenu) {
    setState(() {
      selectedMenu = newMenu;
    });
    widget.onMenuItemSelected(newMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              'Main Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SidebarButton(
            icon: Icons.home,
            text: 'Dashboard',
            isSelected: selectedMenu == 'Dashboard',
            onTap: () => updateSelectedMenu('Dashboard'),
          ),
          _buildExpandableTile(
            icon: Icons.school,
            title: 'Course Management',
            children: [
              'Add New Course',
              'Manage Course',
              'Course Bundle',
            ],
            onMenuItemSelected: updateSelectedMenu,
          ),
          _buildExpandableTile(
            icon: Icons.quiz,
            title: 'Quiz Management',
            children: [
              'Add New Quiz',
              'Manage Quiz',
              'Quiz Overview',
            ],
            onMenuItemSelected: updateSelectedMenu,
          ),
          SidebarButton(
            icon: Icons.priority_high,
            text: 'Roles Manager',
            isSelected: selectedMenu == 'Roles Manager',
            onTap: () => updateSelectedMenu('Roles Manager'),
          ),
          SidebarButton(
            icon: Icons.person,
            text: 'Our Centers',
            isSelected: selectedMenu == 'Our Centers',
            onTap: () => updateSelectedMenu('Our Centers'),
          ),
          SidebarButton(
            icon: Icons.list,
            text: 'Students List',
            isSelected: selectedMenu == 'Students List',
            onTap: () => updateSelectedMenu('Students List'),
          ),
        ],
      ),
    );
  }

  ExpansionTile _buildExpandableTile({
    required IconData icon,
    required String title,
    required List<String> children,
    required Function(String) onMenuItemSelected,
  }) {
    bool isExpanded = selectedMenu == title;

    return ExpansionTile(
      leading: Icon(icon, color: isExpanded ? Colors.blue : Colors.blueGrey),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isExpanded ? Colors.blue : const Color.fromARGB(136, 0, 0, 0),
        ),
      ),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        if (expanded) updateSelectedMenu(title);
      },
      tilePadding:
          EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding as needed
      childrenPadding:
          EdgeInsets.only(left: 32.0), // Padding for the child items
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: Colors.transparent), // Remove top and bottom lines
      ),
      children: children.map((child) {
        return SidebarButton(
          icon: Icons.arrow_right,
          text: child,
          isSelected: selectedMenu == child,
          onTap: () => onMenuItemSelected(child),
        );
      }).toList(),
    );
  }
}

class SidebarButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  SidebarButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius:
              BorderRadius.circular(12), // Applies circular border to all sides
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.blueGrey,
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.blueGrey,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  final String selectedContent;
  final TextEditingController searchController;

  const ContentArea(
      {required this.selectedContent, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedContent,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: _buildContent(selectedContent)),
        ],
      ),
    );
  }

  Widget _buildContent(String selectedContent) {
    switch (selectedContent) {
      case 'Course Content':
        return Dash();
      case 'Priority Task':
        return ModulesList();
      case 'Contact Program Manager':
        return Center(child: Text('Contact details go here.'));
      case 'Raise a Pause Request':
        return Center(child: Text('Pause request form goes here.'));
      case 'Dashboard':
        return Dash();
      default:
        return Center(child: Text('Select a menu item.'));
    }
  }
}
