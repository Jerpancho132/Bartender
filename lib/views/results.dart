import 'package:flutter/material.dart';
import 'package:app/models/cocktail.dart';

class Results extends StatefulWidget {
  const Results({Key? key, required this.result}) : super(key: key);
  final List<Cocktail> result;
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color(0xFFE8DFDA),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Center(
          child: Text('Results'),
        ),
        backgroundColor: const Color(0xffA63542),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: widget.result.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemCount: widget.result.length,
                itemBuilder: (BuildContext c, i) {
                  return cocktailContainer(widget.result[i]);
                })
            : const Center(
                child: Text("Nothing"),
              ),
      ),
    ));
  }

  Widget cocktailContainer(Cocktail c) => Column(
        key: UniqueKey(),
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.network(c.image),
          ),
          Text(c.title),
          //for development purpose only
          Text(c.id.toString())
        ],
      );
}
