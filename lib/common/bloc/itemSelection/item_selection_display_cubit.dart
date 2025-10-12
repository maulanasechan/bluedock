import 'package:bluedock/common/data/models/itemSelection/item_selection_req.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_state.dart';
import 'package:bluedock/common/domain/usecases/get_item_selection_usecase.dart';
import 'package:bluedock/common/domain/usecases/get_type_category_selection_usecase.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemSelectionDisplayCubit extends Cubit<ItemSelectionDisplayState> {
  ItemSelectionDisplayCubit() : super(ItemSelectionDisplayLoading());

  void displaySelection(ItemSelectionReq params) async {
    emit(ItemSelectionDisplayLoading());
    var returnedData = await sl<GetItemSelectionUseCase>().call(params: params);

    returnedData.fold(
      (error) {
        emit(ItemSelectionDisplayFailure(message: error));
      },
      (data) {
        emit(ItemSelectionDisplayFetched(listSelection: data));
      },
    );
  }

  void displayTypeCategorySelection(ItemSelectionReq params) async {
    emit(ItemSelectionDisplayLoading());
    var returnedData = await sl<GetTypeCategorySelectionUseCase>().call(
      params: params,
    );

    returnedData.fold(
      (error) {
        emit(ItemSelectionDisplayFailure(message: error));
      },
      (data) {
        emit(TypeCategorySelectionDisplayFetched(listSelection: data));
      },
    );
  }
}
