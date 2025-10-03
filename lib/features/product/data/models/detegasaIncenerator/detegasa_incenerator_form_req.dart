import 'package:bluedock/features/product/domain/entities/detegasa_incenerator_entity.dart';

class DetegasaInceneratorReq {
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

  const DetegasaInceneratorReq({
    this.productId = '',
    this.productUsage = '',
    this.productModel = '',
    this.heatGenerate = '',
    this.powerRating = '',
    this.imoSludge = '',
    this.solidWaste = '',
    this.maxBurnerConsumption = '',
    this.maxElectricPower = '',
    this.approxInceneratorWeight = '',
    this.fanWeight = '',
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = '',
  });

  DetegasaInceneratorReq copyWith({
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
  }) {
    return DetegasaInceneratorReq(
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
    );
  }
}

extension DetegasaInceneratorXReq on DetegasaInceneratorReq {
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
