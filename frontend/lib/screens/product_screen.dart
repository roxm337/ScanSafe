import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/product_controller.dart';
import '../controllers/preferences_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/recommendation_service.dart';
import '../services/reviews_service.dart';
import '../services/social_share_api_service.dart';
import '../models/product.dart';
import '../models/product_review.dart';
import '../theme.dart';

class ProductScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.textColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final product = productController.product.value;
        if (product == null) {
          return const Center(child: Text('No product selected'));
        }
        return _buildProductContent(context, product);
      }),
    );
  }

  Widget _buildProductContent(BuildContext context, Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          if (product.imageUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // If no image is available, show a placeholder
          if (product.imageUrl == null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.pastelPurple,
                    AppTheme.pastelBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.production_quantity_limits,
                size: 80,
                color: AppTheme.primaryColor.withOpacity(0.7),
              ),
            ),
          const SizedBox(height: 16),
          // Product name and brand
          Text(
            product.name,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.brand,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 20),
          // Safety status
          _buildSafetyCard(product),
          const SizedBox(height: 16),
          // Ingredients section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ingredients',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildIngredientTags(product.ingredientsText.split(', ')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // AI Safety Analysis
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: AppTheme.secondaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'AI Safety Analysis',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSafetyAnalysis(product),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSafetyCard(Product product) {
    // Determine compliance status for styling
    bool hasUserAllergies = false;
    for (var issue in product.compliance.issues) {
      String ingredient = issue['ingredient'] ?? '';
      if (Get.find<PreferencesController>().hasAllergy(ingredient)) {
        hasUserAllergies = true;
        break;
      }
    }

    Color cardColor = hasUserAllergies 
        ? AppTheme.errorColor.withOpacity(0.1)
        : product.compliance.compliant
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.warningColor.withOpacity(0.1);

    Color borderColor = hasUserAllergies 
        ? AppTheme.errorColor
        : product.compliance.compliant
            ? AppTheme.successColor
            : AppTheme.warningColor;

    IconData statusIcon = hasUserAllergies 
        ? Icons.warning_amber_rounded
        : product.compliance.compliant
            ? Icons.check_circle
            : Icons.warning_amber_rounded;

    String statusText = hasUserAllergies 
        ? '⚠ Contains Ingredients You Should Avoid' 
        : product.compliance.compliant 
            ? '✓ Safe to Consume' 
            : '⚠ Not Recommended';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: borderColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: borderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientTags(List<String> ingredients) {
    if (ingredients.isEmpty || (ingredients.length == 1 && ingredients[0].isEmpty)) {
      return Text(
        'No ingredients listed',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: AppTheme.textSecondaryColor,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.take(10).map((ingredient) {
        // Simple logic to determine if an ingredient might be harmful
        bool isPotentiallyHarmful = _isPotentiallyHarmfulIngredient(ingredient);
        bool isUserAllergy = Get.find<PreferencesController>().hasAllergy(ingredient);

        Color tagColor = isUserAllergy 
            ? AppTheme.errorColor.withOpacity(0.1)
            : isPotentiallyHarmful 
                ? AppTheme.warningColor.withOpacity(0.1)
                : Colors.green.withOpacity(0.1);

        Color borderColor = isUserAllergy 
            ? AppTheme.errorColor
            : isPotentiallyHarmful 
                ? AppTheme.warningColor
                : Colors.green;

        String displayText = ingredient.trim();
        if (displayText.isEmpty) return SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: tagColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            displayText,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: borderColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isPotentiallyHarmfulIngredient(String ingredient) {
    // Common potentially harmful ingredients
    List<String> harmfulIngredients = [
      'parabens', 'sulfates', 'phthalates', 'formaldehyde', 'triclosan',
      'petrolatum', 'mineral oil', 'siloxanes', 'synthetic fragrances',
      'sodium lauryl sulfate', 'methylisothiazolinone'
    ];
    
    String lowerIngredient = ingredient.toLowerCase();
    return harmfulIngredients.any((harmful) => lowerIngredient.contains(harmful));
  }

  Widget _buildSafetyAnalysis(Product product) {
    if (product.compliance.issues.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.successColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                ),
                SizedBox(width: 8),
                Text(
                  'All Clear!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'No ingredients of concern detected. This product appears safe for general consumption.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.psychology_alt,
                color: AppTheme.warningColor,
              ),
              SizedBox(width: 8),
              Text(
                'AI Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        ...product.compliance.issues.map((issue) {
          String ingredient = issue['ingredient'] ?? '';
          String reason = issue['reason'] ?? '';
          bool isUserAllergy = Get.find<PreferencesController>().hasAllergy(ingredient);

          Color issueColor = isUserAllergy 
              ? AppTheme.errorColor 
              : AppTheme.warningColor;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUserAllergy 
                  ? AppTheme.errorColor.withOpacity(0.05) 
                  : AppTheme.warningColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: issueColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: issueColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        isUserAllergy ? Icons.warning : Icons.info,
                        size: 16,
                        color: issueColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      ingredient,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: issueColor,
                      ),
                    ),
                    if (isUserAllergy) ...[
                      SizedBox(width: 6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'YOUR ALLERGY',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  reason,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (product.compliance.advice != null && product.compliance.advice!.isNotEmpty) ...[
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Recommendation',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  product.compliance.advice!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}