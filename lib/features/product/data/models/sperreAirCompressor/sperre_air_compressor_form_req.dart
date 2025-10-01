import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';

class SperreAirCompressorReq {
  final String productId;
  final String productUsage;
  final String productType;
  final String coolingSystem;
  final String productTypeCode;
  final String chargingCapacity50Hz1500rpm;
  final String maxDeliveryPressure;
  final List<String> favorites;
  final int quantity;
  final String image;

  const SperreAirCompressorReq({
    this.productId = '',
    this.productUsage = '',
    this.productType = '',
    this.coolingSystem = '',
    this.productTypeCode = '',
    this.chargingCapacity50Hz1500rpm = '',
    this.maxDeliveryPressure = '',
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = '',
  });

  SperreAirCompressorReq copyWith({
    String? productId,
    String? productUsage,
    String? productType,
    String? coolingSystem,
    String? productTypeCode,
    String? chargingCapacity50Hz1500rpm,
    String? maxDeliveryPressure,
    List<String>? favorites,
    int? quantity,
    String? image,
  }) {
    return SperreAirCompressorReq(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productType: productType ?? this.productType,
      coolingSystem: coolingSystem ?? this.coolingSystem,
      productTypeCode: productTypeCode ?? this.productTypeCode,
      chargingCapacity50Hz1500rpm:
          chargingCapacity50Hz1500rpm ?? this.chargingCapacity50Hz1500rpm,
      maxDeliveryPressure: maxDeliveryPressure ?? this.maxDeliveryPressure,
      favorites: favorites ?? this.favorites,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}

extension SperreAirCompressorXReq on SperreAirCompressorReq {
  SperreAirCompressorEntity toEntity() {
    return SperreAirCompressorEntity(
      productId: productId,
      productUsage: productUsage,
      productType: productType,
      coolingSystem: coolingSystem,
      productTypeCode: productTypeCode,
      chargingCapacity50Hz1500rpm: chargingCapacity50Hz1500rpm,
      maxDeliveryPressure: maxDeliveryPressure,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
