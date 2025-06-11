import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/history_service.dart';
import '../models/product.dart';
import '../models/ingredient.dart';
import '../models/scan_history.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  Product? _product;
  String? _barcode;  String? _error;
  bool _loading = false;
  Map<String, List<Ingredient>> _compositionAnalysis = {};

  Future<void> _scanBarcode() async {
    setState(() {
      _loading = true;
      _error = null;
      _product = null;
      _compositionAnalysis = {};
    });
    try {      var result = await BarcodeScanner.scan(
        options: ScanOptions(
          useCamera: 0,
        ),
      );
      String barcode = result.rawContent;
      if (barcode.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'Barcode tidak terdeteksi.';
        });
        return;
      }
      Product? product = await FirebaseService.getProduct(barcode);
        if (product != null) {
        // Analyze compositions
        Map<String, List<Ingredient>> analysis = 
            await FirebaseService.checkCompositions(product.compositions);
        
        // Save to history
        final historyItem = ScanHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productName: product.name,
          barcode: barcode,
          compositions: product.compositions,
          overallStatus: _getOverallStatusFromAnalysis(analysis),
          scanDate: DateTime.now(),
          scanType: 'barcode',
          compositionAnalysis: analysis.map((key, value) => 
            MapEntry(key, value.map((ingredient) => ingredient.name).toList())),
        );
        await HistoryService.addScanHistory(historyItem);
        
        setState(() {
          _barcode = barcode;
          _product = product;
          _compositionAnalysis = analysis;
          _loading = false;
        });
      } else {
        setState(() {
          _barcode = barcode;
          _product = null;
          _loading = false;
          _error = 'Produk tidak ditemukan dalam database.';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Gagal scan barcode.';
      });    }
  }

  Color _getOverallStatusColor() {
    if (_compositionAnalysis.isEmpty) return Colors.grey;
    
    if (_compositionAnalysis['haram']?.isNotEmpty == true) {
      return Colors.red;
    } else if (_compositionAnalysis['meragukan']?.isNotEmpty == true || 
               _compositionAnalysis['unknown']?.isNotEmpty == true) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
  String _getOverallStatus() {
    if (_compositionAnalysis.isEmpty) return 'Tidak Diketahui';
    
    if (_compositionAnalysis['haram']?.isNotEmpty == true) {
      return 'Haram';
    } else if (_compositionAnalysis['meragukan']?.isNotEmpty == true || 
               _compositionAnalysis['unknown']?.isNotEmpty == true) {
      return 'Meragukan';
    } else {
      return 'Halal';
    }
  }

  String _getOverallStatusFromAnalysis(Map<String, List<Ingredient>> analysis) {
    if (analysis.isEmpty) return 'unknown';
    
    if (analysis['haram']?.isNotEmpty == true) {
      return 'haram';
    } else if (analysis['meragukan']?.isNotEmpty == true || 
               analysis['unknown']?.isNotEmpty == true) {
      return 'meragukan';
    } else {
      return 'halal';
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      'Scan Barcode',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 50 : 40),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 28 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: isTablet ? 100 : 80,
                            color: Colors.green.shade300,
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Text(
                            'Pindai barcode produk untuk memeriksa kehalalannya',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),                SizedBox(height: isTablet ? 40 : 32),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _scanBarcode,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, isTablet ? 70 : 60),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt),
                                SizedBox(width: isTablet ? 12 : 8),
                                Text(
                                  'Mulai Scan Barcode',
                                  style: TextStyle(fontSize: isTablet ? 20 : 18),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 40 : 32),
                if (_barcode != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(
                          'Barcode: $_barcode',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_error != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_product != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getOverallStatusColor().withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getOverallStatus().toUpperCase(),
                                    style: TextStyle(
                                      color: _getOverallStatusColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _product!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow('No. Sertifikat', _product!.certificateNumber),
                            _buildInfoRow('Tanggal Expired', _formatExpiredDate(_product!.expiredDate)),
                            const SizedBox(height: 16),
                            const Text(
                              'Analisis Komposisi:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Display composition analysis
                            if (_compositionAnalysis['haram']?.isNotEmpty == true) ...[
                              _buildCompositionSection('Bahan Haram', _compositionAnalysis['haram']!, Colors.red),
                              const SizedBox(height: 12),
                            ],
                            
                            if (_compositionAnalysis['meragukan']?.isNotEmpty == true) ...[
                              _buildCompositionSection('Bahan Meragukan', _compositionAnalysis['meragukan']!, Colors.orange),
                              const SizedBox(height: 12),
                            ],
                            
                            if (_compositionAnalysis['unknown']?.isNotEmpty == true) ...[
                              _buildCompositionSection('Bahan Tidak Dikenal', _compositionAnalysis['unknown']!, Colors.grey),
                              const SizedBox(height: 12),
                            ],
                            
                            if (_compositionAnalysis['halal']?.isNotEmpty == true) ...[
                              _buildCompositionSection('Bahan Halal', _compositionAnalysis['halal']!, Colors.green),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],      ),
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
                  child: Text(
                    ingredient.name,
                    style: TextStyle(
                      color: color.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  String _formatExpiredDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
