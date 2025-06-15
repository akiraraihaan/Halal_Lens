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
  final List<String> _textSizeOptions = ['kecil', 'sedang', 'besar', 'sangat_besar'];
  final List<double> _iconSizeOptions = [
    AppSizes.iconSizeSmall,
    AppSizes.iconSize,
    AppSizes.iconSizeTablet,
  ];
  
  late String _textSize;
  late double _iconSize;
  late String _pendingTextSize;
  late double _pendingIconSize;
  late bool _isColorBlindMode;
  late bool _pendingColorBlindMode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _textSize = _textSizeOptions[1]; // Default to 'sedang'
    _iconSize = _iconSizeOptions[1]; // Default to medium
    _pendingTextSize = _textSizeOptions[1];
    _pendingIconSize = _iconSizeOptions[1];
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
    String savedTextSize = prefs.getString('access_textSize') ?? _textSizeOptions[1];
    double savedIconSize = prefs.getDouble('access_iconSize') ?? _iconSizeOptions[1];
    bool savedColorBlindMode = prefs.getBool('access_colorBlindMode') ?? false;
    
    setState(() {
      if (_textSizeOptions.contains(savedTextSize)) {
        _textSize = savedTextSize;
        _pendingTextSize = savedTextSize;
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
    await prefs.setString('access_textSize', _pendingTextSize);
    await prefs.setDouble('access_iconSize', _pendingIconSize);
    
    setState(() {
      _textSize = _pendingTextSize;
      _iconSize = _pendingIconSize;
    });
    
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    await access.setTextSize(_pendingTextSize);
    await access.setIconSize(_pendingIconSize);
    final isMonochromeMode = access.isColorBlindMode;
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: AppSizes.spacingSmall),
            Text(AppText.settingsSaved),
          ],
        ),
        backgroundColor: isMonochromeMode ? AppColors.successMonochrome : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
        ),
      ),
    );
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
                
                // Mode Buta Warna Section
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
                      child: SwitchListTile(
                        title: Text(
                          AppText.colorBlindMode,
                          style: AppStyles.title(context).copyWith(
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          AppText.colorBlindModeDescription,
                          style: AppStyles.subtitle(context).copyWith(
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
                
                SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
                
                // Ukuran Font Section
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
                          SizedBox(height: AppSizes.spacingLarge),
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
                                        Text(_getIconSizeLabel(size)),
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
                
                SizedBox(height: isTablet ? AppSizes.spacingXLarge : AppSizes.spacingLarge),
                
                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: (_pendingTextSize != _textSize || _pendingIconSize != _iconSize) 
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
