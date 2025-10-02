import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuantumFreshWaterGeneratorModel {
  // Core fields
  final String productId;
  final String waterSolutionType;
  final String typeDescription;
  final String minProductionCapacity;
  final String maxProductionCapacity;
  final bool tailorMadeDesign;
  final List<String> favorites;
  final int quantity;
  final String image;

  // Meta & search (disamakan pola dengan StaffModel)
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  QuantumFreshWaterGeneratorModel({
    required this.productId,
    required this.waterSolutionType,
    required this.typeDescription,
    required this.minProductionCapacity,
    required this.maxProductionCapacity,
    required this.tailorMadeDesign,
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
      'waterSolutionType': waterSolutionType,
      'typeDescription': typeDescription,
      'minProductionCapacity': minProductionCapacity,
      'maxProductionCapacity': maxProductionCapacity,
      'tailorMadeDesign': tailorMadeDesign,
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

  factory QuantumFreshWaterGeneratorModel.fromMap(Map<String, dynamic> map) {
    return QuantumFreshWaterGeneratorModel(
      productId: map['productId'] ?? '',
      waterSolutionType: map['waterSolutionType'] ?? '',
      typeDescription: map['typeDescription'] ?? '',
      minProductionCapacity: map['minProductionCapacity'] ?? '',
      maxProductionCapacity: map['maxProductionCapacity'] ?? '',
      tailorMadeDesign: map['tailorMadeDesign'] ?? '',
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

  factory QuantumFreshWaterGeneratorModel.fromJson(String source) =>
      QuantumFreshWaterGeneratorModel.fromMap(json.decode(source));
}

extension QuantumFreshWaterGeneratorXModel on QuantumFreshWaterGeneratorModel {
  QuantumFreshWaterGeneratorEntity toEntity() {
    return QuantumFreshWaterGeneratorEntity(
      productId: productId,
      waterSolutionType: waterSolutionType,
      typeDescription: typeDescription,
      minProductionCapacity: minProductionCapacity,
      maxProductionCapacity: maxProductionCapacity,
      tailorMadeDesign: tailorMadeDesign,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
