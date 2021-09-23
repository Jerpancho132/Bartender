import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  final int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
          break;
        case 1:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          }
          break;
        case 3:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InventoryPage()),
            );
          }
          break;
      }
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
            Text('Favorites'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffA63542),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ('Home'),
            backgroundColor: Color(0xffA63542),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: ('Search'),
            backgroundColor: Color(0xffA63542),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: ('Favorites'),
            backgroundColor: Color(0xffA63542),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: ('Inventory'),
            backgroundColor: Color(0xffA63542),
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color(0xffE8DFDA),
      ),
    );
  }
}
