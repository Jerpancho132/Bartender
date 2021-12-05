import 'package:flutter/material.dart';
import 'package:app/models/ingredient.dart';

class IngredientDetailsPage extends StatefulWidget {
  final String name;
  final String image;
  final String description;
  final int num;
  const IngredientDetailsPage(
      {Key? key,
      required this.num,
      required this.name,
      required this.image,
      required this.description})
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
            //for image
            widget.image.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(widget.image))),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                  ), //empty container in case of empty images
            Text(
              widget.name,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              widget.description,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
