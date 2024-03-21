import 'package:flutter/material.dart';
import 'package:earthwise/router/route_constants.dart';

// Represents the homepage screen of the app
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// State class for Homepage, contains UI logic
class _HomepageState extends State<Homepage> {
  // Icons for each option on the homepage
  final List<String> icons = [
    "assets/icons/quiz.png",
    "assets/icons/search.png",
    "assets/icons/profil.png",
  ];

  // Names for each option on the homepage
  final List<String> names = ["Quizze", "Search", "Profil"];

  // Route names for navigation
  final List<String> routes = [
    quizRoute,
    searchRoute,
    profilRoute,
  ];

  // Descriptive texts for each option
  final List<String> texts = [
    "Ready for a quiz challenge?",
    "Seeking a specific quiz?",
    "Time to review your stats!",
  ];

  // Builds the UI structure for the homepage
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
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.07),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                Text(
                  "EARTHWISE",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.045,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Image.asset('assets/app/icon.png', height: 90),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Expanded(
                  child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.045),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, mainRoute,
                                arguments: index + 1);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.145,
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
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(names[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.035)),
                                      Text(texts[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02)),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: index == 0 ? -35 : -25,
                                  right: 25,
                                  child: Image.asset(icons[index],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12),
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
