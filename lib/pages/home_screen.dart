import 'package:crypto_coin/pages/coins_screen.dart';
import 'package:crypto_coin/pages/configurations_screen.dart';
import 'package:crypto_coin/pages/favorites_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int actualPage = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: actualPage);
  }

  setActualPage(page) {
    setState(() {
      actualPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          CoinsScreen(),
          FavoritesScreen(),
          ConfigurationsScreen(),
        ],
        onPageChanged: setActualPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: actualPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Configurations'),
        ],
        onTap: (page) {
          pageController.animateToPage(
            page,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        backgroundColor: Colors.black38,
      ),
    );
  }
}
