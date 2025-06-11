import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_history.dart';

class HistoryService {
  static const String _historyKey = 'scan_history';

  static Future<List<ScanHistory>> getScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      return historyJson.map((item) {
        final map = json.decode(item) as Map<String, dynamic>;
        return ScanHistory.fromMap(map);
      }).toList()
        ..sort((a, b) => b.scanDate.compareTo(a.scanDate)); // Sort by newest first
    } catch (e) {
      print('Error loading scan history: $e');
      return [];
    }
  }

  static Future<void> addScanHistory(ScanHistory history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = await getScanHistory();
      
      // Add new history at the beginning
      currentHistory.insert(0, history);
      
      // Keep only last 50 items
      if (currentHistory.length > 50) {
        currentHistory.removeRange(50, currentHistory.length);
      }
      
      final historyJson = currentHistory.map((item) => json.encode(item.toMap())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error saving scan history: $e');
    }
  }

  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing scan history: $e');
    }
  }

  static Future<void> deleteScanHistory(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = await getScanHistory();
      
      currentHistory.removeWhere((item) => item.id == id);
      
      final historyJson = currentHistory.map((item) => json.encode(item.toMap())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error deleting scan history: $e');
    }
  }
}
