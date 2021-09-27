import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';
import 'package:app/views/Widgets/inventory_card.dart';
import 'package:app/views/favorites.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<InventoryPage> {
  final int _selectedIndex = 3;

  get onPressed => null;
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
    MyInventory("Orange Juice", 3, 'oz'),
    MyInventory("Lemon Juice", 2, 'oz')
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
        appBar: AppBar(title: const Text("Inventory")),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                  flex: 3,
                  child:
                      ingredientsDropdownField()), //refactored widget for inputting ingredients
              const Padding(
                  padding: EdgeInsets.only(
                      right: 10)), //seperate ingredient and amount
              Expanded(
                  child:
                      amountTextfield()), //refactored widget for amount of items in bottom
              Expanded(
                  child: insertItemButton()) //refactored widget find in bottom
            ]),
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
        decoration: const InputDecoration(hintText: "0"),
        controller: aCtrl,
        onChanged: (text) {
          setState(() {
            if (isNumeric(text)) {
              amnt = text.isNotEmpty ? int.parse(text) : 0;
            }
          });
        },
      );
  //widget to output given ingredient and amount in list.
  Widget insertItemButton() => ElevatedButton(
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
              flex: 3,
              child: InventoryCard(
                //imported from views/Widgets/inventory_card.dart
                item: items[i].getIngredient,
                amount: items[i].getAmount,
                measurement: items[i].getMeasurement,
              )),
          Expanded(
              child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                items.removeAt(i);
              });
            },
          ))
        ],
      );
}

bool isNumeric(String s) {
  // ignore: unnecessary_null_comparison
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
