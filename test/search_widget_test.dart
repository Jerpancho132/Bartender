import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/views/search.dart';
import 'package:app/global.dart' as global;
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:app/views/results.dart';
import 'search_api_test.mocks.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  //overrides test mocking from flutter test package
  //setUpAll(() => HttpOverrides.global = null);
  global.client = MockClient();

  when(global.client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/')))
      .thenAnswer((realInvocation) async => http.Response(
          '''[{"id": 1, "title": "cocktail", "image": "cocktail image", "glasstype": "Highball glass", "instruction": "something"},
              {"id": 2, "title": "cocktail2", "image": "cocktail image2", "glasstype": "Cocktail glass", "instruction": "something2"}]''',
          200));
  when(global.client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/')))
      .thenAnswer((realInvocation) async => http.Response(
          '''[{"id": 1, "title":"Lime", "image":"an image", "description":"a description"},
              {"id": 2, "title":"white rum", "image":"another image", "description":"another description"}
              ]''', 200));
  when(global.client
          .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/ingredient/Lime')))
      .thenAnswer((realInvocation) async =>
          http.Response('''[{"id": 1, "title":"cosmopolitan"},
              {"id":2,"title": "Long Island"}
              ]''', 200));
  when(global.client.get(
          Uri.parse('http://10.0.2.2:8080/api/cocktails/glass/Cocktail glass')))
      .thenAnswer((realInvocation) async =>
          http.Response('[{"id": 1, "title":"cosmopolitan"}]', 200));
  //instead try to create a mockclient by making httpclient a global variable
  testWidgets('test search page and filter buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));

    final findTextField = find.byKey(const Key('searchfield'));
    final findScrollable = find.byKey(const Key("Scrollable"));
    final findGlass = find.byKey(const Key("key-Cocktail glass"));
    final findAlcoholic = find.byKey(const Key("key-Alcoholic"));
    final findIngredient = find.byKey(const Key('key-Lime'));
    //reload page
    await tester.pumpAndSettle();
    //expects to find a textfield
    expect(findTextField, findsOneWidget);
    expect(findScrollable, findsOneWidget);
    //expects to find a filter button with of type alcoholic
    expect(findAlcoholic, findsOneWidget);
    //expects to find a filter button with keyword cocktail glass
    expect(findGlass, findsOneWidget);
    //drag down until you find the visible ingredient button
    await tester.dragUntilVisible(
        findIngredient, findScrollable, const Offset(0, -250));
    expect(findIngredient, findsOneWidget);
  });
  testWidgets('test button to navigate to next page', (tester) async {
    mockNetworkImagesFor(() async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
          home: const SearchPage(), navigatorObservers: [mockObserver]));

      //find a search button
      final findSearchButton = find.byKey(const Key('navigateToResults'));
      expect(findSearchButton, findsOneWidget);
      //tap search button and expect to navigate to another page
      await tester.tap(findSearchButton);
      await tester.pumpAndSettle();
      expect(find.byType(Results), findsOneWidget);
    });
  });
  testWidgets('test button shows snackbar', (tester) async {
    //create the search page
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));
    //find the button by key
    final findSearchButton = find.byKey(const Key('navigateToResults'));
    expect(findSearchButton, findsOneWidget);
    //find the text field by key
    final findTextField = find.byKey(const Key('searchfield'));
    expect(findTextField, findsOneWidget);
    //test if snackbar appears on wrong input
    await tester.enterText(findTextField, 'asdifh213433');
    await tester.pumpAndSettle();
    await tester.tap(findSearchButton);
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('test button navigation after input text', (tester) async {
    mockNetworkImagesFor(() async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
          home: const SearchPage(), navigatorObservers: [mockObserver]));

      //find a search button
      final findSearchButton = find.byKey(const Key('navigateToResults'));
      expect(findSearchButton, findsOneWidget);
      //find the text field by key
      final findTextField = find.byKey(const Key('searchfield'));
      expect(findTextField, findsOneWidget);
      //expects
      await tester.enterText(findTextField,
          'cocktail'); //the search is referencing the mocked data
      await tester.pumpAndSettle();
      //tap search button and expect to navigate to another page
      await tester.tap(findSearchButton);
      await tester.pumpAndSettle();
      expect(find.byType(Results), findsOneWidget);
    });
  });

  testWidgets('test button navigation after tap filter', (tester) async {
    mockNetworkImagesFor(() async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
          home: const SearchPage(), navigatorObservers: [mockObserver]));
      await tester.pumpAndSettle();
      //keys
      final findScrollable = find.byKey(const Key("Scrollable"));
      final findIngredient = find.byKey(const Key("key-Lime"));
      //find a search button
      final findSearchButton = find.byKey(const Key('navigateToResults'));
      expect(findSearchButton, findsOneWidget);

      //scroll until you find key
      await tester.dragUntilVisible(
          findIngredient, findScrollable, const Offset(0, -250));
      expect(findIngredient, findsOneWidget);
      //tap the filter button and tap the search button
      await tester.tap(findIngredient);
      await tester.pumpAndSettle();
      await tester.tap(findSearchButton);
      await tester.pumpAndSettle();
      expect(find.byType(Results), findsOneWidget);
    });
  });

  testWidgets('test button navigation after tap filter for glasstype',
      (tester) async {
    mockNetworkImagesFor(() async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
          home: const SearchPage(), navigatorObservers: [mockObserver]));
      await tester.pumpAndSettle();
      //find a search button
      final findSearchButton = find.byKey(const Key('navigateToResults'));
      expect(findSearchButton, findsOneWidget);
      //find the glass filter button
      final findFilterButton = find.byKey(const Key("key-Cocktail glass"));
      expect(findFilterButton, findsOneWidget);
      //tap the filter button and tap the search button
      await tester.tap(findFilterButton);
      await tester.pumpAndSettle();
      await tester.tap(findSearchButton);
      await tester.pumpAndSettle();
      expect(find.byType(Results), findsOneWidget);
    });
  });
}
