import 'package:flutter/material.dart';
import 'package:app/models/ingredient.dart';

class IngredientDetailsPage extends StatefulWidget {
  final Ingredient test;
  final int num;
  const IngredientDetailsPage({Key? key, required this.test, required this.num})
      : super(key: key);

  @override
  _IngredientDetailsPageState createState() => _IngredientDetailsPageState();
}

class _IngredientDetailsPageState extends State<IngredientDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8DFDA),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.num.toString(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 350,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(widget.test.image))),
            ),
            Text(
              widget.test.title,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              widget.test.description,
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
