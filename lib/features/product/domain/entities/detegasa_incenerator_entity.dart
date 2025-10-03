import 'package:cloud_firestore/cloud_firestore.dart';

class DetegasaInceneratorEntity {
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

  final List<String> searchKeywords;
  final Timestamp? createdAt;
  final String? createdBy;
  final Timestamp? updatedAt;
  final String? updatedBy;

  const DetegasaInceneratorEntity({
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
    this.searchKeywords = const <String>[],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  DetegasaInceneratorEntity copyWith({
    String? productId,
    String? productUsage,
    String? productModel,
    String? heatGenerate,
    String? powerRating,
    String? imoSludge,
    String? solidWaste,
    String? maxBurnerConsumption,
    String? maxElectricPower,
    String? approxInceneratorWeight,
    String? fanWeight,
    List<String>? favorites,
    int? quantity,
    String? image,
    List<String>? searchKeywords,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? updatedAt,
    String? updatedBy,
  }) {
    return DetegasaInceneratorEntity(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productModel: productModel ?? this.productModel,
      heatGenerate: heatGenerate ?? this.heatGenerate,
      powerRating: powerRating ?? this.powerRating,
      imoSludge: imoSludge ?? this.imoSludge,
      solidWaste: solidWaste ?? this.solidWaste,
      maxBurnerConsumption: maxBurnerConsumption ?? this.maxBurnerConsumption,
      maxElectricPower: maxElectricPower ?? this.maxElectricPower,
      approxInceneratorWeight:
          approxInceneratorWeight ?? this.approxInceneratorWeight,
      fanWeight: fanWeight ?? this.fanWeight,
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
