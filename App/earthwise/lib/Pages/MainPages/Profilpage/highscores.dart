import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Server/webapi.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// Displays the highscores page within the application
class DisplayAllHighscores extends StatefulWidget {
  const DisplayAllHighscores({super.key});

  @override
  State<DisplayAllHighscores> createState() => _DisplayAllHighscoresState();
}

// State class for DisplayAllHighscores
class _DisplayAllHighscoresState extends State<DisplayAllHighscores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Highscores",
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
        child: const Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: BuildHighscores(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to build and display the list of highscores
class BuildHighscores extends StatefulWidget {
  const BuildHighscores({super.key});

  @override
  State<BuildHighscores> createState() => _BuildHighscoresState();
}

// State class for BuildHighscores
class _BuildHighscoresState extends State<BuildHighscores> {
  late User user;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;

    return FutureBuilder<List<dynamic>?>(
      future: getHighscores(user.mail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text(
            'No Highscores available!',
            style: TextStyle(color: Colors.white, fontSize: 25),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final currentScore = snapshot.data![index];
              return FutureBuilder<String>(
                future: getQuizNameById(currentScore[1]),
                builder: (context, snapshotName) {
                  if (snapshotName.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading...'));
                  } else if (snapshotName.hasError) {
                    return const ListTile(
                        title: Text('Error loading quiz name'));
                  } else {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: ListTile(
                        title: Text(
                          snapshotName.data ?? 'Unknown Quiz Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Percentage: ${currentScore[2]} in ${currentScore[4]} Seconds!',
                          style: const TextStyle(fontSize: 16),
                        ),
                        tileColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
