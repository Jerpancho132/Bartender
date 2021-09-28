import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/views/inventory.dart';

void main() {
  group('Testing the inventory wiedget', () {
    testWidgets('This is a test of dropdown button',
        (WidgetTester tester) async {
      //build the app to be tested
      await tester.pumpWidget(const MaterialApp(home: InventoryPage()));
      //get the keys to test the dropdown of the menu
      final dropdown = find.byKey(const ValueKey("Dropdownlist"));
      //run a test that expects the first item in the dropdown button is
      //orange juice

      expect((tester.widget(dropdown) as DropdownButton).value,
          equals("Orange Juice"));
      //tap the button with its button text value
      await tester.tap(find.text("Orange Juice").first);
      //pump twice to complete the action and animation. pump is like a set state
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text("Lime Juice").first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      //expects to find the button with the button value Lime Juice
      expect(find.text("Lime Juice"), findsOneWidget);

      //tap again and look for Gin
      await tester.tap(find.text("Lime Juice").first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text("Gin").first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      //expects the button to be gin
      expect(find.text("Gin"), findsOneWidget);
    });
    //test widget for input amount
    testWidgets("test the input of the amount form to confirm given amount",
        (WidgetTester tester) async {
      //build app to be tested
      await tester.pumpWidget(const MaterialApp(home: InventoryPage()));
      final amountTextField = find.byKey(const Key("amountText"));
      final amountInsertButton = find.byKey(const Key("insertButton"));
      //test of integer amount
      await tester.enterText(amountTextField, "10");
      //finds a 10 in the amounttextfield
      expect(find.text("10"), findsOneWidget);
      await tester.pump();
      //expects the 10 to be consumed and be replaced with a 0
      await tester.tap(amountInsertButton);
      await tester.pump();
      expect(find.text("10"), findsOneWidget);
      expect(find.text("0"), findsOneWidget);
      //expect to find a new card in the inventory
      //total of 3 (inputform card + default given card + new card)
      expect(find.byType(Card), findsNWidgets(3));

      //test a failsafe where given an floating point value it will convert to int or
      //a nonnumeric value, the button should still increase card amount but with 0 on the amount
      await tester.enterText(amountTextField, "4.20");
      await tester.pump();
      await tester.tap(amountInsertButton);
      await tester.pump();
      //a new card should be made
      expect(find.text("0"), findsNWidgets(2));
      expect(find.byType(Card), findsNWidgets(4));
      //test for nonnumeric
      await tester.enterText(amountTextField, "abc");
      await tester.pump();
      await tester.tap(amountInsertButton);
      await tester.pump();
      //still creates a card but
      expect(find.text("0"), findsNWidgets(3));
      expect(find.byType(Card), findsNWidgets(5));
    });
    //test the delete button of a card
    testWidgets("tests the delete button removes a card",
        (WidgetTester tester) async {
      //builds the app to test
      await tester.pumpWidget(const MaterialApp(home: InventoryPage()));

      final deleteButton = find.byKey(const Key("deleteButton"));

      await tester.tap(deleteButton);
      await tester.pump();
      //one less card in the view(originally 2 cards)
      expect(find.byType(Card), findsOneWidget);
    });
    //test the edit button of a text
    testWidgets("tests the edit capabilities of a card",
        (WidgetTester tester) async {
      //builds the app to test
      await tester.pumpWidget(const MaterialApp(home: InventoryPage()));
      await tester.tap(find.text("3"));
      await tester.pump();
      //looks for the textfield that is not the inputform
      await tester.enterText(find.byType(TextField).last, "4");
      //simulates submit
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text("4"), findsOneWidget);

      //change it to 5.1(float) should stay to 4
      await tester.tap(find.text("4"));
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, "5.1");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text("4"), findsOneWidget);

      //change to a nonnumeric, should stay to 4
      //technically impossible because the keyboard changes to numbers only
      //but should still happen regardless
      await tester.tap(find.text("4"));
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, "abc");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text("4"), findsOneWidget);
    });
  });
}
