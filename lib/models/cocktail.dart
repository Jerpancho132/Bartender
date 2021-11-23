//library cocktail_list.global;
class Cocktail {
  final int id;
  final String title;
  final String image;
  final String glasstype;
  final String instruction;

  Cocktail(
      {required this.id,
      required this.title,
      required this.image,
      required this.glasstype,
      required this.instruction});

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        glasstype: json['glasstype'],
        instruction: json['instruction']);
  }

  int get cocktailId => id;

  String get name => title;

  String get imageUrl => image;

  String get glass => glasstype;

  String get cocktailInstruction => instruction;
}
