import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';

class Map {
  final int id;
  SimpleMap map;
  Color colour;

  Map({
    required this.id,
    required this.map,
    required this.colour,
  });
}
