import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';
import 'package:app/views/Widgets/inventory_card.dart';
import 'package:app/views/favorites.dart';
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
    const InventoryPage()
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
      bottomNavigationBar: FloatingNavbar(
        onTap: _onItemTap,
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.search, title: 'Search'),
          FloatingNavbarItem(icon: Icons.star, title: 'Favorites'),
          FloatingNavbarItem(icon: Icons.local_drink, title: 'My Bar'),
        ],
        backgroundColor: const Color(0xffA63542),
        selectedBackgroundColor: const Color(0xffE8DFDA),
        unselectedItemColor: Colors.black,
        //margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
        borderRadius: 20,
        //doesnt seem to have border & border color
      ),
    );
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
