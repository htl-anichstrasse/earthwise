import 'package:countries_world_map/components/canvas/touch_detector.dart';
import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Models/map_colour.dart';

import 'package:maestro/Models/mapSettings.dart';

import 'painter.dart';

/// This is the main widget that will paint the map based on the given insturctions (json).
class SimpleMap extends StatelessWidget {
  final CountryBorder? countryBorder;

  final MapColour mapColours;
  final List<Country> countries;
  final MapSettings settings;

  /// Default color for all countries. If not provided the default Color will be grey.

  /// This is basically a list of countries and colors to apply different colors to specific countries.
  final Map? colors;

  /// Triggered when a country is tapped.
  /// The first parameter is the isoCode of the country that was tapped.
  /// The second parameter is the TapUpDetails of the tap.
  final void Function(String id, String name, TapUpDetails tapDetails)?
      callback;

  /// This is the BoxFit that will be used to fit the map in the available space.
  /// If not provided the default BoxFit will be BoxFit.contain.
  final BoxFit? fit;

  const SimpleMap({
    required this.mapColours,
    this.colors,
    this.callback,
    this.fit,
    this.countryBorder,
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
            painter: SimpleMapPainter(
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

class CountryBorder {
  final Color color;
  final double width;

  const CountryBorder({
    required this.color,
    this.width = 1,
  });
}
