class MyInventory {
  String ingredient;
  int amount;
  String measurement;
  MyInventory(this.ingredient, this.amount, this.measurement);

  String get getIngredient {
    return ingredient;
  }

  int get getAmount {
    return amount;
  }

  String get getMeasurement {
    return measurement;
  }
}
