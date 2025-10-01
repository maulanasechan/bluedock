class SelectionReq {
  final String productTitle;
  final String selectionTitle;

  const SelectionReq({this.productTitle = '', this.selectionTitle = ''});

  SelectionReq copyWith({String? productTitle, String? selectionTitle}) {
    return SelectionReq(
      productTitle: productTitle ?? this.productTitle,
      selectionTitle: selectionTitle ?? this.selectionTitle,
    );
  }
}
