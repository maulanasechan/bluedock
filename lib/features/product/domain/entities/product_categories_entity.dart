class ProductCategoriesEntity {
  final String title;
  final String image;
  final String route;
  final String productCategoriesId;
  final double totalProduct;

  ProductCategoriesEntity({
    required this.productCategoriesId,
    required this.title,
    required this.image,
    required this.route,
    required this.totalProduct,
  });

  ProductCategoriesEntity copyWith({
    String? title,
    String? image,
    String? route,
    String? productCategoriesId,
    double? totalProduct,
  }) {
    return ProductCategoriesEntity(
      productCategoriesId: productCategoriesId ?? this.productCategoriesId,
      title: title ?? this.title,
      image: image ?? this.image,
      route: route ?? this.route,
      totalProduct: totalProduct ?? this.totalProduct,
    );
  }
}
