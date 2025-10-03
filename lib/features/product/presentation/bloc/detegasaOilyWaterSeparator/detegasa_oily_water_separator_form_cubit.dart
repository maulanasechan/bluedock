import 'package:bluedock/features/product/data/models/detegasaOilyWaterSeparator/detegasa_oily_water_separator_form_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetegasaOilyWaterSeparatorFormCubit
    extends Cubit<DetegasaOilyWaterSeparatorReq> {
  DetegasaOilyWaterSeparatorFormCubit()
    : super(const DetegasaOilyWaterSeparatorReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setProductModel(String v) => emit(state.copyWith(productModel: v));
  void setProductCapacity(String v) => emit(state.copyWith(productCapacity: v));
  void setProductHeight(String v) => emit(state.copyWith(productHeight: v));
  void setProductLength(String v) => emit(state.copyWith(productLength: v));
  void setProductWidth(String v) => emit(state.copyWith(productWidth: v));

  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(DetegasaOilyWaterSeparatorEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        productModel: e.productModel,
        productCapacity: e.productCapacity,
        productHeight: e.productHeight,
        productLength: e.productLength,
        productWidth: e.productWidth,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const DetegasaOilyWaterSeparatorReq());
}
