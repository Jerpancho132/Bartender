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

  List glass = [
    'cocktail glass',
    'shot glass',
    'martini glass',
    'highball glass',
    'collins glass',
    'old-fashioned glass',
    'sour glass',
    'champagne flute',
    'margarita glass',
    'pilsner glass',
    'goupe glass',
    'beer mug',
    'copper mug',
    'pint glass',
    'hurricane glass',
    'wine glass'
  ];

  //cocktail glass,shot glass,martini glass,highball glass,collins glass,old-fashioned glass,sour glass,champagne flute
  //margarita glass, pilsner glass,coupe glass,beer mug,copper mug,pint glass,hurricane glass, wine glass

  //added list of ingredients to filter by;
  List _ingredientsFilter = [];
  List _glassFilter = [];
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
                    //snackbar in case there the item returned empty
                    final snackBar = SnackBar(
                        content:
                            const Text('Found no results from your search.'),
                        action: SnackBarAction(
                          label: 'hide',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ));
                    //Filter by given ingredients
                    filter =
                        await searchbyIngredients(filter, _ingredientsFilter);
                    //condition if the textfield has an input
                    //or if the filter buttons have been pressed
                    filter.isNotEmpty
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Results(result: filter)))
                        : ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          Expanded(
              child: ListView(
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
                        return filterButtons(
                            _ingredientsFilter, ingredients[index]);
                      })
                  : const Center(
                      child: Text('No ingredients data found'),
                    ),
              const Center(
                  child: Text(
                'Glass',
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
              //should create a grid view here that builds the
              //types of glass
              const Padding(padding: EdgeInsets.only(top: 10)),

              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4),
                  itemCount: glass.length,
                  itemBuilder: (BuildContext c, index) =>
                      filterButtons(_glassFilter, glass[index])),
            ],
          )),
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
  Widget filterButtons(List f, String i) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            //if clicked add to filters list
            addToFilter(f, i);
          });
          print(f);
        },
        child: Container(
            padding: const EdgeInsets.all(1),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: f.contains(i) ? Colors.red.shade700 : Colors.red.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                i,
                style: const TextStyle(fontSize: 14),
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

  //takes in a the filter list of varying category and the input;
  void addToFilter(List f, String x) {
    //if clicked add to filter list
    if (!f.contains(x)) {
      f.add(x);
    } else {
      //else remove from filters list
      f.remove(x);
    }
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
  //glasses
}
