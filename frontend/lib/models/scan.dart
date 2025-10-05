import 'product.dart';

class Scan {
  final String id;
  final String userId;
  final String productId;
  final String scannedAt;
  final Product product;

  Scan({
    required this.id,
    required this.userId,
    required this.productId,
    required this.scannedAt,
    required this.product,
  });

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      productId: (json['product_id'] ?? json['productId'] ?? '').toString(),
      scannedAt: json['scanned_at'] ?? json['created_at'] ?? json['scannedAt'] ?? '',
      product: json['product'] != null 
          ? Product.fromJson(json['product'], complianceData: json['product']['compliance'] as Map<String, dynamic>?) 
          : Product(
              ean: '',
              name: 'Unknown Product',
              brand: 'Unknown',
              ingredientsText: 'No ingredients listed',
              allergens: [],
              compliance: json['product']?['compliance'] != null 
                  ? json['product']['compliance'] 
                  : {},
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'scanned_at': scannedAt,
      'product': product.toJson(),
    };
  }
}