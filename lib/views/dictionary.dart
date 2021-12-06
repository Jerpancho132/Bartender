import 'package:app/models/description.dart';
import 'package:app/views/dictionary_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/favorites.dart';
import 'package:app/models/ingredient.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart';
import 'package:app/data/tools.dart';
import 'package:flutter/painting.dart';

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

  void _navigateToDetails(
      String name, String image, String description, int index) {
    final route = MaterialPageRoute(
        builder: (context) => IngredientDetailsPage(
              num: index + 1,
              name: name,
              image: image,
              description: description,
            ));
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
      backgroundColor: const Color(0xffE8DFDA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Inventory",
          style: TextStyle(
              fontFamily: 'Roboto', fontSize: 32, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 30,
                child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(children: [
                      const ListTile(
                        title: Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //ingredients list view
                      MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ingredients.length,
                              itemBuilder: (BuildContext c, index) {
                                return ingredientsTile(
                                    ingredients[index], index);
                              })),
                      const ListTile(
                        title: Text(
                          "Tools",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //tools list view
                      MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tools.length,
                              itemBuilder: (BuildContext c, index) {
                                return descriptionTile(tools[index], index);
                              })),
                    ])),
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
          _navigateToDetails(i.title, i.image, i.description, index);
        },
        // leading: SizedBox(
        //   child: Image(
        //       height: 55, width: 55, image: NetworkImage(i.image, scale: 1)),
        // ),
        title: Text(
          i.title,
          style: const TextStyle(color: Colors.black),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      );
  Widget descriptionTile(Description i, int index) => ListTile(
        onTap: () {
          _navigateToDetails(i.name, i.image, i.description, index);
        },
        // leading: i.image.isNotEmpty
        //     ? SizedBox(
        //         child: Image(
        //             height: 55,
        //             width: 55,
        //             image: NetworkImage(i.image, scale: 1)),
        //       )
        //     : const SizedBox(
        //         height: 55,
        //         width: 55,
        //       ),
        title: Text(
          i.name,
          style: const TextStyle(color: Colors.black),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      );
}
