import 'package:flutter/material.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/pages/QuizPages/timer.dart';

class ReverseQuestion extends StatefulWidget {
  const ReverseQuestion({
    Key? key,
    required this.country,
    required this.wrongs,
    required this.timer,
    required this.nextQ,
  }) : super(key: key);

  final String country;
  final List<String> wrongs;
  final SimpleTimer timer;
  final VoidCallback nextQ;

  @override
  _ReverseQuestionState createState() => _ReverseQuestionState();
}

class _ReverseQuestionState extends State<ReverseQuestion> {
  List<String> countries = [];
  Map<String, List<String>> spellings = getAllSpellings();
  late Color textColor = Colors.black;

  double itemHeight = 2;
  double itemWidth = 3;

  @override
  void initState() {
    countries.add(widget.country);
    countries.addAll(widget.wrongs);
    countries.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.timer.startTimer();
    print(countries);

    return Column(
      children: [
        SizedBox(height: 20),
        Expanded(
          child: Center(
            child: Text(
              spellings[widget.country.toUpperCase()]![0],
              style: TextStyle(
                color: Colors.white,
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
            childAspectRatio: (itemWidth /
                itemHeight), // Stellen Sie diese Werte entsprechend ein
            children: List.generate(countries.length, (index) {
              return buildOptions(countries[index], itemWidth,
                  itemHeight); // Übergeben Sie itemWidth und itemHeight
            }),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  Widget buildOptions(String country, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => checkInput(country),
        child: AspectRatio(
          aspectRatio: 1, // Das Verhältnis könnte je nach Bild variieren
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit
                    .cover, // sorgt dafür, dass das Bild den Container ausfüllt
                image: AssetImage("assets/images/${country.toLowerCase()}.png"),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  void checkInput(String input) {
    widget.timer.stopTimer();

    Color tcolor;
    if (input.toLowerCase() == widget.country.toLowerCase()) {
      tcolor = Colors.green;
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
        print("Fehler beim Aufrufen von nextQ: $e");
      }
    });
  }
}
