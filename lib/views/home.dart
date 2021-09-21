import 'package:bar_app/views/Widgets/cocktail_card.dart';
import 'package:bar_app/views/search.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    }

    return Scaffold(
      backgroundColor: new Color(0xFFE8DFDA),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink),
            SizedBox(width: 10),
            Text('Home Page'),
          ],
        ),
      ),
      body: ListView(
        children: [
          Text("Local Drinks",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 2,
                  color: Color(0xffA63542))),
          RecipeCard(
            title: 'Cocktail 1',
            rating: '4.9',
            cookTime: '30 min',
            thumbnailUrl:
                'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
          ),
          Text("Popular",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 2,
                  color: Color(0xffA63542))),
          RecipeCard(
            title: 'Cocktail 2',
            rating: '4.9',
            cookTime: '30 min',
            thumbnailUrl:
                'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
          ),
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
        currentIndex: _selectedIndex,
        unselectedItemColor: Color(0xffE8DFDA),
        onTap: _onItemTapped,
      ),
    );
  }
}
