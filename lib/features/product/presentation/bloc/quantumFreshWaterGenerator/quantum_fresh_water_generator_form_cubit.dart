import 'package:bluedock/features/product/data/models/quantumFreshWaterGenerator/quantum_fresh_water_generator_form_req.dart';
import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuantumFreshWaterGeneratorFormCubit
    extends Cubit<QuantumFreshWaterGeneratorReq> {
  QuantumFreshWaterGeneratorFormCubit()
    : super(const QuantumFreshWaterGeneratorReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setWaterSolutionType(String v) =>
      emit(state.copyWith(waterSolutionType: v));
  void setMinProductionCapacity(String v) =>
      emit(state.copyWith(minProductionCapacity: v));
  void setMaxProductionCapacity(String v) =>
      emit(state.copyWith(maxProductionCapacity: v));
  void setTailorMadeDesign(bool v) => emit(state.copyWith(tailorMadeDesign: v));
  void setTypeDescription(String v) => emit(state.copyWith(typeDescription: v));
  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(QuantumFreshWaterGeneratorEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        waterSolutionType: e.waterSolutionType,
        minProductionCapacity: e.minProductionCapacity,
        maxProductionCapacity: e.maxProductionCapacity,
        tailorMadeDesign: e.tailorMadeDesign,
        typeDescription: e.typeDescription,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const QuantumFreshWaterGeneratorReq());
}
