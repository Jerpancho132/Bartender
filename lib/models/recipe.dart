class Recipe {
  final String ingredient;
  final num amount;
  final String unit;

  Recipe({
    required this.ingredient,
    required this.amount,
    required this.unit,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      ingredient: json['ingredient'],
      amount: json['amount'],
      unit: json['unit'],
    );
  }
}
