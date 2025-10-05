import 'compliance.dart';

class Product {
  final String id; // Add id field
  final String ean;
  final String name;
  final String brand;
  final String? imageUrl;
  final String? category; // Add category field for recommendations
  final String ingredientsText;
  final List<dynamic> allergens;
  final Compliance compliance;
  final Map<String, dynamic>? nutritionalInfo; // Add nutritional info for completeness

  Product({
    this.id = '',  // Default to empty string
    required this.ean,
    required this.name,
    required this.brand,
    this.imageUrl,
    this.category,
    required this.ingredientsText,
    required this.allergens,
    required this.compliance,
    this.nutritionalInfo,
  });

  factory Product.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? complianceData}) {
    return Product(
      id: (json['id'] ?? json['ean'] ?? '').toString(), // Convert to string to handle both int and string
      ean: json['ean'] ?? json['id'] ?? '', // Fallback logic
      name: json['name'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? json['imageUrl'],
      category: json['category'] ?? json['product_category'],
      ingredientsText: json['ingredients_text'] ?? json['ingredientsText'] ?? 'No ingredients listed',
      allergens: json['allergens'] ?? [],
      compliance: complianceData != null 
          ? Compliance.fromJson(complianceData) 
          : json['compliance'] != null 
              ? Compliance.fromJson(json['compliance']) 
              : Compliance.fromJson({}), // Provide default if none exists
      nutritionalInfo: json['nutritional_info'] ?? json['nutritionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ean': ean,
      'name': name,
      'brand': brand,
      'image_url': imageUrl,
      'category': category,
      'ingredients_text': ingredientsText,
      'allergens': allergens,
      'compliance': compliance.toJson(),
      'nutritional_info': nutritionalInfo,
    };
  }
}
