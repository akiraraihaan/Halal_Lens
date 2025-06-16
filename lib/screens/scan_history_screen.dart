import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/scan_history.dart';
import '../models/ingredient.dart';
import '../services/accessibility_provider.dart'; // Using services version for persistence
import '../services/history_service.dart';
import '../services/tts_service.dart'; // Tambahkan import TTS service
import '../constants/app_constants.dart';
import '../constants/text_constants.dart';



class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

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
        title: Text(AppText.clearHistory),
        content: Text(AppText.clearHistoryDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppText.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await HistoryService.clearHistory();
              _loadHistory();
            },
            child: Text(AppText.clearAllHistory),
          ),
        ],
      ),
    );
  }  Color _getStatusColor(String status, BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    final isMonochromeMode = access.isColorBlindMode;
    
    // Apply proper color handling based on color blind mode
    switch (status.toUpperCase()) {
      case 'HARAM':
        return isMonochromeMode ? AppColors.errorMonochrome : AppColors.haram;
      case 'MERAGUKAN':
        return isMonochromeMode ? AppColors.warningMonochrome : AppColors.syubhat;
      case 'HALAL':
        return isMonochromeMode ? AppColors.successMonochrome : AppColors.success;
      default:
        return isMonochromeMode ? AppColors.textSecondaryMonochrome : AppColors.grey;
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
    // Explicitly get the color blind mode status (for debugging)
    final isMonochromeMode = access.isColorBlindMode;
    print("Build method - Color blind mode: $isMonochromeMode");
    
    // Use direct color values instead of constants
    final backgroundColor = isMonochromeMode ? 
      Color(0xFFF5F5F5) : Color(0xFFE8F5E9);
    final textColor = isMonochromeMode ? 
      Color(0xFF333333) : Color(0xFF166138);

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
            AppText.historyTitle,
            textAlign: TextAlign.center,
            style: AppStyles.heading(context).copyWith(
              color: textColor,
            ),
          ),
        ),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep, size: access.iconSize),
              onPressed: _clearAllHistory,
              tooltip: AppText.clearAllHistory,
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
            ? _buildEmptyState(isTablet, access)
            : _buildHistoryList(isTablet, access),
      ),
    );
  }

  Widget _buildEmptyState(bool isTablet, AccessibilityProvider access) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 40 : 32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: access.iconSize * 3,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),
          Text(
            AppText.noScanHistory,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            AppText.startScanning,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(bool isTablet, AccessibilityProvider access) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return _buildHistoryItem(item, isTablet, access);
      },
    );
  }

  Widget _buildHistoryItem(ScanHistory item, bool isTablet, AccessibilityProvider access) {
    final statusColor = _getStatusColor(item.overallStatus, context);
    final isMonochromeMode = access.isColorBlindMode;
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      elevation: 2,
      shadowColor: statusColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: statusColor.withOpacity(0.1),
          width: 1,
        ),
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
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getScanTypeIcon(item.scanType),
                      color: statusColor,
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
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isTablet ? 8 : 6),
                        Row(
                          children: [                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 12 : 8,
                                vertical: isTablet ? 6 : 4,
                              ),                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.overallStatus.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTablet ? 14 : 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  InkWell(
                                    onTap: () => _speakStatus(item.productName, item.overallStatus),
                                    child: Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: isTablet ? 16 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.barcode != null) ...[
                              SizedBox(width: isTablet ? 12 : 8),
                              Flexible(
                                child: Text(
                                  item.barcode!,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: isTablet ? 14 : 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: isMonochromeMode ? Color(0xFF333333) : Color(0xFFE53935), // Use direct colors
                      size: access.iconSize,
                    ),
                    onPressed: () => _deleteHistoryItem(item.id),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: isTablet ? 16 : 14,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(item.scanDate),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isTablet ? 14 : 12,
                    ),
                  ),
                ],
              ),
              if (item.compositions.isNotEmpty) ...[
                SizedBox(height: isTablet ? 12 : 8),
                Container(
                  padding: EdgeInsets.all(isTablet ? 12 : 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.composition,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.compositions.take(3).join(", ") + 
                        (item.compositions.length > 3 ? "..." : ""),
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  void _showHistoryDetails(ScanHistory history) {
    final access = Provider.of<AccessibilityProvider>(context, listen: false);
    final isMonochromeMode = access.isColorBlindMode;
    print("Show details - Status: ${history.overallStatus}, ColorBlind: $isMonochromeMode");
    final statusColor = _getStatusColor(history.overallStatus, context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: isMonochromeMode ? AppColors.backgroundMonochrome : AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  Text(
                    AppText.historyDetailsTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    // Tombol TTS Besar di Bagian Atas
                    ElevatedButton.icon(
                      icon: Icon(Icons.volume_up, size: 28),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          AppText.listenProductStatus,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _speakStatus(history.productName, history.overallStatus),
                    ),
                    SizedBox(height: 16),
                    
                    // Status Banner
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),                      child: Row(
                        children: [
                          Icon(
                            history.overallStatus == AppText.categoryHalal
                                ? Icons.check_circle
                                : history.overallStatus == AppText.categoryHaram
                                    ? Icons.cancel
                                    : history.overallStatus == AppText.categoryMeragukan
                                        ? Icons.warning
                                        : Icons.help_outline,
                            color: statusColor,
                            size: 24,
                          ),
                          SizedBox(width: 12),                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      history.overallStatus,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.volume_up, color: statusColor),
                                      onPressed: () => _speakStatus(history.productName, history.overallStatus),
                                      tooltip: AppText.listenProductStatus,
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 18,
                                    ),
                                  ],
                                ),
                                if (history.overallStatus == AppText.categoryHaram)
                                  Text(
                                    AppText.haramStatusDescription,
                                    style: TextStyle(
                                      color: statusColor.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  )
                                else if (history.overallStatus == AppText.categoryMeragukan)
                                  Text(
                                    AppText.syubhatStatusDescription,
                                    style: TextStyle(
                                      color: statusColor.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  )
                                else if (history.overallStatus == AppText.categoryHalal)
                                  Text(
                                    AppText.halalStatusDescription,
                                    style: TextStyle(
                                      color: statusColor.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Product Info
                    if (history.productName.isNotEmpty) ...[
                      Text(
                        AppText.productInfo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.productName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                              ),
                            ),
                            if (history.barcode?.isNotEmpty == true) ...[
                              SizedBox(height: 8),
                              Text(
                                'Barcode: ${history.barcode}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isMonochromeMode ? AppColors.textSecondaryMonochrome : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                    // Composition Analysis
                    Text(
                      AppText.compositionAnalysis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (history.compositionAnalysis['haram']?.isNotEmpty == true)
                            _buildIngredientSection(
                              AppText.categoryHaram,
                              history.compositionAnalysis['haram']!.map((e) => Ingredient(
                                name: e,
                                status: 'haram',
                                description: '',
                                justification: '',
                              )).toList(),
                              isMonochromeMode ? AppColors.errorMonochrome : AppColors.error,
                              isMonochromeMode,
                            ),
                          if (history.compositionAnalysis['syubhat']?.isNotEmpty == true)
                            _buildIngredientSection(
                              AppText.categoryMeragukan,
                              history.compositionAnalysis['syubhat']!.map((e) => Ingredient(
                                name: e,
                                status: 'meragukan',
                                description: '',
                                justification: '',
                              )).toList(),
                              isMonochromeMode ? AppColors.warningMonochrome : AppColors.warning,
                              isMonochromeMode,
                            ),
                          if (history.compositionAnalysis['unknown']?.isNotEmpty == true)
                            _buildIngredientSection(
                              AppText.categoryUnknown,
                              history.compositionAnalysis['unknown']!.map((e) => Ingredient(
                                name: e,
                                status: 'meragukan',
                                description: '',
                                justification: '',
                              )).toList(),
                              isMonochromeMode ? AppColors.textSecondaryMonochrome : AppColors.grey,
                              isMonochromeMode,
                            ),
                          if (history.compositionAnalysis['halal']?.isNotEmpty == true)
                            _buildIngredientSection(
                              AppText.categoryHalal,
                              history.compositionAnalysis['halal']!.map((e) => Ingredient(
                                name: e,
                                status: 'halal',
                                description: '',
                                justification: '',
                              )).toList(),
                              isMonochromeMode ? AppColors.successMonochrome : AppColors.success,
                              isMonochromeMode,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Scan Info
                    Text(
                      AppText.scanInfo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            AppText.scanType,
                            history.scanType,
                            isMonochromeMode,
                          ),
                          Divider(height: 24),
                          _buildInfoRow(
                            AppText.scanDate,
                            _formatDate(history.scanDate),
                            isMonochromeMode,
                          ),
                        ],
                      ),                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSection(
    String title,
    List<Ingredient> ingredients,
    Color color,
    bool isMonochromeMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    title == AppText.categoryHalal
                        ? Icons.check_circle
                        : title == AppText.categoryHaram
                            ? Icons.cancel
                            : title == AppText.categoryMeragukan
                                ? Icons.warning
                                : Icons.help_outline,
                    color: color,
                    size: 18,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  AppText.ingredientsCount.replaceAll('%d', ingredients.length.toString()),
                  style: TextStyle(
                    fontSize: 14,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (ingredients.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients.map((ingredient) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isMonochromeMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isMonochromeMode ? AppColors.textSecondaryMonochrome : AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isMonochromeMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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

  // Method untuk memanggil text-to-speech
  void _speakStatus(String productName, String status) {
    final ttsService = TTSService();
    ttsService.speakProductStatus(productName, status);
  }
}
