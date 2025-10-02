import 'package:cloud_firestore/cloud_firestore.dart';

class SperreScrewCompressorEntity {
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

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const SperreScrewCompressorEntity({
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
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  SperreScrewCompressorEntity copyWith({
    String? productId,
    String? productUsage,
    String? productType,
    String? coolingSystem,
    String? productTypeCode,
    String? chargingCapacity8Bar,
    String? chargingCapacity10Bar,
    String? chargingCapacity12_5Bar,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return SperreScrewCompressorEntity(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productType: productType ?? this.productType,
      coolingSystem: coolingSystem ?? this.coolingSystem,
      productTypeCode: productTypeCode ?? this.productTypeCode,
      chargingCapacity8Bar: chargingCapacity8Bar ?? this.chargingCapacity8Bar,
      chargingCapacity10Bar:
          chargingCapacity10Bar ?? this.chargingCapacity10Bar,
      chargingCapacity12_5Bar:
          chargingCapacity12_5Bar ?? this.chargingCapacity12_5Bar,
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
