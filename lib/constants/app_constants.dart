import 'package:flutter/material.dart';

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
}

class AppText {
  static const String appName = 'Halal Lens';
  static const String welcomeMessage = 'Selamat Datang';
  static const String welcomeSubtitle = 'Pindai produk untuk memastikan kehalalannya';
  
  // Feature Cards
  static const String scanBarcodeTitle = 'Scan Barcode';
  static const String scanBarcodeSubtitle = 'Pindai barcode produk untuk memeriksa kehalalan';
  static const String scanCompositionTitle = 'Scan Komposisi';
  static const String scanCompositionSubtitle = 'Pindai komposisi produk menggunakan OCR';
  
  // Scan Barcode Screen
  static const String barcodeNotFound = 'Barcode tidak terdeteksi.';
  static const String productNotFound = 'Produk tidak ditemukan dalam database.';
  static const String scanError = 'Gagal scan barcode.';
  static const String startScanBarcode = 'Mulai Scan Barcode';
  static const String barcodeLabel = 'Barcode';
  static const String certificateNumber = 'No. Sertifikat';
  static const String expiredDate = 'Tanggal Expired';
  static const String compositionAnalysis = 'Analisis Komposisi';
  static const String haramIngredients = 'Bahan Haram';
  static const String meragukanIngredients = 'Bahan Meragukan';
  static const String unknownIngredients = 'Bahan Tidak Dikenal';
  static const String halalIngredients = 'Bahan Halal';
  
  // Status
  static const String statusUnknown = 'Tidak Diketahui';
  static const String statusHaram = 'Haram';
  static const String statusMeragukan = 'Meragukan';
  static const String statusHalal = 'Halal';
}

class AppSizes {
  // Button Sizes
  static const double buttonSize = 160.0;
  static const double buttonSizeTablet = 160.0;
  
  // Icon Sizes
  static const double iconSize = 40.0;
  static const double iconSizeTablet = 48.0;
  
  // Font Sizes
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  
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
  static const double iconSizeSmall = 20.0;
}

class AppStyles {
  static TextStyle get heading => const TextStyle(
    fontSize: AppSizes.fontSizeXLarge,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static TextStyle get subheading => const TextStyle(
    fontSize: AppSizes.fontSizeMedium,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  static TextStyle get buttonText => const TextStyle(
    fontSize: AppSizes.fontSizeMedium,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
} 