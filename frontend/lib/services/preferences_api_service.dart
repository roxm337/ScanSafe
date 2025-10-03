import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/user_preferences.dart';

class PreferencesApiService extends GetxService {
  static PreferencesApiService get to => Get.find();
  
  late ApiProvider apiProvider;

  @override
  void onInit() {
    super.onInit();
    apiProvider = Get.find<ApiProvider>();
  }

  Future<UserPreferences> getPreferences() async {
    final response = await apiProvider.get('/preferences');
    return UserPreferences.fromJson(response.data);
  }

  Future<UserPreferences> updatePreferences(UserPreferences preferences) async {
    final response = await apiProvider.post('/preferences', preferences.toJson());
    return UserPreferences.fromJson(response.data);
  }
}