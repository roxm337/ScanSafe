import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/api_provider.dart';
import '../models/user.dart';

import '../services/auth_service.dart';
import '../utils/constants.dart';

class AuthController extends GetxController {
  final ApiProvider apiProvider = Get.put(ApiProvider());
  final AuthService authService;
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;

  AuthController() : authService = AuthService(Get.find<ApiProvider>());

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.tokenKey);
    print(token);
    if (token != null) {
      apiProvider.setToken(token);
      // Optionally fetch user data
      try {
        final response = await authService.fetchUser();
        if (response.statusCode == 200) {
          user.value = User.fromJson(response.data);
        }
      } catch (e) {
        // handle error
      }
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> register(String name, String email, String password, String confirmPassword) async {
    isLoading.value = true;
    try {
      final response = await authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
      );
      
      if (response.statusCode == 200) {
        user.value = User.fromJson(response.data['user']);
        String token = response.data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, token);
        apiProvider.setToken(token);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Registration Failed', 'Please check your details and try again');
      }
    } catch (e) {
      Get.snackbar('Registration Failed', 'Please check your details and try again');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await authService.login(
        email: email,
        password: password,
      );
      
      if (response.statusCode == 200) {
        user.value = User.fromJson(response.data['user']);
        String token = response.data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, token);
        apiProvider.setToken(token);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Login Failed', 'Invalid email or password');
      }
    } catch (e) {
      Get.snackbar('Login Failed', 'Invalid email or password');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Try to logout from server, but don't fail if it doesn't work
      await authService.logout();
    } catch (e) {
      print('Server logout failed: $e');
      // Continue with local logout
    }

    try {
      // Clear local data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Local logout failed: $e');
      Get.snackbar('Logout Issue', 'There was a problem logging out');
    }
  }
}
