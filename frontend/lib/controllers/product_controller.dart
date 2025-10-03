import 'package:get/get.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  Rx<Product?> product = Rx<Product?>(null);

  void setProduct(Product p) {
    product.value = p;
  }
}
