import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  ThemeData get themeData => _themeData;

  void updateFromColorMap(Map<String, String> colors) {
    final primary = hexToColor(colors['primary'] ?? '#FFB300');
    _themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      primaryColor: primary,
      scaffoldBackgroundColor: hexToColor(colors['background'] ?? '#FFFFFF'),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: hexToColor(colors['button'] ?? '#0D47A1')),
      ),
    );
    notifyListeners();
  }
}
