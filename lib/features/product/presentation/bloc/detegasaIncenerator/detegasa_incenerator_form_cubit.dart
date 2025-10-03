import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_form_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_incenerator_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetegasaInceneratorFormCubit extends Cubit<DetegasaInceneratorReq> {
  DetegasaInceneratorFormCubit() : super(const DetegasaInceneratorReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setProductUsage(String v) => emit(state.copyWith(productUsage: v));
  void setProductModel(String v) => emit(state.copyWith(productModel: v));
  void setHeatGenerate(String v) => emit(state.copyWith(heatGenerate: v));
  void setPowerRating(String v) => emit(state.copyWith(powerRating: v));
  void setImoSludge(String v) => emit(state.copyWith(imoSludge: v));
  void setSolidWaste(String v) => emit(state.copyWith(solidWaste: v));
  void setMaxBurnerConsumption(String v) =>
      emit(state.copyWith(maxBurnerConsumption: v));
  void setMaxElectricPower(String v) =>
      emit(state.copyWith(maxElectricPower: v));
  void setApproxInceneratorWeight(String v) =>
      emit(state.copyWith(approxInceneratorWeight: v));
  void setFanWeight(String v) => emit(state.copyWith(fanWeight: v));

  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(DetegasaInceneratorEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        productUsage: e.productUsage,
        productModel: e.productModel,
        heatGenerate: e.heatGenerate,
        powerRating: e.powerRating,
        imoSludge: e.imoSludge,
        solidWaste: e.solidWaste,
        maxBurnerConsumption: e.maxBurnerConsumption,
        maxElectricPower: e.maxElectricPower,
        approxInceneratorWeight: e.approxInceneratorWeight,
        fanWeight: e.fanWeight,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const DetegasaInceneratorReq());
}
