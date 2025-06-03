class HaramComposition {
  final String name;
  final String category;
  final String description;
  final List<String> keywords;

  HaramComposition({
    required this.name,
    required this.category,
    required this.description,
    required this.keywords,
  });

  factory HaramComposition.fromFirestore(Map<String, dynamic> data, String documentId) {
    return HaramComposition(
      name: data['name'] ?? documentId,
      category: data['category'] ?? 'Haram',
      description: data['description'] ?? '',
      keywords: List<String>.from(data['keywords'] ?? []),
    );
  }

  // Check if any of the keywords match the given ingredient
  bool matchesIngredient(String ingredient) {
    String lowerIngredient = ingredient.toLowerCase().trim();
    
    // Check exact name match
    if (name.toLowerCase() == lowerIngredient) return true;
    
    // Check keywords match
    for (String keyword in keywords) {
      if (lowerIngredient.contains(keyword.toLowerCase()) ||
          keyword.toLowerCase().contains(lowerIngredient)) {
        return true;
      }
    }
    
    return false;
  }
}
