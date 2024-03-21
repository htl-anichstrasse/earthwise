import 'package:countries_world_map/components/canvas/touchy_canvas.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';

import 'package:earthwise/Pages/QuizPages/Mapquiz/map/map_settings.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/map_colour.dart';

// Painter class for painting a world map with countries colored based on a data set
class Painter extends CustomPainter {
  final List<Country> countries;
  final MapColour mapColours;
  final BuildContext context;
  final MapSettings settings;
  final Map? colors;
  final CountryBorder? countryBorder;

  const Painter({
    required this.countries,
    required this.mapColours,
    this.colors,
    required this.context,
    this.countryBorder,
    required this.settings,
  });

  @override
  void paint(Canvas c, Size size) {
    TouchyCanvas canvas = TouchyCanvas(context, c);

    if (countries.length > 50) {
      // Draw background Path
      Path backgroundPath = Path();
      backgroundPath.moveTo(0, 0);
      backgroundPath.lineTo(size.width, 0);
      backgroundPath.lineTo(size.width, size.height);
      backgroundPath.lineTo(0, size.height);
      canvas.drawPath(
        backgroundPath,
        Paint()..color = mapColours.backgroundColor,
      );
    }

    List<double> xValues = [];
    List<double> yValues = [];

    for (var country in countries) {
      String instructions = country.map;
      Color colour = country.colour;
      Path path = Path();

      List<String> paths = instructions.split(' ');
      for (int j = 0; j < paths.length - 1; j++) {
        String instruction = paths[j];
        if (instruction == "Z") {
          path.close();
        } else if (instruction == "X") {
          Paint paint = Paint()..color = mapColours.areaColor;
          if (colour == mapColours.rightColor) {
            paint = Paint()..color = mapColours.areaRightColor;
          }
          canvas.drawPath(drawArea(canvas, j + 1, paths, false, colour), paint);
          j += paths.length;
        } else if (instruction == "Y") {
          Paint circlePaint = Paint()..color = mapColours.areaColor;
          if (colour == mapColours.rightColor) {
            circlePaint = Paint()..color = mapColours.areaRightColor;
          }
          circlePaint.style = PaintingStyle.fill;

          canvas.drawCircle(
              Offset(double.parse(paths[j + 1]) - settings.startX,
                  double.parse(paths[j + 2]) - settings.startY),
              double.parse(paths[j + 3]),
              circlePaint);
          j += 3;
        } else if (instruction == "M") {
          double x = double.parse(paths[j + 1]) - settings.startX;
          double y = double.parse(paths[j + 2]) - settings.startY;
          xValues.add(x);
          yValues.add(y);
          j += 2;
          path.moveTo(x, y);
        } else {
          double x = double.parse(paths[j]) - settings.startX;
          double y = double.parse(paths[j + 1]) - settings.startY;
          xValues.add(x);
          yValues.add(y);
          j += 1;
          path.lineTo(x, y);
        }
      }

      Paint paint = Paint()..color = colour;
      canvas.drawPath(path, paint);

      String border = country.border;
      List<String> borderPaths = border.split(' ');

      Paint paint2 = Paint()..color = colour;
      paint2.color = Colors.blue;
      paint2.strokeWidth = 0.2;
      paint2.style = PaintingStyle.stroke;

      if (borderPaths.length > 1) {
        canvas.drawPath(
            drawArea(canvas, 0, borderPaths, false, colour), paint2);
      }
    }

    if (settings.specialCountries != null) {
      for (var c in settings.specialCountries ?? []) {
        List<String> specialPaths = getMapOfCountry(c).split(' ');
        Paint specialPaint = Paint()..color = getColourOfCountry(c);

        canvas.drawPath(
            drawArea(canvas, 0, specialPaths, true, mapColours.areaColor),
            specialPaint);
      }
    }
  }

  Path drawArea(TouchyCanvas canvas, int index, List<String> paths,
      bool connect, Color color) {
    Path path = Path();
    for (int i = index; i < paths.length; i++) {
      String instruction = paths[i];
      if (instruction == "Z") {
        if (connect) {
          path.close();
        }
      } else if (instruction == "Y") {
        Paint circlePaint = Paint()..color = mapColours.areaColor;
        if (color == mapColours.rightColor) {
          circlePaint = Paint()..color = mapColours.areaRightColor;
        }

        circlePaint.style = PaintingStyle.fill;

        canvas.drawCircle(
            Offset(double.parse(paths[i + 1]) - settings.startX,
                double.parse(paths[i + 2]) - settings.startY),
            double.parse(paths[i + 3]),
            circlePaint);
        i += 3;
      } else if (instruction == "M") {
        double x = double.parse(paths[i + 1]) - settings.startX;
        double y = double.parse(paths[i + 2]) - settings.startY;
        i += 2;
        path.moveTo(x, y);
      } else {
        double x = double.parse(paths[i]) - settings.startX;
        double y = double.parse(paths[i + 1]) - settings.startY;
        i += 1;
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => oldDelegate.colors != colors;
}
