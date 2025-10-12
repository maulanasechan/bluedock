import 'dart:convert';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';

class ProductCategoryModel {
  final String title;
  final String image;
  final String route;
  final String categoryId;
  final double totalProduct;

  ProductCategoryModel({
    required this.categoryId,
    required this.title,
    required this.image,
    required this.route,
    required this.totalProduct,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'route': route,
      'categoryId': categoryId,
      'totalProduct': totalProduct,
    };
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      route: map['route'] ?? '',
      categoryId: map['categoryId'] ?? '',
      totalProduct: (map['totalProduct'] is num)
          ? (map['totalProduct'] as num).toDouble()
          : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCategoryModel.fromJson(String source) =>
      ProductCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension ProductCategoryXModel on ProductCategoryModel {
  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(
      categoryId: categoryId,
      title: title,
      image: image,
      route: route,
      totalProduct: totalProduct,
    );
  }
}
