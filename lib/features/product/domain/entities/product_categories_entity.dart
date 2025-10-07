class ProductCategoriesEntity {
  final String title;
  final String image;
  final String route;
  final String categoryId;
  final double totalProduct;

  ProductCategoriesEntity({
    required this.categoryId,
    required this.title,
    required this.image,
    required this.route,
    required this.totalProduct,
  });

  ProductCategoriesEntity copyWith({
    String? title,
    String? image,
    String? route,
    String? categoryId,
    double? totalProduct,
  }) {
    return ProductCategoriesEntity(
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      image: image ?? this.image,
      route: route ?? this.route,
      totalProduct: totalProduct ?? this.totalProduct,
    );
  }
}
