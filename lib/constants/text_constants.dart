class AppText {
  // Language Status
  static int currentLanguageIndex = 0; // 0 for Indonesian, 1 for English

  // Language Settings
  static const List<String> listLanguageSettings = ['Pengaturan Bahasa', 'Language Settings'];
  static String get languageSettings => listLanguageSettings[currentLanguageIndex];
  
  static const List<String> listLanguageSettingsDescription = ['Pilih bahasa yang ingin digunakan', 'Choose your preferred language'];
  static String get languageSettingsDescription => listLanguageSettingsDescription[currentLanguageIndex];
  
  static const List<String> listLanguageIndonesian = ['Bahasa Indonesia', 'Indonesian'];
  static String get languageIndonesian => listLanguageIndonesian[currentLanguageIndex];
  
  static const List<String> listLanguageEnglish = ['Bahasa Inggris', 'English'];
  static String get languageEnglish => listLanguageEnglish[currentLanguageIndex];

  // General
  static const List<String> listAppName = ['Halal Lens', 'Halal Lens'];
  static String get appName => listAppName[currentLanguageIndex];
  
  static const List<String> listWelcomeMessage = ['Selamat Datang', 'Welcome'];
  static String get welcomeMessage => listWelcomeMessage[currentLanguageIndex];
  
  static const List<String> listWelcomeSubtitle = ['Pindai produk untuk memastikan kehalalannya', 'Scan products to ensure their halal status'];
  static String get welcomeSubtitle => listWelcomeSubtitle[currentLanguageIndex];

  // Navigation
  static const List<String> listHome = ['Beranda', 'Home'];
  static String get home => listHome[currentLanguageIndex];
  
  static const List<String> listSettings = ['Aksesibilitas', 'Accessibility'];
  static String get settings => listSettings[currentLanguageIndex];
  
  static const List<String> listHistory = ['Riwayat', 'History'];
  static String get history => listHistory[currentLanguageIndex];
  
  // Feature Cards
  static const List<String> listScanBarcodeTitle = ['Scan Barcode', 'Scan Barcode'];
  static String get scanBarcodeTitle => listScanBarcodeTitle[currentLanguageIndex];
  
  static const List<String> listScanCompositionTitle = ['Scan Komposisi', 'Scan Composition'];
  static String get scanCompositionTitle => listScanCompositionTitle[currentLanguageIndex];
  
  static const List<String> listScanHistoryTitle = ['Riwayat Scan', 'Scan History'];
  static String get scanHistoryTitle => listScanHistoryTitle[currentLanguageIndex];
  
  // Scan Barcode Screen
  static const List<String> listScanBarcodePermission = ['Izinkan akses kamera untuk memindai barcode', 'Allow camera access to scan barcode'];
  static String get scanBarcodePermission => listScanBarcodePermission[currentLanguageIndex];
  
  static const List<String> listScanBarcodePermissionButton = ['Izinkan Akses', 'Allow Access'];
  static String get scanBarcodePermissionButton => listScanBarcodePermissionButton[currentLanguageIndex];
  
  static const List<String> listScanBarcodeInstruction = ['Arahkan QR atau Barcode ke dalam kotak', 'Point QR or Barcode to the box'];
  static String get scanBarcodeInstruction => listScanBarcodeInstruction[currentLanguageIndex];
  
  static const List<String> listScanBarcodeButton = ['Scan Barcode', 'Scan Barcode'];
  static String get scanBarcodeButton => listScanBarcodeButton[currentLanguageIndex];
  
  static const List<String> listScanCompositionButton = ['Scan dengan Komposisi', 'Scan with Composition'];
  static String get scanCompositionButton => listScanCompositionButton[currentLanguageIndex];
  
  static const List<String> listSwitchToComposition = ['Beralih ke Pemindaian Komposisi', 'Switch to Composition Scan'];
  static String get switchToComposition => listSwitchToComposition[currentLanguageIndex];
  
  static const List<String> listSwitchToBarcode = ['Pindai dengan Barcode', 'Scan with Barcode'];
  static String get switchToBarcode => listSwitchToBarcode[currentLanguageIndex];
  
  static const List<String> listBarcodeNotFound = ['Barcode tidak terdeteksi.', 'Barcode not detected.'];
  static String get barcodeNotFound => listBarcodeNotFound[currentLanguageIndex];
  
  static const List<String> listProductNotFound = ['Produk tidak ditemukan dalam database.', 'Product not found in database.'];
  static String get productNotFound => listProductNotFound[currentLanguageIndex];
  
  static const List<String> listScanError = ['Gagal scan barcode.', 'Failed to scan barcode.'];
  static String get scanError => listScanError[currentLanguageIndex];
  
  static const List<String> listStartScanBarcode = ['Mulai Scan Barcode', 'Start Barcode Scan'];
  static String get startScanBarcode => listStartScanBarcode[currentLanguageIndex];
  
  static const List<String> listBarcodeLabel = ['Barcode', 'Barcode'];
  static String get barcodeLabel => listBarcodeLabel[currentLanguageIndex];
  
  static const List<String> listCertificateNumber = ['No. Sertifikat', 'Certificate No.'];
  static String get certificateNumber => listCertificateNumber[currentLanguageIndex];
  
  static const List<String> listExpiredDate = ['Tanggal Expired', 'Expiry Date'];
  static String get expiredDate => listExpiredDate[currentLanguageIndex];
  
  static const List<String> listCompositionAnalysis = ['Analisis Komposisi', 'Composition Analysis'];
  static String get compositionAnalysis => listCompositionAnalysis[currentLanguageIndex];
  
  static const List<String> listAnalysisCompositionTitle = ['Analisis Komposisi:', 'Composition Analysis:'];
  static String get analysisCompositionTitle => listAnalysisCompositionTitle[currentLanguageIndex];
  
  static const List<String> listHaramIngredients = ['Bahan Haram', 'Haram Ingredients'];
  static String get haramIngredients => listHaramIngredients[currentLanguageIndex];
  
  static const List<String> listMeragukanIngredients = ['Bahan Meragukan', 'Doubtful Ingredients'];
  static String get meragukanIngredients => listMeragukanIngredients[currentLanguageIndex];
  
  static const List<String> listUnknownIngredients = ['Bahan Tidak Dikenal', 'Unknown Ingredients'];
  static String get unknownIngredients => listUnknownIngredients[currentLanguageIndex];
  
  static const List<String> listHalalIngredients = ['Bahan Halal', 'Halal Ingredients'];
  static String get halalIngredients => listHalalIngredients[currentLanguageIndex];
  
  // Status
  static const List<String> listStatusUnknown = ['Tidak Diketahui', 'Unknown'];
  static String get statusUnknown => listStatusUnknown[currentLanguageIndex];
  
  static const List<String> listStatusHaram = ['Haram', 'Haram'];
  static String get statusHaram => listStatusHaram[currentLanguageIndex];
  
  static const List<String> listStatusMeragukan = ['Meragukan', 'Doubtful'];
  static String get statusMeragukan => listStatusMeragukan[currentLanguageIndex];
  
  static const List<String> listStatusHalal = ['Halal', 'Halal'];
  static String get statusHalal => listStatusHalal[currentLanguageIndex];

  // Accessibility
  static const List<String> listAccessibilityTitle = ['Pengaturan Aksesibilitas', 'Accessibility Settings'];
  static String get accessibilityTitle => listAccessibilityTitle[currentLanguageIndex];
  
  static const List<String> listSaveSettings = ['Simpan Pengaturan', 'Save Settings'];
  static String get saveSettings => listSaveSettings[currentLanguageIndex];
  
  static const List<String> listSettingsSaved = ['Pengaturan berhasil disimpan', 'Settings saved successfully'];
  static String get settingsSaved => listSettingsSaved[currentLanguageIndex];
  
  static const List<String> listErrorSavingSettings = ['Gagal menyimpan pengaturan', 'Failed to save settings'];
  static String get errorSavingSettings => listErrorSavingSettings[currentLanguageIndex];
  
  static const List<String> listColorBlindMode = ['Mode Buta Warna', 'Color Blind Mode'];
  static String get colorBlindMode => listColorBlindMode[currentLanguageIndex];
  
  static const List<String> listColorBlindModeDescription = ['Mengubah tampilan warna aplikasi menjadi hitam putih', 'Changes the app color display to black and white'];
  static String get colorBlindModeDescription => listColorBlindModeDescription[currentLanguageIndex];
  
  static const List<String> listTextSizeTitle = ['Ukuran Teks', 'Text Size'];
  static String get textSizeTitle => listTextSizeTitle[currentLanguageIndex];
  
  static const List<String> listTextSizeDescription = ['Pilih ukuran teks yang nyaman untuk dibaca', 'Choose a comfortable text size to read'];
  static String get textSizeDescription => listTextSizeDescription[currentLanguageIndex];
  
  static const List<String> listIconSizeDescription = ['Pilih ukuran ikon yang sesuai', 'Choose appropriate icon size'];
  static String get iconSizeDescription => listIconSizeDescription[currentLanguageIndex];
  
  static const List<String> listTextSizeSmall = ['Kecil', 'Small'];
  static String get textSizeSmall => listTextSizeSmall[currentLanguageIndex];
  
  static const List<String> listTextSizeMedium = ['Sedang', 'Medium'];
  static String get textSizeMedium => listTextSizeMedium[currentLanguageIndex];
  
  static const List<String> listTextSizeLarge = ['Besar', 'Large'];
  static String get textSizeLarge => listTextSizeLarge[currentLanguageIndex];
  
  static const List<String> listTextSizeXLarge = ['Sangat Besar', 'Extra Large'];
  static String get textSizeXLarge => listTextSizeXLarge[currentLanguageIndex];

  // Scan History Screen
  static const List<String> listHistoryTitle = ['Riwayat Scan', 'Scan History'];
  static String get historyTitle => listHistoryTitle[currentLanguageIndex];
  
  static const List<String> listHistoryDetailsTitle = ['Detail Riwayat', 'History Details'];
  static String get historyDetailsTitle => listHistoryDetailsTitle[currentLanguageIndex];
  
  static const List<String> listProductInfo = ['Informasi Produk', 'Product Information'];
  static String get productInfo => listProductInfo[currentLanguageIndex];

  static const List<String> listClearHistory = ['Hapus Riwayat', 'Clear History'];
  static String get clearHistory => listClearHistory[currentLanguageIndex];
  
  static const List<String> listClearHistoryDescription = ['Apakah Anda yakin ingin menghapus semua riwayat scan?', 'Are you sure you want to clear all scan history?'];
  static String get clearHistoryDescription => listClearHistoryDescription[currentLanguageIndex];

  static const List<String> listCancel = ['Batal', 'Cancel'];
  static String get cancel => listCancel[currentLanguageIndex];

  static const List<String> listClearAllHistory = ['Hapus Semua Riwayat', 'Clear All History'];
  static String get clearAllHistory => listClearAllHistory[currentLanguageIndex];
  
  static const List<String> listStartScanning = ['Mulai scan produk untuk melihat riwayat', 'Start scanning products to view history'];
  static String get startScanning => listStartScanning[currentLanguageIndex];
  
  static const List<String> listNoScanHistory = ['Belum ada riwayat scan', 'No scan history'];
  static String get noScanHistory => listNoScanHistory[currentLanguageIndex];
  
  static const List<String> listComposition = ['Komposisi:', 'Composition:'];
  static String get composition => listComposition[currentLanguageIndex];
  
  static const List<String> listScanInfo = ['Informasi Scan', 'Scan Information'];
  static String get scanInfo => listScanInfo[currentLanguageIndex];
  
  static const List<String> listScanType = ['Tipe Scan', 'Scan Type'];
  static String get scanType => listScanType[currentLanguageIndex];
  
  static const List<String> listScanDate = ['Tanggal Scan', 'Scan Date'];
  static String get scanDate => listScanDate[currentLanguageIndex];
  
  static const List<String> listIngredientsCount = ['%d bahan', '%d ingredients'];
  static String get ingredientsCount => listIngredientsCount[currentLanguageIndex];

  // Barcode Result Screen
  static const List<String> listScanResultTitle = ['Hasil Scan', 'Scan Result'];
  static String get scanResultTitle => listScanResultTitle[currentLanguageIndex];

  static const List<String> listListenProductStatus = ['Dengarkan Status Produk', 'Listen Product Status'];
  static String get listenProductStatus => listListenProductStatus[currentLanguageIndex];

  static const List<String> listNoCompositionData = ['Tidak ada data komposisi yang tersedia', 'No composition data available'];
  static String get noCompositionData => listNoCompositionData[currentLanguageIndex];
  
  static const List<String> listScanAgainButton = ['Scan Lagi', 'Scan Again'];
  static String get scanAgainButton => listScanAgainButton[currentLanguageIndex];
  
  static const List<String> listBackToHomeButton = ['Kembali ke Home', 'Back to Home'];
  static String get backToHomeButton => listBackToHomeButton[currentLanguageIndex];
  
  static const List<String> listCategoryHaram = ['HARAM', 'HARAM'];
  static String get categoryHaram => listCategoryHaram[currentLanguageIndex];
  
  static const List<String> listCategoryMeragukan = ['MERAGUKAN', 'DOUBTFUL'];
  static String get categoryMeragukan => listCategoryMeragukan[currentLanguageIndex];
  
  static const List<String> listCategoryUnknown = ['TIDAK DIKETAHUI', 'UNKNOWN'];
  static String get categoryUnknown => listCategoryUnknown[currentLanguageIndex];
  
  static const List<String> listCategoryHalal = ['HALAL', 'HALAL'];
  static String get categoryHalal => listCategoryHalal[currentLanguageIndex];
  
  static const List<String> listUnknownStatusDescription = ['Tidak dapat menentukan status kehalalan produk', 'Cannot determine the halal status of the product'];
  static String get unknownStatusDescription => listUnknownStatusDescription[currentLanguageIndex];
  
  static const List<String> listHaramStatusDescription = ['Produk ini mengandung bahan haram', 'This product contains haram ingredients'];
  static String get haramStatusDescription => listHaramStatusDescription[currentLanguageIndex];
  
  static const List<String> listSyubhatStatusDescription = ['Produk ini mengandung bahan yang meragukan', 'This product contains doubtful ingredients'];
  static String get syubhatStatusDescription => listSyubhatStatusDescription[currentLanguageIndex];
  
  static const List<String> listHalalStatusDescription = ['Produk ini aman dan halal untuk dikonsumsi', 'This product is safe and halal for consumption'];
  static String get halalStatusDescription => listHalalStatusDescription[currentLanguageIndex];
  
  static const List<String> listCertificateInfo = ['Informasi Sertifikat', 'Certificate Information'];
  static String get certificateInfo => listCertificateInfo[currentLanguageIndex];
  
  static const List<String> listCertificateExpiredDate = ['Berlaku hingga', 'Valid until'];
  static String get certificateExpiredDate => listCertificateExpiredDate[currentLanguageIndex];

  // Months
  static const List<List<String>> listMonths = [
    ['Januari', 'January'],
    ['Februari', 'February'],
    ['Maret', 'March'],
    ['April', 'April'],
    ['Mei', 'May'],
    ['Juni', 'June'],
    ['Juli', 'July'],
    ['Agustus', 'August'],
    ['September', 'September'],
    ['Oktober', 'October'],
    ['November', 'November'],
    ['Desember', 'December'],
  ];
  static List<String> get months => listMonths.map((e) => e[currentLanguageIndex]).toList();

  // Scan Result
  static const List<String> listIngredientsFound = ['Bahan yang Ditemukan', 'Ingredients Found'];
  static String get ingredientsFound => listIngredientsFound[currentLanguageIndex];

  // New scan text constant
  static const List<String> listScan = ['Scan', 'Scan'];
  static String get scan => listScan[currentLanguageIndex];

  // Rescan text constant
  static const List<String> listRescan = ['Scan Ulang', 'Rescan'];
  static String get rescan => listRescan[currentLanguageIndex];

  // Scan Composition Screen
  static const List<String> listScanCompositionPermission = ['Izinkan akses kamera untuk memindai komposisi produk', 'Allow camera access to scan product composition'];
  static String get scanCompositionPermission => listScanCompositionPermission[currentLanguageIndex];
  
  static const List<String> listScanCompositionPermissionButton = ['Izinkan Akses Kamera', 'Allow Camera Access'];
  static String get scanCompositionPermissionButton => listScanCompositionPermissionButton[currentLanguageIndex];
  
  static const List<String> listScanCompositionInstruction = ['Arahkan kamera ke komposisi produk', 'Point camera to product composition'];
  static String get scanCompositionInstruction => listScanCompositionInstruction[currentLanguageIndex];
  
  static const List<String> listScanningButton = ['Memindai...', 'Scanning...'];
  static String get scanningButton => listScanningButton[currentLanguageIndex];

  // Status Texts
  static const List<String> listHalal = ['Halal', 'Halal'];
  static String get halal => listHalal[currentLanguageIndex];
  
  static const List<String> listHaram = ['Haram', 'Haram'];
  static String get haram => listHaram[currentLanguageIndex];
  
  static const List<String> listMeragukan = ['Meragukan', 'Doubtful'];
  static String get meragukan => listMeragukan[currentLanguageIndex];
  
  static const List<String> listUnknown = ['Tidak Diketahui', 'Unknown'];
  static String get unknown => listUnknown[currentLanguageIndex];

  // Status Descriptions
  static const List<String> listHalalDescription = ['Produk ini aman dikonsumsi karena tidak mengandung bahan haram', 'This product is safe to consume as it contains no haram ingredients'];
  static String get halalDescription => listHalalDescription[currentLanguageIndex];
  
  static const List<String> listHaramDescription = ['Produk ini tidak aman dikonsumsi karena mengandung bahan haram', 'This product is not safe to consume as it contains haram ingredients'];
  static String get haramDescription => listHaramDescription[currentLanguageIndex];
  
  static const List<String> listMeragukanDescription = ['Produk ini mengandung bahan yang meragukan kehalalannya', 'This product contains ingredients of doubtful halal status'];
  static String get meragukanDescription => listMeragukanDescription[currentLanguageIndex];
  
  static const List<String> listUnknownDescription = ['Status kehalalan produk ini tidak dapat ditentukan', 'The halal status of this product cannot be determined'];
  static String get unknownDescription => listUnknownDescription[currentLanguageIndex];

  // Scan Types
  static const List<String> listScanTypeBarcode = [
    'Pemindaian Barcode',
    'Barcode Scan'
  ];
  static String get scanTypeBarcode => listScanTypeBarcode[currentLanguageIndex];

  static const List<String> listScanTypeOCR = [
    'Pemindaian OCR',
    'OCR Scan'
  ];
  static String get scanTypeOCR => listScanTypeOCR[currentLanguageIndex];
} 