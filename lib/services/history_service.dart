import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_history.dart';

class HistoryService {
  static const String _historyKey = 'scan_history';

  static Future<List<ScanHistory>> getScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_historyKey);
    
    if (historyJson == null) return [];
    
    final List<dynamic> historyList = json.decode(historyJson);
    return historyList.map((item) => ScanHistory.fromJson(item)).toList();
  }

  static Future<void> addScanHistory(ScanHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScanHistory> currentHistory = await getScanHistory();
    
    // Add new history at the beginning
    currentHistory.insert(0, history);
    
    // Keep only last 50 items
    if (currentHistory.length > 50) {
      currentHistory.removeLast();
    }
    
    final String historyJson = json.encode(currentHistory.map((h) => h.toJson()).toList());
    await prefs.setString(_historyKey, historyJson);
  }

  static Future<void> deleteScanHistory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScanHistory> currentHistory = await getScanHistory();
    
    currentHistory.removeWhere((item) => item.id == id);
    
    final String historyJson = json.encode(currentHistory.map((h) => h.toJson()).toList());
    await prefs.setString(_historyKey, historyJson);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
