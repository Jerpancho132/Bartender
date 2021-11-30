import 'package:app/views/ingredient_view.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/favorites.dart';
import 'package:app/models/ingredient.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart';

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

  void _navigateToDetails(Ingredient i, int index) {
    final route = MaterialPageRoute(
        builder: (context) => IngredientDetailsPage(test: i, num: index + 1));
    Navigator.of(context).push(route);
  }

  void setIngredients() async {
    final result = await getIngredientsModel(client);
    setState(() {
      ingredients = result
        ..sort((a, b) => a.title
            .toString()
            .toLowerCase()
            .compareTo(b.title.toString().toLowerCase()));
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    setIngredients();
  }

  List ingredients = [];
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 25),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Flexible(
              child: Text(
                'Dictionary',
                style: TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 30,
                child: ListView(children: [
                  const ListTile(
                    title: Text("Ingredients"),
                  ),
                  MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ingredients.length,
                          itemBuilder: (BuildContext c, index) {
                            return ingredientsTile(ingredients[index], index);
                          })),
                ]),
              ),
            ),
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

  Widget ingredientsTile(Ingredient i, int index) => ListTile(
        onTap: () {
          _navigateToDetails(i, index);
        },
        leading: Image(image: NetworkImage(i.image)),
        title: Text(
          i.title,
          style: TextStyle(color: Colors.black),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      );
}
