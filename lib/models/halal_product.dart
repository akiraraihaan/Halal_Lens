class HalalProduct {
  final String barcode;
  final String name;
  final String status;
  final String certificateNumber;
  final DateTime expiredDate;
  final List<String> manualComposition;

  HalalProduct({
    required this.barcode,
    required this.name,
    required this.status,
    required this.certificateNumber,
    required this.expiredDate,
    required this.manualComposition,
  });

  factory HalalProduct.fromFirestore(Map<String, dynamic> data, String documentId) {
    return HalalProduct(
      barcode: documentId,
      name: data['name'] ?? '',
      status: data['status'] ?? 'Tidak Diketahui',
      certificateNumber: data['certificate_number'] ?? '',
      expiredDate: _parseExpiredDate(data['expired_date']),
      manualComposition: List<String>.from(data['manual_composition'] ?? []),
    );
  }

  static DateTime _parseExpiredDate(dynamic expiredDate) {
    if (expiredDate == null) return DateTime.now();
    
    // Handle Firestore Timestamp
    if (expiredDate.runtimeType.toString().contains('Timestamp')) {
      return expiredDate.toDate();
    }
    
    // Handle string format like "1 January 2026 at 00:00:00 UTC+7"
    if (expiredDate is String) {
      try {
        // Simple parsing for the given format
        String dateStr = expiredDate.split(' at ').first;
        List<String> parts = dateStr.split(' ');
        
        if (parts.length >= 3) {
          int day = int.parse(parts[0]);
          String monthStr = parts[1];
          int year = int.parse(parts[2]);
          
          Map<String, int> months = {
            'January': 1, 'February': 2, 'March': 3, 'April': 4,
            'May': 5, 'June': 6, 'July': 7, 'August': 8,
            'September': 9, 'October': 10, 'November': 11, 'December': 12
          };
          
          int month = months[monthStr] ?? 1;
          return DateTime(year, month, day);
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    
    return DateTime.now();
  }

  bool get isExpired => DateTime.now().isAfter(expiredDate);
  
  bool get isHalal => status.toLowerCase() == 'halal' && !isExpired;
  bool get isHaram => status.toLowerCase() == 'haram';
  bool get isSyubhat => status.toLowerCase() == 'syubhat';
}
