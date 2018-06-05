import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ThemeData themeData = new ThemeData(
    brightness: Brightness.light,
    cardColor: Colors.white,
    dividerColor: Colors.grey[300],
    backgroundColor: Colors.grey[100],
    primaryColor: _MyColors.theme[500],
    primaryColorBrightness: Brightness.light,
    secondaryHeaderColor: Colors.white,
    accentColor: _MyColors.accent[500],
    primaryTextTheme: new Typography(platform: defaultTargetPlatform).white,
    primaryIconTheme: const IconThemeData(color: Colors.white),
  accentIconTheme: const IconThemeData(color: Colors.white),
);

class _MyColors {

  _MyColors();

  static const Map<int, Color> theme = const <int, Color>{
    500: const Color(0xFF2196F3),
    600: const Color(0xFF1E88E5),
  };

  static const Map<int, Color> accent = const <int, Color>{
    500: const Color(0xFF9575CD),
  };
}