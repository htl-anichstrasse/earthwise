import 'package:flutter/material.dart';

// For each view, a separate class must be defined
class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  // Each class must have the build method implemented
  // This method returns the actual view, which consists of widgets
  @override
  Widget build(BuildContext context) {
    // The MaterialApp widget is the foundation of the view
    return MaterialApp(
      home: Scaffold(
        // The AppBar is automatically at the top and
        // contains the title of the page
        appBar: AppBar(
          // With the help of the Text widget, you can write text on the page
          title: const Text(
            "Earthwise",
          ),
        ),
        // The Center widget ensures that its child widget
        // is located in the middle of the screen
        body: const Center(
          child: Text(
            "Hello World",
          ),
        ),
      ),
    );
  }
}
