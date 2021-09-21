import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: new Color(0xFFE8DFDA),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink),
            SizedBox(width: 10),
            Text('Search Page'),
          ],
        ),
      ),
      body: ListView(
        children: [
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffA63542),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: new Text('Home'),
            backgroundColor: Color(0xffA63542),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: new Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: new Text('IDK'),
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        unselectedItemColor: Color(0xffE8DFDA),
      ),
    );
  }
}
