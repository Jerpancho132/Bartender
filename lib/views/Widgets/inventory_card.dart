import 'package:flutter/material.dart';

class InventoryCard extends StatefulWidget {
  final String item;
  final int amount;
  final String measurement;
  const InventoryCard(
      {Key? key,
      required this.item,
      required this.amount,
      required this.measurement})
      : super(key: key);

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
            '${widget.item} with amount: ${widget.amount} ${widget.measurement}'),
      ),
    );
  }
}
