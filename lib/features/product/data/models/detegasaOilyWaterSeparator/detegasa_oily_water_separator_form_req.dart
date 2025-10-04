import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';

class DetegasaOilyWaterSeparatorReq {
  final String productId;
  final String productModel;
  final String productCapacity;
  final String productLength;
  final String productWidth;
  final String productHeight;
  final List<String> favorites;
  final int quantity;
  final String image;

  const DetegasaOilyWaterSeparatorReq({
    this.productId = '',
    this.productModel = '',
    this.productCapacity = '',
    this.productLength = '',
    this.productWidth = '',
    this.productHeight = '',
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = 'assets/images/DetegasaOilyWaterSeparator.png',
  });

  DetegasaOilyWaterSeparatorReq copyWith({
    String? productId,
    String? productModel,
    String? productCapacity,
    String? productLength,
    String? productWidth,
    String? productHeight,
    List<String>? favorites,
    int? quantity,
    String? image,
  }) {
    return DetegasaOilyWaterSeparatorReq(
      productId: productId ?? this.productId,
      productModel: productModel ?? this.productModel,
      productCapacity: productCapacity ?? this.productCapacity,
      productLength: productLength ?? this.productLength,
      productWidth: productWidth ?? this.productWidth,
      productHeight: productHeight ?? this.productHeight,
      favorites: favorites ?? this.favorites,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}

extension DetegasaOilyWaterSeparatorXReq on DetegasaOilyWaterSeparatorReq {
  DetegasaOilyWaterSeparatorEntity toEntity() {
    return DetegasaOilyWaterSeparatorEntity(
      productId: productId,
      productModel: productModel,
      productCapacity: productCapacity,
      productLength: productLength,
      productWidth: productWidth,
      productHeight: productHeight,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
