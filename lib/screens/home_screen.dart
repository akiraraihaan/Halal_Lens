import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scan_barcode_screen.dart';
import 'scan_ocr_screen.dart';
import 'scan_history_screen.dart';
import 'admin_panel_screen.dart';
import 'accessibility_settings_screen.dart';
import '../constants/app_constants.dart';
import '../services/accessibility_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ScanHistoryScreen(),
    AccessibilitySettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background, // hijau pastel
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: PhysicalModel(
          color: AppColors.white,
          elevation: 12,
          borderRadius: BorderRadius.circular(32),
          shadowColor: AppColors.black.withOpacity(0.2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.green.shade50, // Samakan dengan background utama
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: access.iconSize),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history, size: access.iconSize),
                    label: 'Riwayat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.accessibility_new, size: access.iconSize),
                    label: 'Aksesibilitas',
                  ),
                ],
                backgroundColor: Colors.white, // Navbar tetap putih
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.grey,
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyle(fontSize: access.fontSize),
                unselectedLabelStyle: TextStyle(fontSize: access.fontSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
              'assets/images/HalalLensHorizontal.png',
              height: 80,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isTablet ? 40 : 32),            
                // Feature Cards
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFeatureCard(
                            context,
                            'Scan Barcode',
                            '', // subtitle dikosongkan
                            Icons.qr_code_scanner,
                            AppColors.primary,
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
                            'Scan Komposisi',
                            '', // subtitle dikosongkan
                            Icons.document_scanner,
                            AppColors.secondary,
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
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isTablet,
    AccessibilityProvider access,
  ) {
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
          height: isTablet ? 160 : 160,
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.7),
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
                    size: access.iconSize,
                    color: color,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: access.fontSize,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
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

