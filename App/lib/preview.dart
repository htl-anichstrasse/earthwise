/*import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:maestro/Models/all_questions.dart';
import 'dart:io';

final country = flagQuestions[0];

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Name: ${country.answers[0]}",
            ),
            Image.asset(country.picture),
            Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
            const SizedBox(height: 24),
            Text(picture.name)
          ],
        ),
      ),
    );
  }
}
*/