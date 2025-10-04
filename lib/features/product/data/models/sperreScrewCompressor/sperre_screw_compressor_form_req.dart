import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';

class SperreScrewCompressorReq {
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

  const SperreScrewCompressorReq({
    this.productId = '',
    this.productUsage = '',
    this.productType = '',
    this.coolingSystem = '',
    this.productTypeCode = '',
    this.chargingCapacity8Bar = '',
    this.chargingCapacity10Bar = '',
    this.chargingCapacity12_5Bar = '',
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = 'assets/images/SperreScrewCompressor.png',
  });

  SperreScrewCompressorReq copyWith({
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
  }) {
    return SperreScrewCompressorReq(
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
    );
  }
}

extension SperreScrewCompressorXReq on SperreScrewCompressorReq {
  SperreScrewCompressorEntity toEntity() {
    return SperreScrewCompressorEntity(
      productId: productId,
      productUsage: productUsage,
      productType: productType,
      coolingSystem: coolingSystem,
      productTypeCode: productTypeCode,
      chargingCapacity8Bar: chargingCapacity8Bar,
      chargingCapacity10Bar: chargingCapacity10Bar,
      chargingCapacity12_5Bar: chargingCapacity12_5Bar,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
