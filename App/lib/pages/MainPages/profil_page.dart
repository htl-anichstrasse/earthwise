import 'package:flutter/material.dart';
import 'package:maestro/Server/internet.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/Server/webapi.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/pages/QuizPages/progress_bar.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  int currentLevel = 5;
  double progress = 0.5;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data!;
            if (isLoggedIn) {
              return profilPage();
            } else {
              return guestPage();
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ein Fehler ist aufgetreten'));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget guestPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              checkInternet(context, loginRoute);
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              checkInternet(context, registrationRoute);
            },
            child: const Text('Registrierung'),
          ),
        ],
      ),
    );
  }

  Widget profilPage() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    setLevel(user.mail, 15500);

    return Container(
      alignment: Alignment.center,
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
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: IconButton(
                icon: const Icon(Icons.settings,
                    color: Color.fromARGB(255, 25, 2, 125), size: 40),
                onPressed: () {
                  Navigator.pushNamed(context, settingsRoute);
                },
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Image(
            image: AssetImage("assets/icons/profil.png"),
            width: 170,
          ),
          const SizedBox(height: 15),
          Text(user.username,
              style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 50),
          CustomProgressBar(
            level: (user.score / 1000).floor(),
            progress: (user.score % 1000) / 1000,
            width: 300,
          ),
        ],
      ),
    );
  }
}
