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
}
