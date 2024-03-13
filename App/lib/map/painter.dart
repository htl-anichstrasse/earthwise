import 'package:countries_world_map/components/canvas/touchy_canvas.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'dart:math';
import 'package:maestro/Models/map_colour.dart';

import 'package:maestro/Models/mapSettings.dart';

/// This painter will paint a world map with all///
/// Giving countries a different color based on a data set can help visualize data.

class SimpleMapPainter extends CustomPainter {
  final List<Country> countries;

  final MapColour mapColours;

  /// This Color is used for all the countries that have no custom color

  final BuildContext context;
  final MapSettings settings;

  /// The CountryColors is basically a list of Countries and Colors to give a Countrie a color of choice.
  final Map? colors;

  final CountryBorder? countryBorder;

  const SimpleMapPainter({
    required this.countries,
    required this.mapColours,
    this.colors,
    required this.context,
    this.countryBorder,
    required this.settings,
  });

  @override
  void paint(Canvas c, Size s) {
    TouchyCanvas canvas = TouchyCanvas(context, c);

    if (countries.length > 50) {
      // Draw background Path
      Path backgroundPath = Path();
      backgroundPath.moveTo(0, 0);
      backgroundPath.lineTo(s.width, 0);
      backgroundPath.lineTo(s.width, s.height);
      backgroundPath.lineTo(0, s.height);
      canvas.drawPath(
        backgroundPath,
        Paint()..color = mapColours.backgroundColor,
      );
    }

    // Get country paths from Json
    // List countryPaths = json.decode(jsonData);

    // Draw paths
    //for (int i = 0; i < countryPathList.length; i++) {
    // List<String> paths = countryPathList[i].instructions;
    List<double> xValues = [];
    List<double> yValues = [];

    for (var country in countries) {
      String instructions = country.map;
      Color colour = country.colour;
      Path path = Path();
      Path pathX = Path();

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

      /*
      paint.color = Colors.white;
      paint.strokeWidth = 0.1;
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);

      
      if (xValues.reduce(max) - xValues.reduce(min) < 100) {
        if (yValues.reduce(max) - yValues.reduce(min) < 100) {
          Rect rect = Rect.fromLTRB(xValues.reduce(min), yValues.reduce(min),
              xValues.reduce(max), yValues.reduce(max));
          Paint paint2 = Paint()..color = Colors.yellow;
          canvas.drawOval(rect, paint2);
        }
      }
      
      
      
      if (countries.length < 50) {
        double avgX = calculateAvg(xValues);
        double avgY = calculateAvg(yValues);

        Paint circlePaint = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill;

        double circleRadius = 10.0;
        canvas.drawCircle(Offset(avgX, avgY), circleRadius, circlePaint);

        xValues = [];
        yValues = [];
        colour = Colors.purple;
      }
      
      
      paint.color = Colors.white;
      paint.strokeWidth = 0.3;
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);

      double avgX = calculateAvg(xValues);
      double avgY = calculateAvg(yValues);

      Paint circlePaint = Paint()
        ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

      double circleRadius = 10.0; // Ändere dies nach Bedarf
    
      // canvas.drawCircle(Offset(avgX, avgY), circleRadius, circlePaint);

      // Read path instructions and start drawing
      for (int j = 0; j < paths.length; j++) {
        String instruction = paths[j];
        if (instruction == "c") {
          oldX = 0;
          oldY = 0;
          path.close();
        } else {
          List<String> coordinates = instruction.substring(1).split(',');
          double x = oldX + double.parse(coordinates[0]);
          double y = oldY + double.parse(coordinates[1]);

          if (instruction[0] == 'm') path.moveTo(x, y);
          if (instruction[0] == 'l') path.lineTo(x, y);
          oldX = x;
          oldY = y;
        }
        



        final onTapUp = (tabdetail) => callback(
              countryPathList[i].uniqueID,
              countryPathList[i].name,
              tabdetail,
            );

        // Draw country body
        String uniqueID = countryPathList[i].uniqueID;
          Paint paint = Paint()..color = colors?[uniqueID] ?? backgroundColor;
      */
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

  double calculateAvg(List values) {
    if (values.isEmpty) {
      return 0.0; // Rückgabewert für eine leere Liste
    }

    double summe = 0.0;

    for (double zahl in values) {
      summe += zahl;
    }
    return summe / values.length;
  }

  @override
  bool shouldRepaint(SimpleMapPainter oldDelegate) =>
      oldDelegate.colors != colors;
}
