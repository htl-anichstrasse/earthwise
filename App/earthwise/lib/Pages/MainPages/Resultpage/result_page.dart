import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Server/webapi.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// Page for displaying quiz result
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

// State class for ResultPage
class _ResultPageState extends State<ResultPage> {
  void updateUser() async {
    final userProvider = Provider.of<UserProvider>(context);
    oldUser = userProvider.user;
    var p = await getUserData(oldUser.mail);
    var newUser = User(
      mail: oldUser.mail,
      password: oldUser.password,
      username: p["username"],
      score: p["level"],
    );
    await DatabaseHelper.instance.insertUser(newUser);
    userProvider.setUser(newUser);
  }

  late User oldUser;
  @override
  Widget build(BuildContext context) {
    updateUser();
    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  "Result: ${widget.quizname}",
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.white54, thickness: 1),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Image.asset(
                  "assets/icons/trophy.png",
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                const SizedBox(height: 20),
                Text(
                  "Time: ${widget.time} Seconds.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                Text(
                  "You achieved ${widget.percentage}%!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildSquareButton(
                        context, "Look at your Quiz", Icons.visibility, () {
                      Navigator.pop(context);
                    }),
                    _buildSquareButton(
                        context, "Play Again?", Icons.restart_alt, () {
                      Navigator.pushNamed(context, widget.route,
                          arguments: widget.continent);
                    }),
                    _buildSquareButton(
                        context, "Play more Quizzes?", Icons.arrow_back, () {
                      Navigator.pushNamed(context, selectionPageRoute,
                          arguments: widget.continent);
                    }),
                    _buildSquareButton(context, "Go Home", Icons.home, () {
                      Navigator.pushNamed(context, mainRoute);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build square button widget
  Widget _buildSquareButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    double size = MediaQuery.of(context).size.width / 2.5;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.pink, Colors.purple],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
