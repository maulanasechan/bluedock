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
}
