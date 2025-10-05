import 'package:flutter/material.dart';
import 'package:frontend/controllers/preferences_controller.dart';
import 'package:frontend/controllers/scan_history_controller.dart';
import 'package:frontend/screens/scan_screen.dart';
import 'package:frontend/services/preferences_api_service.dart';
import 'package:frontend/services/recommendations_api_service.dart';
import 'package:frontend/services/recommendations_service.dart';
import 'package:frontend/services/reviews_api_service.dart';
import 'package:frontend/services/social_share_service.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/product_screen.dart';
import 'package:frontend/screens/home_screen.dart'; // Updated to use home screen
import 'package:frontend/screens/settings_screen.dart';
import 'package:frontend/screens/scan_history_screen.dart';
import 'package:frontend/screens/about_screen.dart';
import 'package:frontend/screens/preferences_screen.dart';
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/providers/api_provider.dart';
import 'package:frontend/theme.dart';
import 'package:frontend/services/recommendation_service.dart';
import 'package:frontend/services/reviews_service.dart';
import 'package:frontend/services/social_share_api_service.dart';

void main() {
  Get.put(ApiProvider());
  Get.put(PreferencesApiService());
  Get.put(ReviewsApiService());
  Get.put(RecommendationsApiService());
  Get.put(SocialShareApiService());
  Get.put(ReviewsService(Get.find<ApiProvider>()));
  Get.put(RecommendationsService(Get.find<ApiProvider>()));
  Get.put(SocialShareService(Get.find<ApiProvider>()));
  Get.put(AuthController());
  Get.put(PreferencesController());
  Get.put(RecommendationService());
  Get.put(ScanHistoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ScanSafe',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => HomeScreen()), // Changed to home screen
        GetPage(name: '/product', page: () => ProductScreen()),
        GetPage(name: '/history', page: () => HistoryScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(name: '/settings', page: () => SettingsScreen()),
        GetPage(name: '/scan-history', page: () => ScanHistoryScreen()),
        GetPage(name: '/about', page: () => AboutScreen()),
        GetPage(name: '/preferences', page: () => PreferencesScreen()),
        GetPage(name: '/scan', page: () => ScanScreen()),
        GetPage(name: '/saved', page: () => ScanHistoryScreen()), // Reuse ScanHistoryScreen for saved products
      ],
    );
  }
}
