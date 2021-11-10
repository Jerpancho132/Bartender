import 'package:app/models/cocktail.dart';
import 'package:app/resources/api_calls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('test api calls', () {
    test('test getCocktails', () async {
      final client = MockClient();
      //mockito providing a successful response of a correct json body
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 1, "title": "cocktail", "image": "cocktail image", "glasstype": "highball glass", "instruction": "something"},
              {"id": 2, "title": "cocktail2", "image": "cocktail image2", "glasstype": "highball glass2", "instruction": "something2"}]''',
              200));
      expect(await getCocktails(client), isA<List<Cocktail>>());
    });
    test('getCocktails ThrowException', () {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktails(client), throwsException);
    });
  });
}
