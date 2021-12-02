import 'package:app/models/cocktail.dart';
import 'package:app/models/ingredient.dart';
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
    test('test getCocktails ThrowException', () {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktails(client), throwsException);
    });

    test('test getIngredients', () async {
      final client = MockClient();
      //mockito providing a successful response of a correct json body
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 1, "title":"Lime", "image":"an image", "description":"a description"},
              {"id": 2, "title":"white rum", "image":"another image", "description":"another description"}
              ]''', 200));
      expect(await getIngredients(client), isA<List>());
    });
    test('test getIngredients ThrowException', () {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getIngredients(client), throwsException);
    });

    test('test getCocktailByIngredients', () async {
      final client = MockClient();
      String i = "vodka";
      //mockito providing a successful response of a correct json body
      when(client.get(
              Uri.parse('http://10.0.2.2:8080/api/cocktails/ingredient/$i')))
          .thenAnswer((realInvocation) async =>
              http.Response('''[{"id": 1, "title":"cosmopolitan"},
              {"id":2,"title": "Long Island"}
              ]''', 200));
      expect(await getCocktailsbyIngredient(client, i), isA<List>());
    });
    test('test getCocktailByIngredients ThrowException', () {
      final client = MockClient();
      String i = "vodka";
      when(client.get(
              Uri.parse('http://10.0.2.2:8080/api/cocktails/ingredient/$i')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsbyIngredient(client, i), throwsException);
    });
    test('test getCocktailByGlass', () async {
      final client = MockClient();
      String i = "cocktail glass";
      //mockito providing a successful response of a correct json body
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/glass/$i')))
          .thenAnswer((realInvocation) async =>
              http.Response('[{"id": 1, "title":"cosmopolitan"}]', 200));

      expect(await getCocktailsByGlass(client, i), isA<List>());
    });
    test('test getCocktailByGlass ThrowException', () {
      final client = MockClient();
      String i = "not vodka";
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/glass/$i')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsByGlass(client, i), throwsException);
    });
    //test byAlcoholic
    test('test getCocktailByAlcoholic', () async {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/alcohol/1')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 1, "title":"cosmopolitan"},{"id":2 , "title":"Mimosa"}]''',
              200));
      expect(await getCocktailsByAlcoholic(client), isA<List>());
    });
    //test byAlcoholic Throw Exception
    test('test getCocktailByAlcohol ThrowException', () {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/alcohol/1')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsByAlcoholic(client), throwsException);
    });
    //test byNonAlcoholic
    test('test getCocktailByNonAlcoholic', () async {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/alcohol/0')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 3, "title":"fruit punch"},{"id":4 , "title":"watermelon lemonade"}]''',
              200));
      expect(await getCocktailsByNonAlcoholic(client), isA<List>());
    });
    //test byNonAlcoholic Throw Exception
    test('test getCocktailByNonAlcoholic ThrowException', () {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/alcohol/0')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsByNonAlcoholic(client), throwsException);
    });
    //test by classical
    test('test getCocktailByClassic', () async {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/classic/1')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 1, "title":"cosmopolitan"},{"id":2 , "title":"Mimosa"}]''',
              200));
      expect(await getCocktailsByClassic(client), isA<List>());
    });
    //test by classical Throw Exception
    test('test getCocktailByClassic ThrowException', () {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/classic/1')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsByClassic(client), throwsException);
    });
    //test by Tropical
    test('test getCocktailByTropical', () async {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/tropical/1')))
          .thenAnswer((realInvocation) async =>
              http.Response('''[{"id": 1, "title":"cosmopolitan"}]''', 200));
      expect(await getCocktailsByTropical(client), isA<List>());
    });
    //test by Tropical Throw Exception
    test('test getCocktailByTropical ThrowException', () {
      final client = MockClient();
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/tropical/1')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsByTropical(client), throwsException);
    });
    //test by local
    test('test getCocktailByLocal', () async {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/local/1')))
          .thenAnswer((realInvocation) async =>
              http.Response('''[{"id":21, "title": "local drink"}]''', 200));
      expect(await getCocktailsByLocal(client), isA<List>());
    });
    //test by local Throw Exception
    test('test getCocktailByLocal ThrowException', () {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/local/1')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getCocktailsByLocal(client), throwsException);
    });
    //test ingredients model
    test('test getIngredientsModel', () async {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 1, "title": "vodka", "measurement": "oz", "image": "https://www.thecocktaildb.com/images/ingredients/Vodka.png","description": "Vodka is a distilled beverage composed primarily of water and ethanol, sometimes with traces of impurities and flavorings."},
              {"id": 2, "title": "Cointreau", "measurement": "oz", "image": "https://www.thecocktaildb.com/images/ingredients/Cointreau.png","description": "Cointreau is an orange-flavoured triple sec liqueur."}]''',
              200));
      expect(await getIngredientsModel(client), isA<List<Ingredient>>());
    });
    test('test getIngredientsModel throws Exception', () {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getIngredientsModel(client), throwsException);
    });
    //test getting single ingredient
    test('test getSingleIngredient', () async {
      final client = MockClient();
      String i = 'Vodka';
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/ingredients/name/$i')))
          .thenAnswer((realInvocation) async => http.Response(
              '{"id": 1, "title":"Vodka","measurement":"oz","image":"https://www.thecocktaildb.com/images/ingredients/Vodka.png", "description": "Vodka is a distilled beverage composed primarily of water and ethanol, sometimes with traces of impurities and flavorings."}',
              200));
      expect(await getSingleIngredient(client, i), isA<Ingredient>());
    });

    test('test getSingleIngredient throws exception', () {
      final client = MockClient();
      String i = 'Vodka';
      when(client
              .get(Uri.parse('http://10.0.2.2:8080/api/ingredients/name/$i')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getSingleIngredient(client, i), throwsException);
    });
    //test measurement api
    test('test getMeasurements', () async {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
          .thenAnswer((realInvocation) async => http.Response(
              '''[{"id": 1, "title": "vodka", "measurement": "oz", "image": "https://www.thecocktaildb.com/images/ingredients/Vodka.png","description": "Vodka is a distilled beverage composed primarily of water and ethanol, sometimes with traces of impurities and flavorings."},
              {"id": 2, "title": "Cointreau", "measurement": "oz", "image": "https://www.thecocktaildb.com/images/ingredients/Cointreau.png","description": "Cointreau is an orange-flavoured triple sec liqueur."}]''',
              200));
      expect(await getMeasurements(client), isA<List>());
    });
    test('test getMeasurements throws exception', () {
      final client = MockClient();
      when(client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
          .thenAnswer(
              (realInvocation) async => http.Response('Error Response', 500));
      expect(getMeasurements(client), throwsException);
    });
  });
}
