import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';

class SperreAirCompressorFormCubit extends Cubit<SperreAirCompressorReq> {
  SperreAirCompressorFormCubit() : super(const SperreAirCompressorReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setProductUsage(String v) => emit(state.copyWith(productUsage: v));
  void setProductType(String v) => emit(state.copyWith(productType: v));
  void setCoolingSystem(String v) => emit(state.copyWith(coolingSystem: v));
  void setProductTypeCode(String v) => emit(state.copyWith(productTypeCode: v));
  void setChargingCapacity50Hz1500rpm(String v) =>
      emit(state.copyWith(chargingCapacity50Hz1500rpm: v));
  void setMaxDeliveryPressure(String v) =>
      emit(state.copyWith(maxDeliveryPressure: v));
  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(SperreAirCompressorEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        productUsage: e.productUsage,
        productType: e.productType,
        coolingSystem: e.coolingSystem,
        productTypeCode: e.productTypeCode,
        chargingCapacity50Hz1500rpm: e.chargingCapacity50Hz1500rpm,
        maxDeliveryPressure: e.maxDeliveryPressure,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const SperreAirCompressorReq());
}
