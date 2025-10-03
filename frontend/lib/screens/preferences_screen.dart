import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preferences_controller.dart';
import '../models/user_preferences.dart';
import '../components/layout/custom_card.dart';
import '../components/buttons/custom_elevated_button.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final PreferencesController preferencesController = Get.find<PreferencesController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller if it's not already in GetX
    if (Get.isRegistered<PreferencesController>()) {
      preferencesController;
    } else {
      Get.put(PreferencesController());
    }
    
    // Load preferences when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preferencesController.loadPreferences();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Obx(() => preferencesController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      color: Colors.white,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Personal Profile',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your preferences and restrictions',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Allergies section
            _buildAllergiesSection(context),

            const SizedBox(height: 20),

            // Dietary restrictions section
            _buildDietarySection(context),

            const SizedBox(height: 20),

            // Lifestyle preferences section
            _buildLifestyleSection(context),

            const SizedBox(height: 20),

            // Save button
            CustomElevatedButton(
              text: 'Save Preferences',
              onPressed: () {
                preferencesController.savePreferences();
                Get.snackbar('Success', 'Preferences saved successfully!');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesSection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Allergies & Sensitivities',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Select ingredients you need to avoid',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserPreferences.commonAllergies.map((allergy) {
              bool isSelected = preferencesController.userPreferences.value.allergies.contains(allergy);
              return FilterChip(
                label: Text(allergy),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                checkmarkColor: Theme.of(context).colorScheme.primary,
                onSelected: (bool selected) {
                  if (selected) {
                    preferencesController.addAllergy(allergy);
                  } else {
                    preferencesController.removeAllergy(allergy);
                  }
                },
                labelStyle: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).dividerColor,
                  ),
                ),
              );
            }).toList(),
          ),
          // Custom allergy input
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Add custom allergy',
              prefixIcon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                preferencesController.addAllergy(value.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDietarySection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Dietary Preferences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Select your dietary restrictions and preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserPreferences.dietaryOptions.map((option) {
              bool isSelected = preferencesController.userPreferences.value.dietaryRestrictions.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                checkmarkColor: Theme.of(context).colorScheme.primary,
                onSelected: (bool selected) {
                  if (selected) {
                    preferencesController.addDietaryRestriction(option);
                  } else {
                    preferencesController.removeDietaryRestriction(option);
                  }
                },
                labelStyle: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).dividerColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleSection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.eco,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                'Lifestyle Preferences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Select your lifestyle preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserPreferences.lifestyleOptions.map((option) {
              bool isSelected = preferencesController.userPreferences.value.lifestylePreferences.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
                checkmarkColor: Theme.of(context).colorScheme.tertiary,
                onSelected: (bool selected) {
                  if (selected) {
                    preferencesController.userPreferences.value.lifestylePreferences.add(option);
                    preferencesController.savePreferences();
                  } else {
                    preferencesController.userPreferences.value.lifestylePreferences.remove(option);
                    preferencesController.savePreferences();
                  }
                },
                labelStyle: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.tertiary 
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.tertiary 
                        : Theme.of(context).dividerColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}