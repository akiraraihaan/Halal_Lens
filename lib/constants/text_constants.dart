class AppText {
  // General
  static const String appName = 'Halal Lens';
  static const String welcomeMessage = 'Selamat Datang';
  static const String welcomeSubtitle = 'Pindai produk untuk memastikan kehalalannya';

  // Navigation
  static const String home = 'Beranda';
  static const String settings = 'Aksesibilitas';
  static const String history = 'Riwayat';
  
  // Feature Cards
  static const String scanBarcodeTitle = 'Scan Barcode';
  static const String scanCompositionTitle = 'Scan Komposisi';
  static const String scanHistoryTitle = 'Riwayat Scan';
  
  // Scan Barcode Screen
  static const String scanBarcodePermission = 'Izin kamera diperlukan untuk scan barcode';
  static const String scanBarcodePermissionButton = 'Berikan Izin';
  static const String scanBarcodeInstruction = 'Arahkan QR atau Barcode ke dalam kotak';
  static const String scanBarcodeButton = 'Scan Barcode';
  static const String scanCompositionButton = 'Scan dengan Komposisi';
  static const String barcodeNotFound = 'Barcode tidak terdeteksi.';
  static const String productNotFound = 'Produk tidak ditemukan dalam database.';
  static const String scanError = 'Gagal scan barcode.';
  static const String startScanBarcode = 'Mulai Scan Barcode';
  static const String barcodeLabel = 'Barcode';
  static const String certificateNumber = 'No. Sertifikat';
  static const String expiredDate = 'Tanggal Expired';
  static const String compositionAnalysis = 'Analisis Komposisi';
  static const String analysisCompositionTitle = 'Analisis Komposisi:';
  static const String haramIngredients = 'Bahan Haram';
  static const String meragukanIngredients = 'Bahan Meragukan';
  static const String unknownIngredients = 'Bahan Tidak Dikenal';
  static const String halalIngredients = 'Bahan Halal';
  
  // Status
  static const String statusUnknown = 'Tidak Diketahui';
  static const String statusHaram = 'Haram';
  static const String statusMeragukan = 'Meragukan';
  static const String statusHalal = 'Halal';

  // Accessibility
  static const String accessibilityTitle = 'Pengaturan Aksesibilitas';
  static const String saveSettings = 'Simpan Pengaturan';
  static const String settingsSaved = 'Pengaturan berhasil disimpan';
  static const String colorBlindMode = 'Mode Buta Warna';
  static const String colorBlindModeDescription = 'Mengubah tampilan warna aplikasi menjadi hitam putih';
  static const String textSizeTitle = 'Ukuran Teks';
  static const String textSizeDescription = 'Pilih ukuran teks yang nyaman untuk dibaca';
  static const String iconSizeDescription = 'Pilih ukuran ikon yang sesuai';
  static const String textSizeSmall = 'Kecil';
  static const String textSizeMedium = 'Sedang';
  static const String textSizeLarge = 'Besar';
  static const String textSizeXLarge = 'Sangat Besar';

  // Scan History Screen
  static const String historyTitle = 'Riwayat Scan';
  static const String historyDetailsTitle = 'Detail Riwayat';
  static const String productInfo = 'Informasi Produk';
  static const String scanInfo = 'Informasi Scan';
  static const String scanType = 'Tipe Scan';
  static const String scanDate = 'Tanggal Scan';
  static const String ingredientsCount = '%d bahan';

  // Barcode Result Screen
  static const String scanResultTitle = 'Hasil Scan';
  static const String scanAgainButton = 'Scan Lagi';
  static const String backToHomeButton = 'Kembali ke Home';
  static const String categoryHaram = 'HARAM';
  static const String categoryMeragukan = 'MERAGUKAN';
  static const String categoryUnknown = 'TIDAK DIKETAHUI';
  static const String categoryHalal = 'HALAL';
  static const String unknownStatusDescription = 'Tidak dapat menentukan status kehalalan produk';
  static const String haramStatusDescription = 'Produk ini mengandung bahan haram';
  static const String syubhatStatusDescription = 'Produk ini mengandung bahan yang meragukan';
  static const String halalStatusDescription = 'Produk ini aman dan halal untuk dikonsumsi';
  static const String certificateInfo = 'Informasi Sertifikat';
  static const String certificateExpiredDate = 'Berlaku hingga';
  static const List<String> months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // Scan Result
  static const String ingredientsFound = 'Bahan yang Ditemukan';

  // New scan text constant
  static const String scan = 'Scan';

  // Rescan text constant
  static const String rescan = 'Scan Ulang';

  // Scan Composition Screen
  static const String scanCompositionPermission = 'Izinkan akses kamera untuk memindai komposisi produk';
  static const String scanCompositionPermissionButton = 'Izinkan Akses Kamera';
  static const String scanCompositionInstruction = 'Arahkan kamera ke komposisi produk';
  static const String scanningButton = 'Memindai...';
} 