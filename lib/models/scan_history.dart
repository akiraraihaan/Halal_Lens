class ScanHistory {
  final String id;
  final String productName;
  final String? barcode;
  final List<String> compositions;
  final String overallStatus; // 'halal', 'haram', 'meragukan'
  final DateTime scanDate;
  final String scanType; // 'barcode' or 'ocr'
  final Map<String, List<String>> compositionAnalysis;

  ScanHistory({
    required this.id,
    required this.productName,
    this.barcode,
    required this.compositions,
    required this.overallStatus,
    required this.scanDate,
    required this.scanType,
    required this.compositionAnalysis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'barcode': barcode,
      'compositions': compositions,
      'overallStatus': overallStatus,
      'scanDate': scanDate.millisecondsSinceEpoch,
      'scanType': scanType,
      'compositionAnalysis': compositionAnalysis,
    };
  }

  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'] ?? '',
      productName: map['productName'] ?? '',
      barcode: map['barcode'],
      compositions: List<String>.from(map['compositions'] ?? []),
      overallStatus: map['overallStatus'] ?? 'unknown',
      scanDate: DateTime.fromMillisecondsSinceEpoch(map['scanDate'] ?? 0),
      scanType: map['scanType'] ?? 'barcode',
      compositionAnalysis: Map<String, List<String>>.from(
        map['compositionAnalysis']?.map((key, value) => 
          MapEntry(key, List<String>.from(value))) ?? {}
      ),
    );
  }
}
