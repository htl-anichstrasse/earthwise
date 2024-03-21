import 'package:flutter/material.dart';

// Function to show a dialog when time is up
void showTimeUpDialog(BuildContext context, String contentText,
    VoidCallback onGiveUpPressed, VoidCallback onContinuePressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Zeit vorbei'),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Schließt den Dialog

              onGiveUpPressed();
            },
            child: const Text('Aufgeben'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Schließt den Dialog

              onContinuePressed();
            },
            child: const Text('Weiterspielen'),
          ),
        ],
      );
    },
  );
}
