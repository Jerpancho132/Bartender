import 'package:app/views/favorites.dart';
import 'package:app/views/inventory.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/testdata/cocktail_listdata.dart';
import 'package:app/models/cocktail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final int _selectedIndex = 1;
  final _controller = TextEditingController();
  List<Cocktail> result = cocktailList;
  List<String> spirits = ["Vodka", "Gin", "Tequila", "Whiskey", "Rum"];
  String search = "";

  List<String> filter = [];
  List<int> filterindex = [];
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFE8DFDA),
        appBar: AppBar(
          backgroundColor: const Color(0xffA63542),
          title: Row(
            children: const [
              Text('Search Page'),
            ],
          ),
        ),
        drawer: Drawer(
            elevation: 30,
            child: Container(
                height: 100,
                color: Colors.red[200],
                child: ListView(children: [
                  const SizedBox(
                    height: 50,
                    child: DrawerHeader(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        child: Text(
                          "Filter",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "Roboto", fontSize: 30),
                        )),
                  ),
                  const Text(
                    "Spirits",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 3),
                    itemCount: spirits.length,
                    itemBuilder: (BuildContext c, i) {
                      return spiritsCard(spirits[i], i);
                    },
                  ),
                ]))),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: "Search for Cocktail",
                    contentPadding: EdgeInsets.only(left: 10)),
                onChanged: searchCocktails,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      // ignore: non_constant_identifier_names
                      return buildList(result[index]);
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
      ),
    );
  }

  Widget spiritsCard(String f, int i) => GestureDetector(
        onTap: () {
          setState(() {
            if (!filterindex.contains(i)) {
              //adds the item into the filter list
              //and also adds the index of the card;
              filter.add(f);
              filterindex.add(i);
            } else {
              filterindex.remove(i);
              filter.remove(f);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: filterindex.contains(i)
                ? const Color(0xFFA63542)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            f,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget buildList(Cocktail c) => ListTile(
        leading: Image.network(
          c.imageUrl,
          fit: BoxFit.fill,
          width: 50,
          height: 50,
        ),
        title: Text(c.title),
      );

  void searchCocktails(String s) {
    final filteredsearch = cocktailList.where((cocktail) {
      final titleLower = cocktail.title.toLowerCase();
      final searchLower = s.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      search = s;
      result = filteredsearch;
    });
  }
}
