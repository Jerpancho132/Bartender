import 'package:flutter_test/flutter_test.dart';
import 'package:app/views/search.dart';
import 'package:flutter/material.dart';

void main() {
  group("test search widget", () {
    testWidgets("test the search bar and its searches",
        (WidgetTester tester) async {
      //first build the widget to be tested
      tester.pumpWidget(const SearchPage());
      final searchBar = find.byKey(const Key("searchbar"));

      expect(searchBar, findsOneWidget);
      //
    });
  });
}
