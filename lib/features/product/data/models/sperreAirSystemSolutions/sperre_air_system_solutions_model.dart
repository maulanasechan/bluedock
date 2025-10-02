import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SperreAirSystemSolutionsModel {
  // Core fields
  final String productId;
  final String productUsage;
  final String productName;
  final String productCategory;
  final String productExplanation;
  final List<String> favorites;
  final int quantity;
  final String image;

  // Meta & search (disamakan pola dengan StaffModel)
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  SperreAirSystemSolutionsModel({
    required this.productId,
    required this.productUsage,
    required this.productExplanation,
    required this.productName,
    required this.productCategory,
    required this.favorites,
    required this.quantity,
    required this.image,
    required this.updatedBy,
    this.updatedAt,
    required this.createdAt,
    required this.createdBy,
    this.searchKeywords = const <String>[],
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productUsage': productUsage,
      'productName': productName,
      'productCategory': productCategory,
      'productExplanation': productExplanation,
      'favorites': favorites,
      'quantity': quantity,
      'image': image,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'searchKeywords': searchKeywords,
    };
  }

  factory SperreAirSystemSolutionsModel.fromMap(Map<String, dynamic> map) {
    return SperreAirSystemSolutionsModel(
      productId: map['productId'] ?? '',
      productUsage: map['productUsage'] ?? '',
      productCategory: map['productCategory'] ?? '',
      productName: map['productName'] ?? '',
      productExplanation: map['productExplanation'] ?? '',
      favorites: (map['favorites'] is List)
          ? List<String>.from(
              (map['favorites'] as List).map((e) => e.toString()),
            )
          : const <String>[],
      quantity: (map['quantity'] is num)
          ? (map['quantity'] as num).toInt()
          : int.tryParse(map['quantity']?.toString() ?? '') ?? 0,
      image: map['image'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'] ?? Timestamp(0, 0),
      createdBy: map['createdBy'] ?? '',
      searchKeywords: (map['searchKeywords'] is List)
          ? List<String>.from(
              (map['searchKeywords'] as List).map((e) => e.toString()),
            )
          : const <String>[],
    );
  }

  String toJson() => json.encode(toMap());

  factory SperreAirSystemSolutionsModel.fromJson(String source) =>
      SperreAirSystemSolutionsModel.fromMap(json.decode(source));
}

extension SperreAirSystemSolutionsXModel on SperreAirSystemSolutionsModel {
  SperreAirSystemSolutionsEntity toEntity() {
    return SperreAirSystemSolutionsEntity(
      productId: productId,
      productUsage: productUsage,
      productCategory: productCategory,
      productName: productName,
      productExplanation: productExplanation,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
