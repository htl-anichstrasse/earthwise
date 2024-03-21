import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/SingleFlag/prepare_single_flag.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';

// SingleFlagPage class for displaying a single flag guessing quiz page
class SingleFlagPage extends StatefulWidget {
  const SingleFlagPage({super.key, required this.country, required this.timer});
  final String country;
  final SimpleTimer timer;

  @override
  State<SingleFlagPage> createState() => _SingleFlagPageState();
}

// _SingleFlagPageState class handling the state of the SingleFlagPage
class _SingleFlagPageState extends State<SingleFlagPage> {
  String result = "";
  final flagQuestionController = TextEditingController();
  int counter = 0;

  bool disableTextField = true;

  late String country = widget.country;
  late final SimpleTimer _timer = widget.timer;
  bool onFirstChange = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              "Quiz: Guess the following flag!",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset("assets/images/${country.toLowerCase()}.png"),
            ),
            const SizedBox(height: 25),
            TextField(
              enabled: disableTextField,
              controller: flagQuestionController,
              onSubmitted: (tQuestionController) {
                submitted();
              },
              onChanged: (value) {
                if (onFirstChange) {
                  onFirstChange = false;
                  _timer.startTimer();
                }
              },
              cursorColor: const Color.fromARGB(255, 27, 4, 101),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color.fromARGB(255, 27, 4, 101),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      submitted();
                    },
                    child: const Text("Check"),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Result: $result",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle the submission of the answer
  void submitted() {
    result = "Wronggg";
    String? check =
        checkAnswer(flagQuestionController.text.toLowerCase(), [country]);
    if (check != null) {
      result = "Correct!!!";
      scorePoints++;
      _timer.stopTimer();
    }

    setState(() {
      disableTextField = false;
      result;
    });
  }
}
