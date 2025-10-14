class SearchWithTypeReq {
  final String type;
  final String keyword;

  const SearchWithTypeReq({this.type = '', this.keyword = ''});

  SearchWithTypeReq copyWith({String? type, String? keyword}) {
    return SearchWithTypeReq(
      type: type ?? this.type,
      keyword: keyword ?? this.keyword,
    );
  }
}
