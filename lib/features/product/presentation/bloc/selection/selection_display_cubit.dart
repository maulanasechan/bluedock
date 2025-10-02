import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:bluedock/features/product/domain/usecases/product/get_selection_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/selection/selection_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionDisplayCubit extends Cubit<SelectionDisplayState> {
  SelectionDisplayCubit() : super(SelectionDisplayLoading());

  void displaySelection(SelectionReq params) async {
    emit(SelectionDisplayLoading());
    var returnedData = await sl<GetSelectionUseCase>().call(params: params);

    returnedData.fold(
      (error) {
        emit(SelectionDisplayFailure(message: error));
      },
      (data) {
        emit(SelectionDisplayFetched(listSelection: data));
      },
    );
  }
}
