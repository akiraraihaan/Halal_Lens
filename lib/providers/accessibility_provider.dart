import 'package:flutter/material.dart';

class AccessibilityProvider with ChangeNotifier {
  bool _isHighContrast = false;
  bool _isColorBlindMode = false;
  double _iconSize = 24.0;

  bool get isHighContrast => _isHighContrast;
  bool get isColorBlindMode => _isColorBlindMode;
  double get iconSize => _iconSize;

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    notifyListeners();
  }

  void toggleColorBlindMode() {
    _isColorBlindMode = !_isColorBlindMode;
    notifyListeners();
  }

  void setIconSize(double size) {
    _iconSize = size;
    notifyListeners();
  }
} 