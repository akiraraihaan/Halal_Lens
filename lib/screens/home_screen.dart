import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_provider.dart';
import '../constants/app_constants.dart';
import 'scan_barcode_screen.dart';
import 'scan_ocr_screen.dart';
import 'scan_history_screen.dart';
import 'admin_panel_screen.dart';
import 'accessibility_settings_screen.dart';
import '../constants/text_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AccessibilitySettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final isColorBlind = access.isColorBlindMode;

    return Scaffold(
      backgroundColor: isColorBlind ? AppColors.backgroundMonochrome : AppColors.background,
      body: _pages[_currentIndex],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: SizedBox(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanBarcodeScreen()),
              );
            },
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            elevation: 0,
            child: Icon(Icons.camera, size: 90, color: isColorBlind ? AppColors.primaryMonochrome : AppColors.primary),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.screenPaddingLarge,
          vertical: AppSizes.spacingMedium,
        ),
        child: PhysicalModel(
          color: AppColors.white,
          elevation: 12,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          shadowColor: AppColors.black.withOpacity(0.2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                color: isColorBlind ? AppColors.backgroundMonochrome : Colors.green.shade50,
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: AppIconSizes.size(context)),
                    label: AppText.home,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.accessibility_new, size: AppIconSizes.size(context)),
                    label: AppText.settings,
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: isColorBlind ? AppColors.primaryMonochrome : AppColors.primary,
                unselectedItemColor: isColorBlind ? AppColors.grey : AppColors.grey,
                showUnselectedLabels: true,
                selectedLabelStyle: AppStyles.body(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: AppStyles.body(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final isColorBlind = access.isColorBlindMode;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isColorBlind ? AppColors.backgroundMonochrome : AppColors.background,
        elevation: 0,
        toolbarHeight: 150,
        title: GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 40),
            child: Image.asset(
              isColorBlind ? 'assets/images/HalalLensHorizontalMonokrom.png' : 'assets/images/HalalLensHorizontal.png',
              height: 80,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: isColorBlind ? AppColors.backgroundMonochrome : AppColors.background,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isTablet ? 40 : 32),            
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFeatureCard(
                            context,
                            AppText.scanBarcodeTitle,
                            Icons.qr_code_scanner,
                            isColorBlind ? AppColors.primaryMonochrome : AppColors.primary,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ScanBarcodeScreen()),
                            ),
                            isTablet,
                            access,
                          ),
                          SizedBox(width: isTablet ? 32 : 24),
                          _buildFeatureCard(
                            context,
                            AppText.scanCompositionTitle,
                            Icons.document_scanner,
                            isColorBlind ? AppColors.secondaryMonochrome : AppColors.secondary,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ScanOCRScreen()),
                            ),
                            isTablet,
                            access,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: (isColorBlind ? AppColors.primaryMonochrome : AppColors.primary).withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ScanHistoryScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 32 : 24,
                            vertical: isTablet ? 16 : 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                isColorBlind ? AppColors.primaryMonochrome : AppColors.primary,
                                isColorBlind ? AppColors.primaryMonochrome.withOpacity(0.8) : AppColors.primary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isTablet ? 12 : 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                                ),
                                child: Icon(
                                  Icons.history,
                                  size: AppIconSizes.size(context),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: isTablet ? 16 : 12),
                              Text(
                                AppText.scanHistoryTitle,
                                style: AppStyles.subtitle(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isTablet,
    AccessibilityProvider access,
  ) {
    final isColorBlind = access.isColorBlindMode;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: isTablet ? 160 : 160,
          height: isTablet ? 200 : 200,
          padding: EdgeInsets.all(isTablet ? 24 : 12),
          decoration: BoxDecoration(
            color: isColorBlind ? AppColors.backgroundMonochrome : AppColors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                spreadRadius: 4,
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: AppIconSizes.size(context),
                    color: color,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Flexible(
                  child: Text(
                    title,
                    style: AppStyles.title(context).copyWith(color: color),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}