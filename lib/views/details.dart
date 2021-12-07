// ignore_for_file: prefer_const_constructors
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/models/recipe.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart' as global;
import 'Widgets/ingredient_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/resources/favorites_helper.dart';

class Details extends StatefulWidget {
  final int id;
  final String title;
  final String imgUrl;
  final String instructions;
  final String glass;
  const Details(
      {Key? key,
      required this.id,
      required this.title,
      required this.imgUrl,
      required this.instructions,
      required this.glass})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<int> ids = [];
  //variables to be replaced by database implementation
  bool selected = false;

  void setRecipe() async {
    final result = await fetchIngredients(global.client, widget.title);
    setState(() {
      _ingredients = result;
    });
    // print(_ingredients.map((e) => e.ingredient));
  }

  favoritescocktails(int id) async {
    final data = await DatabaseHelper.instance.getList();
    List<int> c = [];
    for (var i = 0; i < data.length; i++) {
      c.add(data[i]['id']);
    }
    for (var i = 0; i < c.length; i++) {
      if (c[i] == id) {
        setState(() {
          selected = true;
        });
      }
    }
    setState(() {
      ids = c;
    });
  }

  insertFavorite(int id, bool val) async {
    Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {DatabaseHelper.columnId2: id};
    if (val == true) {
      for (var i = 0; i < ids.length; i++) {
        if (id == widget.id) {
          await db.delete('cocktails', where: 'id = ?', whereArgs: [id]);
        }
      }
    } else {
      await db.insert(DatabaseHelper.table, row);
    }
    print(await db.query(DatabaseHelper.table));
  }

  @override
  void initState() {
    super.initState();
    setRecipe();
    favoritescocktails(widget.id);
  }

  List<Recipe> _ingredients = <Recipe>[];

  @override
  Widget build(BuildContext context) {
    print("current length is: ");
    print(_ingredients.length);
    return Scaffold(
      backgroundColor: const Color(0xffE8DFDA),
      body: detailLayout(widget.title, widget.imgUrl, widget.instructions),
    );
  }

  Widget detailLayout(String title, String imgUrl, String inst) {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 10),
        //padding: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //image detail
          children: [
            Flexible(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      padding: const EdgeInsets.only(top: 25),
                      iconSize: 35,
                      icon: const Icon(Icons.arrow_back),
                      color: Color(0xffA63542),
                    ),
                    Flexible(
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sansita(
                              textStyle: const TextStyle(
                                  color: Color(0xff2A8676),
                                  letterSpacing: .5,
                                  fontSize: 30))),
                    ),
                    IconButton(
                      icon: Icon(selected ? Icons.star : Icons.star_border),
                      onPressed: () {
                        setState(() {
                          insertFavorite(widget.id, selected);
                          selected = !selected;
                        });
                      },
                      padding: const EdgeInsets.only(top: 25),
                      iconSize: 35,
                      color: Color(0xffA63542),
                    ),
                  ]),
            ),
            //Make new container here so the rest of the view scrolls together
            //list of ingredients
            SizedBox(
                height: MediaQuery.of(context).size.height - 75,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: SafeArea(
                        bottom: true,
                        child: ListView(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Color(0xff2A8676),
                                      width: 3,
                                    ),
                                    image: DecorationImage(
                                        image: NetworkImage(imgUrl),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                            Text("Glass",
                                style: GoogleFonts.sansita(
                                    textStyle: const TextStyle(
                                        color: Color(0xff2A8676),
                                        letterSpacing: .5,
                                        fontSize: 30))),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 3,
                                      crossAxisSpacing: 2,
                                      crossAxisCount: 3),
                              children: [glassContainer()],
                            ),
                            Text("Ingredients",
                                style: GoogleFonts.sansita(
                                    textStyle: const TextStyle(
                                        color: Color(0xff2A8676),
                                        letterSpacing: .5,
                                        fontSize: 30))),
                            MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _ingredients.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 3,
                                            crossAxisSpacing: 2,
                                            crossAxisCount: 3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Center(
                                          child: IngredientCard(
                                        ingredient:
                                            _ingredients[index].ingredient,
                                        amount: _ingredients[index]
                                            .amount
                                            .toDouble(),
                                        unit: _ingredients[index].unit,
                                      ));
                                    })),
                            Text("Instructions",
                                style: GoogleFonts.sansita(
                                    textStyle: const TextStyle(
                                        color: Color(0xff2A8676),
                                        letterSpacing: .5,
                                        fontSize: 30))),
                            Container(
                              padding: EdgeInsets.all(8),
                              height: MediaQuery.of(context).size.height / 5.2,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: Color(0xffD98C82),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: AutoSizeText(inst,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.sansita(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          letterSpacing: .5,
                                          fontSize: 15))),
                            ),
                          ],
                        ),
                      )),
                ))
          ],
        ));
  }

  Widget glassContainer() => Container(
        width: 30,
        height: 50,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xffD98C82),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Align(
          child: AutoSizeText(
            widget.glass,
            maxLines: 3,
            minFontSize: 10,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
