import 'package:app/views/details.dart';
import 'package:app/views/dictionary.dart';
import 'package:app/views/search.dart';
import 'package:app/views/inventory.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:app/models/cocktail.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart' as global;
import 'package:app/resources/favorites_helper.dart';
import 'package:app/views/Widgets/favorites_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  List<Cocktail> cocktails = [];
  List<int> ids = [];
  int _index = 2;
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

  favoritescocktails() async {
    final data = await DatabaseHelper.instance.getList();
    List<int> c = [];
    for (var i = 0; i < data.length; i++) {
      c.add(data[i]['id']);
    }
    setState(() {
      ids = c;
    });
  }

  void searchbyId() async {
    final data = await DatabaseHelper.instance.getList();
    List<int> c = [];
    for (var i = 0; i < data.length; i++) {
      c.add(data[i]['id']);
    }
    List<Cocktail> d = [];
    for (var i = 0; i < c.length; i++) {
      var x = await getSingleCocktailById(global.client, c[i]);
      d.add(x);
    }
    setState(() {
      cocktails = d;
    });
    print(c);
    print(cocktails);
  }

  @override
  void initState() {
    searchbyId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
              fontFamily: 'Roboto', fontSize: 32, color: Colors.black),
        ),
      ),
      body: GridView.builder(
          itemCount: cocktails.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Center(
                child: redirectToDetails(
                    cocktails[index].id,
                    cocktails[index].name,
                    cocktails[index].image,
                    cocktails[index].instruction,
                    cocktails[index].glasstype));
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

  Widget redirectToDetails(int id, String name, String image,
          String instructions, String glass) =>
      GestureDetector(
        onTap: () async {
          final results = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Details(
                    id: id,
                    title: name,
                    imgUrl: image,
                    instructions: instructions,
                    glass: glass,
                  )));
          if (results) {
            setState(() {
              searchbyId();
            });
          }
        },
        child: favoritesCard(id, name, image, instructions, glass, context),
      );
}
