// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/models/recipe.dart';
import 'package:app/resources/api_calls.dart';
import 'package:app/global.dart' as global;
import 'Widgets/ingredient_card.dart';

class Details extends StatefulWidget {
  final int id;
  final String title;
  final String imgUrl;
  final String instructions;
  const Details(
      {Key? key,
      required this.id,
      required this.title,
      required this.imgUrl,
      required this.instructions})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //variables to be replaced by database implementation
  bool selected = false;

  void setRecipe() async {
    final result = await fetchIngredients(global.client, widget.title);
    setState(() {
      _ingredients = result;
    });
    // print(_ingredients.map((e) => e.ingredient));
  }

  @override
  void initState() {
    super.initState();
    setRecipe();
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                    selected = !selected;
                  });
                },
                padding: const EdgeInsets.only(top: 25),
                iconSize: 35,
                color: Color(0xffA63542),
              ),
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xff2A8676),
                      width: 3,
                    ),
                    image: DecorationImage(
                        image: NetworkImage(imgUrl), fit: BoxFit.fill)),
              ),
            ),
            //Make new container here so the rest of the view scrolls together

            //list of ingredients
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ingredients",
                      style: GoogleFonts.sansita(
                          textStyle: const TextStyle(
                              color: Color(0xff2A8676),
                              letterSpacing: .5,
                              fontSize: 30))),
                  Flexible(
                    fit: FlexFit.tight,
                    child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _ingredients.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 2,
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: IngredientCard(
                                ingredient: _ingredients[index].ingredient,
                                amount: _ingredients[index].amount.toDouble(),
                                unit: _ingredients[index].unit,
                              ));
                            })),
                  ),
                  Text("Instructions",
                      style: GoogleFonts.sansita(
                          textStyle: const TextStyle(
                              color: Color(0xff2A8676),
                              letterSpacing: .5,
                              fontSize: 30))),
                  Container(
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffD98C82),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(inst,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.sansita(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                letterSpacing: .5,
                                fontSize: 15))),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
