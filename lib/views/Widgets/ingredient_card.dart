import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IngredientCard extends StatelessWidget {
  final String ingredient;
  final double amount;
  final String unit;
  const IngredientCard({
    Key? key,
    required this.ingredient,
    required this.amount,
    required this.unit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //add link to ingredients page here later if we get to it
          Navigator.pop(
            context,
          );
        },
        child: Container(
          //padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffD98C82),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const SizedBox(width: 6),
              Text(ingredient,
                  style: GoogleFonts.sansita(
                      textStyle: const TextStyle(color: Colors.black),
                      letterSpacing: .5,
                      fontSize: 15)),
            ],
          ),
        ));
  }
}
