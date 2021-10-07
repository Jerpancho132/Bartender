import 'package:app/views/favorites.dart';
import 'package:app/views/inventory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/models/cocktail.dart';

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

  final _controller = TextEditingController();
  final db = FirebaseFirestore.instance.collection("Drinks");

  void addCocktail(QuerySnapshot qs, List<Cocktail> l) {
    for (int i = 0; i < qs.docs.length; i++) {
      DocumentSnapshot snap = qs.docs[i];
      l.add(Cocktail(snap.id, snap.get("Ingredients"), snap.get("Instructions"),
          snap.get("Picture")));
    }
  }

  //when this page is initiallized, this will be called and place the
  //collection of cocktails into the results variable
  Future<void> getData() async {
    final d = FirebaseFirestore.instance.collection("Drinks");
    QuerySnapshot snapshot = await d.get();
    addCocktail(snapshot, result);
  }

  List<Cocktail> result = [];

  //drawer variables
  List<String> spirits = ["Vodka", "Gin", "Tequila", "Whiskey", "Rum"];
  List<String> filter = [];
  List<int> filterindex = [];
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
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
                key: const Key("searchbar"),
                //this is the search bar that will filter out the dataset
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: "Search for Cocktail",
                    contentPadding: EdgeInsets.only(left: 10)),
                onChanged: searchCocktails,
              ),
            ),
            Expanded(
              child: cocktailBuilder(),
            )
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

  //the container for the filter options
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
          key: const Key("Filters"),
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
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

  //the item built from the dataset of ingredients
  Widget buildContainer(Cocktail c) => Column(
        //should expect to see all items before searching
        key: const Key("items"),
        children: [
          SizedBox(
              width: 150,
              height: 150,
              child: Image.network(
                c.imageUrl,
              )),
          Text(c.title)
        ],
      );
  Widget cocktailBuilder() => result.isNotEmpty
      ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1),
          shrinkWrap: true,
          itemCount: result.length,
          itemBuilder: (context, index) {
            return buildContainer(result[index]);
          })
      : const Center(
          //when you come across nothing in your search
          key: Key("NoResults"),
          child: Text("No Results"),
        );
  //the function that filters the dataset according to name of cocktail
  void searchCocktails(String s) async {
    final QuerySnapshot searchDB = await FirebaseFirestore.instance
        .collection("Drinks")
        .where("title", isGreaterThanOrEqualTo: s.toLowerCase())
        .where("title", isLessThanOrEqualTo: s.toLowerCase() + '\uf8ff')
        .get();

    setState(() {
      //removes everything from the list and add the new queried result
      result.removeRange(0, result.length);
      addCocktail(searchDB, result);
    });
  }
}
