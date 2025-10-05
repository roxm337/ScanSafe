import 'package:dio/dio.dart';
import '../providers/api_provider.dart';
import '../models/scan.dart';

class ScanService {
  final ApiProvider _apiProvider;

  ScanService(this._apiProvider);

  Future<Response> getScans() async {
    return await _apiProvider.get('/scans');
  }

  Future<Response> createScan(String ean) async {
    final data = {'ean': ean};
    return await _apiProvider.post('/scan', data);
  }
}