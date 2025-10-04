// Dummy data for products in ScanSafe app
// Used to populate UI during development

class DummyData {
  static List<Map<String, dynamic>> dummyProducts = [
    {
      'id': '1',
      'ean': '1234567890123',
      'name': 'Organic Apple Juice',
      'brand': 'Nature\'s Best',
      'image_url': 'https://via.placeholder.com/300x300/8A2BE2/FFFFFF?text=Apple+Juice',
      'ingredients_text': 'Organic apple juice, ascorbic acid (vitamin C), calcium lactate',
      'allergens': [],
      'compliance': {
        'compliant': true,
        'issues': [],
        'advice': 'Suitable for most dietary restrictions. Contains no artificial preservatives.'
      }
    },
    {
      'id': '2',
      'ean': '9876543210987',
      'name': 'Gluten-Free Bread',
      'brand': 'Healthy Bakes',
      'image_url': 'https://via.placeholder.com/300x300/40E0D0/FFFFFF?text=Bread',
      'ingredients_text': 'Rice flour, potato starch, tapioca starch, eggs, olive oil, salt, yeast, xanthan gum, sugar, vinegar',
      'allergens': ['Eggs'],
      'compliance': {
        'compliant': false,
        'issues': [
          {
            'ingredient': 'xanthan gum',
            'reason': 'Some people may experience digestive discomfort with large amounts'
          }
        ],
        'advice': 'Contains eggs, not suitable for those with egg allergies. Low in fiber compared to traditional bread.'
      }
    },
    {
      'id': '3',
      'ean': '5551234567890',
      'name': 'Baby Shampoo',
      'brand': 'Gentle Care',
      'image_url': 'https://via.placeholder.com/300x300/FF69B4/FFFFFF?text=Baby+Shampoo',
      'ingredients_text': 'Water, sodium laureth sulfate, cocamidopropyl betaine, glycerin, sodium chloride, citric acid, parfum, sodium benzoate, methylisothiazolinone',
      'allergens': [],
      'compliance': {
        'compliant': false,
        'issues': [
          {
            'ingredient': 'methylisothiazolinone',
            'reason': 'Preservative that may cause skin irritation, especially in sensitive individuals'
          },
          {
            'ingredient': 'sodium laureth sulfate',
            'reason': 'Sulfate that may cause eye irritation'
          }
        ],
        'advice': 'Not recommended for babies with sensitive skin. Consider paraben and sulfate-free alternatives.'
      }
    },
    {
      'id': '4',
      'ean': '4440987654321',
      'name': 'Protein Bar - Chocolate',
      'brand': 'Fit Snacks',
      'image_url': 'https://via.placeholder.com/300x300/D1C4E9/FFFFFF?text=Protein+Bar',
      'ingredients_text': 'Protein blend (whey protein isolate, milk protein isolate), almonds, dark chocolate chips (cocoa mass, sugar, cocoa butter), rice syrup, natural flavors, sea salt, mixed tocopherols',
      'allergens': ['Milk', 'Almonds'],
      'compliance': {
        'compliant': true,
        'issues': [],
        'advice': 'High protein content (20g per bar). Contains nuts - not suitable for those with almond allergies.'
      }
    },
    {
      'id': '5',
      'ean': '3331122334455',
      'name': 'Facial Moisturizer',
      'brand': 'Eco Beauty',
      'image_url': 'https://via.placeholder.com/300x300/B3E5FC/FFFFFF?text=Moisturizer',
      'ingredients_text': 'Aqua, glycerin, caprylic/capric triglyceride, cetearyl alcohol, sodium hyaluronate, niacinamide, parfum, phenoxyethanol, ethylhexylglycerin',
      'allergens': [],
      'compliance': {
        'compliant': false,
        'issues': [
          {
            'ingredient': 'phenoxyethanol',
            'reason': 'Preservative that may cause skin irritation in sensitive individuals'
          }
        ],
        'advice': 'Formulated for sensitive skin but contains phenoxyethanol. Patch test before use. Not recommended for pregnancy without consulting a physician.'
      }
    }
  ];

  static List<Map<String, String>> dummyReviews = [
    {
      'id': '1',
      'productId': '1',
      'userName': 'Sarah M.',
      'reviewText': 'Great tasting apple juice with no added sugar. Perfect for my kids!',
      'rating': '4',
      'date': '2023-10-01',
      'tags': 'no-added-sugar, kid-friendly, tasty',
      'helpfulVotes': '12'
    },
    {
      'id': '2',
      'productId': '2',
      'userName': 'John D.',
      'reviewText': 'Good texture but a bit dense. Better toasted.',
      'rating': '3',
      'date': '2023-09-28',
      'tags': 'good-but-dense, better-toasted',
      'helpfulVotes': '5'
    },
    {
      'id': '3',
      'productId': '3',
      'userName': 'Emma L.',
      'reviewText': 'Caused irritation around my baby\'s eyes. Would not recommend.',
      'rating': '1',
      'date': '2023-09-25',
      'tags': 'caused-irritation, not-recommended',
      'helpfulVotes': '24'
    }
  ];

  static List<Map<String, String>> quickActions = [
    {
      'title': 'Scan History',
      'subtitle': 'Review your past scans',
      'icon': 'history'
    },
    {
      'title': 'AI Assistant',
      'subtitle': 'Get product safety advice',
      'icon': 'psychology'
    },
    {
      'title': 'Preferences',
      'subtitle': 'Update your dietary needs',
      'icon': 'settings'
    },
    {
      'title': 'Profile',
      'subtitle': 'Manage your account',
      'icon': 'person'
    }
  ];

  static List<Map<String, String>> recommendations = [
    {
      'title': 'Eco Beauty Products',
      'subtitle': 'Discover safe and sustainable beauty alternatives',
      'icon': 'eco'
    },
    {
      'title': 'Food Safety Guide',
      'subtitle': 'Check ingredients for your dietary needs',
      'icon': 'restaurant'
    },
    {
      'title': 'Pregnancy Safe Products',
      'subtitle': 'Products safe to use during pregnancy',
      'icon': 'pregnant_woman'
    }
  ];
}