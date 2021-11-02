class Cocktail {
  final int id;
  final String title;
  final String image;
  final String glassType;
  final String instruction;

  Cocktail(
      {required this.id,
      required this.title,
      required this.image,
      required this.glassType,
      required this.instruction});

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        glassType: json['glasstype'],
        instruction: json['instruction']);
  }
}
