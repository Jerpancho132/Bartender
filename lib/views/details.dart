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
  List<String> ingredients = ["Gin", "Lime Juice", "Sugar Syrup", "Lime"];
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
            const Expanded(child: Text("Test")),
            Expanded(
                child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.star_border),
            ))
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(imgUrl))),
          )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [Text("data")],
                    ),
                  )))
        ],
      ),
    );
  }
}
