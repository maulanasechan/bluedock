import 'package:cloud_firestore/cloud_firestore.dart';

class QuantumFreshWaterGeneratorEntity {
  final String productId;
  final String waterSolutionType;
  final String typeDescription;
  final String minProductionCapacity;
  final String maxProductionCapacity;
  final bool tailorMadeDesign;
  final List<String> favorites;
  final int quantity;
  final String image;

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const QuantumFreshWaterGeneratorEntity({
    required this.productId,
    required this.waterSolutionType,
    required this.typeDescription,
    required this.minProductionCapacity,
    required this.maxProductionCapacity,
    required this.tailorMadeDesign,
    required this.favorites,
    required this.quantity,
    required this.image,
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  QuantumFreshWaterGeneratorEntity copyWith({
    String? productId,
    String? waterSolutionType,
    String? typeDescription,
    String? minProductionCapacity,
    String? maxProductionCapacity,
    bool? tailorMadeDesign,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return QuantumFreshWaterGeneratorEntity(
      productId: productId ?? this.productId,
      waterSolutionType: waterSolutionType ?? this.waterSolutionType,
      typeDescription: typeDescription ?? this.typeDescription,
      minProductionCapacity:
          minProductionCapacity ?? this.minProductionCapacity,
      maxProductionCapacity:
          maxProductionCapacity ?? this.maxProductionCapacity,
      tailorMadeDesign: tailorMadeDesign ?? this.tailorMadeDesign,
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
