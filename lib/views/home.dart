import 'package:app/views/Widgets/cocktail_card.dart';
import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 1:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          }
          break;
        case 2:
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
            Text('Home Page'),
          ],
        ),
      ),
      body: Column(
          //local drinks
          children: [
            Row(
              children: const [
                Text("Local Drinks",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 36,
                        letterSpacing: 2,
                        color: Color(0xffA63542))),
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: const [
                  RecipeCard(
                    title: 'Cocktail 2',
                    rating: '4.9',
                    cookTime: '30 min',
                    thumbnailUrl:
                        'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
                  ),
                  RecipeCard(
                    title: 'Cocktail 2',
                    rating: '4.9',
                    cookTime: '30 min',
                    thumbnailUrl:
                        'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
                  ),
                ],
              ),
            ),
            Row(
              children: const [
                Text("Popular Drinks",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 36,
                        letterSpacing: 2,
                        color: Color(0xffA63542))),
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: const [
                  RecipeCard(
                    title: 'Cocktail 2',
                    rating: '4.9',
                    cookTime: '30 min',
                    thumbnailUrl:
                        'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
                  ),
                  RecipeCard(
                    title: 'Cocktail 2',
                    rating: '4.9',
                    cookTime: '30 min',
                    thumbnailUrl:
                        'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
                  ),
                ],
              ),
            )
          ]),
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
