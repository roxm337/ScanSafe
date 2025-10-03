import 'package:dio/dio.dart';
import '../providers/api_provider.dart';

class ProductService {
  final ApiProvider _apiProvider;

  ProductService(this._apiProvider);

  Future<Response> scanProduct(String ean) async {
    final data = {'ean': ean};
    return await _apiProvider.post('/scan', data);
  }
}