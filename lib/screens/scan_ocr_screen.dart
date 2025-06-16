import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../services/firebase_service.dart';
import '../services/history_service.dart';
import '../services/accessibility_provider.dart';
import '../models/ingredient.dart';
import '../models/scan_history.dart';
import '../constants/app_constants.dart';
import '../constants/text_constants.dart';
import 'ocr_result_screen.dart';
import 'scan_barcode_screen.dart';
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
  bool _isFlashOn = false;
  String? _error;
  bool _hasPermission = false;
  List<String> _ingredients = [];
  Map<String, List<Ingredient>> _compositionAnalysis = {};

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _hasPermission = status.isGranted;
        if (_hasPermission) {
          _initCamera();
        }
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      if (_cameraController != null) {
        await _cameraController!.dispose();
      }
      
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium, // Changed from high to medium for better performance
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal menginisialisasi kamera';
        });
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _scanText() async {
    if (!_isCameraInitialized || _cameraController == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _ingredients = [];
      _compositionAnalysis = {};
    });
    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();
      
      String allText = recognizedText.text;
      List<String> ingredients = allText
          .replaceAll(';', ',')
          .replaceAll('\n', ',')
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();

      Map<String, List<Ingredient>> analysis = 
          await FirebaseService.checkCompositions(ingredients);
      
      // Save to history
      final historyItem = ScanHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productName: 'Produk OCR - ${DateTime.now().toString().substring(0, 16)}',
        barcode: null,
        compositions: ingredients,
        overallStatus: _getOverallStatusFromAnalysis(analysis),
        scanDate: DateTime.now(),
        scanType: 'ocr',
        compositionAnalysis: analysis.map((key, value) => 
          MapEntry(key, value.map((ingredient) => ingredient.name).toList())),
      );
      await HistoryService.addScanHistory(historyItem);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OCRResultScreen(
            imagePath: image.path,
            ingredients: ingredients,
            compositionAnalysis: analysis,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Gagal scan komposisi.';
      });
    }
  }

  Color _statusColor() {
    if (_compositionAnalysis['haram']?.isNotEmpty == true) return Colors.red;
    if (_compositionAnalysis['meragukan']?.isNotEmpty == true || 
        _compositionAnalysis['unknown']?.isNotEmpty == true) return Colors.orange;
    if (_compositionAnalysis['halal']?.isNotEmpty == true) return Colors.green;
    return Colors.grey;
  }

  String _statusText() {
    if (_compositionAnalysis['haram']?.isNotEmpty == true) return 'Haram';
    if (_compositionAnalysis['meragukan']?.isNotEmpty == true || 
        _compositionAnalysis['unknown']?.isNotEmpty == true) return 'Meragukan';
    if (_compositionAnalysis['halal']?.isNotEmpty == true) return 'Halal';
    return 'Tidak Diketahui';
  }
  String _getOverallStatusFromAnalysis(Map<String, List<Ingredient>> analysis) {
    if (analysis.isEmpty) return AppText.categoryUnknown;
    
    if (analysis['haram']?.isNotEmpty == true) {
      return AppText.categoryHaram;
    } else if (analysis['meragukan']?.isNotEmpty == true || 
               analysis['unknown']?.isNotEmpty == true) {
      return AppText.categoryMeragukan;
    } else if (analysis['halal']?.isNotEmpty == true) {
      return AppText.categoryHalal;
    } else {
      return AppText.categoryUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isMonochromeMode = access.isColorBlindMode;

    final backgroundColor = isMonochromeMode ? 
      AppColors.backgroundMonochrome : AppColors.background;
    final textColor = isMonochromeMode ? 
      AppColors.textPrimaryMonochrome : AppColors.textPrimary;
    final primaryColor = isMonochromeMode ? 
      AppColors.primaryMonochrome : AppColors.primary;
    final secondaryColor = isMonochromeMode ? 
      AppColors.secondaryMonochrome : AppColors.secondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            textAlign: TextAlign.center,
            AppText.scanCompositionTitle,
            style: AppStyles.heading(context).copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? AppSizes.screenPaddingXLarge : AppSizes.screenPaddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isTablet ? 32 : 16),
                      // Camera Container
                      Container(
                        width: double.infinity,
                        height: isTablet ? 400 : 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: !_hasPermission
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: Colors.white, size: 64),
                                      SizedBox(height: 16),
                                      Text(
                                        AppText.scanCompositionPermission,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: _checkPermission,
                                        icon: Icon(Icons.camera_alt),
                                        label: Text(AppText.scanCompositionPermissionButton),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  children: [
                                    if (_isCameraInitialized)
                                      Transform.scale(
                                        scale: 2.15,
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 1 / _cameraController!.value.aspectRatio,
                                            child: CameraPreview(_cameraController!),
                                          ),
                                        ),
                                      ),
                                    // Overlay kotak scan
                                    Center(
                                      child: Container(
                                        width: isTablet ? 300 : 220,
                                        height: isTablet ? 150 : 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                    // Teks instruksi
                                    Positioned(
                                      bottom: 24,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            AppText.scanCompositionInstruction,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isTablet ? 16 : 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Tombol flash
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          onPressed: _toggleFlash,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 40 : 24),
                      // Scan Button
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                        child: ElevatedButton.icon(
                          onPressed: _loading ? null : _scanText,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: access.iconSize,
                          ),
                          label: Text(
                            _loading ? AppText.scanningButton : AppText.scanCompositionButton,
                            style: AppStyles.body(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 20 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Switch Mode Button at bottom
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () async {
                  if (_cameraController != null) {
                    await _cameraController!.dispose();
                  }
                  if (mounted) {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanBarcodeScreen()),
                    );
                  }
                },
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: primaryColor,
                  size: access.iconSize,
                ),
                label: Text(
                  AppText.switchToBarcode,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompositionSection(String title, List<Ingredient> ingredients, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                title.contains('Haram') ? Icons.warning : 
                title.contains('Meragukan') || title.contains('Tidak Dikenal') ? Icons.help_outline : Icons.check_circle,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...ingredients.map((ingredient) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 6,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name,
                        style: TextStyle(
                          color: color.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (ingredient.description.isNotEmpty)
                        Text(
                          ingredient.description,
                          style: TextStyle(
                            color: color.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}