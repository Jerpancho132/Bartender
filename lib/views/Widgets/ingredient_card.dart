import 'package:auto_size_text/auto_size_text.dart';
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
    print(ingredient);
    return Container(
      width: 150,
      height: 50,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xffD98C82),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Align(
        child: AutoSizeText(
          '$ingredient ${amount.toStringAsFixed(2)}-$unit',
          maxLines: 3,
          minFontSize: 10,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
