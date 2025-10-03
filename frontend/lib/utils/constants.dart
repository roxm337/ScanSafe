class AppConstants {
  // API endpoints
  static const String baseUrl = 'http://192.168.1.8:8000/api';
  
  // Storage keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  
  // Validation patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Animation durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 700);
}