import 'package:flutter_test/flutter_test.dart';
import 'package:app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group("test search widget", () {
    testWidgets("test the search bar and its searches",
        (WidgetTester tester) async {
      //this function creates a mock for the network images used in the fi
      mockNetworkImagesFor(() async {
        //first build the widget to be tested
        await tester.pumpWidget(const MaterialApp(home: SearchPage()));

        final searchBar = find.byKey(const Key("searchbar"));
        //simple test to see if searchbar exist
        expect(searchBar, findsWidgets);
      });
    });
  });
}
