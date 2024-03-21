import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// Defines an asynchronous function to check for an internet connection.
Future<bool> hasInternetConnection() async {
  // Checks the current connectivity status (mobile, wifi, none, etc.).
  var result = await Connectivity().checkConnectivity();

  // Returns true if the connectivity result is either mobile data or wifi.
  return result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi;
}

void checkInternet(BuildContext context, String route) async {
  if (await hasInternetConnection()) {
    Navigator.pushNamed(context, route);
  } else {
    noInternetPopUp(context, "Fehlende Internetverbinung",
        "Sie benötigen eine Internetverbindung um sich anzumelden!");
  }
}

Future noInternetPopUp(BuildContext context, String title, String content) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(content),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
