import 'package:flutter/material.dart';
import 'package:earthwise/Pages/MainPages/Homepage/home_page.dart';
import 'package:earthwise/Pages/MainPages/Profilpage/profil_page.dart';
import 'package:earthwise/Pages/MainPages/Quizpage/quiz_page.dart';
import 'package:earthwise/Pages/MainPages/Searchpage/search_page.dart';

// Represents the main page that holds the navigation and page view for the app
class Mainpage extends StatefulWidget {
  const Mainpage({super.key, required this.page});

  // Initial page index
  final int page;

  @override
  State<Mainpage> createState() => _MainpageState();
}

// State class for Mainpage, managing page views and bottom navigation
class _MainpageState extends State<Mainpage> {
  // Current selected index for the bottom navigation bar
  late int bottomSelectedIndex = widget.page;

  // Controller for page view to manage page navigation programmatically
  late PageController pageController = PageController(
    initialPage: widget.page,
    keepPage: true,
  );

  // Builds the page view for swiping through pages
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        const Homepage(),
        QuizPage(),
        const SearchPage(),
        const ProfilPage(),
      ],
    );
  }

  // Updates the state when a new page is selected from the PageView
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  // Updates the state and navigates to the selected page when tapped on BottomNavigationBar
  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  // Builds the scaffold including the PageView and BottomNavigationBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  // Constructs the BottomNavigationBar
  Widget buildBottomNavBar() {
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
