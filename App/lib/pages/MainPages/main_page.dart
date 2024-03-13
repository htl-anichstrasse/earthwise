import 'package:flutter/material.dart';
import 'package:maestro/multilingualism/language_constants.dart';
import 'package:maestro/pages/MainPages/home_page.dart';
import 'package:maestro/pages/MainPages/profil_page.dart';
import 'package:maestro/pages/MainPages/quiz_page.dart';
import 'package:maestro/pages/MainPages/search_page.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key, required this.page});

  final int page;

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  late int bottomSelectedIndex = widget.page;

  late PageController pageController = PageController(
    initialPage: widget.page,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Homepage(),
        QuizPage(),
        const SearchPage(),
        const ProfilPage(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavBat(),
    );
  }

  Widget buildBottomNavBat() {
    return BottomNavigationBar(
      currentIndex: bottomSelectedIndex,
      onTap: (index) {
        bottomTapped(index);
      },
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      unselectedFontSize: 0,
      selectedFontSize: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 5, 1, 77),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(label: "Homepage", icon: Icon(Icons.apps)),
        BottomNavigationBarItem(label: "Quizpage", icon: Icon(Icons.quiz)),
        BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
        BottomNavigationBarItem(label: "Profilpage", icon: Icon(Icons.person)),
      ],
    );
  }
}
