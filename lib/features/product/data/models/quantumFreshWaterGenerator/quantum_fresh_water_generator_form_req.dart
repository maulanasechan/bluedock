import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';

class QuantumFreshWaterGeneratorReq {
  final String productId;
  final String waterSolutionType;
  final String typeDescription;
  final String minProductionCapacity;
  final String maxProductionCapacity;
  final bool tailorMadeDesign;
  final List<String> favorites;
  final int quantity;
  final String image;

  const QuantumFreshWaterGeneratorReq({
    this.productId = '',
    this.waterSolutionType = '',
    this.typeDescription = '',
    this.minProductionCapacity = '',
    this.maxProductionCapacity = '',
    this.tailorMadeDesign = false,
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = '',
  });

  QuantumFreshWaterGeneratorReq copyWith({
    String? productId,
    String? waterSolutionType,
    String? typeDescription,
    String? minProductionCapacity,
    String? maxProductionCapacity,
    bool? tailorMadeDesign,
    List<String>? favorites,
    int? quantity,
    String? image,
  }) {
    return QuantumFreshWaterGeneratorReq(
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
    );
  }
}

extension QuantumFreshWaterGeneratorXReq on QuantumFreshWaterGeneratorReq {
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
