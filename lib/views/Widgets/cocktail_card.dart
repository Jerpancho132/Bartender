import 'package:flutter/material.dart';
import 'package:app/views/details.dart';
import 'package:google_fonts/google_fonts.dart';

class CocktailCard extends StatelessWidget {
  final String cocktailName;
  final String thumbnailUrl;
  final String instructions;
  const CocktailCard({
    Key? key,
    required this.cocktailName,
    required this.thumbnailUrl,
    required this.instructions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Details(
                    title: cocktailName,
                    imgUrl: thumbnailUrl,
                    instructions: instructions,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(thumbnailUrl),
            //cant decide between cover or fill on this one
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Align(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(cocktailName,
                      style: GoogleFonts.sansita(
                          textStyle: const TextStyle(
                              color: Color(0xff2A8676),
                              letterSpacing: .5,
                              fontSize: 25)))),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }
}
