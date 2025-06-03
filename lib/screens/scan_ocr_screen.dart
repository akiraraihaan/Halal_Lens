import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/firebase_service.dart';
import '../models/haram_composition.dart';
// import 'package:flutter_tts/flutter_tts.dart'; // Uncomment if using flutter_tts

class ScanOCRScreen extends StatefulWidget {
  const ScanOCRScreen({Key? key}) : super(key: key);

  @override
  State<ScanOCRScreen> createState() => _ScanOCRScreenState();
}

class _ScanOCRScreenState extends State<ScanOCRScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _loading = false;
  String? _error;
  List<String> _ingredients = [];
  List<HaramComposition> _haramFound = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _scanText() async {
    if (!_isCameraInitialized || _cameraController == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _ingredients = [];
      _haramFound = [];
    });
    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();
      // Ekstrak ingredient dari hasil OCR (sederhana: split koma/baris)
      String allText = recognizedText.text;
      List<String> ingredients = allText
          .replaceAll(';', ',')
          .replaceAll('\n', ',')
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();
      List<HaramComposition> haramFound = await FirebaseService.checkIngredients(ingredients);
      setState(() {
        _ingredients = ingredients;
        _haramFound = haramFound;
        _loading = false;
      });
      // TODO: Integrasi TTS di sini
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Gagal scan komposisi.';
      });
    }
  }

  Color _statusColor() {
    if (_haramFound.isEmpty && _ingredients.isNotEmpty) return Colors.green;
    if (_haramFound.isNotEmpty) return Colors.red;
    return Colors.grey;
  }

  String _statusText() {
    if (_haramFound.isEmpty && _ingredients.isNotEmpty) return 'Halal';
    if (_haramFound.isNotEmpty) return 'Haram';
    return 'Tidak Diketahui';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Komposisi (OCR)')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (_isCameraInitialized)
              AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _scanText,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.blueGrey,
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Scan Komposisi', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_ingredients.isNotEmpty)
              Card(
                color: _statusColor().withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_statusText(), style: TextStyle(color: _statusColor(), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Komposisi:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ..._ingredients.map((e) {
                        final isHaram = _haramFound.any((h) => h.name.toLowerCase() == e);
                        return Text(
                          '- $e',
                          style: TextStyle(color: isHaram ? Colors.red : null),
                        );
                      }),
                      if (_haramFound.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Bahan Haram Terdeteksi:', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ..._haramFound.map((h) => Text('- ${h.name} (${h.category})', style: const TextStyle(color: Colors.red))),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
