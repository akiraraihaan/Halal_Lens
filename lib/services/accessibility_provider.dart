import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider extends ChangeNotifier {
  double _fontSize = 16;
  double _iconSize = 24;

  double get fontSize => _fontSize;
  double get iconSize => _iconSize;

  AccessibilityProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('access_fontSize') ?? 16;
    _iconSize = prefs.getDouble('access_iconSize') ?? 24;
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
}
