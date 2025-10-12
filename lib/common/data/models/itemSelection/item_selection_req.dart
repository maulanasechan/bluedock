class ItemSelectionReq {
  final String collection;
  final String document;
  final String subCollection;

  const ItemSelectionReq({
    this.collection = '',
    this.document = '',
    this.subCollection = '',
  });

  ItemSelectionReq copyWith({
    String? collection,
    String? document,
    String? subCollection,
  }) {
    return ItemSelectionReq(
      collection: collection ?? this.collection,
      document: document ?? this.document,
      subCollection: subCollection ?? this.subCollection,
    );
  }
}
