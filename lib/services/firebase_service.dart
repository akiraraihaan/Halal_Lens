import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/ingredient.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get product by barcode
  static Future<Product?> getProduct(String barcode) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('products')
          .doc(barcode)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return Product.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
  
  // Get all ingredients
  static Future<List<Ingredient>> getAllIngredients() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('ingredients')
          .get();
      
      return querySnapshot.docs.map((doc) {
        return Ingredient.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching ingredients: $e');
      return [];
    }
  }
  
  // Get all products
  static Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .get();
      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Check compositions against ingredient database
  static Future<Map<String, List<Ingredient>>> checkCompositions(List<String> compositions) async {
    List<Ingredient> allIngredients = await getAllIngredients();
    
    Map<String, List<Ingredient>> result = {
      'halal': [],
      'haram': [],
      'meragukan': [],
      'unknown': []
    };
    
    for (String composition in compositions) {
      bool found = false;
      for (Ingredient ingredient in allIngredients) {
        if (ingredient.matchesText(composition)) {
          result[ingredient.status]?.add(ingredient);
          found = true;
          break;
        }
      }
      
      if (!found) {
        // Create unknown ingredient
        Ingredient unknown = Ingredient(
          name: composition,
          status: 'unknown',
          description: 'Bahan tidak dikenal dalam database',
          justification: 'Perlu penelitian lebih lanjut',
        );
        result['unknown']?.add(unknown);
      }
    }
    
    return result;
  }
  
  // Add or update ingredient
  static Future<void> addIngredient(Ingredient ingredient) async {
    try {
      await _firestore
          .collection('ingredients')
          .doc(ingredient.name)
          .set(ingredient.toFirestore());
    } catch (e) {
      print('Error adding ingredient: $e');
    }
  }
  
  // Add or update product
  static Future<void> addProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.barcode)
          .set(product.toFirestore());
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Update ingredient
  static Future<void> updateIngredient(String name, Ingredient ingredient) async {
    try {
      await _firestore
          .collection('ingredients')
          .doc(name)
          .set(ingredient.toFirestore());
    } catch (e) {
      print('Error updating ingredient: $e');
    }
  }

  // Update product
  static Future<void> updateProduct(String barcode, Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(barcode)
          .set(product.toFirestore());
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Delete ingredient
  static Future<void> deleteIngredient(String name) async {
    try {
      await _firestore.collection('ingredients').doc(name).delete();
    } catch (e) {
      print('Error deleting ingredient: $e');
    }
  }

  // Delete product
  static Future<void> deleteProduct(String barcode) async {
    try {
      await _firestore.collection('products').doc(barcode).delete();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
