class ProductCategoryEntity {
  final String title;
  final String image;
  final String route;
  final String categoryId;
  final double totalProduct;

  ProductCategoryEntity({
    required this.categoryId,
    required this.title,
    required this.image,
    required this.route,
    required this.totalProduct,
  });

  ProductCategoryEntity copyWith({
    String? title,
    String? image,
    String? route,
    String? categoryId,
    double? totalProduct,
  }) {
    return ProductCategoryEntity(
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      image: image ?? this.image,
      route: route ?? this.route,
      totalProduct: totalProduct ?? this.totalProduct,
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'title': title,
    'image': image,
    'route': route,
    'totalProduct': totalProduct,
  };

  /// ✅ fromJson versi aman
  factory ProductCategoryEntity.fromJson(Map<String, dynamic> json) {
    double asDouble(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return ProductCategoryEntity(
      categoryId: (json['categoryId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      totalProduct: asDouble(json['totalProduct']),
    );
  }

  /// ✅ Opsional: agar konsisten dengan model lain (fromMap)
  factory ProductCategoryEntity.fromMap(Map<String, dynamic> map) =>
      ProductCategoryEntity.fromJson(map);
}
