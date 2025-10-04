class UserPreferences {
  List<String> allergies;
  List<String> dietaryRestrictions;
  List<String> lifestylePreferences;
  List<String> ingredientAlerts;
  bool notificationsEnabled;
  String? profileImage;

  UserPreferences({
    this.allergies = const [],
    this.dietaryRestrictions = const [],
    this.lifestylePreferences = const [],
    this.ingredientAlerts = const [],
    this.notificationsEnabled = true,
    this.profileImage,
  });

  // Common allergies
  static const List<String> commonAllergies = [
    'Gluten',
    'Lactose',
    'Nuts',
    'Peanuts',
    'Soy',
    'Eggs',
    'Shellfish',
    'Fish',
    'Wheat',
    'Sesame',
    'Parabens',
    'Sulfates',
    'Fragrance',
  ];

  // Dietary restrictions
  static const List<String> dietaryOptions = [
    'Vegan',
    'Vegetarian',
    'Pescatarian',
    'Keto',
    'Paleo',
    'Halal',
    'Kosher',
    'Organic',
    'Non-GMO',
    'Sugar-free',
    'Low-carb',
  ];

  // Lifestyle preferences
  static const List<String> lifestyleOptions = [
    'Eco-friendly',
    'Cruelty-free',
    'Fair-trade',
    'Sustainable packaging',
    'Plastic-free',
  ];

  UserPreferences.fromJson(Map<String, dynamic> json)
      : allergies = List<String>.from(json['allergies'] ?? []),
        dietaryRestrictions = List<String>.from(json['dietaryRestrictions'] ?? []),
        lifestylePreferences = List<String>.from(json['lifestylePreferences'] ?? []),
        ingredientAlerts = List<String>.from(json['ingredientAlerts'] ?? []),
        notificationsEnabled = json['notificationsEnabled'] ?? true,
        profileImage = json['profileImage'];

  Map<String, dynamic> toJson() {
    return {
      'allergies': allergies,
      'dietaryRestrictions': dietaryRestrictions,
      'lifestylePreferences': lifestylePreferences,
      'ingredientAlerts': ingredientAlerts,
      'notificationsEnabled': notificationsEnabled,
      'profileImage': profileImage,
    };
  }
}