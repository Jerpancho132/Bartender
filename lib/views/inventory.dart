import 'package:app/views/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';
import 'package:app/views/favorites.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:app/global.dart' as global;
import 'package:app/resources/api_calls.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<InventoryPage> {
  int _index = 3;
  final List<Widget> _options = <Widget>[
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const InventoryPage(),
    const DictionaryPage()
  ];

  dynamic listinventory;
  final int _selectedIndex = 3;
  bool editable = false;
  void _onItemTap(int index) {
    setState(() {
      _index = index;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _options.elementAt(_index)),
      );
    });
  }

  void setIngredients() async {
    final result = await getIngredients(global.client);
    var l = List<String>.from(result);
    setState(() {
      //initialize ingredients list
      //double dot is cascade notation
      ingredients = l..sort();
    });
  }

  void setMeasurements() async {
    final result = await getMeasurements(global.client);
    var l = List<String>.from(result);
    setState(() {
      //initialize ingredients list
      //double dot is cascade notation
      measurement = l;
    });
  }

  update() async {
    setState(() {
      ingredients;
      measurement;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory(); //file path

    return directory.path; //returns file path
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/inven.txt'); //make a path variable
  }

  Future<void> listFile() async {
    final file = await _localFile;
    dynamic data;
    final _datafile = file.openRead();
    data = await _datafile
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    setState(() {
      listinventory = data;
    });
  }

  Future<List<MyInventory>> _inventorylist() async {
    List<MyInventory> catalog = <MyInventory>[];
    final file = await _localFile;
    final contents = await file.readAsString().then((p) {
      for (String i in const LineSplitter().convert(p)) {
        catalog.add(MyInventory(i, 0));
      }
    });
    return catalog;
  }

  Future<File> writeFile(String name, int amt, String measurement) async {
    final file = await _localFile;
    String v = amt.toString();

    String product = ',' + name + ' ' + v + ' ' + measurement;
    return file.writeAsString(product,
        mode: FileMode.append); //writes the string in the function to the file
  }

  _setup() async {
    List<MyInventory> catalog = await _inventorylist();
    setState(() {
      items = catalog;
    });
  }

  Future<File> deletefromfile(String object) async {
    dynamic _delete;
    String products = '';
    print(object);
    int count = 0;
    final file = await _localFile;
    final _myFile = File('$file/inv.txt');

    final _datafile = file.openRead();
    _delete = await _datafile
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    for (var i = 0; i < _delete[0].length; i++) {
      if (_delete[0][i] == object || _delete[0][i] == '') {
        print(_delete[0][i]);
      } else {
        if (count == 0 && _delete[0][i] != object) {
          products += _delete[0][i];
          count++;
        } else {
          products += ',' + _delete[0][i];
          count++;
        }
      }
    }

    return file.writeAsString(products);
  }

  @override
  void initState() {
    setIngredients();
    setMeasurements();
    super.initState();
    listFile();
  }

  List<String> ingredients = [];
  List<String> measurement = [];
  //grabs the entire database get collection by .collection

  //the index should match the index of the ingredients list
  //the general measurement used in cocktails are ounces but could be ml too
  // ignore: prefer_typing_uninitialized_variables
  var selectedIngredient;
  // ignore: prefer_typing_uninitialized_variables
  var relatedMeasurement;

  List<MyInventory> items = <MyInventory>[
    MyInventory("orange", 3),
    MyInventory("lemon", 2)
  ];
  String ing = "";
  int amnt = 0;
  final TextEditingController iCtrl = TextEditingController();
  final TextEditingController aCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA4BFB3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Inventory",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 32),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              color: const Color(0xFF2A8676),
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
          listinventory == null
              ? Container()
              : Expanded(
                  child: ListView.builder(
                      key: Key(listinventory[0].length.toString()),
                      itemCount: listinventory[0].length,
                      itemBuilder: (context, index) {
                        //return listOfIngredients(index);
                        return ListTile(
                          key: Key("List"),
                          title: Row(
                            children: [
                              Expanded(child: Text(listinventory[0][index])),
                              Expanded(
                                  child: IconButton(
                                // ignore: prefer_const_constructors
                                key: Key("deleteButton"),
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    deletefromfile(listinventory[0][index]);
                                    listFile();
                                    _setup();
                                  });
                                },
                              )),
                            ],
                          ),
                          //leading: Icon(Icons.invert_colors),
                          //title: Text(listinventory[0][index]),
                        );
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

  //widget to insert ingredients you own.
  Widget ingredientsDropdownField() {
    return DropdownButton(
      dropdownColor: const Color(0xFF31A471),
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
          backgroundColor: MaterialStateProperty.all(const Color(0xFF31A471)),
          shape: MaterialStateProperty.all(const CircleBorder())),
      onPressed: () {
        setState(() {
          print(
            selectedIngredient,
          );
          print(amnt);
          print(relatedMeasurement);
          writeFile(selectedIngredient, amnt, relatedMeasurement);
          _inventorylist();
          _setup();
          listFile();
          aCtrl.clear();
          selectedIngredient != null
              ? items.add(MyInventory(selectedIngredient, amnt))
              : null;
          amnt = 0;
        });
      },
      child: const Icon(Icons.add));
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
