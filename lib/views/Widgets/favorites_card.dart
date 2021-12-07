import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget favoritesCard(int id, String name, String image, String instructions,
        String glass, BuildContext context) =>
    Container(
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
          image: NetworkImage(image),
          //cant decide between cover or fill on this one
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(name,
                    style: GoogleFonts.sansita(
                        textStyle: const TextStyle(
                            color: Color(0xff2A8676),
                            letterSpacing: .5,
                            fontSize: 25)))),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
