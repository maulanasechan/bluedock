import 'package:bluedock/features/product/data/models/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_form_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_sewage_treatment_plant_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetegasaSewageTreatmentPlantFormCubit
    extends Cubit<DetegasaSewageTreatmentPlantReq> {
  DetegasaSewageTreatmentPlantFormCubit()
    : super(const DetegasaSewageTreatmentPlantReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setProductUsage(String v) => emit(state.copyWith(productUsage: v));
  void setProductModel(String v) => emit(state.copyWith(productModel: v));
  void setProductCrew(String v) => emit(state.copyWith(productCrew: v));
  void setProductCapacity(String v) => emit(state.copyWith(productCapacity: v));
  void setKilogramsOfBiochemicalOxygen(String v) =>
      emit(state.copyWith(kilogramsOfBiochemicalOxygen: v));
  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(DetegasaSewageTreatmentPlantEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        productUsage: e.productUsage,
        productModel: e.productModel,
        productCrew: e.productCrew,
        productCapacity: e.productCapacity,
        kilogramsOfBiochemicalOxygen: e.kilogramsOfBiochemicalOxygen,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const DetegasaSewageTreatmentPlantReq());
}
