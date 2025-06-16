import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../constants/text_constants.dart';
import '../services/accessibility_provider.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccessibilitySettingsScreen> createState() => _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Initialize with default values
  String _textSize = 'sedang';
  String _pendingTextSize = 'sedang';
  double _iconSize = AppSizes.iconSize;
  double _pendingIconSize = AppSizes.iconSize;
  bool _isColorBlindMode = false;
  bool _pendingColorBlindMode = false;
  int _currentLanguageIndex = 0;
  int _pendingLanguageIndex = 0;
  
  final List<String> _textSizeOptions = ['kecil', 'sedang', 'besar', 'sangat_besar'];
  final List<double> _iconSizeOptions = [
    AppSizes.iconSizeSmall,
    AppSizes.iconSize,
    AppSizes.iconSizeTablet,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.forward();
    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final access = Provider.of<AccessibilityProvider>(context, listen: false);
      
      // Load text size
      _textSize = prefs.getString('access_textSize') ?? 'sedang';
      _pendingTextSize = _textSize;
      
      // Load icon size
      _iconSize = prefs.getDouble('access_iconSize') ?? AppSizes.iconSize;
      _pendingIconSize = _iconSize;
      
      // Load color blind mode from provider
      _isColorBlindMode = access.isColorBlindMode;
      _pendingColorBlindMode = _isColorBlindMode;
      
      // Load language
      _currentLanguageIndex = prefs.getInt('access_languageIndex') ?? 0;
      _pendingLanguageIndex = _currentLanguageIndex;
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save text size
      await prefs.setString('access_textSize', _pendingTextSize);
      
      // Save icon size
      await prefs.setDouble('access_iconSize', _pendingIconSize);
      
      // Save color blind mode
      await prefs.setBool('access_colorBlindMode', _pendingColorBlindMode);
      
      // Save language
      await prefs.setInt('access_languageIndex', _pendingLanguageIndex);
      
      // Update state
      setState(() {
        _textSize = _pendingTextSize;
        _iconSize = _pendingIconSize;
        _isColorBlindMode = _pendingColorBlindMode;
        _currentLanguageIndex = _pendingLanguageIndex;
      });
      
      // Update provider
      final access = Provider.of<AccessibilityProvider>(context, listen: false);
      await access.setTextSize(_pendingTextSize);
      await access.setIconSize(_pendingIconSize);
      await access.setColorBlindMode(_pendingColorBlindMode);
      await access.setLanguage(_pendingLanguageIndex);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.settingsSaved,
              style: AppStyles.body(context).copyWith(color: Colors.white),
            ),
            backgroundColor: _isColorBlindMode ? 
              AppColors.primaryMonochrome : 
              AppColors.primary,
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.top + 500, // Add extra padding for bottom navigation
              left: AppSizes.spacingMedium,
              right: AppSizes.spacingMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.errorSavingSettings,
              style: AppStyles.body(context).copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 80, // Add extra padding for bottom navigation
              left: AppSizes.spacingMedium,
              right: AppSizes.spacingMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
          ),
        );
      }
    }
  }

  String _getTextSizeLabel(String size) {
    switch (size) {
      case 'kecil':
        return AppText.textSizeSmall;
      case 'sedang':
        return AppText.textSizeMedium;
      case 'besar':
        return AppText.textSizeLarge;
      case 'sangat_besar':
        return AppText.textSizeXLarge;
      default:
        return AppText.textSizeMedium;
    }
  }

  String _getIconSizeLabel(double size) {
    if (size == AppSizes.iconSizeSmall) return AppText.textSizeSmall;
    if (size == AppSizes.iconSize) return AppText.textSizeMedium;
    return AppText.textSizeLarge;
  }

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    // Use provider's color blind mode for initial background
    final isMonochromeMode = access.isColorBlindMode;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
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
            textAlign: TextAlign.center,
            AppText.accessibilityTitle,
            style: AppStyles.heading(context).copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _animationController.view,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: isTablet ? AppSizes.screenPaddingXLarge : AppSizes.screenPaddingLarge,
              right: isTablet ? AppSizes.screenPaddingXLarge : AppSizes.screenPaddingLarge,
              bottom: isTablet ? AppSizes.screenPaddingXLarge : AppSizes.screenPaddingLarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isTablet ? AppSizes.spacingMedium : AppSizes.spacingSmall),
                
                // Language Selection Section
                _buildSection(
                  AppText.languageSettings,
                  Icons.language,
                  secondaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.spacingLarge),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
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
                          Text(
                            AppText.languageSettingsDescription,
                            style: AppStyles.subtitle(context).copyWith(
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingMedium,
                              vertical: AppSizes.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _pendingLanguageIndex,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                                style: AppStyles.body(context).copyWith(color: textColor),
                                items: [
                                  DropdownMenuItem<int>(
                                    value: 0,
                                    child: Text(
                                      AppText.languageIndonesian,
                                      style: AppStyles.body(context).copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 1,
                                    child: Text(
                                      AppText.languageEnglish,
                                      style: AppStyles.body(context).copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _pendingLanguageIndex = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
                
                // Color Blind Mode Section
                _buildSection(
                  AppText.colorBlindMode,
                  Icons.visibility,
                  secondaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.spacingLarge),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
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
                          Text(
                            AppText.colorBlindModeDescription,
                            style: AppStyles.subtitle(context).copyWith(
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          SwitchListTile(
                            title: Text(
                              AppText.colorBlindMode,
                              style: AppStyles.title(context).copyWith(
                                color: textColor,
                              ),
                            ),
                            value: _pendingColorBlindMode,
                            onChanged: (value) {
                              setState(() {
                                _pendingColorBlindMode = value;
                              });
                            },
                            activeColor: primaryColor,
                            activeTrackColor: primaryColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
                
                // Text Size Section
                _buildSection(
                  AppText.textSizeTitle,
                  Icons.format_size,
                  secondaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.spacingLarge),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
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
                          Text(
                            AppText.textSizeDescription,
                            style: AppStyles.subtitle(context).copyWith(
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingMedium,
                              vertical: AppSizes.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _pendingTextSize,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                                style: AppStyles.body(context).copyWith(color: textColor),
                                items: _textSizeOptions.map((size) {
                                  return DropdownMenuItem<String>(
                                    value: size,
                                    child: Text(
                                      _getTextSizeLabel(size),
                                      style: AppStyles.body(context).copyWith(
                                        fontSize: size == 'kecil' ? AppTextSizes.subtitleSmall :
                                                size == 'sedang' ? AppTextSizes.subtitleMedium :
                                                size == 'besar' ? AppTextSizes.subtitleLarge :
                                                AppTextSizes.subtitleXLarge,
                                        color: primaryColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _pendingTextSize = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
                
                // Icon Size Section
                _buildSection(
                  AppText.iconSizeDescription,
                  Icons.photo_size_select_large,
                  secondaryColor,
                  textColor,
                  isTablet,
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.spacingLarge),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
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
                          Text(
                            AppText.iconSizeDescription,
                            style: AppStyles.subtitle(context).copyWith(
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingMedium,
                              vertical: AppSizes.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                value: _pendingIconSize,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                                style: AppStyles.body(context).copyWith(color: textColor),
                                items: _iconSizeOptions.map((size) {
                                  return DropdownMenuItem<double>(
                                    value: size,
                                    child: Row(
                                      children: [
                                        Icon(Icons.accessibility, size: size, color: textColor),
                                        SizedBox(width: AppSizes.spacingSmall),
                                        Text(
                                          _getIconSizeLabel(size),
                                          style: AppStyles.body(context).copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: AppSizes.spacingXLarge),
                
                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: (_pendingTextSize != _textSize || 
                              _pendingIconSize != _iconSize || 
                              _pendingColorBlindMode != _isColorBlindMode ||
                              _pendingLanguageIndex != _currentLanguageIndex) 
                      ? _saveSettings 
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXLarge,
                        vertical: AppSizes.spacingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      ),
                      disabledBackgroundColor: primaryColor.withOpacity(0.5),
                      disabledForegroundColor: Colors.white.withOpacity(0.7),
                    ),
                    child: Text(
                      AppText.saveSettings,
                      style: AppStyles.button(context).copyWith(color: Colors.white),
                    ),
                  ),
                ),
                
                SizedBox(height: AppSizes.spacingXLarge),
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
            Icon(icon, color: primaryColor, size: AppIconSizes.size(context)),
            SizedBox(width: AppSizes.spacingSmall),
            Text(
              title,
              style: AppStyles.title(context).copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingMedium),
        content,
      ],
    );
  }
}

