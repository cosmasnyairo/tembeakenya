import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tembea_kenya/models/category.dart';
import 'package:tembea_kenya/models/destination.dart';

class DestinationProvider with ChangeNotifier {
  final String url = 'https://tembeakenya.herokuapp.com/';

  List<Destination> _destinations = [];
  List<Destination> get destinations => [..._destinations];

  Future<List<Categories>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList('categories') ?? [];

    if (categories.isEmpty) {
      try {
        final response = await http.get(Uri.parse('$url/categories'), headers: {
          "Content-Type": "application/json",
        });
        json.decode(response.body).forEach(
              (element) => categories.add(jsonEncode(Categories(
                name: element['categories'],
                length: element['length'],
              ))),
            );
        prefs.setStringList('categories', categories);
      } on Exception catch (e) {
        throw e;
      }
    }
    return categories
        .map(
            (categoriesjson) => Categories.fromJson(jsonDecode(categoriesjson)))
        .toList();
  }

  Future<void> getDestination(String name) async {
    _destinations = [];
    try {
      final response = await http.post(
        Uri.parse('$url/$name'),
        body: json.encode({'limit': 9, 'offset': 0}),
        headers: {
          "Content-Type": "application/json",
        },
      );
      json.decode(response.body).forEach(
            (element) => _destinations.add(
              Destination(
                imageurl: element['image_url'],
                title: element['title'],
                about: element['about'],
                review: element['review'],
                noofreviews: element['no_of_reviews'],
                summary: element['summary'],
                wikipediaurl: element['wikipedia_url'],
              ),
            ),
          );
    } on Exception catch (e) {
      throw e;
    }
    notifyListeners();
    return _destinations;
  }

  Future<void> getNextDestination(String name, int offset) async {
    try {
      final response = await http.post(
        Uri.parse('$url/$name'),
        body: json.encode({'limit': 9, 'offset': offset}),
        headers: {"Content-Type": "application/json"},
      );
      json.decode(response.body).forEach(
            (element) => _destinations.add(
              Destination(
                imageurl: element['image_url'],
                title: element['title'],
                about: element['about'],
                review: element['review'],
                noofreviews: element['no_of_reviews'],
                summary: element['summary'],
                wikipediaurl: element['wikipedia_url'],
              ),
            ),
          );
    } on Exception catch (e) {
      print('exception $e');
      throw e;
    }
    notifyListeners();
    return _destinations;
  }

  Future<List<Destination>> searchDestination(String query) async {
    List<Destination> _fetcheddestinations = [];
    final response = await http.post(
      Uri.parse('$url/searchdestination'),
      body: json.encode({'query': query}),
      headers: {
        "Content-Type": "application/json",
      },
    );
    json.decode(response.body).forEach(
          (element) => _fetcheddestinations.add(
            Destination(
              imageurl: element['image_url'],
              title: element['title'],
              about: element['about'],
              review: element['review'],
              noofreviews: element['no_of_reviews'],
              summary: element['summary'],
              wikipediaurl: element['wikipedia_url'],
            ),
          ),
        );
    return _fetcheddestinations;
  }

  Future<List<Destination>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('destinations') ?? [];

    return bookmarks
        .map((destinationjson) =>
            Destination.fromJson(jsonDecode(destinationjson)))
        .toList();
  }

  Future<bool> isBookmarked(Destination destination) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('destinations') ?? [];
    return bookmarks.contains(jsonEncode(destination));
  }

  Future<void> bookmarkDestination(Destination destination, bool add) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('destinations') ?? [];
    add
        ? bookmarks.add(jsonEncode(destination))
        : bookmarks.remove(jsonEncode(destination));

    prefs.setStringList('destinations', bookmarks);
    notifyListeners();
  }

  Future<void> clearBookmarks() async {
    await SharedPreferences.getInstance()
        .then((value) => value.remove('destinations'));
    notifyListeners();
  }
}
