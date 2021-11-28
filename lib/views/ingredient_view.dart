import 'package:flutter/material.dart';
import 'package:app/models/ingredient.dart';

class IngredientDetailsPage extends StatefulWidget {
  final Ingredient test;
  const IngredientDetailsPage({Key? key, required this.test}) : super(key: key);

  @override
  _IngredientDetailsPageState createState() => _IngredientDetailsPageState();
}

class _IngredientDetailsPageState extends State<IngredientDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              widget.test.id.toString(),
              style: TextStyle(color: Colors.black),
            ),
            Image(image: NetworkImage(widget.test.image)),
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
