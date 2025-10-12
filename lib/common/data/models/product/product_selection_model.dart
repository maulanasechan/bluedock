import 'dart:convert';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';

class ProductSelectionModel {
  final String productModel;
  final String image;
  final String route;
  final String productId;
  final double quantity;
  final List<String> searchKeywords;

  ProductSelectionModel({
    required this.productId,
    required this.productModel,
    required this.image,
    required this.route,
    required this.quantity,
    this.searchKeywords = const <String>[],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productModel': productModel,
      'image': image,
      'route': route,
      'productId': productId,
      'quantity': quantity,
      'searchKeywords': searchKeywords,
    };
  }

  factory ProductSelectionModel.fromMap(Map<String, dynamic> map) {
    return ProductSelectionModel(
      productModel: map['productModel'] ?? '',
      image: map['image'] ?? '',
      route: map['route'] ?? '',
      productId: map['productId'] ?? '',
      quantity: (map['quantity'] is num)
          ? (map['quantity'] as num).toDouble()
          : 0.0,
      searchKeywords: (map['searchKeywords'] is List)
          ? List<String>.from(
              (map['searchKeywords'] as List).map((e) => e.toString()),
            )
          : const <String>[],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductSelectionModel.fromJson(String source) =>
      ProductSelectionModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

extension ProductSelectionXModel on ProductSelectionModel {
  ProductSelectionEntity toEntity() {
    return ProductSelectionEntity(
      productId: productId,
      productModel: productModel,
      image: image,
      route: route,
      quantity: quantity,
    );
  }
}
