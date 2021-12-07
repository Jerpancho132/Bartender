import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(widget.image))),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                  ), //empty container in case of empty images
            const Padding(padding: EdgeInsets.all(7)),
            Flexible(
              child: Text(
                widget.name,
                style: GoogleFonts.ubuntu(
                    textStyle: Theme.of(context).textTheme.headline5),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: AutoSizeText(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                        textStyle: Theme.of(context).textTheme.bodyText1,
                        fontSize: 15,
                        height: 1.6),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
