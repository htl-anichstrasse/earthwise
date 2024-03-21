import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';

class MapSettings {
  final List<String> countries;
  final List<String>? specialCountries;
  final double startX;
  final double endX;
  final double startY;
  final double endY;

  MapSettings({
    required this.countries,
    this.specialCountries,
    required this.startX,
    required this.endX,
    required this.startY,
    required this.endY,
  });
}

MapSettings souveranSettings = MapSettings(
  countries: countryCodes,
  specialCountries: specialCountries,
  startX: 0,
  endX: 1200,
  startY: -500,
  endY: 800,
);

MapSettings northAmericaSettings = MapSettings(
  countries: northAmericaCodes,
  startX: 0,
  endX: 400,
  startY: 0,
  endY: 220,
);

MapSettings southAmericaSettings = MapSettings(
  countries: southAmericaCodes,
  startX: 240,
  endX: 450,
  startY: 180,
  endY: 400,
);

MapSettings asiaSettings = MapSettings(
  countries: asiaCodes,
  startX: 550,
  endX: 900,
  startY: 75,
  endY: 300,
);
MapSettings africaSettings = MapSettings(
  countries: africaCodes,
  startX: 420,
  endX: 700,
  startY: 120,
  endY: 400,
);

MapSettings oceaniaSettings = MapSettings(
  countries: oceaniaCodes,
  startX: 800,
  endX: 1200,
  startY: 175,
  endY: 400,
);

MapSettings europeSetting = MapSettings(
  countries: europeCodes,
  specialCountries: specialCountries,
  startX: 440,
  endX: 630,
  startY: 0,
  endY: 140,
);
