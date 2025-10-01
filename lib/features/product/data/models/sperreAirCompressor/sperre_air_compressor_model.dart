import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';

class SperreAirCompressorModel {
  // Core fields
  final String productId;
  final String productUsage;
  final String productType;
  final String coolingSystem;
  final String productTypeCode;
  final String chargingCapacity50Hz1500rpm;
  final String maxDeliveryPressure;
  final List<String> favorites;
  final int quantity;
  final String image;

  // Meta & search (disamakan pola dengan StaffModel)
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  SperreAirCompressorModel({
    required this.productId,
    required this.productUsage,
    required this.productType,
    required this.coolingSystem,
    required this.productTypeCode,
    required this.chargingCapacity50Hz1500rpm,
    required this.maxDeliveryPressure,
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
      'chargingCapacity50Hz1500rpm': chargingCapacity50Hz1500rpm,
      'maxDeliveryPressure': maxDeliveryPressure,
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

  factory SperreAirCompressorModel.fromMap(Map<String, dynamic> map) {
    return SperreAirCompressorModel(
      productId: map['productId'] ?? '',
      productUsage: map['productUsage'] ?? '',
      productType: map['productType'] ?? '',
      coolingSystem: map['coolingSystem'] ?? '',
      productTypeCode: map['productTypeCode'] ?? '',
      chargingCapacity50Hz1500rpm: map['chargingCapacity50Hz1500rpm'] ?? '',
      maxDeliveryPressure: map['maxDeliveryPressure'] ?? '',
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

  factory SperreAirCompressorModel.fromJson(String source) =>
      SperreAirCompressorModel.fromMap(json.decode(source));
}

extension SperreAirCompressorXModel on SperreAirCompressorModel {
  SperreAirCompressorEntity toEntity() {
    return SperreAirCompressorEntity(
      productId: productId,
      productUsage: productUsage,
      productType: productType,
      coolingSystem: coolingSystem,
      productTypeCode: productTypeCode,
      chargingCapacity50Hz1500rpm: chargingCapacity50Hz1500rpm,
      maxDeliveryPressure: maxDeliveryPressure,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
