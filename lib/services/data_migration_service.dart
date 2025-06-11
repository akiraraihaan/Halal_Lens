import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ingredient.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

class DataMigrationService {
  // Load and migrate ingredients from local JSON to Firestore
  static Future<void> migrateIngredientsToFirestore() async {
    try {
      // Load ingredients from assets
      String ingredientsJson = await rootBundle.loadString('bases/ingredients.json');
      Map<String, dynamic> data = jsonDecode(ingredientsJson);
      Map<String, dynamic> ingredients = data['ingredients'];
      
      for (String name in ingredients.keys) {
        Ingredient ingredient = Ingredient.fromJson(ingredients[name], name);
        await FirebaseService.addIngredient(ingredient);
        print('Added ingredient: $name');
      }
      
      print('Successfully migrated ${ingredients.length} ingredients to Firestore');
    } catch (e) {
      print('Error migrating ingredients: $e');
    }
  }
  
  // Load and migrate products from local JSON to Firestore
  static Future<void> migrateProductsToFirestore() async {
    try {
      // Load products from assets
      String productsJson = await rootBundle.loadString('bases/products.json');
      Map<String, dynamic> data = jsonDecode(productsJson);
      Map<String, dynamic> products = data['products'];
      
      for (String barcode in products.keys) {
        Product product = Product.fromJson(products[barcode], barcode);
        await FirebaseService.addProduct(product);
        print('Added product: ${product.name}');
      }
      
      print('Successfully migrated ${products.length} products to Firestore');
    } catch (e) {
      print('Error migrating products: $e');
    }
  }
  
  // Run full migration
  static Future<void> runFullMigration() async {
    print('Starting data migration...');
    await migrateIngredientsToFirestore();
    await migrateProductsToFirestore();
    print('Data migration completed!');
  }
}
