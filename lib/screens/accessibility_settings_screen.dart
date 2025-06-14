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

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> with SingleTickerProviderStateMixin {
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
  
  late double _fontSize;
  late double _iconSize;
  late double _pendingFontSize;
  late double _pendingIconSize;
  late bool _isColorBlindMode;
  late bool _pendingColorBlindMode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fontSize = _fontSizeOptions.first;
    _iconSize = _iconSizeOptions.first;
    _pendingFontSize = _fontSizeOptions.first;
    _pendingIconSize = _iconSizeOptions.first;
    _isColorBlindMode = false;
    _pendingColorBlindMode = false;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _loadSettings();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    double savedFontSize = prefs.getDouble('access_fontSize') ?? _fontSizeOptions.first;
    double savedIconSize = prefs.getDouble('access_iconSize') ?? _iconSizeOptions.first;
    bool savedColorBlindMode = prefs.getBool('access_colorBlindMode') ?? false;
    
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
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('access_fontSize', _pendingFontSize);
    await prefs.setDouble('access_iconSize', _pendingIconSize);
    
    setState(() {
      _fontSize = _pendingFontSize;
      _iconSize = _pendingIconSize;
    });
    
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    await access.setFontSize(_pendingFontSize);
    await access.setIconSize(_pendingIconSize);
    final isMonochromeMode = access.isColorBlindMode;
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Pengaturan berhasil disimpan'),
          ],
        ),
        backgroundColor: isMonochromeMode ? AppColors.successMonochrome : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _getFontSizeLabel(double size) {
    if (size == AppSizes.fontSizeSmall) return 'Kecil';
    if (size == AppSizes.fontSizeMedium) return 'Sedang';
    if (size == AppSizes.fontSizeLarge) return 'Besar';
    return 'Sangat Besar';
  }

  String _getIconSizeLabel(double size) {
    if (size == AppSizes.iconSizeSmall) return 'Kecil';
    if (size == AppSizes.iconSize) return 'Normal';
    return 'Besar';
  }

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final isMonochromeMode = access.isColorBlindMode;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    final backgroundColor = isMonochromeMode ? 
      AppColors.backgroundMonochrome : AppColors.background;
    final textColor = isMonochromeMode ? 
      AppColors.textPrimaryMonochrome : AppColors.textPrimary;
    final primaryColor = isMonochromeMode ? 
      AppColors.primaryMonochrome : AppColors.primary;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Pengaturan Aksesibilitas',
          style: AppStyles.heading(context).copyWith(
            fontSize: AppSizes.fontSizeLarge,
            color: textColor,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _animationController.view,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                SizedBox(height: isTablet ? 32 : 24),
                
                // Mode Buta Warna Section
                _buildSection(
                  'Mode Buta Warna',
                  Icons.visibility,
                  primaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            isMonochromeMode ? 
                              AppColors.backgroundMonochrome : 
                              AppColors.background,
                            isMonochromeMode ? 
                              AppColors.backgroundMonochrome.withOpacity(0.8) : 
                              AppColors.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          'Mode Monokrom',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          'Mengubah tampilan warna aplikasi menjadi hitam putih',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                        value: _pendingColorBlindMode,
                        onChanged: (value) async {
                          setState(() {
                            _pendingColorBlindMode = value;
                            _isColorBlindMode = value;
                          });
                          
                          final access = Provider.of<AccessibilityProvider>(context, listen: false);
                          await access.setColorBlindMode(value);
                          
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('access_colorBlindMode', value);
                        },
                        activeColor: primaryColor,
                        activeTrackColor: primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isTablet ? 32 : 24),
                
                // Ukuran Font Section
                _buildSection(
                  'Ukuran Font',
                  Icons.format_size,
                  primaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 24 : 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            isMonochromeMode ? 
                              AppColors.backgroundMonochrome : 
                              AppColors.background,
                            isMonochromeMode ? 
                              AppColors.backgroundMonochrome.withOpacity(0.8) : 
                              AppColors.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<double>(
                            value: _pendingFontSize,
                            isExpanded: true,
                            style: AppStyles.body(context),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            items: _fontSizeOptions.map((size) {
                              return DropdownMenuItem<double>(
                                value: size,
                                child: Text(
                                  _getFontSizeLabel(size),
                                  style: TextStyle(
                                    fontSize: size,
                                    color: textColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingFontSize = value;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Contoh teks dengan ukuran pilihan',
                              style: TextStyle(
                                fontSize: _pendingFontSize,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isTablet ? 32 : 24),
                
                // Ukuran Icon Section
                _buildSection(
                  'Ukuran Icon',
                  Icons.photo_size_select_large,
                  primaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 24 : 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            isMonochromeMode ? 
                              AppColors.backgroundMonochrome : 
                              AppColors.background,
                            isMonochromeMode ? 
                              AppColors.backgroundMonochrome.withOpacity(0.8) : 
                              AppColors.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<double>(
                            value: _pendingIconSize,
                            isExpanded: true,
                            style: AppStyles.body(context),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            items: _iconSizeOptions.map((size) {
                              return DropdownMenuItem<double>(
                                value: size,
                                child: Text(
                                  _getIconSizeLabel(size),
                                  style: TextStyle(
                                    fontSize: AppSizes.fontSizeMedium,
                                    color: textColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _pendingIconSize = value;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.visibility, size: _pendingIconSize, color: textColor),
                                Icon(Icons.accessibility, size: _pendingIconSize, color: textColor),
                                Icon(Icons.settings, size: _pendingIconSize, color: textColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isTablet ? 32 : 24),
                
                // Save Button
                if (_pendingFontSize != _fontSize || _pendingIconSize != _iconSize)
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 40 : 32,
                          vertical: isTablet ? 16 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                SizedBox(height: isTablet ? 32 : 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color primaryColor,
    Color textColor,
    bool isTablet,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: isTablet ? 24 : 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        content,
      ],
    );
  }
}
