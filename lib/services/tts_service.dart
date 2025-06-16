import 'package:flutter_tts/flutter_tts.dart';
import 'package:halal_lens/constants/text_constants.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _flutterTts.setLanguage(AppText.currentLanguageIndex == 0 ? 'id-ID' : 'en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    }
  }

  Future<void> speak(String text) async {
    await initialize();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Metode untuk membacakan status halal/haram/meragukan dengan informasi tambahan
  Future<void> speakProductStatus(String productName, String status) async {
    await initialize();
    
    String message;
    switch (status.toUpperCase()) {
      case 'HALAL':
        message = AppText.currentLanguageIndex == 0 
          ? 'Produk $productName memiliki status halal dan aman untuk dikonsumsi.'
          : 'Product $productName has halal status and is safe for consumption.';
        break;
      case 'HARAM':
        message = AppText.currentLanguageIndex == 0
          ? 'Perhatian! Produk $productName memiliki status haram dan tidak direkomendasikan untuk dikonsumsi.'
          : 'Warning! Product $productName has haram status and is not recommended for consumption.';
        break;
      case 'MERAGUKAN':
        message = AppText.currentLanguageIndex == 0
          ? 'Hati-hati! Produk $productName memiliki status meragukan, perlu pemeriksaan lebih lanjut.'
          : 'Caution! Product $productName has doubtful status and needs further verification.';
        break;
      default:
        message = AppText.currentLanguageIndex == 0
          ? 'Status produk $productName tidak dapat ditentukan.'
          : 'Product $productName status cannot be determined.';
    }
    
    await _flutterTts.speak(message);
  }

  Future<void> dispose() async {
    await _flutterTts.stop();
  }
}
