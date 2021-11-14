import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/views/search.dart';
import 'package:app/global.dart' as global;
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'search_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  //overrides test mocking from flutter test package
  //setUpAll(() => HttpOverrides.global = null);
  global.client = MockClient();

  when(global.client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/')))
      .thenAnswer((realInvocation) async => http.Response(
          '''[{"id": 1, "title": "cocktail", "image": "cocktail image", "glasstype": "highball glass", "instruction": "something"},
              {"id": 2, "title": "cocktail2", "image": "cocktail image2", "glasstype": "highball glass2", "instruction": "something2"}]''',
          200));
  when(global.client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
      .thenAnswer((realInvocation) async => http.Response(
          '''[{"id": 1, "title":"Lime", "image":"an image", "description":"a description"},
              {"id": 2, "title":"white rum", "image":"another image", "description":"another description"}
              ]''', 200));
  when(global.client.get(
          Uri.parse('http://10.0.2.2:8080/api/cocktails/ingredient/vodka')))
      .thenAnswer((realInvocation) async =>
          http.Response('''[{"id": 1, "title":"cosmopolitan"},
              {"id":2,"title": "Long Island"}
              ]''', 200));
  when(global.client.get(
          Uri.parse('http://10.0.2.2:8080/api/cocktails/glass/cocktail glass')))
      .thenAnswer((realInvocation) async =>
          http.Response('[{"id": 1, "title":"cosmopolitan"}]', 200));
  //instead try to create a mockclient by making httpclient a global variable
  testWidgets('test search page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));

    final findTextField = find.byKey(const Key('searchfield'));
    //reload page
    await tester.pumpAndSettle();
    //expects to find a textfield
    expect(findTextField, findsOneWidget);
    expect(find.text('Lime'), findsOneWidget);
    expect(find.text('cocktail glass'), findsOneWidget);
  });
}
