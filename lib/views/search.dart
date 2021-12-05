import 'package:app/views/dictionary.dart';
import 'package:app/views/favorites.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/results.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/models/cocktail.dart';
import 'package:flutter/painting.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart' as global;

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/rendering.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ///
  int _index = 1;
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

  ///

  void _navigateToResultsPage(BuildContext context) {
    final route =
        MaterialPageRoute(builder: (context) => Results(result: filter));
    Navigator.of(context).push(route);
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
    'Cocktail glass',
    'Highball glass',
    'Champagne flute',
    'Copper mug',
    'Margarita glass',
    'Rocks glass',
    'Martini glass',
    'Beer mug',
    'Collins glass',
    'Shot glass',
    'Wine glass',
    'Sour glass',
    'Brandy snifter',
    'Cordial galss',
    'Coffee cup',
    'Coffee mug'
  ];

  List type = [];

  //cocktail glass,shot glass,martini glass,highball glass,collins glass,old-fashioned glass,sour glass,champagne flute
  //margarita glass, pilsner glass,coupe glass,beer mug,copper mug,pint glass,hurricane glass, wine glass

  //added list of ingredients to filter by;
  final List _ingredientsFilter = [];
  final List _glassFilter = [];
  //types
  PrimitiveWrapper alcohol = PrimitiveWrapper(0);
  PrimitiveWrapper nonAlcoholic = PrimitiveWrapper(0);
  PrimitiveWrapper classic = PrimitiveWrapper(0);
  PrimitiveWrapper tropical = PrimitiveWrapper(0);
  PrimitiveWrapper local = PrimitiveWrapper(0);
  //initial list only for reference
  List<Cocktail> cocktailList = [];
  //this is used for filtering the list from given categories
  List<Cocktail> searchList = [];
  List<Cocktail> filter = [];
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
                  key: const Key('navigateToResults'),
                  onPressed: () async {
                    //initialize a new list that first takes in the search list
                    filter = searchList;
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
                    //Filter by given glass types
                    filter = await searchByGlass(filter, _glassFilter);
                    //filter by types if it is 1
                    //else just return same list;
                    filter = await searchByAlcoholic(filter, alcohol);
                    filter = await searchByNonAlcoholic(filter, nonAlcoholic);
                    filter = await searchByClassic(filter, classic);
                    filter = await searchByTropical(filter, tropical);
                    filter = await searchByLocal(filter, local);
                    //condition if the textfield has an input
                    //or if the filter buttons have been pressed
                    filter.isNotEmpty
                        ? _navigateToResultsPage(context)
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
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    key: const Key('Scrollable'),
                    shrinkWrap: true,
                    children: [
                      //type
                      const Center(
                          child: Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4),
                        children: [
                          filterTypeButtons(alcohol, "Alcoholic"),
                          filterTypeButtons(nonAlcoholic, "Non-Alcoholic"),
                          filterTypeButtons(classic, "Classic"),
                          filterTypeButtons(tropical, "Tropical"),
                          filterTypeButtons(local, "Local"),
                        ],
                      ),
                      //glass type
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 2,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4),
                          itemCount: glass.length,
                          itemBuilder: (BuildContext c, index) =>
                              filterButtons(_glassFilter, glass[index])),
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
                              child: Text('Error Loading Ingredients'),
                            ),
                    ],
                  ))),
        ],
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

  //filter button widget for each ingredient
  Widget filterButtons(List f, String i) => GestureDetector(
        key: Key('key-$i'),
        behavior: HitTestBehavior.opaque,
        //if clicked add to filters list
        onTap: () {
          setState(() {
            addToFilter(f, i);
          });
          //print(f);
        },
        child: Container(
            padding: const EdgeInsets.all(1),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: f.contains(i) ? Colors.red.shade700 : Colors.red.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            //flutter plugin for auto sizing text
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                i,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                minFontSize: 10,
                maxLines: 2,
              ),
            )),
      );
  Widget filterTypeButtons(PrimitiveWrapper type, String i) => GestureDetector(
        key: Key('key-$i'),
        behavior: HitTestBehavior.opaque,
        //if clicked add to filters list
        onTap: () {
          setState(() {});
          if (type.val == 0) {
            type.val = 1;
          } else {
            type.val = 0;
          }
          //print(i);
          //print(type.val);
        },
        child: Container(
            padding: const EdgeInsets.all(1),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: type.val == 1 ? Colors.red.shade700 : Colors.red.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                i,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
                minFontSize: 10,
                maxLines: 2,
              ),
            )),
      );
  //searches for the list of cocktail by input string
  void searchFunction(String s) {
    //starts the searchList with the full list
    //print(searchList.map((e) => e.title).toList());
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
  Future<List<Cocktail>> searchByGlass(List<Cocktail> f, List g) async {
    List ids = [];
    if (g.isNotEmpty) {
      if (f.isNotEmpty) {
        for (int x = 0; x < g.length; x++) {
          ids.addAll(await getCocktailsByGlass(global.client, g[x]));
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

  Future<List<Cocktail>> searchByAlcoholic(
      List<Cocktail> f, PrimitiveWrapper a) async {
    if (a.val == 1) {
      if (f.isNotEmpty) {
        List ids = await getCocktailsByAlcoholic(global.client);
        final _filteredSearch =
            f.where((cocktail) => ids.contains(cocktail.id)).toList();
        return _filteredSearch;
      } else {
        return f;
      }
    }
    return f;
  }

  Future<List<Cocktail>> searchByNonAlcoholic(
      List<Cocktail> f, PrimitiveWrapper a) async {
    if (a.val == 1) {
      if (f.isNotEmpty) {
        List ids = await getCocktailsByNonAlcoholic(global.client);
        final _filteredSearch =
            f.where((cocktail) => ids.contains(cocktail.id)).toList();
        return _filteredSearch;
      } else {
        return f;
      }
    }
    return f;
  }

  Future<List<Cocktail>> searchByClassic(
      List<Cocktail> f, PrimitiveWrapper a) async {
    if (a.val == 1) {
      if (f.isNotEmpty) {
        List ids = await getCocktailsByClassic(global.client);
        final _filteredSearch =
            f.where((cocktail) => ids.contains(cocktail.id)).toList();
        return _filteredSearch;
      } else {
        return f;
      }
    }
    return f;
  }

  Future<List<Cocktail>> searchByTropical(
      List<Cocktail> f, PrimitiveWrapper a) async {
    if (a.val == 1) {
      if (f.isNotEmpty) {
        List ids = await getCocktailsByTropical(global.client);
        final _filteredSearch =
            f.where((cocktail) => ids.contains(cocktail.id)).toList();
        return _filteredSearch;
      } else {
        return f;
      }
    }
    return f;
  }

  Future<List<Cocktail>> searchByLocal(
      List<Cocktail> f, PrimitiveWrapper a) async {
    if (a.val == 1) {
      if (f.isNotEmpty) {
        List ids = await getCocktailsByLocal(global.client);
        final _filteredSearch =
            f.where((cocktail) => ids.contains(cocktail.id)).toList();
        return _filteredSearch;
      } else {
        return f;
      }
    }
    return f;
  }
}

//allows us to modify a primitive datatype by reference
class PrimitiveWrapper {
  int val;
  PrimitiveWrapper(this.val);
}
