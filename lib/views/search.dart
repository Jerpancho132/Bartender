import 'package:app/views/favorites.dart';
import 'package:app/views/inventory.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _index = 1;
  final List<Widget> _options = <Widget>[
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const InventoryPage()
  ];

  void _onItemTap(int index) {
    setState(() {
      _index = index;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _options.elementAt(_index)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_drink),
            SizedBox(width: 10),
            Text('Search Page'),
          ],
        ),
      ),
      body: ListView(
        children: const [
          Text("Filter",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 2,
                  color: Color(0xffA63542))),
          Text("Popular",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 2,
                  color: Color(0xffA63542))),
        ],
      ),
      bottomNavigationBar: FloatingNavbar(
        onTap: _onItemTap,
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.search, title: 'Search'),
          FloatingNavbarItem(icon: Icons.star, title: 'Favorites'),
          FloatingNavbarItem(icon: Icons.local_drink, title: 'My Bar'),
        ],
        backgroundColor: const Color(0xffA63542),
        selectedBackgroundColor: const Color(0xffE8DFDA),
        unselectedItemColor: Colors.black,
        //margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
        borderRadius: 20,
        //doesnt seem to have border & border color
      ),
    );
  }
}
