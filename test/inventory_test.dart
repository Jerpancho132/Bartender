import 'package:app/models/inventory_model.dart';
import 'package:test/test.dart';

void main() {
  group('Test inventory model', () {
    test('Test inventory with a given amount', () async {
      final inventory = MyInventory('orange', 5);

      //when making an instance of an inventory expect the amount to be the instance given.
      expect(inventory.getAmount, 5);
    });
    test('Test inventory with a given ingredient', () async {
      final inventory = MyInventory('orange', 5);

      //when making an instance of an inventory expect the amount to be the instance given.
      expect(inventory.getIngredient, 'orange');
    });
  });
}
