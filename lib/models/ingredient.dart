class Ingredient {
  final String name;
  final String status; // "halal", "haram", "meragukan"
  final String description;
  final String justification;
  final List<String> alternativeNames;

  Ingredient({
    required this.name,
    required this.status,
    required this.description,
    required this.justification,
    this.alternativeNames = const [],
  });

  factory Ingredient.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Ingredient(
      name: documentId,
      status: data['status'] ?? 'meragukan',
      description: data['description'] ?? '',
      justification: data['justification'] ?? '',
      alternativeNames: List<String>.from(data['alternative_names'] ?? []),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json, String name) {
    return Ingredient(
      name: name,
      status: json['status'] ?? 'meragukan',
      description: json['description'] ?? '',
      justification: json['justification'] ?? '',
      alternativeNames: List<String>.from(json['alternative_names'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'status': status,
      'description': description,
      'justification': justification,
      'alternative_names': alternativeNames,
    };
  }

  // Check if this ingredient matches a given text
  bool matchesText(String text) {
    String lowerText = text.toLowerCase().trim();
    
    // Check exact name match
    if (name.toLowerCase() == lowerText) return true;
    
    // Check alternative names
    for (String altName in alternativeNames) {
      if (lowerText.contains(altName.toLowerCase()) ||
          altName.toLowerCase().contains(lowerText)) {
        return true;
      }
    }
    
    return false;
  }

  bool get isHalal => status == 'halal';
  bool get isHaram => status == 'haram';
  bool get isMeragukan => status == 'meragukan';
}