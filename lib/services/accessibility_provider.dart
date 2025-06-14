import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider extends ChangeNotifier {
  double _fontSize = 16;
  double _iconSize = 24;
  bool _isColorBlindMode = false;

  double get fontSize => _fontSize;
  double get iconSize => _iconSize;
  bool get isColorBlindMode => _isColorBlindMode;

  AccessibilityProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('access_fontSize') ?? 16;
    _iconSize = prefs.getDouble('access_iconSize') ?? 24;
    _isColorBlindMode = prefs.getBool('access_colorBlindMode') ?? false;
    notifyListeners();
  }

  Future<void> setFontSize(double v) async {
    _fontSize = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('access_fontSize', v);
    notifyListeners();
  }

  Future<void> setIconSize(double v) async {
    _iconSize = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('access_iconSize', v);
    notifyListeners();
  }
  
  Future<void> setColorBlindMode(bool enabled) async {
    _isColorBlindMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('access_colorBlindMode', enabled);
    notifyListeners();
  }
}
