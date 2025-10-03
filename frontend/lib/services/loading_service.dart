import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxString _loadingMessage = ''.obs;

  bool get isLoading => _isLoading.value;
  String get loadingMessage => _loadingMessage.value;

  void startLoading([String message = 'Loading...']) {
    _loadingMessage.value = message;
    _isLoading.value = true;
  }

  void stopLoading() {
    _isLoading.value = false;
    _loadingMessage.value = '';
  }
}