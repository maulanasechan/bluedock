import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SperreAirSystemSolutionsFormCubit
    extends Cubit<SperreAirSystemSolutionsReq> {
  SperreAirSystemSolutionsFormCubit()
    : super(const SperreAirSystemSolutionsReq());

  // setters
  void setProductId(String v) => emit(state.copyWith(productId: v));
  void setProductUsage(String v) => emit(state.copyWith(productUsage: v));
  void setProductCategory(String v) => emit(state.copyWith(productCategory: v));
  void setProductName(String v) => emit(state.copyWith(productName: v));
  void setProductExplanation(String v) =>
      emit(state.copyWith(productExplanation: v));
  void setImage(String v) => emit(state.copyWith(image: v));

  // hydrate from entity
  void hydrateFromEntity(SperreAirSystemSolutionsEntity e) {
    emit(
      state.copyWith(
        productId: e.productId,
        productUsage: e.productUsage,
        productCategory: e.productCategory,
        productName: e.productName,
        productExplanation: e.productExplanation,
        favorites: e.favorites,
        quantity: e.quantity,
        image: e.image,
      ),
    );
  }

  void reset() => emit(const SperreAirSystemSolutionsReq());
}
