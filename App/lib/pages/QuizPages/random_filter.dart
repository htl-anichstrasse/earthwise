import 'package:flutter/material.dart';
import 'package:maestro/Models/all_questions.dart';
import 'package:maestro/Models/country.dart';
// import 'package:g/slider.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:maestro/slider.dart';

class RandomFilter extends StatefulWidget {
  const RandomFilter({super.key});

  @override
  State<RandomFilter> createState() => _RandomFilterState();
}

int count = getAllQuestion().length;

class _RandomFilterState extends State<RandomFilter> {
  List<Widget> items = [];

  List<bool> itemsSelected = [true, true, true];

  Stack buildIconAndTextToggleButton(Icon icon, String text) {
    return Stack(
      alignment: Alignment.center,
      children: [
        icon,
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
    items.add(
      buildIconAndTextToggleButton(const Icon(Icons.flag), "Flags"),
    );
    items.add(
      buildIconAndTextToggleButton(const Icon(Icons.location_city), "Stadt"),
    );
    items.add(
      buildIconAndTextToggleButton(const Icon(Icons.landscape), "Land"),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 4, 101),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(Icons.home),
        ),
        title: const Text("Random-Filter"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50, width: double.infinity),
            const Text("Random-Filter:"),
            const SizedBox(height: 15),
            const Text("How many Quizzes you wanna play?"),
            const SizedBox(height: 5),
            const SliderWidget(),
            const SizedBox(height: 10),
            const Text("Kategorien"),
            const SizedBox(height: 10),
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  itemsSelected[index] = !itemsSelected[index];
                });
              },
              constraints: const BoxConstraints(
                minHeight: 60,
                minWidth: 60,
              ),
              borderWidth: 2,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              isSelected: itemsSelected,
              children: items,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, randomRoute,
                    arguments: Continent.world);
              },
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}

int getCountOfQuestions() {
  return count.toInt();
}
