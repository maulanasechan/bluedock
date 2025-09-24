import 'package:bluedock/common/widgets/button/bloc/button_responsive_state.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonResponsiveCubit extends Cubit<ButtonResponsiveState> {
  ButtonResponsiveCubit() : super(ButtonResponsiveInitial());

  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonResponsiveLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold(
        (error) {
          emit(ButtonResponsiveFailure(errorMessage: error));
        },
        (data) {
          emit(ButtonResponsiveSuccess());
        },
      );
    } catch (e) {
      emit(ButtonResponsiveFailure(errorMessage: e.toString()));
    }
  }
}
