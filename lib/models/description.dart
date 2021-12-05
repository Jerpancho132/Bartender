class Description {
  final String name;
  final String image;
  final String description;

  Description({required this.name, required this.description, this.image = ""});

  String get getName => name;

  String get getDescription => description;

  String get getImage => image;
}
