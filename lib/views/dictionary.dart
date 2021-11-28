import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/favorites.dart';
import 'package:app/models/ingredient.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  int _index = 4;
  final List<Widget> _options = <Widget>[
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const InventoryPage(),
    const DictionaryPage()
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

  Ingredient test = Ingredient(
      id: 1,
      title: "Vodka",
      measurement: "oz",
      image: "https://www.thecocktaildb.com/images/ingredients/Vodka.png",
      description:
          "Vodka is a distilled beverage composed primarily of water and ethanol, sometimes with traces of impurities and flavorings.");
  Ingredient test2 = Ingredient(
      id: 2,
      title: "Scotch",
      measurement: "oz",
      image: "https://www.thecocktaildb.com/images/ingredients/Scotch.png",
      description:
          "Scotch whisky, often simply called Scotch, is malt whisky or grain whisky made in Scotland.");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 25),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              'Dictionary',
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(
                child: ExpansionTile(
              title: const Text('Ingredients'),
              children: [ingredientsTile(test), ingredientsTile(test2)],
            )),
          ],
        ),
      ),
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

  Widget ingredientsTile(Ingredient i) => InkWell(
        onTap: () {
          print(i.id);
          print(i.description);
        },
        child: ListTile(
          title: Text(i.title),
          trailing: const Icon(Icons.keyboard_arrow_right),
        ),
      );
}
