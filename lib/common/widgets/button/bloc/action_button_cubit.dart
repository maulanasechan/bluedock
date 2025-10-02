import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ActionButtonCubit extends Cubit<ActionButtonState> {
  ActionButtonCubit() : super(ActionButtonInitial());

  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(ActionButtonLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold(
        (error) {
          emit(ActionButtonFailure(errorMessage: error));
        },
        (data) {
          emit(ActionButtonSuccess());
        },
      );
    } catch (e) {
      emit(ActionButtonFailure(errorMessage: e.toString()));
    }
  }

  void reset() => emit(ActionButtonInitial());
}
