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
  double _fontSize = 16;
  double _iconSize = 24;
  double _pendingFontSize = 16;
  double _pendingIconSize = 24;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('access_fontSize') ?? 16;
      _iconSize = prefs.getDouble('access_iconSize') ?? 24;
      _pendingFontSize = _fontSize;
      _pendingIconSize = _iconSize;
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
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            'Accessibility Settings',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
                    children: [
                      const Text('Ukuran Font', style: TextStyle(fontWeight: FontWeight.bold)),
                      Slider(
                        min: 12,
                        max: 32,
                        divisions: 10,
                        value: _pendingFontSize,
                        label: _pendingFontSize.round().toString(),
                        onChanged: (v) => setState(() {
                          _pendingFontSize = v;
                          _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                        }),
                      ),
                      Text('Contoh Teks', style: TextStyle(fontSize: _pendingFontSize)),
                      const SizedBox(height: 32),
                      const Text('Ukuran Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                      Slider(
                        min: 16,
                        max: 64,
                        divisions: 12,
                        value: _pendingIconSize,
                        label: _pendingIconSize.round().toString(),
                        onChanged: (v) => setState(() {
                          _pendingIconSize = v;
                          _changed = _pendingFontSize != _fontSize || _pendingIconSize != _iconSize;
                        }),
                      ),
                      Row(
                        children: [
                          Icon(Icons.visibility, size: _pendingIconSize),
                          const SizedBox(width: 16),
                          Icon(Icons.hearing, size: _pendingIconSize),
                          const SizedBox(width: 16),
                          Icon(Icons.accessibility, size: _pendingIconSize),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _changed ? _saveSettings : null,
                        child: const Text('Simpan'),
                      ),
                      const SizedBox(height: 16),
                      Text('Pengaturan ini akan diterapkan ke seluruh aplikasi setelah menekan tombol Simpan.'),
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
