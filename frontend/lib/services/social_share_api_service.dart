import 'package:get/get.dart';
import '../providers/api_provider.dart';

class SocialShareApiService extends GetxService {
  static SocialShareApiService get to => Get.find();
  
  late ApiProvider apiProvider;

  @override
  void onInit() {
    super.onInit();
    apiProvider = Get.find<ApiProvider>();
  }

  Future<Map<String, dynamic>> generateShareContent(String productId) async {
    try {
      // Validate productId and handle empty case
      String actualProductId = productId.isEmpty ? 'unknown' : productId;
      final response = await apiProvider.get('/product/$actualProductId/share-content');
      if (response.data != null) {
        return response.data;
      }
    } catch (e) {
      print('Error generating share content: $e');
    }
    
    return {
      'title': 'Product',
      'description': 'Check out this product',
      'url': '',
      'image': '',
      'hashtags': [],
      'message': 'Check out this product',
    };
  }

  Future<bool> trackShare(String productId, String platform) async {
    try {
      // Validate productId and handle empty case
      String actualProductId = productId.isEmpty ? 'unknown' : productId;
      final response = await apiProvider.post('/product/$actualProductId/share-track', {
        'platform': platform
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Error tracking share: $e');
      return false;
    }
  }
}