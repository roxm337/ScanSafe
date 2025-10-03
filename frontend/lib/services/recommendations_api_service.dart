import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/product.dart';

class RecommendationsApiService extends GetxService {
  static RecommendationsApiService get to => Get.find();
  
  late ApiProvider apiProvider;

  @override
  void onInit() {
    super.onInit();
    apiProvider = Get.find<ApiProvider>();
  }

  Future<List<Product>> getUserRecommendations({int limit = 10}) async {
    final response = await apiProvider.get('/recommendations?limit=$limit');
    if (response.data != null) {
      return (response.data as List)
          .map((json) => Product.fromJson(json['product']))
          .toList();
    }
    return [];
  }

  Future<List<Product>> getProductAlternatives(String productId, {int limit = 5}) async {
    final response = await apiProvider.get('/product/$productId/alternatives?limit=$limit');
    if (response.data != null) {
      return (response.data as List)
          .map((json) => Product.fromJson(json['product'] ?? json))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getPersonalizedRecommendations(String productId) async {
    final response = await apiProvider.get('/product/$productId/recommendations');
    if (response.data != null) {
      return response.data;
    }
    return {};
  }

  Future<List<Product>> getTrendingRecommendations() async {
    final response = await apiProvider.get('/trending');
    if (response.data != null) {
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    }
    return [];
  }
}