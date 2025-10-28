class ProductSelectionEntity {
  final String productModel;
  final String image;
  final String route;
  final String productId;
  final double quantity;

  ProductSelectionEntity({
    required this.productId,
    required this.productModel,
    required this.image,
    required this.route,
    required this.quantity,
  });

  ProductSelectionEntity copyWith({
    String? productModel,
    String? image,
    String? route,
    String? productId,
    double? quantity,
  }) {
    return ProductSelectionEntity(
      productId: productId ?? this.productId,
      productModel: productModel ?? this.productModel,
      image: image ?? this.image,
      route: route ?? this.route,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productModel': productModel,
    'image': image,
    'route': route,
    'quantity': quantity,
  };

  /// ✅ fromJson versi aman terhadap tipe
  factory ProductSelectionEntity.fromJson(Map<String, dynamic> json) {
    double asDouble(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return ProductSelectionEntity(
      productId: (json['productId'] ?? '').toString(),
      productModel: (json['productModel'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      quantity: asDouble(json['quantity']),
    );
  }

  /// ✅ Opsional: alias agar seragam dengan pemanggilan `fromMap`
  factory ProductSelectionEntity.fromMap(Map<String, dynamic> map) =>
      ProductSelectionEntity.fromJson(map);
}
