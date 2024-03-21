import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/SingleChoiceQuiz/prepare_scq.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';

// Widget for Single Choice Quiz Page
class SingleChoiceQuizPage extends StatefulWidget {
  const SingleChoiceQuizPage({
    Key? key,
    required this.country,
    required this.wrongs,
    required this.nextQ,
    required this.timer,
  }) : super(key: key);

  final String country;
  final List<String> wrongs;
  final VoidCallback nextQ;
  final SimpleTimer timer;

  @override
  _SingleChoiceQuizPageState createState() => _SingleChoiceQuizPageState();
}

class _SingleChoiceQuizPageState extends State<SingleChoiceQuizPage> {
  List<String> countries = [];
  Map<String, List<String>> spellings = getAllSpellings();
  late Color textColor = Colors.white;

  late String country = widget.country;
  late List<String> wrongs = widget.wrongs;

  double itemHeight = 2;
  double itemWidth = 3;

  @override
  void initState() {
    countries.add(country);
    countries.addAll(wrongs);
    countries.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.timer.startTimer();

    if (spellings[country.toUpperCase()]?[0] == null) {
      widget.nextQ();
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              spellings[country.toUpperCase()]![0],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: (itemWidth / itemHeight),
            children: List.generate(countries.length, (index) {
              return buildOptions(countries[index], itemWidth, itemHeight);
            }),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  // Widget to build options
  Widget buildOptions(String country, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => checkInput(country),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/${country.toLowerCase()}.png"),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  // Method to check user input
  void checkInput(String input) {
    widget.timer.stopTimer();

    Color tcolor;
    if (input.toLowerCase() == country.toLowerCase()) {
      tcolor = Colors.green;
      scqScore++;
    } else {
      tcolor = Colors.red;
    }

    setState(() {
      textColor = tcolor;
    });

    Future.delayed(const Duration(seconds: 1), () {
      try {
        widget.nextQ();
      } catch (e) {
        print("Error calling nextQ: $e");
      }
    });
  }
}
