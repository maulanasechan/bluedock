import 'package:bluedock/common/data/models/product/product_selection_req.dart';
import 'package:bluedock/common/domain/usecases/get_product_categories_usecase.dart';
import 'package:bluedock/common/bloc/productSection/product_section_state.dart';
import 'package:bluedock/common/domain/usecases/get_product_selection_usecase.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSectionCubit extends Cubit<ProductSectionState> {
  ProductSectionCubit() : super(ProductSectionLoading());
  int _reqId = 0;

  void displayProductCategories() async {
    final myReq = ++_reqId;
    emit(ProductSectionLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<GetProductCategoriesUseCase>().call();
    returnedData.fold(
      (error) {
        emit(ProductSectionFailure(message: error.toString()));
      },
      (data) {
        emit(ProductCategoryFetched(productCategory: data));
      },
    );
  }

  void displayProductSelection(ProductSelectionReq req) async {
    final myReq = ++_reqId;
    emit(ProductSectionLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<GetProductSelectionUseCase>().call(params: req);
    returnedData.fold(
      (error) {
        emit(ProductSectionFailure(message: error.toString()));
      },
      (data) {
        emit(ProductSelectionFetched(productSelection: data));
      },
    );
  }
}
