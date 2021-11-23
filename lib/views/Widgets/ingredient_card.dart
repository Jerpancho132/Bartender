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
        width: 112,
        height: 25,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xffD98C82),
          borderRadius: BorderRadius.circular(15),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(ingredient),
              Text(amount.toStringAsFixed(2)),
              Text(unit)
            ],
          ),
        ));
  }
}
