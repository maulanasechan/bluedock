import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SperreScrewCompressorModel {
  // Core fields
  final String productId;
  final String productUsage;
  final String productType;
  final String coolingSystem;
  final String productTypeCode;
  final String chargingCapacity8Bar;
  final String chargingCapacity10Bar;
  final String chargingCapacity12_5Bar;
  final List<String> favorites;
  final int quantity;
  final String image;

  // Meta & search (disamakan pola dengan StaffModel)
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  SperreScrewCompressorModel({
    required this.productId,
    required this.productUsage,
    required this.productType,
    required this.coolingSystem,
    required this.productTypeCode,
    required this.chargingCapacity8Bar,
    required this.chargingCapacity10Bar,
    required this.chargingCapacity12_5Bar,
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
      'productType': productType,
      'coolingSystem': coolingSystem,
      'productTypeCode': productTypeCode,
      'chargingCapacity8Bar': chargingCapacity8Bar,
      'chargingCapacity10Bar': chargingCapacity10Bar,
      'chargingCapacity12_5Bar': chargingCapacity12_5Bar,
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

  factory SperreScrewCompressorModel.fromMap(Map<String, dynamic> map) {
    return SperreScrewCompressorModel(
      productId: map['productId'] ?? '',
      productUsage: map['productUsage'] ?? '',
      productType: map['productType'] ?? '',
      coolingSystem: map['coolingSystem'] ?? '',
      productTypeCode: map['productTypeCode'] ?? '',
      chargingCapacity8Bar: map['chargingCapacity8Bar'] ?? '',
      chargingCapacity10Bar: map['chargingCapacity10Bar'] ?? '',
      chargingCapacity12_5Bar: map['chargingCapacity12_5Bar'] ?? '',
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

  factory SperreScrewCompressorModel.fromJson(String source) =>
      SperreScrewCompressorModel.fromMap(json.decode(source));
}

extension SperreScrewCompressorXModel on SperreScrewCompressorModel {
  SperreScrewCompressorEntity toEntity() {
    return SperreScrewCompressorEntity(
      productId: productId,
      productUsage: productUsage,
      productType: productType,
      coolingSystem: coolingSystem,
      productTypeCode: productTypeCode,
      chargingCapacity8Bar: chargingCapacity8Bar,
      chargingCapacity10Bar: chargingCapacity10Bar,
      chargingCapacity12_5Bar: chargingCapacity12_5Bar,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
