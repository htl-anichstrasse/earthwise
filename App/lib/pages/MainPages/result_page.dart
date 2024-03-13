import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/router/route_constants.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    Key? key,
    required this.percentage,
    required this.quizname,
    required this.time,
    required this.route,
    required this.continent,
  }) : super(key: key);

  final int percentage;
  final String quizname;
  final int time;
  final String route;
  final Continent continent;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 10, 199, 196), // Startfarbe
              Color.fromARGB(255, 4, 2, 104), // Endfarbe
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                Text(
                  "Ergebnis:",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white),
                ),
                const Divider(color: Colors.white54),
                Text(
                  "Quiz: ${widget.quizname}",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  "Time: ${widget.time}",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  "Du hast ${widget.percentage}% erreicht!",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 50),
                _buildButton(context, "Look at Quiz", () {
                  Navigator.pop(context);
                }),
                _buildButton(context, "Again?", () {
                  Navigator.pushNamed(context, widget.route,
                      arguments: widget.continent);
                }),
                _buildButton(context, "Go Back", () {
                  Navigator.pushNamed(context, selectionPageRoute,
                      arguments: widget.continent);
                }),
                _buildButton(context, "Home", () {
                  Navigator.pushNamed(context, mainRoute);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: Text(text),
      ),
    );
  }
}
