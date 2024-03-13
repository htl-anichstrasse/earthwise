import 'package:flutter/material.dart';

void showTimeUpDialog(BuildContext context, String contentText,
    VoidCallback onGiveUpPressed, VoidCallback onContinuePressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Zeit vorbei'),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Schließt den Dialog

              onGiveUpPressed();
            },
            child: Text('Aufgeben'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Schließt den Dialog

              onContinuePressed();
            },
            child: Text('Weiterspielen'),
          ),
        ],
      );
    },
  );
}
