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
  bool _changed = false;
  @override
  void initState() {
    super.initState();
    // Selalu set default ke nilai pertama dari opsi untuk menghindari error
    _fontSize = _fontSizeOptions.first;
    _iconSize = _iconSizeOptions.first;
    _pendingFontSize = _fontSizeOptions.first;
    _pendingIconSize = _iconSizeOptions.first;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    double savedFontSize = prefs.getDouble('access_fontSize') ?? _fontSizeOptions.first;
    double savedIconSize = prefs.getDouble('access_iconSize') ?? _iconSizeOptions.first;
    
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
      
      _changed = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('access_fontSize', _pendingFontSize);
    await prefs.setDouble('access_iconSize', _pendingIconSize);
    setState(() {
      _fontSize = _pendingFontSize;
      _iconSize = _pendingIconSize;
      _changed = false;
    });
    // ignore: use_build_context_synchronously
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    await access.setFontSize(_pendingFontSize);
    await access.setIconSize(_pendingIconSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: AppSizes.spacingSmall),
          child: Text(
            'Accessibility Settings',
            style: AppStyles.heading.copyWith(fontSize: AppSizes.fontSizeLarge),
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [                      const Text('Ukuran Font', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile<double>(
                            title: Text('Small'),
                            value: AppSizes.fontSizeSmall,
                            groupValue: _pendingFontSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingFontSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                          RadioListTile<double>(
                            title: Text('Medium'),
                            value: AppSizes.fontSizeMedium,
                            groupValue: _pendingFontSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingFontSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                          RadioListTile<double>(
                            title: Text('Large'),
                            value: AppSizes.fontSizeLarge,
                            groupValue: _pendingFontSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingFontSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                          RadioListTile<double>(
                            title: Text('X-Large'),
                            value: AppSizes.fontSizeXLarge,
                            groupValue: _pendingFontSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingFontSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      // Tampilkan contoh teks sesuai ukuran yang dipilih
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Contoh teks dengan ukuran pilihan',
                          style: TextStyle(fontSize: _pendingFontSize),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingLarge),
                      const Text('Ukuran Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile<double>(
                            title: Text('Small'),
                            value: AppSizes.iconSizeSmall,
                            groupValue: _pendingIconSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingIconSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                          RadioListTile<double>(
                            title: Text('Normal'),
                            value: AppSizes.iconSize,
                            groupValue: _pendingIconSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingIconSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                          RadioListTile<double>(
                            title: Text('Large'),
                            value: AppSizes.iconSizeTablet,
                            groupValue: _pendingIconSize,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingIconSize = value;
                                  _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      // Tampilkan contoh ikon sesuai ukuran yang dipilih
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: _pendingIconSize),
                            const SizedBox(width: 12),
                            Icon(Icons.accessibility, size: _pendingIconSize),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.visibility, size: _pendingIconSize),
                          const SizedBox(width: AppSizes.spacingMedium),
                          Icon(Icons.hearing, size: _pendingIconSize),
                          const SizedBox(width: AppSizes.spacingMedium),
                          Icon(Icons.accessibility, size: _pendingIconSize),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingXLarge),
                      ElevatedButton(
                        onPressed: _changed ? _saveSettings : null,
                        child: const Text('Simpan', style: AppStyles.button),
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),
                      Text('Pengaturan ini akan diterapkan ke seluruh aplikasi setelah menekan tombol Simpan.', style: AppStyles.body),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
