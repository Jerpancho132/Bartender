import 'dart:convert';
import 'package:test/test.dart';
import 'package:app/models/cocktail.dart';

void main() {
  group('test Cocktail model getters', () {
    test('Create new Cocktail', () {
      //simple test of generating new Cocktail object
      final test = Cocktail(
          id: 1,
          title: "title",
          image: "image",
          glasstype: "glasstype",
          instruction: "instruction");

      expect(test, isA<Cocktail>());
    });
    test('get id', () {
      //simple test of id getter
      final test = Cocktail(
          id: 2,
          title: "title",
          image: "image",
          glasstype: "glasstype",
          instruction: "instruction");
      expect(test.cocktailId, 2);
    });
    test('get title', () {
      //simple test of title getter
      final test = Cocktail(
          id: 3,
          title: "new title",
          image: "image",
          glasstype: "glasstype",
          instruction: "instruction");
      expect(test.name, "new title");
    });
    test('get image', () {
      //simple test of imageURL getter
      final test = Cocktail(
          id: 4,
          title: "title",
          image: "new image",
          glasstype: "glasstype",
          instruction: "instruction");
      expect(test.imageUrl, "new image");
    });
    test('get glasstype', () {
      //simple test of glasstype getter
      final test = Cocktail(
          id: 2,
          title: "title",
          image: "image",
          glasstype: "Wine Glass",
          instruction: "instruction");
      expect(test.glass, "Wine Glass");
    });
    test('get instructions', () {
      //simple test of instruction getter
      final test = Cocktail(
          id: 2,
          title: "title",
          image: "image",
          glasstype: "glasstype",
          instruction: "simple instruction");
      expect(test.cocktailInstruction, "simple instruction");
    });
  });
  group("test factory function", () {
    test('test Cocktail.fromJson', () {
      String json =
          '{"id":1,"title":"cosmopolitan","image":"someimageurl","glasstype":"cup","instruction":"complex instruction"}';

      final test = Cocktail.fromJson(jsonDecode(json));

      //should expect a cocktail object converted from a given json body
      expect(test, isA<Cocktail>());
      expect(test.cocktailId, 1);
      expect(test.name, "cosmopolitan");
      expect(test.imageUrl, "someimageurl");
      expect(test.glass, "cup");
      expect(test.cocktailInstruction, "complex instruction");
    });
  });
}
