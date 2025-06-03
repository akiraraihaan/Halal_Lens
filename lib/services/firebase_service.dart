import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/halal_product.dart';
import '../models/haram_composition.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get halal product by barcode
  static Future<HalalProduct?> getHalalProduct(String barcode) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('halal_product')
          .doc(barcode)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return HalalProduct.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching halal product: $e');
      return null;
    }
  }
  
  // Get all haram compositions
  static Future<List<HaramComposition>> getAllHaramCompositions() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('haram_composition')
          .get();
      
      return querySnapshot.docs.map((doc) {
        return HaramComposition.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching haram compositions: $e');
      return [];
    }
  }
  
  // Check ingredients against haram compositions
  static Future<List<HaramComposition>> checkIngredients(List<String> ingredients) async {
    List<HaramComposition> haramCompositions = await getAllHaramCompositions();
    List<HaramComposition> foundHaramIngredients = [];
    
    for (String ingredient in ingredients) {
      for (HaramComposition haram in haramCompositions) {
        if (haram.matchesIngredient(ingredient)) {
          foundHaramIngredients.add(haram);
          break; // Avoid duplicates
        }
      }
    }
    
    return foundHaramIngredients;
  }
}
