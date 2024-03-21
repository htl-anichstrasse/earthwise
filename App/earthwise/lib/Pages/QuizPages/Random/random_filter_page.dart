import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:earthwise/Pages/QuizPages/Random/slider.dart';

// RandomFilterPage class for handling random quiz filter settings
class RandomFilterPage extends StatefulWidget {
  const RandomFilterPage({super.key});

  @override
  State<RandomFilterPage> createState() => _RandomFilterPageState();
}

int count = 0;

class _RandomFilterPageState extends State<RandomFilterPage> {
  List<Widget> items = [];
  String? selectedContinent;

  final List<Continent> continents = getContinents();

  List<bool> categoriesSelected = [true, true, true, true];
  String basis = "assets/icons/";

  late List<String> images = [
    "${basis}city.png",
    "${basis}map.png",
    "${basis}mc.png",
    "${basis}flag.png"
  ];

  final List<String> names = ["Cities", "Map", "SCQ", "Flags"];

  // Method to build toggle buttons for categories
  Stack buildIconAndTextToggleButton(String image, String text) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          image,
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(text),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    items.clear();
    for (int i = 0; i < images.length; i++) {
      items.add(
        buildIconAndTextToggleButton(images[i], names[i]),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 15,
        title: const Text(
          "Random Quiz",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, mainRoute, arguments: 3);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 10, 199, 196),
              Color.fromARGB(255, 4, 2, 104),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.3),
              const Text(
                "How many Quizzes?",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const SliderWidget(),
              const SizedBox(height: 20),
              const Text(
                "Which Region?",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: selectedContinent,
                  hint: Text("Wähle eine Option",
                      style: TextStyle(color: Colors.grey[800])),
                  icon: const Icon(Icons.arrow_downward,
                      color: Colors.deepPurple),
                  iconSize: 24,
                  elevation: 16,
                  style:
                      const TextStyle(color: Colors.deepPurple, fontSize: 18),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedContinent = newValue;
                    });
                  },
                  items: continents
                      .map<DropdownMenuItem<String>>((Continent value) {
                    return DropdownMenuItem<String>(
                      value: getNameofContinent(value),
                      child: Text(getNameofContinent(value)),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Categories",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildToggleIcon(0),
                  buildToggleIcon(1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildToggleIcon(2),
                  buildToggleIcon(3),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GestureDetector(
                  onTap: () {
                    startRandomQuiz();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 75,
                    margin: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft, // Startpunkt des Verlaufs
                        end: Alignment.bottomRight, // Endpunkt des Verlaufs
                        colors: [
                          Colors.pink,
                          Colors.purple,
                        ],
                      ), // Farbe des Buttons
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rundung der Ecken
                    ),
                    child: const Center(
                      child: Text(
                        "Play",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Method to start a random quiz based on selected settings
  void startRandomQuiz() {
    String name = selectedContinent ?? "World";
    Continent continent = getContinentByName(name);
    int count = getCountOfQuestions();
    List<QuizType> types = getQuizTypes();
    Navigator.pushNamed(context, randomRoute,
        arguments: [types, count, continent]);
  }

// Method to get the selected quiz types based on user's selection
  List<QuizType> getQuizTypes() {
    List<QuizType> types = [
      QuizType.tablequiz,
      QuizType.mapquiz,
      QuizType.scq,
      QuizType.flagquiz
    ];
    List<QuizType> choosenTypes = [];
    for (int i = 0; i < categoriesSelected.length; i++) {
      if (categoriesSelected[i]) {
        choosenTypes.add(types[i]);
      }
    }
    if (choosenTypes.isEmpty) {
      return types;
    }
    return choosenTypes;
  }

// Method to build toggle icons for quiz categories
  Widget buildToggleIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          categoriesSelected[index] = !categoriesSelected[index];
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          color: categoriesSelected[index] ? Colors.white70 : Colors.red[300],
          border: Border.all(
            color:
                categoriesSelected[index] ? Colors.red[600]! : Colors.red[900]!,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(index == 0 ? 8 : 0),
            topRight: Radius.circular(index == 1 ? 8 : 0),
            bottomLeft: Radius.circular(index == 2 ? 8 : 0),
            bottomRight: Radius.circular(index == 3 ? 8 : 0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              images[index],
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(names[index]),
          ],
        ),
      ),
    );
  }
}

int getCountOfQuestions() {
  return count.toInt();
}
