class SearchInventoryReq {
  final String category;
  final String model;
  final String keyword;

  const SearchInventoryReq({
    this.category = '',
    this.model = '',
    this.keyword = '',
  });

  SearchInventoryReq copyWith({
    String? category,
    String? model,
    String? keyword,
  }) {
    return SearchInventoryReq(
      category: category ?? this.category,
      model: model ?? this.model,
      keyword: keyword ?? this.keyword,
    );
  }
}
