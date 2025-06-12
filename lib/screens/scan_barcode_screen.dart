import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/history_service.dart';
import '../models/product.dart';
import '../models/ingredient.dart';
import '../models/scan_history.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../constants/app_constants.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  Product? _product;
  String? _barcode;
  String? _error;
  bool _loading = false;
  Map<String, List<Ingredient>> _compositionAnalysis = {};

  Future<void> _scanBarcode() async {
    setState(() {
      _loading = true;
      _error = null;
      _product = null;
      _compositionAnalysis = {};
    });
    try {
      var result = await BarcodeScanner.scan(
        options: ScanOptions(
          useCamera: 0,
        ),
      );
      String barcode = result.rawContent;
      if (barcode.isEmpty) {
        setState(() {
          _loading = false;
          _error = AppText.barcodeNotFound;
        });
        return;
      }
      Product? product = await FirebaseService.getProduct(barcode);
      if (product != null) {
        Map<String, List<Ingredient>> analysis = 
            await FirebaseService.checkCompositions(product.compositions);
        
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
          _error = AppText.productNotFound;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = AppText.scanError;
      });
    }
  }

  Color _getOverallStatusColor() {
    if (_compositionAnalysis.isEmpty) return AppColors.grey;
    
    if (_compositionAnalysis['haram']?.isNotEmpty == true) {
      return AppColors.error;
    } else if (_compositionAnalysis['meragukan']?.isNotEmpty == true || 
               _compositionAnalysis['unknown']?.isNotEmpty == true) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }

  String _getOverallStatus() {
    if (_compositionAnalysis.isEmpty) return AppText.statusUnknown;
    
    if (_compositionAnalysis['haram']?.isNotEmpty == true) {
      return AppText.statusHaram;
    } else if (_compositionAnalysis['meragukan']?.isNotEmpty == true || 
               _compositionAnalysis['unknown']?.isNotEmpty == true) {
      return AppText.statusMeragukan;
    } else {
      return AppText.statusHalal;
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppText.scanBarcodeTitle,
          style: AppStyles.heading.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? AppSizes.screenPaddingXLarge : AppSizes.screenPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: isTablet ? AppSizes.iconSizeTablet : AppSizes.iconSize,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: isTablet ? AppSizes.spacingLarge : AppSizes.spacingMedium),
                        Text(
                          AppText.scanBarcodeSubtitle,
                          textAlign: TextAlign.center,
                          style: AppStyles.body.copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _scanBarcode,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, isTablet ? AppSizes.buttonSizeTablet : AppSizes.buttonSize),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
                      ),
                      elevation: AppSizes.buttonElevation,
                    ),
                    child: _loading
                        ? CircularProgressIndicator(color: AppColors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: AppColors.white),
                              SizedBox(width: isTablet ? AppSizes.spacingMedium : AppSizes.spacingSmall),
                              Text(
                                AppText.startScanBarcode,
                                style: AppStyles.button.copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
              if (_barcode != null)
                Container(
                  padding: EdgeInsets.all(AppSizes.spacingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.qr_code, color: AppColors.grey),
                      SizedBox(width: AppSizes.spacingSmall),
                      Text(
                        '${AppText.barcodeLabel}: $_barcode',
                        style: AppStyles.body.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              if (_error != null)
                Container(
                  margin: EdgeInsets.only(top: AppSizes.spacingMedium),
                  padding: EdgeInsets.all(AppSizes.spacingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    border: Border.all(color: AppColors.error.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error),
                      SizedBox(width: AppSizes.spacingSmall),
                      Expanded(
                        child: Text(
                          _error!,
                          style: AppStyles.body.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_product != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: AppSizes.spacingMedium),
                      padding: EdgeInsets.all(AppSizes.spacingLarge),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.spacingSmall,
                                  vertical: AppSizes.spacingXSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: _getOverallStatusColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                                ),
                                child: Text(
                                  _getOverallStatus().toUpperCase(),
                                  style: AppStyles.button.copyWith(
                                    color: _getOverallStatusColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          Text(
                            _product!.name,
                            style: AppStyles.heading,
                          ),
                          SizedBox(height: AppSizes.spacingLarge),
                          _buildInfoRow(AppText.certificateNumber, _product!.certificateNumber),
                          _buildInfoRow(AppText.expiredDate, _formatExpiredDate(_product!.expiredDate)),
                          SizedBox(height: AppSizes.spacingMedium),
                          Text(
                            AppText.compositionAnalysis,
                            style: AppStyles.subheading,
                          ),
                          SizedBox(height: AppSizes.spacingSmall),
                          
                          if (_compositionAnalysis['haram']?.isNotEmpty == true) ...[
                            _buildCompositionSection(AppText.haramIngredients, _compositionAnalysis['haram']!, AppColors.error),
                            SizedBox(height: AppSizes.spacingSmall),
                          ],
                          
                          if (_compositionAnalysis['meragukan']?.isNotEmpty == true) ...[
                            _buildCompositionSection(AppText.meragukanIngredients, _compositionAnalysis['meragukan']!, AppColors.warning),
                            SizedBox(height: AppSizes.spacingSmall),
                          ],
                          
                          if (_compositionAnalysis['unknown']?.isNotEmpty == true) ...[
                            _buildCompositionSection(AppText.unknownIngredients, _compositionAnalysis['unknown']!, AppColors.grey),
                            SizedBox(height: AppSizes.spacingSmall),
                          ],
                          
                          if (_compositionAnalysis['halal']?.isNotEmpty == true) ...[
                            _buildCompositionSection(AppText.halalIngredients, _compositionAnalysis['halal']!, AppColors.success),
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppStyles.body.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompositionSection(String title, List<Ingredient> ingredients, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
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
                size: AppSizes.iconSizeSmall,
              ),
              SizedBox(width: AppSizes.spacingXSmall),
              Text(
                title,
                style: AppStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingXSmall),
          ...ingredients.map((ingredient) => Padding(
            padding: EdgeInsets.only(bottom: AppSizes.spacingXSmall),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 6,
                  color: color,
                ),
                SizedBox(width: AppSizes.spacingXSmall),
                Expanded(
                  child: Text(
                    ingredient.name,
                    style: AppStyles.body.copyWith(
                      color: color.withOpacity(0.8),
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
