import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';
import 'package:app/views/favorites.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:app/global.dart' as global;
import 'package:app/resources/api_calls.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/resources/database_helper.dart';
import 'package:app/views/results.dart';
import 'package:app/models/cocktail.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:app/views/dictionary.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<InventoryPage> {
  dynamic listinventory;
  bool editable = false;
  List<Cocktail> filter = [];
  List<Cocktail> cocktailList = [];
  List<Cocktail> searchList = [];
  List _ingredientsFilter = [];

  int _index = 3;
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

  void _navigateToResultsPage(BuildContext context) {
    final route =
        MaterialPageRoute(builder: (context) => Results(result: filter));
    Navigator.of(context).push(route);
  }

  void setIngredients() async {
    final result = await getIngredients(global.client);
    var l = List<String>.from(result);
    setState(() {
      //initialize ingredients list
      //double dot is cascade notation
      ingredients = l;
    });
  }

  void setMeasurements() async {
    final result = await getMeasurements(global.client);
    var l = List<String>.from(result);
    setState(() {
      //initialize measurements list
      //double dot is cascade notation
      measurement = l;
    });
  }

  void setCocktails() async {
    final result = await getCocktails(global.client);
    setState(() {
      //initialize both base
      cocktailList = result;
      searchList = result;
    });
  }

  update() async {
    setState(() {
      ingredients;
      measurement;
    });
  }

  _insert(String p, int a, String m) async {
    int repeat = 0;
    Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: p,
      DatabaseHelper.columnAmount: a,
      DatabaseHelper.columnMeasurement: m,
    };

    for (var i = 0; i < _ingredientsFilter.length; i++) {
      if (_ingredientsFilter[i] == p) {
        await db.update('my_table', row, where: 'name = ?', whereArgs: [p]);
      }
    }

    if (repeat == 0) {
      await db.insert(DatabaseHelper.table, row);
    }
  }

  Future<void> listF() async {
    final datalist = await DatabaseHelper.instance.getList();
    List<MyInventory> data = [];
    _ingredientsFilter = [];
    String inv = '';
    int a;
    String m;
    for (var i = 0; i < datalist.length; i++) {
      inv = datalist[i]['name'];
      a = datalist[i]['amount'];
      m = datalist[i]['measurement'];
      data.add(MyInventory(inv, a, m));
      _ingredientsFilter.add(datalist[i]['name']);
    }
    setState(() {
      items = [];
      items = data;
    });

    print(_ingredientsFilter);
  }

  Future<void> delete(String product) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'my_table',
      where: 'name = ?',
      whereArgs: [product],
    );
    _ingredientsFilter.remove(product);
  }

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

  @override
  void initState() {
    setIngredients();
    setMeasurements();
    setCocktails();
    listF();
    super.initState();
  }

  List<String> ingredients = [];
  List<String> measurement = [];

  // these data should be grabbed from a database when implemented
  List<MyInventory> items = <MyInventory>[];
  //grabs the entire database get collection by .collection

  //the index should match the index of the ingredients list
  //the general measurement used in cocktails are ounces but could be ml too
  // ignore: prefer_typing_uninitialized_variables
  var selectedIngredient;
  // ignore: prefer_typing_uninitialized_variables
  var relatedMeasurement;
  int amnt = 0;
  final TextEditingController aCtrl = TextEditingController();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              color: const Color(0xffA63542),
              child: ListTile(
                  title: Row(children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    child: ingredientsDropdownField(),
                    height: 50,
                  ),
                ),
                //refactored widget for inputting ingredients
                const Padding(
                    padding: EdgeInsets.only(
                        right: 10)), //seperate ingredient and amount
                Expanded(
                  child: SizedBox(
                    child: amountTextfield(),
                    height: 30,
                  ),
                ),
                Expanded(
                    child: SizedBox(
                  child: relatedMeasurement != null
                      ? Text(
                          relatedMeasurement,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        )
                      : const Text(""),
                )),
                //refactored widget for amount of items in bottom
                Expanded(
                    child:
                        insertItemButton()) //refactored widget find in bottom
              ])),
            ),
          ),
          ElevatedButton(
              key: const Key('navigateToResults'),
              style: ElevatedButton.styleFrom(primary: Color(0xffA63542)),
              onPressed: () async {
                //initialize a new list that first takes in the search list
                filter = searchList;
                //snackbar in case there the item returned empty
                final snackBar = SnackBar(
                    content: const Text('Found no results from your search.'),
                    action: SnackBarAction(
                      label: 'hide',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ));
                //Filter by given ingredients
                filter = await searchbyIngredients(filter, _ingredientsFilter);
                print(filter);
                filter.isNotEmpty
                    ? _navigateToResultsPage(context)
                    : ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('See Recommended Cocktails')),
          Expanded(
              child: ListView.builder(
                  key: Key(items.length.toString()),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return listOfIngredients(index);
                  })),
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

  Widget ingredientsDropdownField() {
    return DropdownButton(
      dropdownColor: const Color(0xFFD98C82),
      style: const TextStyle(color: Colors.white),
      items: ingredients.map((String value) {
        return DropdownMenuItem(child: Text(value), value: value);
      }).toList(),
      value: selectedIngredient,
      onChanged: (dynamic val) {
        print(val);
        setState(() {
          selectedIngredient = val;
          relatedMeasurement = measurement[ingredients.indexOf(val)];
        });
      },
      isExpanded: true,
      hint: const Text(
        "Choose Ingredient",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  //widget to insert given amount of ingredient.
  Widget amountTextfield() => TextField(
        key: const Key("amountText"),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            hintText: "0", hintStyle: TextStyle(color: Colors.white)),
        controller: aCtrl,
        onChanged: (text) {
          setState(() {
            if (isNumeric(text) && isInteger(num.parse(text))) {
              amnt = int.parse(text);
            } else {
              amnt = 0;
            }
          });
        },
      );
  //widget to output given ingredient and amount in list.
  Widget insertItemButton() => ElevatedButton(
      key: const Key("insertButton"),
      style: ButtonStyle(
          alignment: Alignment.center,
          backgroundColor: MaterialStateProperty.all(const Color(0xffD98C82)),
          shape: MaterialStateProperty.all(const CircleBorder())),
      onPressed: () {
        setState(() {
          _insert(selectedIngredient, amnt, relatedMeasurement);
          listF();
          aCtrl.clear();
          selectedIngredient != null
              ? items.add(
                  MyInventory(selectedIngredient, amnt, relatedMeasurement))
              : null;
          amnt = 0;
        });
      },
      child: const Icon(Icons.add));

  Widget listOfIngredients(int i) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 5,
              child: listCard(items[i].getIngredient, items[i].getAmount,
                  items[i].getMeasurement, i)),
        ],
      );
  Widget listCard(String i, int a, String m, int index) => Card(
        key: Key('List$index'),
        color: const Color(0xffA63542),
        child: ListTile(
            title: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  i,
                  style: const TextStyle(color: Colors.white),
                )),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: editable
                    ? TextField(
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            hintText: items[index].getAmount.toString()),
                        onSubmitted: (val) {
                          setState(() {
                            //changes the amount of already placed tile
                            if (isNumeric(val) && isInteger(num.parse(val))) {
                              items[index].amount = int.parse(val);
                            }
                          });
                          editable = false;
                        },
                      )
                    : Text(
                        '$a',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                onTap: () {
                  setState(() {
                    editable = true;
                  });
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  m,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
            Expanded(
                child: IconButton(
              key: const Key("deleteButton"),
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  delete(i);
                  listF();
                  //items.removeAt(index);
                });
              },
            ))
          ],
        )),
      );
}

bool isNumeric(String s) {
  // ignore: unnecessary_null_comparison
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

bool isInteger(num value) {
  if (value is int) {
    return true;
  }
  return false;
}
