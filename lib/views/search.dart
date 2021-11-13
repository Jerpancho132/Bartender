import 'package:app/views/favorites.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/models/cocktail.dart';
import 'package:flutter/painting.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart' as global;

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

  //places the promise object into a list
  void setCocktails() async {
    final result = await getCocktails(global.client);
    setState(() {
      //initialize both base
      cocktailList = result;
      searchList = result;
    });
  }

  //places the promise ingredient into a list
  void setIngredients() async {
    final result = await getIngredients(global.client);
    setState(() {
      //initialize ingredients list
      //double dot is cascade notation
      ingredients = result..sort();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCocktails();
    setIngredients();
  }

  //list of every possible ingredients in the database initialized
  List ingredients = [];

  //added list of ingredients to filter by;
  List _ingredientsFilter = [];
  //initial list only for reference
  List<Cocktail> cocktailList = [];
  //this is used for filtering the list from given categories
  List<Cocktail> searchList = [];
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: TextField(
                      key: const Key("searchfield"),
                      //this is the search bar that will filter out the dataset
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Search for Cocktail",
                          contentPadding: EdgeInsets.only(left: 10)),
                      onChanged: searchFunction),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    //initialize a new list that first takes in the search list
                    List<Cocktail> filter = searchList;
                    //Filter by given ingredients
                    filter =
                        await searchbyIngredients(filter, _ingredientsFilter);
                    //condition if the textfield has an input
                    //or if the filter buttons have been pressed
                    if (filter.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Results(result: filter)));
                    } else {
                      //shows a small notification bar in the bottom
                      //search result came out empty.
                      final snackBar = SnackBar(
                          content:
                              const Text('Found no results from your search.'),
                          action: SnackBarAction(
                            label: 'hide',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Search')),
              const Padding(padding: EdgeInsets.only(right: 10))
            ],
          ),
          const Center(
              child: Text(
            'Filters',
            style: TextStyle(
              fontSize: 25,
            ),
          )),
          const Padding(padding: EdgeInsets.only(top: 10)),
          //set up a list view for each type of filter categories
          //first category is ingredients, then age-range, then location
          ListView(
            shrinkWrap: true,
            children: [
              //setup a grid view of ingredient options
              const Center(
                  child: Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
              //should create a grid view here that builds the
              //list of ingredients but shows nothing if the api call gets nothing.
              const Padding(padding: EdgeInsets.only(top: 10)),
              //this is the gridview for the ingredients filter buttons
              ingredients.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                        return ingredientCard(ingredients[index]);
                      })
                  : const Center(
                      child: Text('No ingredients data found'),
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
    );
  }

  //filter button widget for each ingredient
  Widget ingredientCard(String i) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            //if clicked add to filters list
            if (!_ingredientsFilter.contains(i)) {
              _ingredientsFilter.add(i);
            } else {
              //else remove from filters list
              _ingredientsFilter.remove(i);
            }
            print(_ingredientsFilter);
          });
        },
        child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _ingredientsFilter.contains(i)
                  ? Colors.red.shade700
                  : Colors.red.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                i,
                style: const TextStyle(fontSize: 15),
              ),
            )),
      );
  //searches for the list of cocktail by input string
  void searchFunction(String s) {
    //starts the searchList with the full list
    print(searchList.map((e) => e.title).toList());
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

  //function to filter list by ingredients;
  Future<List<Cocktail>> searchbyIngredients(List<Cocktail> f, List i) async {
    List ids = [];
    if (i.isNotEmpty) {
      if (f.isNotEmpty) {
        for (int x = 0; x < i.length; x++) {
          ids.addAll(await getCocktailsbyIngredient(global.client, i[x]));
        }
        //makes ids distinct
        ids = ids.toSet().toList();
        //filters the searchlist which has already been filtered by
        //searchFunction and further filters it by ingredients
        final _filteredSearch = f.where((cocktail) {
          return ids.contains(cocktail.id);
        }).toList();
        return _filteredSearch;
      } else {
        //just return the empty list if empty
        return f;
      }
    } else {
      //returns search list empty if nothing to filter by
      return f;
    }
  }
}
