import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/api_provider.dart';
import '../models/product.dart';
import 'product_controller.dart';

import '../services/product_service.dart';

class ScanController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final ProductService productService;
  final ProductController productController = Get.put(ProductController());
  RxBool isLoading = false.obs;
  RxBool isScanningEnabled = true.obs;
  MobileScannerController scannerController = MobileScannerController();

  ScanController() : productService = ProductService(Get.find<ApiProvider>());

  @override
  void onInit() {
    super.onInit();
    // Scanner starts automatically when created
  }

  void onDetect(BarcodeCapture capture) {
    if (!isScanningEnabled.value) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        fetchProduct(barcode.rawValue!);
        break;
      }
    }
  }

  Future<void> fetchProduct(String ean) async {
    isScanningEnabled.value = false;
    isLoading.value = true;
    try {
      final response = await productService.scanProduct(ean);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        print('Attempting to parse product...');
        final productData = response.data['product'];
        final complianceData = response.data['compliance'];
        print('Product data: $productData');
        print('Compliance data: $complianceData');
        final product = Product.fromJson(productData, complianceData: complianceData);
        print('Product parsed successfully: ${product.name}');
        productController.product.value = product;
        print('Navigating to product screen...');
        Get.toNamed('/product');
        print('Navigation successful');
      } else {
        Get.snackbar('Product Not Found', 'Unable to find product with this EAN code');
        isScanningEnabled.value = true; // Re-enable scanning on failure
      }
    } catch (e, stackTrace) {
      print('Error in fetchProduct: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Scanning Error', 'Failed to fetch product information. Please try again.');
      isScanningEnabled.value = true; // Re-enable scanning on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> manualScan(String ean) async {
    fetchProduct(ean);
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
