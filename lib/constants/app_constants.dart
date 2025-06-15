import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_provider.dart';
import 'text_constants.dart';

class AppColors {
  static const Color primary = Color.fromRGBO(22, 97, 56, 1); // Green
  static const Color secondary = Color.fromRGBO(196, 166, 97, 1); // Blue Grey
  static const Color background = Color.fromARGB(255, 232, 245, 233); // Light Green 50
  static const Color textPrimary = Color.fromRGBO(22, 97, 56, 1); // Green 900
  static const Color textSecondary = Color.fromRGBO(196, 166, 97, 1); // Grey 700
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);
  static const Color success = Color(0xFF43A047);
  
  // Mode Buta Warna (Monokrom)
  static const Color primaryMonochrome = Color(0xFF333333); // Dark Grey
  static const Color secondaryMonochrome = Color(0xFF666666); // Medium Grey
  static const Color backgroundMonochrome = Color(0xFFF5F5F5); // Light Grey
  static const Color textPrimaryMonochrome = Color(0xFF333333); // Dark Grey
  static const Color textSecondaryMonochrome = Color(0xFF666666); // Medium Grey
  static const Color errorMonochrome = Color(0xFF333333); // Dark Grey
  static const Color warningMonochrome = Color(0xFF666666); // Medium Grey
  static const Color successMonochrome = Color(0xFF333333); // Dark Grey

  // Status Colors
  static const Color halal = Color(0xFF4CAF50);
  static const Color haram = Color(0xFFF44336);
  static const Color syubhat = Color(0xFFFFC107);
}

class AppSizes {
  // Button Sizes
  static const double buttonSize = 160.0;
  static const double buttonSizeTablet = 160.0;
  static const double buttonHeight = 60.0;
  static const double buttonHeightLarge = 70.0;
  
  // Icon Sizes
  static const double iconSizeSmall = 28.0;
  static const double iconSize = 32.0;
  static const double iconSizeTablet = 40.0;
  
  // Font Sizes
  static const double fontSizeSmall = 10.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 22.0;
  
  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  
  // Border Radius
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 20.0;
  static const double screenPaddingXLarge = 32.0;
  static const double screenPaddingLarge = 24.0;
  static const double buttonBorderRadius = 20.0;
  static const double buttonElevation = 2.0;
  static const double spacingXSmall = 4.0;
}

class AppTextSizes {
  // Base sizes for different text types
  static const double headingSmall = 16.0;
  static const double headingMedium = 20.0;
  static const double headingLarge = 24.0;
  static const double headingXLarge = 28.0;

  static const double titleSmall = 14.0;
  static const double titleMedium = 18.0;
  static const double titleLarge = 22.0;
  static const double titleXLarge = 26.0;

  static const double subtitleSmall = 12.0;
  static const double subtitleMedium = 16.0;
  static const double subtitleLarge = 20.0;
  static const double subtitleXLarge = 24.0;

  static const double bodySmall = 10.0;
  static const double bodyMedium = 14.0;
  static const double bodyLarge = 18.0;
  static const double bodyXLarge = 22.0;

  // Get text size based on accessibility setting
  static double getTextSize(BuildContext context, double baseSize) {
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    switch (access.textSize) {
      case 'kecil':
        return baseSize * 0.8;
      case 'sedang':
        return baseSize;
      case 'besar':
        return baseSize * 1.2;
      case 'sangat_besar':
        return baseSize * 1.4;
      default:
        return baseSize;
    }
  }
}

class AppStyles {

  static TextStyle heading(BuildContext context) {
    return TextStyle(
      fontSize: AppTextSizes.getTextSize(context, AppTextSizes.headingMedium),
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
    );
  }

  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontSize: AppTextSizes.getTextSize(context, AppTextSizes.titleMedium),
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
    );
  }
  
  static TextStyle subtitle(BuildContext context) {
    return TextStyle(
      fontSize: AppTextSizes.getTextSize(context, AppTextSizes.subtitleMedium),
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }
  
  static TextStyle body(BuildContext context) {
    return TextStyle(
      fontSize: AppTextSizes.getTextSize(context, AppTextSizes.bodyMedium),
      color: AppColors.textPrimary,
    );
  }

  static TextStyle button(BuildContext context) {
    return TextStyle(
      fontSize: AppTextSizes.getTextSize(context, AppTextSizes.bodyMedium),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle caption(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return TextStyle(
      fontSize: isTablet ? 14 : 12,
      fontWeight: FontWeight.normal,
    );
  }
}

class AppIconSizes {
  static double size(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    return access.iconSize;
  }
} 