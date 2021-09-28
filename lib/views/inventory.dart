import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';
import 'package:app/views/favorites.dart';
import 'package:flutter/services.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<InventoryPage> {
  final int _selectedIndex = 3;
  bool editable = false;
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
        case 1:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
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
      }
    });
  }

  // these data should be grabbed from a database when implemented
  List<MyInventory> items = <MyInventory>[
    MyInventory("Orange Juice", 3, 'Oz'),
    MyInventory("Lemon Juice", 2, 'Oz')
  ];
  //this could also be grabbed from a database
  static List ingredients = [
    "Orange Juice",
    "Lime Juice",
    "Gin",
    "Angostura Bitters",
    "Ice"
  ];
  //this list matches directly with the ingredients. this could be
  //replaced when database is implemented
  static List msrment = ["Oz", "Oz", "Oz", "dash", ""];

  //the index should match the index of the ingredients list
  //the general measurement used in cocktails are ounces but could be ml too
  String ing = ingredients.first;
  int amnt = 0;
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
                color: Color(0xFF2A8676),
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

                  //refactored widget for amount of items in bottom
                  Expanded(
                      child:
                          insertItemButton()) //refactored widget find in bottom
                ])),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return listOfIngredients(index);
                    })),
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
                backgroundColor: Color(0xffA63542)),
            BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: ('Favorites'),
                backgroundColor: Color(0xffA63542)),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: ('Inventory'),
                backgroundColor: Color(0xffA63542)),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: const Color(0xffE8DFDA),
          onTap: _onItemTapped,
        ));
  }

  //widget to insert ingredients you own.
  Widget ingredientsDropdownField() => DropdownButton(
      style: TextStyle(color: Colors.white),
      dropdownColor: Color(0xFFA4BFB3),
      isExpanded: true,
      value: ing,
      onChanged: (nval) {
        setState(() {
          ing = nval.toString();
        });
      },
      items: ingredients.map((valItem) {
        return DropdownMenuItem(
          value: valItem,
          child: Text(valItem),
        );
      }).toList());
  //widget to insert given amount of ingredient.
  Widget amountTextfield() => TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            hintText: "0", hintStyle: TextStyle(color: Colors.white)),
        controller: aCtrl,
        onChanged: (text) {
          setState(() {
            if (isNumeric(text) && isInteger(num.parse(text))) {
              amnt = text.isNotEmpty ? int.parse(text) : 0;
            }
          });
        },
      );
  //widget to output given ingredient and amount in list.
  Widget insertItemButton() => ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF31A471)),
          shape: MaterialStateProperty.all(const CircleBorder())),
      onPressed: () {
        setState(() {
          aCtrl.clear();
          items.add(MyInventory(ing, amnt, msrment[ingredients.indexOf(ing)]));
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
        color: const Color(0xFF2A8676),
        child: ListTile(
            title: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  i,
                  style: TextStyle(color: Colors.white),
                )),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: editable
                    ? TextField(
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: items[index].getAmount.toString()),
                        onSubmitted: (val) {
                          setState(() {
                            //changes the amount of already placed tile
                            if (isNumeric(val) && isInteger(num.parse(val))) {
                              items[index].changeAmount(int.parse(val));
                            }
                          });
                          editable = false;
                        },
                      )
                    : Text(
                        '$a',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
            Expanded(
                child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  items.removeAt(index);
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
  return double.tryParse(s) != null;
}

bool isInteger(num value) {
  if (value is int) {
    return true;
  }
  return false;
}
