import 'package:cloud_firestore/cloud_firestore.dart';

class SperreAirCompressorEntity {
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

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const SperreAirCompressorEntity({
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
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  SperreAirCompressorEntity copyWith({
    String? productId,
    String? productUsage,
    String? productType,
    String? coolingSystem,
    String? productTypeCode,
    String? chargingCapacity50Hz1500rpm,
    String? maxDeliveryPressure,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return SperreAirCompressorEntity(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productType: productType ?? this.productType,
      coolingSystem: coolingSystem ?? this.coolingSystem,
      productTypeCode: productTypeCode ?? this.productTypeCode,
      chargingCapacity50Hz1500rpm:
          chargingCapacity50Hz1500rpm ?? this.chargingCapacity50Hz1500rpm,
      maxDeliveryPressure: maxDeliveryPressure ?? this.maxDeliveryPressure,
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
