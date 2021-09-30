import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E5F2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_drink),
            SizedBox(width: 10),
            Text('Search Page'),
          ],
        ),
      ),
      body: ListView(
        children: const [
          Text("Filter",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 2,
                  color: Color(0xffA63542))),
          Text("Popular",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 2,
                  color: Color(0xffA63542))),
        ],
      ),
    );
  }
}
