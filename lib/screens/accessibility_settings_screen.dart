import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../services/accessibility_provider.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccessibilitySettingsScreen> createState() => _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> {
  // Opsi ukuran font dan ikon dari AppSizes
  final List<double> _fontSizeOptions = [
    AppSizes.fontSizeSmall,
    AppSizes.fontSizeMedium,
    AppSizes.fontSizeLarge,
    AppSizes.fontSizeXLarge,
  ];
  final List<double> _iconSizeOptions = [
    AppSizes.iconSizeSmall,
    AppSizes.iconSize,
    AppSizes.iconSizeTablet,
  ];
  
  // Default ke nilai pertama dari opsi
  late double _fontSize;
  late double _iconSize;
  late double _pendingFontSize;
  late double _pendingIconSize;
  late bool _isColorBlindMode;
  late bool _pendingColorBlindMode;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    // Selalu set default ke nilai pertama dari opsi untuk menghindari error
    _fontSize = _fontSizeOptions.first;
    _iconSize = _iconSizeOptions.first;
    _pendingFontSize = _fontSizeOptions.first;
    _pendingIconSize = _iconSizeOptions.first;
    _isColorBlindMode = false;
    _pendingColorBlindMode = false;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    double savedFontSize = prefs.getDouble('access_fontSize') ?? _fontSizeOptions.first;
    double savedIconSize = prefs.getDouble('access_iconSize') ?? _iconSizeOptions.first;
    bool savedColorBlindMode = prefs.getBool('access_colorBlindMode') ?? false;
    
    // Cari opsi yang tersedia, jika tidak ada gunakan nilai default
    setState(() {
      if (_fontSizeOptions.contains(savedFontSize)) {
        _fontSize = savedFontSize;
        _pendingFontSize = savedFontSize;
      }
      
      if (_iconSizeOptions.contains(savedIconSize)) {
        _iconSize = savedIconSize;
        _pendingIconSize = savedIconSize;
      }
      
      _isColorBlindMode = savedColorBlindMode;
      _pendingColorBlindMode = savedColorBlindMode;
      
      _changed = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('access_fontSize', _pendingFontSize);
    await prefs.setDouble('access_iconSize', _pendingIconSize);
    await prefs.setBool('access_colorBlindMode', _pendingColorBlindMode);
    
    setState(() {
      _fontSize = _pendingFontSize;
      _iconSize = _pendingIconSize;
      _isColorBlindMode = _pendingColorBlindMode;
      _changed = false;
    });
    
    // ignore: use_build_context_synchronously
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    await access.setFontSize(_pendingFontSize);
    await access.setIconSize(_pendingIconSize);
    await access.setColorBlindMode(_pendingColorBlindMode);
  }

  @override
  Widget build(BuildContext context) {
    // Get current color blind mode from provider to preview changes
    final access = Provider.of<AccessibilityProvider>(context);
    final isMonochromeMode = access.isColorBlindMode;
    
    // Use the correct background color based on mode
    final backgroundColor = isMonochromeMode ? 
      AppColors.backgroundMonochrome : AppColors.background;
    final textColor = isMonochromeMode ? 
      AppColors.textPrimaryMonochrome : AppColors.textPrimary;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: AppSizes.spacingSmall),
          child: Text(
            'Accessibility Settings',
            style: AppStyles.heading.copyWith(
              fontSize: AppSizes.fontSizeLarge,
              color: textColor,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMedium,
            vertical: AppSizes.spacingSmall,
          ),
          child: ListView(
            children: [
              const Text('Ukuran Font', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<double>(
                title: Text('Small', style: TextStyle(color: textColor)),
                value: AppSizes.fontSizeSmall,
                groupValue: _pendingFontSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingFontSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              RadioListTile<double>(
                title: Text('Medium', style: TextStyle(color: textColor)),
                value: AppSizes.fontSizeMedium,
                groupValue: _pendingFontSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingFontSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              RadioListTile<double>(
                title: Text('Large', style: TextStyle(color: textColor)),
                value: AppSizes.fontSizeLarge,
                groupValue: _pendingFontSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingFontSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              RadioListTile<double>(
                title: Text('X-Large', style: TextStyle(color: textColor)),
                value: AppSizes.fontSizeXLarge,
                groupValue: _pendingFontSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingFontSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              
              // Contoh teks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Contoh teks dengan ukuran pilihan',
                  style: TextStyle(fontSize: _pendingFontSize, color: textColor),
                ),
              ),
              
              const SizedBox(height: AppSizes.spacingMedium),
              Text('Ukuran Icon', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
              
              RadioListTile<double>(
                title: Text('Small', style: TextStyle(color: textColor)),
                value: AppSizes.iconSizeSmall,
                groupValue: _pendingIconSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingIconSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              RadioListTile<double>(
                title: Text('Normal', style: TextStyle(color: textColor)),
                value: AppSizes.iconSize,
                groupValue: _pendingIconSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingIconSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              RadioListTile<double>(
                title: Text('Large', style: TextStyle(color: textColor)),
                value: AppSizes.iconSizeTablet,
                groupValue: _pendingIconSize,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pendingIconSize = value;
                      _changed = _pendingFontSize != _fontSize || 
                                _pendingIconSize != _iconSize || 
                                _pendingColorBlindMode != _isColorBlindMode;
                    });
                  }
                },
              ),
              
              // Contoh ikon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: _pendingIconSize, color: textColor),
                    const SizedBox(width: 12),
                    Icon(Icons.accessibility, size: _pendingIconSize, color: textColor),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSizes.spacingMedium),
              Text('Mode Buta Warna', 
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor)
              ),
              SwitchListTile(
                title: Text('Aktifkan Mode Monokrom', style: TextStyle(color: textColor)),
                subtitle: Text(
                  'Mengubah tampilan warna aplikasi menjadi hitam putih', 
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
                value: _pendingColorBlindMode,
                onChanged: (value) {
                  setState(() {
                    _pendingColorBlindMode = value;
                    _changed = _pendingFontSize != _fontSize || 
                              _pendingIconSize != _iconSize || 
                              _pendingColorBlindMode != _isColorBlindMode;
                  });
                },
                activeColor: isMonochromeMode ? AppColors.primaryMonochrome : AppColors.primary,
              ),
              
              const SizedBox(height: AppSizes.spacingMedium),
              // Preview mode buta warna
              if (_pendingColorBlindMode != _isColorBlindMode)
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacingMedium),
                  decoration: BoxDecoration(
                    color: _pendingColorBlindMode ? 
                      AppColors.backgroundMonochrome : AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    border: Border.all(
                      color: _pendingColorBlindMode ? 
                        AppColors.secondaryMonochrome : AppColors.secondary,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview Mode ${_pendingColorBlindMode ? "Monokrom" : "Normal"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _pendingColorBlindMode ? 
                            AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ini adalah contoh tampilan mode yang dipilih',
                        style: TextStyle(
                          color: _pendingColorBlindMode ? 
                            AppColors.textSecondaryMonochrome : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: AppSizes.spacingLarge),
              Center(
                child: ElevatedButton(
                  onPressed: _changed ? _saveSettings : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMonochromeMode ? 
                      AppColors.primaryMonochrome : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingLarge,
                      vertical: AppSizes.spacingSmall,
                    ),
                  ),
                  child: Text('Simpan', style: AppStyles.button),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Pengaturan ini akan diterapkan ke seluruh aplikasi setelah menekan tombol Simpan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }
}
