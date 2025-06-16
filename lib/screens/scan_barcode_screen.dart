import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/firebase_service.dart';
import '../models/product.dart';
import '../models/ingredient.dart';
import '../constants/app_constants.dart';
import '../constants/text_constants.dart';
import '../services/accessibility_provider.dart';
import 'scan_ocr_screen.dart';
import 'barcode_result_screen.dart';
import '../services/history_service.dart';
import '../models/scan_history.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  bool _isFlashOn = false;
  MobileScannerController? _scannerController;
  bool _hasPermission = false;
  String? _lastScannedBarcode;
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _hasPermission = status.isGranted;
      });
      if (status.isGranted) {
        try {
          // Dispose existing controller if any
          await _scannerController?.stop();
          _scannerController?.dispose();
          
          // Create new controller
          _scannerController = MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
            torchEnabled: false,
          );
          
          // Initialize and start
          await _scannerController?.start();
          
          // Force rebuild to show camera preview
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          print('Error initializing camera: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _processBarcode(String barcode) async {
    if (_scannerController == null) return;
    // Prevent duplicate scans within 2 seconds
    if (barcode == _lastScannedBarcode && 
        _lastScanTime != null && 
        DateTime.now().difference(_lastScanTime!) < const Duration(seconds: 2)) {
      return;
    }

    // Update last scanned barcode and time
    setState(() {
      _lastScannedBarcode = barcode;
      _lastScanTime = DateTime.now();
    });

    try {
      // Pause scanner temporarily to prevent multiple scans
      await _scannerController?.stop();
      
      Product? product = await FirebaseService.getProduct(barcode);
      if (product != null) {
        Map<String, List<Ingredient>> analysis = 
            await FirebaseService.checkCompositions(product.compositions);
        
        // Save to history
        await HistoryService.addScanHistory(ScanHistory(
          productName: product.name,
          barcode: barcode,
          scanType: 'barcode',
          overallStatus: _getOverallStatus(analysis),
          compositions: product.compositions,
          scanDate: DateTime.now(),
          compositionAnalysis: analysis.map((key, value) => 
            MapEntry(key, value.map((e) => e.name).toList())),
        ));
        
        // Resume scanner after processing
        await _scannerController?.start();
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BarcodeResultScreen(
              barcode: barcode,
              product: product,
              compositionAnalysis: analysis,
            ),
          ),
        );
      } else {
        // Resume scanner after processing
        await _scannerController?.start();
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BarcodeResultScreen(
              barcode: barcode,
              product: null,
              compositionAnalysis: {},
              error: AppText.productNotFound,
            ),
          ),
        );
      }
    } catch (e) {
      // Resume scanner in case of error
      await _scannerController?.start();
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BarcodeResultScreen(
            barcode: null,
            product: null,
            compositionAnalysis: {},
            error: AppText.scanError,
          ),
        ),
      );
    }
  }

  String _getOverallStatus(Map<String, List<Ingredient>> analysis) {
    if (analysis.isEmpty) return AppText.categoryUnknown;
    if (analysis['haram']?.isNotEmpty == true) {
      return AppText.categoryHaram;
    } else if (analysis['meragukan']?.isNotEmpty == true || analysis['unknown']?.isNotEmpty == true) {
      return AppText.categoryMeragukan;
    } else if (analysis['halal']?.isNotEmpty == true) {
      return AppText.categoryHalal;
    } else {
      return AppText.categoryUnknown;
    }
  }

  Future<void> _toggleFlash() async {
    if (_scannerController == null) return;
    try {
      await _scannerController?.toggleTorch();
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {}
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
            AppText.scanBarcodeTitle,
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
                      // Scanner Container
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
                                        AppText.scanBarcodePermission,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: _initCamera,
                                        icon: Icon(Icons.camera_alt),
                                        label: Text(AppText.scanBarcodePermissionButton),
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
                                    MobileScanner(
                                      controller: _scannerController!,
                                      onDetect: (capture) {
                                        final List<Barcode> barcodes = capture.barcodes;
                                        if (barcodes.isNotEmpty) {
                                          _processBarcode(barcodes.first.rawValue ?? '');
                                        }
                                      },
                                      onScannerStarted: (value) {
                                        print('Scanner started: $value');
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
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
                                            AppText.scanBarcodeInstruction,
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
                  if (_hasPermission) {
                    await _scannerController?.stop();
                    _scannerController?.dispose();
                    _scannerController = null;
                  }
                  if (mounted) {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanOCRScreen()),
                    );
                  }
                },
                icon: Icon(
                  Icons.document_scanner,
                  color: secondaryColor,
                  size: access.iconSize,
                ),
                label: Text(
                  AppText.switchToComposition,
                  style: TextStyle(
                    color: secondaryColor,
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
}
