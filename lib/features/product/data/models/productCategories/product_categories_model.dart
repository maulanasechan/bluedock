import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/product_categories_entity.dart';

class ProductCategoriesModel {
  final String title;
  final String image;
  final String route;
  final String categoryId;
  final double totalProduct;

  ProductCategoriesModel({
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

  factory ProductCategoriesModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoriesModel(
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

  factory ProductCategoriesModel.fromJson(String source) =>
      ProductCategoriesModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

extension ProductCategoriesXModel on ProductCategoriesModel {
  ProductCategoriesEntity toEntity() {
    return ProductCategoriesEntity(
      categoryId: categoryId,
      title: title,
      image: image,
      route: route,
      totalProduct: totalProduct,
    );
  }
}
