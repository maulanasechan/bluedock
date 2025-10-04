class ProductReq {
  final String productId;
  final String categoryId;

  const ProductReq({this.productId = '', this.categoryId = ''});

  ProductReq copyWith({String? productId, String? categoryId}) {
    return ProductReq(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
