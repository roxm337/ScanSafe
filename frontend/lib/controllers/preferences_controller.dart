import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';
import '../services/preferences_api_service.dart';

class PreferencesController extends GetxController {
  Rx<UserPreferences> userPreferences = UserPreferences().obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    isLoading.value = true;
    try {
      // Try to load from API first
      try {
        final apiService = Get.find<PreferencesApiService>();
        userPreferences.value = await apiService.getPreferences();
      } catch (e) {
        print('Error loading preferences from API: $e');
        // Fallback to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userPreferences.value = UserPreferences(
          allergies: prefs.getStringList('allergies') ?? [],
          dietaryRestrictions: prefs.getStringList('dietary_restrictions') ?? [],
          lifestylePreferences: prefs.getStringList('lifestyle_preferences') ?? [],
          ingredientAlerts: prefs.getStringList('ingredient_alerts') ?? [],
          notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
          profileImage: prefs.getString('profile_image'),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePreferences() async {
    isLoading.value = true;
    try {
      // Save to API
      try {
        final apiService = Get.find<PreferencesApiService>();
        userPreferences.value = await apiService.updatePreferences(userPreferences.value);
      } catch (e) {
        print('Error saving preferences to API: $e');
        // Fallback to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('allergies', userPreferences.value.allergies);
        await prefs.setStringList('dietary_restrictions', userPreferences.value.dietaryRestrictions);
        await prefs.setStringList('lifestyle_preferences', userPreferences.value.lifestylePreferences);
        await prefs.setStringList('ingredient_alerts', userPreferences.value.ingredientAlerts);
        await prefs.setBool('notifications_enabled', userPreferences.value.notificationsEnabled);
        
        if (userPreferences.value.profileImage != null) {
          await prefs.setString('profile_image', userPreferences.value.profileImage!);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setAllergies(List<String> allergies) {
    userPreferences.value.allergies = allergies;
    savePreferences();
  }

  void setDietaryRestrictions(List<String> restrictions) {
    userPreferences.value.dietaryRestrictions = restrictions;
    savePreferences();
  }

  void setLifestylePreferences(List<String> preferences) {
    userPreferences.value.lifestylePreferences = preferences;
    savePreferences();
  }

  void addAllergy(String allergy) {
    if (!userPreferences.value.allergies.contains(allergy)) {
      userPreferences.value.allergies.add(allergy);
      savePreferences();
    }
  }

  void removeAllergy(String allergy) {
    userPreferences.value.allergies.remove(allergy);
    savePreferences();
  }

  void addDietaryRestriction(String restriction) {
    if (!userPreferences.value.dietaryRestrictions.contains(restriction)) {
      userPreferences.value.dietaryRestrictions.add(restriction);
      savePreferences();
    }
  }

  void removeDietaryRestriction(String restriction) {
    userPreferences.value.dietaryRestrictions.remove(restriction);
    savePreferences();
  }

  bool hasAllergy(String ingredient) {
    return userPreferences.value.allergies
        .any((allergy) => ingredient.toLowerCase().contains(allergy.toLowerCase()));
  }

  bool matchesDietaryPreference(String productTag) {
    return userPreferences.value.dietaryRestrictions
        .any((preference) => productTag.toLowerCase().contains(preference.toLowerCase()));
  }
}