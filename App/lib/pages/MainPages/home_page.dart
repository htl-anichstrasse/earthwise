import 'package:flutter/material.dart';
import 'package:maestro/router/route_constants.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> icons = [
    "assets/icons/quiz.png",
    "assets/icons/search.png",
    "assets/icons/profil.png"
  ];
  final List<String> names = ["Quizze", "Search", "Profil"];
  final List<String> routes = [quizRoute, searchRoute, profilRoute];
  final List<String> texts = [
    "Ready for a quiz challenge?",
    "Seeking a specific quiz?",
    "Time to review your stats!"
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  "EARTHWISE",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Image.asset('assets/app/icon.png', height: 90),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Expanded(
                  child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, mainRoute,
                                arguments: index + 1);
                          },
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.pink, Colors.purple],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(22),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(names[index],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 27)),
                                      Text(texts[index],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: index == 0 ? -35 : -25,
                                  right: 30,
                                  child: Image.asset(icons[index], height: 100),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
