import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ingredient.dart';
import '../constants/app_constants.dart';
import '../constants/text_constants.dart';
import '../services/accessibility_provider.dart';
import '../services/tts_service.dart'; // Tambahkan import TTS service
import 'scan_ocr_screen.dart';

class OCRResultScreen extends StatelessWidget {
  final String imagePath;
  final List<String> ingredients;
  final Map<String, List<Ingredient>> compositionAnalysis;
  final String? error;
  final TTSService _ttsService = TTSService();

  OCRResultScreen({
    Key? key,
    required this.imagePath,
    required this.ingredients,
    required this.compositionAnalysis,
    this.error,
  }) : super(key: key);

  String _getOverallStatus() {
    if (compositionAnalysis.isEmpty) return AppText.categoryUnknown;
    if (compositionAnalysis['haram']?.isNotEmpty == true) {
      return AppText.categoryHaram;
    } else if (compositionAnalysis['meragukan']?.isNotEmpty == true || compositionAnalysis['unknown']?.isNotEmpty == true) {
      return AppText.categoryMeragukan;
    } else if (compositionAnalysis['halal']?.isNotEmpty == true) {
      return AppText.categoryHalal;
    } else {
      return AppText.categoryUnknown;
    }
  }

  Color _getOverallStatusColor(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final isMonochromeMode = access.isColorBlindMode;    if (compositionAnalysis.isEmpty) return AppColors.grey;
    if (compositionAnalysis['haram']?.isNotEmpty == true) {
      return isMonochromeMode ? AppColors.errorMonochrome : AppColors.error;
    } else if (compositionAnalysis['meragukan']?.isNotEmpty == true || compositionAnalysis['unknown']?.isNotEmpty == true) {
      return isMonochromeMode ? AppColors.warningMonochrome : AppColors.warning;
    } else if (compositionAnalysis['halal']?.isNotEmpty == true) {
      return isMonochromeMode ? AppColors.successMonochrome : AppColors.success;
    } else {
      return AppColors.grey;
    }
  }
  String _getStatusDescription() {
    if (compositionAnalysis.isEmpty) {
      return AppText.unknownStatusDescription;
    }
    if (compositionAnalysis['haram']?.isNotEmpty == true) {
      return AppText.haramStatusDescription;
    } else if (compositionAnalysis['meragukan']?.isNotEmpty == true || compositionAnalysis['unknown']?.isNotEmpty == true) {
      return AppText.syubhatStatusDescription;} else {
      return AppText.halalStatusDescription;
    }
  }

  // Method untuk memanggil text-to-speech
  void _speakStatus(String productLabel) {
    final status = _getOverallStatus();
    _ttsService.speakProductStatus(productLabel, status);
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
            AppText.scanResultTitle,
            textAlign: TextAlign.center,
            style: AppStyles.heading(context).copyWith(
              color: textColor,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
            size: access.iconSize,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? AppSizes.screenPaddingXLarge : AppSizes.screenPaddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (error != null)
                  _buildErrorCard(error!, primaryColor)
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tombol TTS Besar untuk Akses Cepat Bantuan Suara
                      ElevatedButton.icon(
                        icon: Icon(Icons.volume_up, size: isTablet ? 32 : 28),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          child: Text(
                            AppText.listenProductStatus,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getOverallStatusColor(context),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, isTablet ? 70 : 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () => _speakStatus(AppText.scanResultTitle),
                      ),
                      SizedBox(height: 20),
                      // Status Banner
                      _buildStatusBanner(
                        _getOverallStatus(),
                        _getOverallStatusColor(context),
                        _getStatusDescription(),
                        isTablet,
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Captured Image
                      Container(
                        width: double.infinity,
                        height: isTablet ? 300 : 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Composition Analysis
                      _buildCompositionAnalysis(
                        compositionAnalysis,
                        isTablet,
                        primaryColor,
                        textColor,
                        isMonochromeMode,
                      ),
                    ],
                  ),
                SizedBox(height: isTablet ? 32 : 24),
                // Action Buttons
                _buildActionButtons(
                  context,
                  isTablet,
                  primaryColor,
                  secondaryColor,
                  textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(
    String status,
    Color statusColor,
    String description,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.1),
            statusColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  status == AppText.categoryHalal
                      ? Icons.check_circle
                      : status == AppText.categoryHaram
                          ? Icons.cancel
                          : status == AppText.categoryMeragukan
                              ? Icons.warning
                              : Icons.help_outline,
                  color: statusColor,
                  size: isTablet ? 32 : 24,
                ),
              ),
              SizedBox(width: 16),
              Text(
                status,
                style: TextStyle(
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              description,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: statusColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCompositionAnalysis(
    Map<String, List<Ingredient>> analysis,
    bool isTablet,
    Color primaryColor,
    Color textColor,
    bool isMonochromeMode,
  ) {
    // Check if there are any ingredients
    bool hasIngredients = 
        analysis['halal']?.isNotEmpty == true || 
        analysis['haram']?.isNotEmpty == true || 
        analysis['syubhat']?.isNotEmpty == true || 
        analysis['unknown']?.isNotEmpty == true;
    
    // Display special message if analysis is empty
    if (!hasIngredients) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.compositionAnalysis,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                AppText.noCompositionData,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: textColor.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppText.compositionAnalysis,
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Halal Ingredients - Show halal ingredients first
              if (analysis['halal']?.isNotEmpty == true)
                _buildIngredientSection(
                  AppText.categoryHalal,
                  analysis['halal']!,
                  isMonochromeMode ? AppColors.successMonochrome : AppColors.success,
                  isTablet,
                  textColor,
                ),
              // Haram Ingredients
              if (analysis['haram']?.isNotEmpty == true)
                _buildIngredientSection(
                  AppText.categoryHaram,
                  analysis['haram']!,
                  isMonochromeMode ? AppColors.errorMonochrome : AppColors.error,
                  isTablet,
                  textColor,
                ),
              // Syubhat Ingredients
              if (analysis['syubhat']?.isNotEmpty == true)
                _buildIngredientSection(
                  AppText.categoryMeragukan,
                  analysis['syubhat']!,
                  isMonochromeMode ? AppColors.warningMonochrome : AppColors.warning,
                  isTablet,
                  textColor,
                ),
              // Unknown Ingredients
              if (analysis['unknown']?.isNotEmpty == true)
                _buildIngredientSection(
                  AppText.categoryUnknown,
                  analysis['unknown']!,
                  isMonochromeMode ? AppColors.textSecondaryMonochrome : AppColors.grey,
                  isTablet,
                  textColor,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientSection(
    String title,
    List<Ingredient> ingredients,
    Color color,
    bool isTablet,
    Color textColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    title == AppText.categoryHalal
                        ? Icons.check_circle
                        : title == AppText.categoryHaram
                            ? Icons.cancel
                            : title == AppText.categoryMeragukan
                                ? Icons.warning
                                : Icons.help_outline,
                    color: color,
                    size: 18,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  AppText.ingredientsCount.replaceAll('%d', ingredients.length.toString()),
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (ingredients.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients.map((ingredient) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: textColor,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isTablet,
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanOCRScreen()),
              );
            },
            icon: Icon(
              Icons.document_scanner,
              color: Colors.white,
            ),
            label: Text(
              AppText.scanAgainButton,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
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
    );  }
}