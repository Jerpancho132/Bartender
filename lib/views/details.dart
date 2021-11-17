// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/models/recipe.dart';

import 'Widgets/ingredient_card.dart';

class Details extends StatefulWidget {
  final String title;
  final String imgUrl;
  final String instructions;
  const Details(
      {Key? key,
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
  //code for retrieving cocktail list from databse
  Future<List<Recipe>> fetchIngredients() async {
    var url = "http://10.0.2.2:8080/api/ingredients/cocktail/cosmopolitan";
    var response = await http.get(Uri.parse(url));

    var ingredients = <Recipe>[];

    if (response.statusCode == 200) {
      var ingredientsJson = json.decode(response.body);
      for (var ingredientJson in ingredientsJson) {
        ingredients.add(Recipe.fromJson(ingredientJson));
      }
    }
    return ingredients;
  }

  @override
  void initState() {
    fetchIngredients().then((value) {
      setState(() {
        _ingredients.addAll(value);
      });
    });
  }

  final List<Recipe> _ingredients = <Recipe>[];

  @override
  Widget build(BuildContext context) {
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
              Text(title,
                  style: GoogleFonts.sansita(
                      textStyle: const TextStyle(
                          color: Color(0xff2A8676),
                          letterSpacing: .5,
                          fontSize: 30))),
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
                  Text(_ingredients[2].ingredient,
                      style: GoogleFonts.sansita(
                          textStyle: const TextStyle(
                              color: Color(0xff2A8676),
                              letterSpacing: .5,
                              fontSize: 30))),
                  /*GridView.builder(
                      itemCount: _ingredients.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: IngredientCard(
                          ingredient: _ingredients[index].ingredient,
                          amount: _ingredients[index].amount,
                          unit: _ingredients[index].unit,
                        ));
                      }), */

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
