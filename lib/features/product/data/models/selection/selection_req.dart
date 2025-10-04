class SelectionReq {
  final String categoryId;
  final String selectionTitle;

  const SelectionReq({this.categoryId = '', this.selectionTitle = ''});

  SelectionReq copyWith({String? categoryId, String? selectionTitle}) {
    return SelectionReq(
      categoryId: categoryId ?? this.categoryId,
      selectionTitle: selectionTitle ?? this.selectionTitle,
    );
  }
}
