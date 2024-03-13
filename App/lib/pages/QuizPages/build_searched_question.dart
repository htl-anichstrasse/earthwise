import 'package:flutter/material.dart';

class BuildSearchedQ extends StatefulWidget {
  const BuildSearchedQ({super.key, required this.title});

  final String title;

  @override
  State<BuildSearchedQ> createState() => _BuildSearchedQState();
}

class _BuildSearchedQState extends State<BuildSearchedQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 4, 101),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.home),
        ),
        title: const Text("Searched Question"),
      ),
      body: Column(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("") // BuildFlagQuestion(
                  //getQuestionFromTitle(widget.title),
                  //),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: const Size(120, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Abbrechen"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
