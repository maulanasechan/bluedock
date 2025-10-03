import 'package:cloud_firestore/cloud_firestore.dart';

class DetegasaSewageTreatmentPlantEntity {
  final String productId;
  final String productUsage;
  final String productModel;
  final String productCrew;
  final String productCapacity;
  final String kilogramsOfBiochemicalOxygen;
  final List<String> favorites;
  final int quantity;
  final String image;

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const DetegasaSewageTreatmentPlantEntity({
    required this.productId,
    required this.productUsage,
    required this.productModel,
    required this.productCrew,
    required this.productCapacity,
    required this.kilogramsOfBiochemicalOxygen,
    required this.favorites,
    required this.quantity,
    required this.image,
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  DetegasaSewageTreatmentPlantEntity copyWith({
    String? productId,
    String? productUsage,
    String? productModel,
    String? productCrew,
    String? productCapacity,
    String? kilogramsOfBiochemicalOxygen,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return DetegasaSewageTreatmentPlantEntity(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productModel: productModel ?? this.productModel,
      productCrew: productCrew ?? this.productCrew,
      productCapacity: productCapacity ?? this.productCapacity,
      kilogramsOfBiochemicalOxygen:
          kilogramsOfBiochemicalOxygen ?? this.kilogramsOfBiochemicalOxygen,
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
