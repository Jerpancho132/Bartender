import 'dart:convert';
import 'package:app/models/cocktail.dart';
import 'package:http/http.dart' as http;

Future<List<Cocktail>> getCocktails(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/'));

  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => Cocktail.fromJson(e)).toList();
  } else {
    throw Exception('did not get response');
  }
}

//gets cocktails by a given ingredient
Future<List> getCocktailsbyIngredient(http.Client client, String i) async {
  final response = await client
      .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/ingredient/$i'));
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    //returns id of cocktail by that ingredient
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('Could not get cocktails by ingredients');
  }
}

//get cocktails by glass type
Future<List> getCocktailsByGlass(http.Client client, String g) async {
  final response = await client
      .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/glass/$g'));
  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('did not get response');
  }
}

//test
//get cocktails by Alcoholic drinks
Future<List> getCocktailsByAlcoholic(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/alcohol/1'));
  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('did not get response');
  }
}

//test
//get cocktails by NonAlcoholic drinks
Future<List> getCocktailsByNonAlcoholic(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/alcohol/0'));
  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('did not get response');
  }
}

//test
//get cocktails by classical drinks
Future<List> getCocktailsByClassic(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/classic/1'));
  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('did not get response');
  }
}

//test
//get cocktails by classical drinks
Future<List> getCocktailsByTropical(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://10.0.2.2:8080/api/cocktails/tropical/1'));
  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('did not get response');
  }
}

//test
//get cocktails by classical drinks
Future<List> getCocktailsByLocal(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8080/api/cocktails/local/1'));
  if (response.statusCode == 200) {
    //gets json turn it to a iterable list
    Iterable list = json.decode(response.body);
    return list.map((e) => e['id']).toList();
  } else {
    throw Exception('did not get response');
  }
}

//gets all the list of possible ingredients from the database
Future<List> getIngredients(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/'));
  if (response.statusCode == 200) {
    Iterable data = json.decode(response.body);
    return data.map((e) => e['title']).toList();
  } else {
    throw Exception('could not get ingredients');
  }
}

Future<List> getMeasurements(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://10.0.2.2:8080/api/ingredients/'));
  if (response.statusCode == 200) {
    Iterable data = json.decode(response.body);
    return data.map((e) => e['measurement']).toList();
  } else {
    throw Exception('could not get ingredients');
  }
}