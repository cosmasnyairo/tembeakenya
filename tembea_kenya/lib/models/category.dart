import 'package:flutter/material.dart';

class Categories {
  final String name;
  final int length;

  categoryIcon() {
    return {
      'art_and_culture': Icons.art_track,
      'beaches': Icons.beach_access,
      'kid_friendly': Icons.child_care,
      'museums': Icons.museum,
      'outdoors': Icons.grass_outlined
    }[name];
  }

  Categories({this.name, this.length});

  Categories.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        length = json['length'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'length': length,
      };
}
