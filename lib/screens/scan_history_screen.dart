import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/scan_history.dart';
import '../services/accessibility_provider.dart';
import '../services/history_service.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  List<ScanHistory> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    try {
      final history = await HistoryService.getScanHistory();
      setState(() {
        _history = history;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading history: $e')),
      );
    }
  }

  Future<void> _deleteHistoryItem(String id) async {
    await HistoryService.deleteScanHistory(id);
    _loadHistory();
  }

  Future<void> _clearAllHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to clear all scan history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await HistoryService.clearHistory();
              _loadHistory();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'halal':
        return Colors.green;
      case 'haram':
        return Colors.red;
      case 'meragukan':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getScanTypeIcon(String scanType) {
    return scanType == 'barcode' ? Icons.qr_code_scanner : Icons.document_scanner;
  }

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      body: Container(
        color: Colors.green.shade50, // hijau pastel sama dengan HomePage
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: access.iconSize),
                        onPressed: () => Navigator.pop(context),
                      ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      'Riwayat Scan',
                      style: TextStyle(
                        fontSize: access.fontSize * 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_history.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.delete_sweep, size: access.iconSize),
                        onPressed: _clearAllHistory,
                        tooltip: 'Clear All History',
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _history.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: access.iconSize * 2.5,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: isTablet ? 20 : 16),
                                Text(
                                  'Belum ada riwayat scan',
                                  style: TextStyle(
                                    fontSize: access.fontSize * 1.1,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                                Text(
                                  'Mulai scan produk untuk melihat riwayat',
                                  style: TextStyle(
                                    fontSize: access.fontSize,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32.0 : 16.0,
                              vertical: isTablet ? 16.0 : 8.0,
                            ),
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              final item = _history[index];
                              return _buildHistoryItem(item, isTablet, access);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(ScanHistory item, bool isTablet, AccessibilityProvider access) {
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showHistoryDetails(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12 : 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.overallStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getScanTypeIcon(item.scanType),
                      color: _getStatusColor(item.overallStatus),
                      size: access.iconSize,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: TextStyle(
                            fontSize: access.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isTablet ? 6 : 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 12 : 8,
                                vertical: isTablet ? 6 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(item.overallStatus),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.overallStatus.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: access.fontSize * 0.8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (item.barcode != null) ...[
                              SizedBox(width: isTablet ? 12 : 8),
                              Flexible(
                                child: Text(
                                  item.barcode!,
                                  style: TextStyle(fontSize: access.fontSize * 0.8, color: Colors.grey.shade700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: access.iconSize),
                    onPressed: () => _deleteHistoryItem(item.id),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                _formatDate(item.scanDate),
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (item.compositions.isNotEmpty) ...[
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  'Komposisi: ${item.compositions.take(3).join(", ")}${item.compositions.length > 3 ? "..." : ""}',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  void _showHistoryDetails(ScanHistory item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.productName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(_getScanTypeIcon(item.scanType)),
                  SizedBox(width: 8),
                  Text('${item.scanType == 'barcode' ? 'Barcode' : 'OCR'} Scan'),
                ],
              ),
              if (item.barcode != null) ...[
                SizedBox(height: 8),
                Text('Barcode: ${item.barcode}'),
              ],
              SizedBox(height: 8),
              Text('Status: ${item.overallStatus.toUpperCase()}'),
              SizedBox(height: 8),
              Text('Tanggal: ${_formatDate(item.scanDate)}'),
              if (item.compositions.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(
                  'Komposisi:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...item.compositions.map((comp) => Text('• $comp')),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Kemarin ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
