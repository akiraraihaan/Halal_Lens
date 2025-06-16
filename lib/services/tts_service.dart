import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> _initTTS() async {
    if (_isInitialized) return;
    
    await _flutterTts.setLanguage('id-ID'); // Bahasa Indonesia
    await _flutterTts.setSpeechRate(0.5); // Kecepatan bicara (0.0 - 1.0)
    await _flutterTts.setVolume(1.0); // Volume (0.0 - 1.0)
    await _flutterTts.setPitch(1.0); // Pitch/nada (0.5 - 2.0)
    
    _isInitialized = true;
  }

  static Future<void> speak(String text) async {
    await _initTTS();
    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Metode untuk membacakan status halal/haram/meragukan dengan informasi tambahan
  static Future<void> speakProductStatus(String productName, String status) async {
    String message;
    
    switch (status.toUpperCase()) {
      case 'HALAL':
        message = 'Produk $productName memiliki status halal dan aman untuk dikonsumsi.';
        break;
      case 'HARAM':
        message = 'Perhatian! Produk $productName memiliki status haram dan tidak direkomendasikan untuk dikonsumsi.';
        break;
      case 'MERAGUKAN':
        message = 'Hati-hati! Produk $productName memiliki status meragukan, perlu pemeriksaan lebih lanjut.';
        break;
      default:
        message = 'Status produk $productName tidak dapat ditentukan.';
    }
    
    await speak(message);
  }
}
