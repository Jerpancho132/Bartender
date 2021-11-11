import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/views/search.dart';

void main() {
  //overrides test mocking from flutter test package
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('test search page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));

    final findTextField = find.byKey(const Key('searchfield'));
    //expects to find a textfield
    expect(findTextField, findsOneWidget);
  });
}
