class ProductSelectionReq {
  final String categoryId;
  final String keyword;

  const ProductSelectionReq({this.categoryId = '', this.keyword = ''});

  ProductSelectionReq copyWith({String? categoryId, String? keyword}) {
    return ProductSelectionReq(
      categoryId: categoryId ?? this.categoryId,
      keyword: keyword ?? this.keyword,
    );
  }
}
