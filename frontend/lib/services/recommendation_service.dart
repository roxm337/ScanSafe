import 'package:frontend/models/compliance.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/preferences_controller.dart';
import '../services/recommendations_api_service.dart';

class RecommendationService extends GetxService {
  final PreferencesController preferencesController = Get.find<PreferencesController>();

  /// Finds alternative products based on user preferences and dietary restrictions
  Future<List<Product>> findAlternatives(Product product) async {
    try {
      final apiService = Get.find<RecommendationsApiService>();
      String productId = product.id.isEmpty ? product.ean : product.id;
      return await apiService.getProductAlternatives(productId);
    } catch (e) {
      print('Error getting alternatives from API: $e');
      // Fallback to local logic
      return _findAlternativesLocal(product);
    }
  }

  /// Finds alternative products using local logic (fallback)
  List<Product> _findAlternativesLocal(Product product) {
    List<Product> alternatives = [];
    
    // Check if the product has allergens that match user's allergies
    if (product.compliance.issues.isNotEmpty) {
      // Create mock alternatives that don't have the problematic ingredients
      List<String> safeAlternativeNames = [];
      
      for (var issue in product.compliance.issues) {
        String ingredient = issue['ingredient'] ?? '';
        
        if (preferencesController.hasAllergy(ingredient)) {
          // Generate alternative name based on the allergen
          safeAlternativeNames.add(_createAlternativeNameFromAllergen(ingredient, product));
        }
      }
      
      // Add alternatives to list
      safeAlternativeNames.forEach((altName) {
        alternatives.add(_createMockProduct(altName, product));
      });
    }
    
    return alternatives;
  }

  /// Creates an alternative name based on an allergen
  String _createAlternativeNameFromAllergen(String allergen, Product originalProduct) {
    String alternativeName = '';
    
    if (allergen.toLowerCase().contains('lactose') || allergen.toLowerCase().contains('dairy')) {
      alternativeName = 'Lactose-Free ${originalProduct.name}';
    } else if (allergen.toLowerCase().contains('gluten')) {
      alternativeName = 'Gluten-Free ${originalProduct.name}';
    } else if (allergen.toLowerCase().contains('nuts')) {
      alternativeName = 'Nut-Free ${originalProduct.name}';
    } else if (allergen.toLowerCase().contains('soy')) {
      alternativeName = 'Soy-Free ${originalProduct.name}';
    } else {
      alternativeName = '${allergen}-Free Alternative for ${originalProduct.name}';
    }
    
    return alternativeName;
  }

  /// Creates a mock product from a name
  Product _createMockProduct(String name, Product originalProduct) {
    return Product(
      id: 'mock_${(originalProduct.id.isEmpty ? originalProduct.ean : originalProduct.id)}_${name.hashCode}',
      name: name,
      brand: originalProduct.brand,
      imageUrl: originalProduct.imageUrl,
      ean: 'mock_${originalProduct.ean}',
      category: originalProduct.category,
      ingredientsText: 'Formulated to be safe for your dietary needs',
      allergens: [],
      compliance: Compliance(
        compliant: true,
        issues: [],
        advice: 'Recommended as a safe alternative',
      ),
      nutritionalInfo: originalProduct.nutritionalInfo,
    );
  }

  /// Checks if a product matches the user's dietary preferences
  bool matchesUserPreferences(Product product) {
    bool matches = true;
    
    // Check dietary restrictions
    for (String restriction in preferencesController.userPreferences.value.dietaryRestrictions) {
      if (restriction.toLowerCase() == 'vegan' && !product.name.toLowerCase().contains('vegan')) {
        // This would be more sophisticated in a real app
        matches = false;
      }
      // Add more dietary checks as needed
    }
    
    return matches;
  }

  /// Generates a recommendation message for the user
  Future<String> generateRecommendationMessage(Product product) async {
    try {
      final apiService = Get.find<RecommendationsApiService>();
      String productId = product.id.isEmpty ? product.ean : product.id;
      final result = await apiService.getPersonalizedRecommendations(productId);
      
      if (result.containsKey('risk_analysis')) {
        var riskAnalysis = result['risk_analysis'];
        if (riskAnalysis is Map && riskAnalysis.containsKey('advice')) {
          return riskAnalysis['advice'];
        }
      }
    } catch (e) {
      print('Error getting recommendations from API: $e');
    }

    // Fallback to local logic
    List<String> recommendations = [];
    
    // Check for allergens
    for (var issue in product.compliance.issues) {
      String ingredient = issue['ingredient'] ?? '';
      if (preferencesController.hasAllergy(ingredient)) {
        recommendations.add('🚨 Contains $ingredient which you are allergic to');
      }
    }
    
    // Check for dietary preferences
    for (String preference in preferencesController.userPreferences.value.dietaryRestrictions) {
      if (product.name.toLowerCase().contains(preference.toLowerCase())) {
        recommendations.add('✅ Matches your $preference preference');
      }
    }
    
    if (recommendations.isEmpty) {
      return 'This product appears to be safe based on your profile';
    }
    
    return recommendations.join('\n');
  }
}