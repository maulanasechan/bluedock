import 'dart:convert';
import 'package:bluedock/features/product/domain/entities/detegasa_incenerator_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetegasaInceneratorModel {
  final String productId;
  final String productUsage;
  final String productModel;
  final String heatGenerate;
  final String powerRating;
  final String imoSludge;
  final String solidWaste;
  final String maxBurnerConsumption;
  final String maxElectricPower;
  final String approxInceneratorWeight;
  final String fanWeight;
  final List<String> favorites;
  final int quantity;
  final String image;

  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> searchKeywords;

  DetegasaInceneratorModel({
    required this.productId,
    required this.productUsage,
    required this.productModel,
    required this.heatGenerate,
    required this.powerRating,
    required this.imoSludge,
    required this.solidWaste,
    required this.maxBurnerConsumption,
    required this.maxElectricPower,
    required this.approxInceneratorWeight,
    required this.fanWeight,
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
      'heatGenerate': heatGenerate,
      'powerRating': powerRating,
      'imoSludge': imoSludge,
      'solidWaste': solidWaste,
      'maxBurnerConsumption': maxBurnerConsumption,
      'maxElectricPower': maxElectricPower,
      'approxInceneratorWeight': approxInceneratorWeight,
      'fanWeight': fanWeight,
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

  factory DetegasaInceneratorModel.fromMap(Map<String, dynamic> map) {
    return DetegasaInceneratorModel(
      productId: map['productId'] ?? '',
      productUsage: map['productUsage'] ?? '',
      productModel: map['productModel'] ?? '',
      heatGenerate: map['heatGenerate'] ?? '',
      powerRating: map['powerRating'] ?? '',
      imoSludge: map['imoSludge'] ?? '',
      solidWaste: map['solidWaste'] ?? '',
      maxBurnerConsumption: map['maxBurnerConsumption'] ?? '',
      maxElectricPower: map['maxElectricPower'] ?? '',
      approxInceneratorWeight: map['approxInceneratorWeight'] ?? '',
      fanWeight: map['fanWeight'] ?? '',
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

  factory DetegasaInceneratorModel.fromJson(String source) =>
      DetegasaInceneratorModel.fromMap(json.decode(source));
}

extension DetegasaInceneratorXModel on DetegasaInceneratorModel {
  DetegasaInceneratorEntity toEntity() {
    return DetegasaInceneratorEntity(
      productId: productId,
      productUsage: productUsage,
      productModel: productModel,
      heatGenerate: heatGenerate,
      powerRating: powerRating,
      imoSludge: imoSludge,
      solidWaste: solidWaste,
      maxBurnerConsumption: maxBurnerConsumption,
      maxElectricPower: maxElectricPower,
      approxInceneratorWeight: approxInceneratorWeight,
      fanWeight: fanWeight,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
