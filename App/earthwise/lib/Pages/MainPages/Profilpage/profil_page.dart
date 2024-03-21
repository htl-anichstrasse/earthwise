import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Elements/progress_bar.dart';
import 'package:earthwise/Server/internet.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// This page represents the user
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
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

  // Widget if the user is registered as guest
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

  double progress = 0;
  late User user;

  // Display the profil of the user
  Widget profilPage() {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;

    progress = user.score % 1000 / 1000;
    if (progress < 150) {
      progress = 150;
    }

    return Container(
      alignment: Alignment.center,
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
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
              child: IconButton(
                icon: Image.asset(
                  "assets/icons/trophy.png",
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, allHighscoresRoute);
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
              child: IconButton(
                icon: Icon(Icons.settings,
                    color: const Color.fromARGB(255, 25, 2, 125),
                    size: MediaQuery.of(context).size.height * 0.055),
                onPressed: () {
                  Navigator.pushNamed(context, settingsRoute);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        Image(
          image: const AssetImage("assets/icons/profil.png"),
          width: MediaQuery.of(context).size.height * 0.22,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        Text(user.username,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.055,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.045),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
          child: CustomProgressBar(
            level: (user.score / 1000).round(),
            progress: progress,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ]),
    );
  }
}
