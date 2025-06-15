import 'package:uuid/uuid.dart';

class ScanHistory {
  final String id;
  final String productName;
  final String? barcode;
  final String scanType;
  final String overallStatus;
  final List<String> compositions;
  final DateTime scanDate;
  final Map<String, List<String>> compositionAnalysis;

  ScanHistory({
    String? id,
    required this.productName,
    this.barcode,
    required this.scanType,
    required this.overallStatus,
    required this.compositions,
    required this.scanDate,
    required this.compositionAnalysis,
  }) : id = id ?? const Uuid().v4();

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      id: json['id'] as String,
      productName: json['productName'] as String,
      barcode: json['barcode'] as String?,
      scanType: json['scanType'] as String,
      overallStatus: json['overallStatus'] as String,
      compositions: List<String>.from(json['compositions'] as List),
      scanDate: DateTime.parse(json['scanDate'] as String),
      compositionAnalysis: Map<String, List<String>>.from(
        json['compositionAnalysis']?.map((key, value) => 
          MapEntry(key, List<String>.from(value))) ?? {}
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'barcode': barcode,
      'scanType': scanType,
      'overallStatus': overallStatus,
      'compositions': compositions,
      'scanDate': scanDate.toIso8601String(),
      'compositionAnalysis': compositionAnalysis,
    };
  }
}
