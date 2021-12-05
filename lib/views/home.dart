import 'package:app/models/cocktail.dart';
import 'package:app/views/Widgets/cocktail_card.dart';
import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/favorites.dart';
import 'package:app/views/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart' as global;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //code for floating navbar
  int _index = 0;
  final List<Widget> _options = <Widget>[
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const InventoryPage(),
    const DictionaryPage()
  ];

  void _onItemTap(int index) {
    if (index != _index) {
      setState(() {
        _index = index;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => _options.elementAt(_index)),
        );
      });
    }
  }

  @override
  void initState() {
    getCocktails(global.client).then((value) {
      setState(() {
        _cocktails.addAll(value);
      });
    });
  }

  final List<Cocktail> _cocktails = <Cocktail>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        backgroundColor: const Color(0xffA63542),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_drink),
            SizedBox(width: 10),
            Text('Popular Drinks'),
          ],
        ),
      ),
      body: GridView.builder(
          itemCount: _cocktails.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Center(
                child: CocktailCard(
              cocktailName: _cocktails[index].title,
              thumbnailUrl: _cocktails[index].image,
              instructions: _cocktails[index].instruction,
            ));
          }),
      bottomNavigationBar: FloatingNavbar(
        onTap: _onItemTap,
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.search, title: 'Search'),
          FloatingNavbarItem(icon: Icons.star, title: 'Favorites'),
          FloatingNavbarItem(icon: Icons.local_drink, title: 'My Bar'),
          FloatingNavbarItem(icon: Icons.book, title: 'Dictionary'),
        ],
        backgroundColor: const Color(0xffA63542),
        selectedBackgroundColor: const Color(0xffE8DFDA),
        unselectedItemColor: Colors.black,
        //margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
        borderRadius: 10,
        fontSize: 10,
        //doesnt seem to have border & border color
      ),
    );
  }
}
