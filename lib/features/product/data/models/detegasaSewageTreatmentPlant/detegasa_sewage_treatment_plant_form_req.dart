import 'package:bluedock/features/product/domain/entities/detegasa_sewage_treatment_plant_entity.dart';

class DetegasaSewageTreatmentPlantReq {
  final String productId;
  final String productUsage;
  final String productModel;
  final String productCrew;
  final String productCapacity;
  final String kilogramsOfBiochemicalOxygen;
  final List<String> favorites;
  final int quantity;
  final String image;

  const DetegasaSewageTreatmentPlantReq({
    this.productId = '',
    this.productUsage = '',
    this.productModel = '',
    this.productCrew = '',
    this.productCapacity = '',
    this.kilogramsOfBiochemicalOxygen = '',
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = 'assets/images/DetegasaSewageTreatmentPlant.png',
  });

  DetegasaSewageTreatmentPlantReq copyWith({
    String? productId,
    String? productUsage,
    String? productModel,
    String? productCrew,
    String? productCapacity,
    String? kilogramsOfBiochemicalOxygen,
    List<String>? favorites,
    int? quantity,
    String? image,
  }) {
    return DetegasaSewageTreatmentPlantReq(
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
    );
  }
}

extension DetegasaSewageTreatmentPlantXReq on DetegasaSewageTreatmentPlantReq {
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
