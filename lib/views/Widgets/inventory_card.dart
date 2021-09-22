import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  final String item;
  final int amount;
  const InventoryCard({Key? key, required this.item, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('$item with amount $amount'),
      ),
    );
  }
}
