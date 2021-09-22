import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';
import 'package:app/views/Widgets/inventory_card.dart';

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
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          }
          break;
      }
    });
  }

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
        appBar: AppBar(title: const Text("Inventory")),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                  flex: 3,
                  child:
                      ingredientsTextField()), //refactored widget for inputting ingredients
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
                      return InventoryCard(
                          //imported from views/Widgets/inventory_card.dart
                          item: items[index].getIngredient,
                          amount: items[index].getAmount);
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
  Widget ingredientsTextField() => TextField(
        decoration: const InputDecoration(hintText: "Ingredient"),
        controller: iCtrl,
        onChanged: (text) {
          setState(() {
            ing = text;
          });
        },
      );
  //widget to insert given amount of ingredient.
  Widget amountTextfield() => TextField(
        decoration: const InputDecoration(hintText: "0"),
        controller: aCtrl,
        onChanged: (text) {
          setState(() {
            amnt = text.isNotEmpty ? int.parse(text) : 0;
          });
        },
      );
  //widget to output given ingredient and amount in list.
  Widget insertItemButton() => ElevatedButton(
      onPressed: () {
        setState(() {
          iCtrl.clear();
          aCtrl.clear();
          items.add(MyInventory(ing, amnt));
        });
      },
      child: const Icon(Icons.add));
}
