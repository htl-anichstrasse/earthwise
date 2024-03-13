import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/router/route_constants.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map> continents = [
    {"name": Continent.northAmerica, "icon": "assets/icons/north_america.svg"},
    {"name": Continent.southAmerica, "icon": "assets/icons/south_america.svg"},
    {"name": Continent.europe, "icon": "assets/icons/europe.svg"},
    {"name": Continent.africa, "icon": "assets/icons/africa.svg"},
    {"name": Continent.asia, "icon": "assets/icons/asia.svg"},
    {"name": Continent.oceania, "icon": "assets/icons/australia.svg"}
  ];

  final Color buttonColour = Colors.white30;
  final Color iconColour = const Color.fromARGB(200, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "EARTHWISE",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, selectionPageRoute,
                      arguments: Continent.world);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: buttonColour,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/world.svg",
                            width: 700,
                            color: iconColour,
                            height: 175,
                          ),
                          const Text("World",
                              style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GridView.builder(
                padding: EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: continents.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, selectionPageRoute,
                          arguments: continents[index]["name"]);
                    },
                    child: Card(
                      color: buttonColour,
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            continents[index]["icon"]!,
                            width: 100,
                            height: 100,
                            color: iconColour,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              getNameofContinent(continents[index]["name"]),
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
