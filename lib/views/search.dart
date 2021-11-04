import 'dart:convert';
import 'package:app/views/favorites.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/results.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/models/cocktail.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final int _selectedIndex = 1;
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

  Future<List<Cocktail>> getCocktails() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/'));

    if (response.statusCode == 200) {
      //gets json turn it to a iterable list
      Iterable list = json.decode(response.body);
      return list.map((e) => Cocktail.fromJson(e)).toList();
    } else {
      throw Exception('did not get response');
    }
  }

  //gets all the list of possible ingredients from the database
  Future<List> getIngredients() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/'));
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body);
      return data.map((e) => e['title']).toList();
    } else {
      throw Exception('could not get ingredients');
    }
  }

  //places the promise object into a list
  void setCocktails() async {
    final result = await getCocktails();
    setState(() {
      //initialize both base
      cocktailList = result;
      searchList = result;
    });
  }

  //places the promise ingredient into a list
  void setIngredients() async {
    final result = await getIngredients();
    setState(() {
      //initialize ingredients list
      ingredients = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCocktails();
    setIngredients();
  }

  //list of every possible ingredients in the database;
  List ingredients = [];
  //added list of ingredients to filter by;
  List filterIngredientsList = ['lmao'];
  //main only for reference
  List<Cocktail> cocktailList = [];
  //this is used for searching the list
  List<Cocktail> searchList = [];
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFE8DFDA),
        appBar: AppBar(
          backgroundColor: const Color(0xffA63542),
          title: Row(
            children: const [
              Text('Search Page'),
            ],
          ),
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
                  key: const Key("searchbar"),
                  //this is the search bar that will filter out the dataset
                  controller: _controller,
                  decoration: const InputDecoration(
                      hintText: "Search for Cocktail",
                      contentPadding: EdgeInsets.only(left: 10)),
                  onSubmitted: searchFunction),
            ),
            //should create a grid view here that builds the
            //list but shows nothing if the api call gets nothing.
            ElevatedButton(
                onPressed: () {
                  //condition if the textfield has an input
                  //or if the filter buttons have been pressed
                  if (_controller.text.isNotEmpty ||
                      filterIngredientsList.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Results(result: searchList)));
                  } else {
                    print('list is empty');
                  }
                },
                child: Text('Search')),
            //set up a list view for each type of filter categories
            //first category is ingredients, then age-range, then location
            ListView(
              shrinkWrap: true,
              children: [
                //setup a grid view of ingredient options
                ingredients.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4),
                        itemCount: ingredients.length,
                        itemBuilder: (BuildContext c, index) {
                          //replace this with buttons that will add
                          //them to the filter list
                          return Text(ingredients[index]);
                        })
                    : const Center(
                        child: Text('No Ingredients'),
                      ),
                //setup next grid view for next category
              ],
            )
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
      ),
    );
  }

  //searches for the
  void searchFunction(String s) {
    //starts the searchList with the full list
    print(ingredients);
    searchList = cocktailList;

    final filteredSearch = searchList.where((cocktail) {
      final titleLower = cocktail.title.toLowerCase();
      final searchLower = s.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
    setState(() {
      searchList = filteredSearch;
    });
  }
}
