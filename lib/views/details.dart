import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //variables in use until database implemented
  String name = 'Gimlet';
  String imgurl =
      "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg";
  List<String> ingredients = [
    'Gin',
    'Syrup',
    'Lime Juice',
    'Soda Water',
    'Lime Garnish',
    'ice'
  ];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE8DFDA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 100),
              ),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xff2A8676),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 100)),
              Expanded(
                  child: IconButton(
                iconSize: 25,
                icon: const Icon(Icons.star_border),
                color: const Color(0xffA63542),
                onPressed: () {},
              ))
            ],
          ),
          leading: IconButton(
            color: const Color(0xffA63542),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: const Alignment(0, -1),
                          fit: BoxFit.fill,
                          image: NetworkImage(imgurl))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Ingredients',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff2A8676),
                      fontSize: 24,
                      fontFamily: 'Roboto',
                    ),
                  )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    //replace text with a placeholder for ingredients
                    return Text(ingredients[index]);
                  },
                  itemCount: ingredients.length,
                ),
              )),
            ],
          ),
        ));
  }
}
