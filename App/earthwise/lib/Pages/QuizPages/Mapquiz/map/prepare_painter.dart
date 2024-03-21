import 'package:countries_world_map/components/canvas/touch_detector.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/map_settings.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/map_colour.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/painter.dart';

/// This is the main widget that will paint the map based on the given instructions (json).
class DrawMap extends StatelessWidget {
  final MapColour mapColours;
  final List<Country> countries;
  final MapSettings settings;
  final Map? colors;
  final void Function(String id, String name, TapUpDetails tapDetails)?
      callback;
  final BoxFit? fit;

  const DrawMap({
    required this.mapColours,
    this.colors,
    this.callback,
    this.fit,
    required this.settings,
    required this.countries,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: fit ?? BoxFit.contain,
      child: RepaintBoundary(
        child: CanvasTouchDetector(
          builder: (context) => CustomPaint(
            isComplex: true,
            size: Size(settings.endX - settings.startX,
                settings.endY - settings.startY),
            painter: Painter(
              context: context,
              settings: settings,
              countries: countries,
              colors: colors,
              mapColours: mapColours,
            ),
          ),
        ),
      ),
    );
  }
}
