import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SperreScrewCompressorFormCubit extends Cubit<SperreScrewCompressorReq> {
  SperreScrewCompressorFormCubit() : super(const SperreScrewCompressorReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setProductUsage(String v) => emit(state.copyWith(productUsage: v));
  void setProductType(String v) => emit(state.copyWith(productType: v));
  void setCoolingSystem(String v) => emit(state.copyWith(coolingSystem: v));
  void setProductTypeCode(String v) => emit(state.copyWith(productTypeCode: v));
  void setChargingCapacity8Bar(String v) =>
      emit(state.copyWith(chargingCapacity8Bar: v));
  void setChargingCapacity10Bar(String v) =>
      emit(state.copyWith(chargingCapacity10Bar: v));
  void setChargingCapacity12_5Bar(String v) =>
      emit(state.copyWith(chargingCapacity12_5Bar: v));
  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(SperreScrewCompressorEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        productUsage: e.productUsage,
        productType: e.productType,
        coolingSystem: e.coolingSystem,
        productTypeCode: e.productTypeCode,
        chargingCapacity8Bar: e.chargingCapacity8Bar,
        chargingCapacity10Bar: e.chargingCapacity10Bar,
        chargingCapacity12_5Bar: e.chargingCapacity12_5Bar,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const SperreScrewCompressorReq());
}
