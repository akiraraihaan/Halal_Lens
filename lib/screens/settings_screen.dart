import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: isTablet ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: isTablet ? 40 : 32),
                _buildSettingsSection(
                  'Umum',
                  [
                    _buildSettingsTile(
                      'Notifikasi',
                      'Atur pengaturan notifikasi',
                      Icons.notifications_outlined,
                      () {},
                      isTablet,
                    ),
                    _buildSettingsTile(
                      'Tema',
                      'Ubah tema aplikasi',
                      Icons.palette_outlined,
                      () {},
                      isTablet,
                    ),
                  ],
                  isTablet,
                ),
                SizedBox(height: isTablet ? 32 : 24),
                _buildSettingsSection(
                  'Tentang',
                  [
                    _buildSettingsTile(
                      'Versi Aplikasi',
                      '1.0.0',
                      Icons.info_outline,
                      () {},
                      isTablet,
                    ),
                    _buildSettingsTile(
                      'Bantuan',
                      'Panduan penggunaan aplikasi',
                      Icons.help_outline,
                      () {},
                      isTablet,
                    ),
                  ],
                  isTablet,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: isTablet ? 16 : 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isTablet,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.green,
                size: isTablet ? 24 : 20,
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
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: isTablet ? 24 : 20,
            ),
          ],
        ),
      ),
    );
  }
} 