import 'dart:convert';
import 'package:bluedock/features/project/domain/entities/selection/category_selection_entity.dart';

class CategorySelectionModel {
  final String title;
  final String image;
  final String route;
  final String categoryId;
  final double totalProduct;

  CategorySelectionModel({
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

  factory CategorySelectionModel.fromMap(Map<String, dynamic> map) {
    return CategorySelectionModel(
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

  factory CategorySelectionModel.fromJson(String source) =>
      CategorySelectionModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

extension CategorySelectionXModel on CategorySelectionModel {
  CategorySelectionEntity toEntity() {
    return CategorySelectionEntity(
      categoryId: categoryId,
      title: title,
      image: image,
      route: route,
      totalProduct: totalProduct,
    );
  }
}
