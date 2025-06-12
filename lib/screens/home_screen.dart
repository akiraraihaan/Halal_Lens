import 'package:flutter/material.dart';
import 'scan_barcode_screen.dart';
import 'scan_ocr_screen.dart';
import 'scan_history_screen.dart';
import 'admin_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50, // hijau pastel
      body: _currentIndex == 0 ? const HomePage() : const ScanHistoryScreen(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: PhysicalModel(
          color: Colors.white,
          elevation: 12,
          borderRadius: BorderRadius.circular(32),
          shadowColor: Colors.black.withOpacity(0.2),
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
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Riwayat',
                  ),
                ],
                backgroundColor: Colors.white, // Navbar tetap putih
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
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
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      body: Container(
        color: Colors.green.shade50, // hijau pastel
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isTablet ? 30 : 20),
                      // Header Section
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isTablet ? 16 : 12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.mosque,
                              color: Colors.green,
                              size: isTablet ? 40 : 32,
                            ),
                          ),
                          SizedBox(width: isTablet ? 20 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Halal Lens',
                                    style: TextStyle(
                                      fontSize: isTablet ? 40 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Pindai produk untuk memastikan kehalalannya',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 60 : 40),
                      
                      // Feature Cards
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
                          child: Column(
                            children: [
                              _buildFeatureCard(
                                context,
                                'Scan Barcode',
                                'Pindai barcode produk untuk memeriksa kehalalan',
                                Icons.qr_code_scanner,
                                Colors.green,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ScanBarcodeScreen()),
                                ),
                                isTablet,
                              ),
                              SizedBox(height: isTablet ? 32 : 24),
                              _buildFeatureCard(
                                context,
                                'Scan Komposisi',
                                'Pindai komposisi produk menggunakan OCR',
                                Icons.document_scanner,
                                Colors.blueGrey,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ScanOCRScreen()),
                                ),
                                isTablet,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Hilangkan SizedBox atau spacer di bawah
                    ],
                  ),
                ),
              ),
            ],
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
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 28 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: isTablet ? 36 : 32,
                  color: color,
                ),
              ),
              SizedBox(width: isTablet ? 20 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: isTablet ? 20 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
