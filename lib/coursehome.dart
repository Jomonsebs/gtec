import 'package:flutter/material.dart';

class Dash extends StatefulWidget {
  const Dash({super.key});

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  int? selectedButton; // Track the selection state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the Column inside SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row with title, description, categories, and button
              Row(
                children: [
                  // Column for the first two texts on the left side
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Courses',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Manage your courses here.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  // Info text and button on the right side
                  Row(
                    children: [
                      Text('12 categories | 139 courses',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Create Course',
                            style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20), // Set text color to black
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Second Row with category and icon button
              Row(
                children: [
                  Text('Course Category', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit_document),
                    onPressed: () {},
                    tooltip: 'Edit Category',
                  ),
                  Container(
                    width: 800,
                    height: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Row for displaying the first 3 cards
              Row(
                children: [
                  // Card 1
                  GestureDetector(
                    onTap: () {
                      print("Card tapped!");
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Blue background section with image
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 160,
                                color: Color.fromARGB(255, 0, 86, 156),
                                child: Center(
                                  child: Image.asset(
                                    'assets/sap.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Lower part with text and icon
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SAP Cloud',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    IconButton(
                                      icon: Icon(Icons.edit_document,
                                          color: Colors.grey, size: 18),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between cards
                  // Add other cards here if necessary
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Action when the button is pressed
                      print('Prev button pressed');
                    },
                    child: Text(
                      'Prev',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          const Color.fromARGB(255, 0, 0, 0), // Text color
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                   InkWell(
                    onTap: () {
                      setState(() {
                        selectedButton = 1; // Set button 1 as selected
                      });
                      print("Button 1 tapped");
                    },
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedButton == 1
                            ? Colors.blue
                            : Colors.transparent, // Set selection color only for button 1
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedButton == 1
                              ? Colors.transparent
                              : Colors.black, // Add border for unselected buttons
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedButton == 1
                                ? Colors.white
                                : Colors.black, // Change text color when selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedButton = 2; // Set button 2 as selected
                      });
                      print("Button 2 tapped");
                    },
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedButton == 2
                            ? Colors.blue
                            : Colors.transparent, // Set selection color only for button 2
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedButton == 2
                              ? Colors.transparent
                              : Colors.black, // Add border for unselected buttons
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedButton == 2
                                ? Colors.white
                                : Colors.black, // Change text color when selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedButton = 3; // Set button 3 as selected
                      });
                      print("Button 3 tapped");
                    },
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedButton == 3
                            ? Colors.blue
                            : Colors.transparent, // Set selection color only for button 3
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedButton == 3
                              ? Colors.transparent
                              : Colors.black, // Add border for unselected buttons
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedButton == 3
                                ? Colors.white
                                : Colors.black, // Change text color when selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      // Action when the button is pressed
                      print('Next button pressed');
                    },
                    child: Text('Next'),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          const Color.fromARGB(255, 0, 0, 0), // Text color
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ), // Second Row with category and icon button
              Row(
                children: [
                  Text('Course Category', style: TextStyle(fontSize: 18)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit_document),
                    onPressed: () {},
                    tooltip: 'Edit Category',
                  ),
                  Container(
                    width: 800,
                    height: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 30), // Space between rows
              // Row for displaying the next 3 cards (duplicates of the first 3 cards)
              Row(
                children: [
                  // Card 4 (duplicate of Card 1)
                  GestureDetector(
                    onTap: () {
                      print("Card tapped!");
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Blue background section with image
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 160,
                                color: Color.fromARGB(255, 0, 86, 156),
                                child: Center(
                                  child: Image.asset(
                                    'assets/sap.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Lower part with text and icon
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SAP Cloud',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    IconButton(
                                      icon: Icon(Icons.edit_document,
                                          color: Colors.grey, size: 18),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between cards
                  // Add Card 5 and 6 as needed
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Action when the button is pressed
                      print('Prev button pressed');
                    },
                    child: Text(
                      'Prev',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          const Color.fromARGB(255, 0, 0, 0), // Text color
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                   InkWell(
                    onTap: () {
                      setState(() {
                        selectedButton = 4; // Set button 1 as selected
                      });
                      print("Button 1 tapped");
                    },
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedButton == 4
                            ? Colors.blue
                            : Colors.transparent, // Set selection color only for button 1
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedButton == 4
                              ? Colors.transparent
                              : Colors.black, // Add border for unselected buttons
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedButton == 4
                                ? Colors.white
                                : Colors.black, // Change text color when selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedButton = 5; // Set button 2 as selected
                      });
                      print("Button 2 tapped");
                    },
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedButton == 5
                            ? Colors.blue
                            : Colors.transparent, // Set selection color only for button 2
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedButton == 5
                              ? Colors.transparent
                              : Colors.black, // Add border for unselected buttons
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedButton == 5
                                ? Colors.white
                                : Colors.black, // Change text color when selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedButton = 6; // Set button 3 as selected
                      });
                      print("Button 3 tapped");
                    },
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedButton == 6
                            ? Colors.blue
                            : Colors.transparent, // Set selection color only for button 3
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedButton == 6
                              ? Colors.transparent
                              : Colors.black, // Add border for unselected buttons
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedButton == 6
                                ? Colors.white
                                : Colors.black, // Change text color when selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      // Action when the button is pressed
                      print('Next button pressed');
                    },
                    child: Text('Next'),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          const Color.fromARGB(255, 0, 0, 0), // Text color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}