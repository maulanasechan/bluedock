import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetegasaOilyWaterSeparatorModel {
  final String productId;
  final String productModel;
  final String productCapacity;
  final String productLength;
  final String productWidth;
  final String productHeight;
  final List<String> favorites;
  final int quantity;
  final String image;

  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  DetegasaOilyWaterSeparatorModel({
    required this.productId,
    required this.productModel,
    required this.productCapacity,
    required this.productLength,
    required this.productWidth,
    required this.productHeight,
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
      'productModel': productModel,
      'productCapacity': productCapacity,
      'productLength': productLength,
      'productWidth': productWidth,
      'productHeight': productHeight,
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

  factory DetegasaOilyWaterSeparatorModel.fromMap(Map<String, dynamic> map) {
    return DetegasaOilyWaterSeparatorModel(
      productId: map['productId'] ?? '',
      productModel: map['productModel'] ?? '',
      productCapacity: map['productCapacity'] ?? '',
      productLength: map['productLength'] ?? '',
      productWidth: map['productWidth'] ?? '',
      productHeight: map['productHeight'] ?? '',
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

  factory DetegasaOilyWaterSeparatorModel.fromJson(String source) =>
      DetegasaOilyWaterSeparatorModel.fromMap(json.decode(source));
}

extension DetegasaOilyWaterSeparatorXModel on DetegasaOilyWaterSeparatorModel {
  DetegasaOilyWaterSeparatorEntity toEntity() {
    return DetegasaOilyWaterSeparatorEntity(
      productId: productId,
      productModel: productModel,
      productCapacity: productCapacity,
      productLength: productLength,
      productWidth: productWidth,
      productHeight: productHeight,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
