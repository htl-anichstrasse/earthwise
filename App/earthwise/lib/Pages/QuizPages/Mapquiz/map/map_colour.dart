import 'package:flutter/material.dart';

class MapColour {
  final Color backgroundColor;
  final Color defaultColor;
  final Color borderColor;
  final Color rightColor;
  final Color areaColor;
  final Color areaRightColor;

  MapColour({
    required this.backgroundColor,
    required this.defaultColor,
    required this.borderColor,
    required this.rightColor,
    required this.areaColor,
    required this.areaRightColor,
  });
}

MapColour defaultColor = MapColour(
  backgroundColor: const Color.fromARGB(0, 228, 0, 0),
  defaultColor: const Color.fromARGB(255, 197, 210, 4),
  borderColor: const Color.fromARGB(255, 0, 0, 0),
  rightColor: const Color.fromARGB(255, 0, 172, 6),
  areaColor: const Color.fromARGB(255, 3, 119, 244),
  areaRightColor: const Color.fromARGB(255, 67, 233, 72),
);
