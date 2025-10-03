import 'package:cloud_firestore/cloud_firestore.dart';

class DetegasaOilyWaterSeparatorEntity {
  final String productId;
  final String productModel;
  final String productCapacity;
  final String productLength;
  final String productWidth;
  final String productHeight;

  final List<String> favorites;
  final int quantity;
  final String image;

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const DetegasaOilyWaterSeparatorEntity({
    required this.productId,
    required this.productModel,
    required this.productCapacity,
    required this.productLength,
    required this.productWidth,
    required this.productHeight,
    required this.favorites,
    required this.quantity,
    required this.image,
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  DetegasaOilyWaterSeparatorEntity copyWith({
    String? productId,
    String? productModel,
    String? productCapacity,
    String? productLength,
    String? productWidth,
    String? productHeight,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return DetegasaOilyWaterSeparatorEntity(
      productId: productId ?? this.productId,
      productModel: productModel ?? this.productModel,
      productCapacity: productCapacity ?? this.productCapacity,
      productLength: productLength ?? this.productLength,
      productWidth: productWidth ?? this.productWidth,
      productHeight: productHeight ?? this.productHeight,
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
