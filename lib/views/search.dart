import 'package:flutter/material.dart';
import 'package:app/views/home.dart';
import 'package:app/views/inventory.dart';
import 'package:app/views/favorites.dart';
//import cocktail model package
import 'package:app/models/cocktail.dart';
//install firestore package
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _selectedIndex = 1;
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

  //collect data from snapshot and place them into list
  void addCocktail(QuerySnapshot qs, List<Cocktail> c) {
    for (int i = 0; i < qs.docs.length; i++) {
      DocumentSnapshot snap = qs.docs[i];
      c.add(Cocktail(snap.id, snap.get("Ingredients"), snap.get("Instructions"),
          snap.get("Picture")));
    }
  }

  //when this page is initiallized, this will be called and place the
  //collection of cocktails into the results variable
  Future<void> getData() async {
    final d = FirebaseFirestore.instance.collection("Drinks");
    QuerySnapshot snapshot = await d.get();
    setState(() {
      addCocktail(snapshot, result);
      search = result;
    });
    //set the editable list
  }

  //initialize database when state starts
  @override
  void initState() {
    //initialize filter for regions + local
    super.initState();
    //sets all the data when calling the function is complete
    getData().whenComplete(() {
      setState(() {});
    });
  }

  //initialize list with every cocktail in database
  //it should never be changed
  List<Cocktail> result = [];
  //editable List
  List<Cocktail> search = [];
  //text editing controller
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        title: Text("Search"),
      ),
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
                  hintText: "Search for a Cocktail",
                  contentPadding: EdgeInsets.only(left: 10)),
              onSubmitted: searchResult,
            ),
          ),
          Expanded(
              child: search.isNotEmpty
                  ? cocktailBuilder()
                  : const Center(
                      //when no data shows
                      child: Text("No Results",
                          style: TextStyle(color: Colors.black)),
                    ))
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
      ),
    );
  }

  //widget builder for the cocktails
  Widget cocktailBuilder() => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1),
      shrinkWrap: true,
      itemCount: search.length,
      itemBuilder: (context, index) {
        return buildContainer(search[index]);
      });
  //widget container for the cocktails
  Widget buildContainer(Cocktail c) => Column(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.network(c.picture),
          ),
          Text(
            c.name,
            style: TextStyle(color: Colors.black),
          )
        ],
      );
  //this function will go onSubmitted of textfield and change the
  //results of the cocktail based on the string
  void searchResult(String s) {
    //if string is empty, show result of all cocktails again or choose to show none
    setState(() {
      if (s.isEmpty) {
        search = result;
      } else {
        //make it so when you submit a new string
        //results show cocktails of that string
        final filteredSearch = result.where((e) {
          final name = e.name.toLowerCase();
          final search = s.toLowerCase();

          return name.contains(search);
        }).toList();
        //sets search to new filtered search by name
        search = filteredSearch;
      }
    });
  }
}
