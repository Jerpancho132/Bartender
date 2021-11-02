import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/favorites.dart';
//import cocktail model package
import 'package:app/models/cocktail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _selectedIndex = 1;
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
        case 2:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
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

  //text editing controller
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        backgroundColor: const Color(0xffA63542),
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: "Search for a Cocktail",
                  contentPadding: EdgeInsets.only(left: 10)),
              onSubmitted: (e) {},
            ),
          ),
        ],
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
              backgroundColor: Color(0xffA63542)),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: ('Favorites'),
              backgroundColor: Color(0xffA63542)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: ('Inventory'),
              backgroundColor: Color(0xffA63542)),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color(0xffE8DFDA),
        onTap: _onItemTapped,
      ),
    );
  }
}
