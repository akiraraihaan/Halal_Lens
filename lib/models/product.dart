class Product {
  final String barcode;
  final String name;
  final String certificateNumber;
  final DateTime expiredDate;
  final List<String> compositions;
  final String? brand;
  final String? imageUrl;

  Product({
    required this.barcode,
    required this.name,
    required this.certificateNumber,
    required this.expiredDate,
    required this.compositions,
    this.brand,
    this.imageUrl,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      barcode: documentId,
      name: data['name'] ?? '',
      certificateNumber: data['certificate_number'] ?? '',
      expiredDate: _parseExpiredDate(data['expired_date']),
      compositions: List<String>.from(data['compositions'] ?? []),
      brand: data['brand'] as String?,
      imageUrl: data['image_url'] as String?,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json, String barcode) {
    return Product(
      barcode: barcode,
      name: json['name'] ?? '',
      certificateNumber: json['certificate_number'] ?? '',
      expiredDate: DateTime.parse(json['expired_date'] as String),
      compositions: List<String>.from(json['compositions'] ?? []),
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
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

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'certificate_number': certificateNumber,
      'expired_date': expiredDate.toIso8601String(),
      'compositions': compositions,
      'brand': brand,
      'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'certificate_number': certificateNumber,
      'expired_date': expiredDate.toIso8601String(),
      'brand': brand,
      'image_url': imageUrl,
    };
  }
}
