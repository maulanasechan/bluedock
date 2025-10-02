import 'package:cloud_firestore/cloud_firestore.dart';

class SperreAirSystemSolutionsEntity {
  final String productId;
  final String productUsage;
  final String productCategory;
  final String productName;
  final String productExplanation;
  final List<String> favorites;
  final int quantity;
  final String image;

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const SperreAirSystemSolutionsEntity({
    required this.productId,
    required this.productUsage,
    required this.productCategory,
    required this.productName,
    required this.productExplanation,
    required this.favorites,
    required this.quantity,
    required this.image,
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  SperreAirSystemSolutionsEntity copyWith({
    String? productId,
    String? productUsage,
    String? productCategory,
    String? productName,
    String? productExplanation,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return SperreAirSystemSolutionsEntity(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productCategory: productCategory ?? this.productCategory,
      productName: productName ?? this.productName,
      productExplanation: productExplanation ?? this.productExplanation,
      favorites: favorites ?? this.favorites,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
