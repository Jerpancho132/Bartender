// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //variables to be replaced by database implementation
  String title = "Gimlet";
  String imgUrl =
      "https://www.thecocktaildb.com/images/media/drink/3xgldt1513707271.jpg";
  List<String> ingredients = [
    "Gin",
    "Lime Juice",
    "Sugar Syrup",
    "Lime",
  ];
  List<String> instructions = ["step1", "step2", "step3", "step4"];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            Expanded(
                child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.star_border),
            ))
          ],
        ),
      ),
      body: Column(
        //image detail
        children: [
          Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(imgUrl))),
              )),
          //ingredients section
          Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Ingredients",
                  style: TextStyle(
                      color: Color(0xFF2A8676),
                      fontSize: 24,
                      fontFamily: 'Roboto'),
                ),
              )),
          //list of ingredients
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 3,
              //creates a map of the ingredients array to iterate
              //through each element and then converts it to list.
              children: ingredients.map((e) => ingredientsCard(e)).toList(),
            ),
          )),
          Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Instructions",
                  style: TextStyle(
                      color: Color(0xFF2A8676),
                      fontSize: 24,
                      fontFamily: 'Roboto'),
                ),
              )),
          Expanded(
              flex: 1,
              child: ListView.builder(
                  itemCount: instructions.length,
                  itemBuilder: (context, index) {
                    //change widget to its own design.
                    return ingredientsCard(instructions[index]);
                  }))
        ],
      ),
    );
  }

  Widget ingredientsCard(String ing) => Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const SizedBox(width: 7),
            Text(ing), //takes in the ingredients  and places em on a card
          ],
        ),
      );
}
