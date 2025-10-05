import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan.dart';
import '../services/scan_service.dart';
import '../providers/api_provider.dart';
import '../utils/constants.dart';

class ScanHistoryController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final ScanService scanService;
  var scans = <Scan>[].obs;
  var isLoading = true.obs;

  ScanHistoryController() : scanService = ScanService(Get.find<ApiProvider>());

  @override
  void onInit() {
    super.onInit();
    fetchScans();
  }

  Future<void> fetchScans() async {
    try {
      // Check if user is authenticated by checking for token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.tokenKey);
      
      if (token == null) {
        print('No authentication token found, cannot fetch scan history');
        isLoading.value = false;
        return;
      }
      
      isLoading.value = true;
      final response = await scanService.getScans();
      print("response data ----> " + response.data.toString());
      
      if (response.statusCode == 200) {
        final List<dynamic> scanList = response.data['data'] ?? response.data;
        scans.assignAll(
          scanList.map((json) => Scan.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      print('Error fetching scan history: $e');
      if (e is DioException) {
        print('DioException details: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        print('DioException data: ${e.response?.data}');
      }
    } finally {
      isLoading.value = false;
    }
  }
}