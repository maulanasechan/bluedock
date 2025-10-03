import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/detegasa_sewage_treatment_plant_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetegasaSewageTreatmentPlantModel {
  // Core fields
  final String productId;
  final String productUsage;
  final String productModel;
  final String productCrew;
  final String productCapacity;
  final String kilogramsOfBiochemicalOxygen;
  final List<String> favorites;
  final int quantity;
  final String image;

  // Meta & search (disamakan pola dengan StaffModel)
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  DetegasaSewageTreatmentPlantModel({
    required this.productId,
    required this.productUsage,
    required this.productModel,
    required this.productCrew,
    required this.productCapacity,
    required this.kilogramsOfBiochemicalOxygen,
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
      'productModel': productModel,
      'productCrew': productCrew,
      'productCapacity': productCapacity,
      'kilogramsOfBiochemicalOxygen': kilogramsOfBiochemicalOxygen,
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

  factory DetegasaSewageTreatmentPlantModel.fromMap(Map<String, dynamic> map) {
    return DetegasaSewageTreatmentPlantModel(
      productId: map['productId'] ?? '',
      productUsage: map['productUsage'] ?? '',
      productModel: map['productModel'] ?? '',
      productCrew: map['productCrew'] ?? '',
      productCapacity: map['productCapacity'] ?? '',
      kilogramsOfBiochemicalOxygen: map['kilogramsOfBiochemicalOxygen'] ?? '',
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

  factory DetegasaSewageTreatmentPlantModel.fromJson(String source) =>
      DetegasaSewageTreatmentPlantModel.fromMap(json.decode(source));
}

extension DetegasaSewageTreatmentPlantXModel
    on DetegasaSewageTreatmentPlantModel {
  DetegasaSewageTreatmentPlantEntity toEntity() {
    return DetegasaSewageTreatmentPlantEntity(
      productId: productId,
      productUsage: productUsage,
      productModel: productModel,
      productCrew: productCrew,
      productCapacity: productCapacity,
      kilogramsOfBiochemicalOxygen: kilogramsOfBiochemicalOxygen,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
