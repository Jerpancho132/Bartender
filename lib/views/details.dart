// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //variables to be replaced by database implementation
  String title = "Margarita";
  String imgUrl =
      "https://www.hangoverweekends.co.uk/media/15502/margarita.jpg?width=298px&height=412px";
  List<String> ingredients = [
    "Tequila",
    "Triple Sec",
    "Sour Mix",
    "Simple Syrup",
    "Lime Juice",
    "Lime Garnish",
  ];
  List<String> instructions = ["step1", "step2", "step3", "step4"];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD6E5F2),
      body: detailLayout(),
    );
  }

  Widget ingredientsCard(String ing) => Container(
        //padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
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

  Widget detailLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 10),
      //padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //image detail
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.only(top: 25),
            iconSize: 25,
            icon: const Icon(Icons.arrow_back),
            color: Color(0xff9BB34F),
          ),
          Text(title,
              style: GoogleFonts.sansita(
                  textStyle: const TextStyle(
                      color: Color(0xff9BB34F),
                      letterSpacing: .5,
                      fontSize: 40))),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(0xffDADFC7),
                    width: 6,
                  ),
                  image: DecorationImage(
                      image: NetworkImage(imgUrl), fit: BoxFit.fill)),
            ),
          ),
          //Make new container here so the rest of the view scrolls together
          //ingredients section
          Text("Ingredients",
              style: GoogleFonts.sansita(
                  textStyle: const TextStyle(
                      color: Color(0xff9BB34F),
                      letterSpacing: .5,
                      fontSize: 30))),
          //list of ingredients
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 3,
              //creates a map of the ingredients array to iterate
              //through each element and then converts it to list.
              children: ingredients.map((e) => ingredientsCard(e)).toList(),
            ),
          ),
          Text("Instructions",
              style: GoogleFonts.sansita(
                  textStyle: const TextStyle(
                      color: Color(0xff9BB34F),
                      letterSpacing: .5,
                      fontSize: 30))),
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
}
