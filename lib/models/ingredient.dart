class Ingredient {
  final int id;
  final String title;
  final String measurement;
  final String image;
  final String description;

  Ingredient(
      {required this.id,
      required this.title,
      required this.measurement,
      this.image = "",
      this.description = ""});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json["id"],
        title: json["title"],
        measurement: json["measurement"],
        image: json["image"],
        description: json["description"]);
  }

  toList() {}
}
