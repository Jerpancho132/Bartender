import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/search.dart';
import 'package:app/models/inventory_model.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<InventoryPage> {
  final int _selectedIndex = 3;
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

  List<MyInventory> items = <MyInventory>[];
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
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Ingredient"),
                    controller: iCtrl,
                    onChanged: (text) {
                      setState(() {
                        ing = text;
                      });
                    },
                  )),
              const Padding(
                  padding: EdgeInsets.only(
                      right: 10)), //seperate ingredient and amount
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(hintText: "0"),
                controller: aCtrl,
                onChanged: (text) {
                  setState(() {
                    amnt = text.isNotEmpty ? int.parse(text) : 0;
                  });
                },
              )),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          iCtrl.clear();
                          aCtrl.clear();
                          items.add(MyInventory(ing, amnt));
                        });
                      },
                      child: const Icon(Icons.add)))
            ]),
            Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return InventoryList(
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
}

//template for adding an inventory
class InventoryList extends StatefulWidget {
  final String item;
  final int amount;
  const InventoryList({
    Key? key,
    required this.item,
    required this.amount,
  }) : super(key: key);
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${widget.item} with amount ${widget.amount}'),
      ),
    );
  }
}
