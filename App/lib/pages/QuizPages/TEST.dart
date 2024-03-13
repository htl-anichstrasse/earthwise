import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TestPage extends StatelessWidget {
  final List<Map<String, String>> continents = [
    {"name": "Nordamerika", "icon": "assets/icons/north_america.svg"},
    {"name": "Südamerika", "icon": "assets/icons/south_america.svg"},
    {"name": "Europa", "icon": "assets/icons/europe.svg"},
    {"name": "Afrika", "icon": "assets/icons/africa.svg"},
    {"name": "Asien", "icon": "assets/icons/asia.svg"},
    {"name": "Australien", "icon": "assets/icons/australia.svg"}
  ];

  TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wähle deinen Kontinent'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: continents.length,
          itemBuilder: (context, index) {
            print("ASDSADSAD");
            print(continents[index]);
            return GestureDetector(
              onTap: () {
                // Aktion bei Tipp auf Kontinent
              },
              child: Card(
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      continents[index]["icon"]!,
                      width: 75,
                      height: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(continents[index]["name"]!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
