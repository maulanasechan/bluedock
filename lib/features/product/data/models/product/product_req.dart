class ProductReq {
  final String productId;
  final String productCategoriesTitle;
  final String productCategoriesId;

  const ProductReq({
    this.productId = '',
    this.productCategoriesId = '',
    this.productCategoriesTitle = '',
  });

  ProductReq copyWith({
    String? productId,
    String? productCategoriesId,
    String? productCategoriesTitle,
  }) {
    return ProductReq(
      productId: productId ?? this.productId,
      productCategoriesId: productCategoriesId ?? this.productCategoriesId,
      productCategoriesTitle:
          productCategoriesTitle ?? this.productCategoriesTitle,
    );
  }
}
