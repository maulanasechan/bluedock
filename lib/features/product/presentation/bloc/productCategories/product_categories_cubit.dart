import 'package:bluedock/features/product/domain/usecases/productCategories/get_product_categories_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/productCategories/product_categories_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoriesCubit extends Cubit<ProductCategoriesState> {
  ProductCategoriesCubit() : super(ProductCategoriesLoading());
  int _reqId = 0;

  void displayProductCategories() async {
    final myReq = ++_reqId;
    emit(ProductCategoriesLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<GetProductCategoriesUseCase>().call();
    returnedData.fold(
      (error) {
        emit(ProductCategoriesFailure());
      },
      (data) {
        emit(ProductCategoriesFetched(productCategories: data));
      },
    );
  }
}
