import 'package:flutter/material.dart';

class AccessibilityProvider with ChangeNotifier {
  bool _isHighContrast = false;
  bool _isColorBlindMode = false;
  double _iconSize = 24.0;
  double _fontSize = 16.0; // Added to match the service version
  String _textSize = 'sedang'; // Added to match the service version

  bool get isHighContrast => _isHighContrast;
  bool get isColorBlindMode => _isColorBlindMode;
  double get iconSize => _iconSize;
  double get fontSize => _fontSize; // Added getter
  String get textSize => _textSize; // Added getter

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
  
  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
  
  void setTextSize(String size) {
    _textSize = size;
    notifyListeners();
  }
} 