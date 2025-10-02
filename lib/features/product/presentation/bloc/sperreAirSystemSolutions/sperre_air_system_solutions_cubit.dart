import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/search_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirSystemSolutions/sperre_air_system_solutions_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SperreAirSystemSolutionsCubit
    extends Cubit<SperreAirSystemSolutionsState> {
  SperreAirSystemSolutionsCubit() : super(SperreAirSystemSolutionsInitial());
  int _reqId = 0;

  void displaySperreAirSystemSolutions({String? params}) async {
    final myReq = ++_reqId;
    emit(SperreAirSystemSolutionsLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchSperreAirSystemSolutionsUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(SperreAirSystemSolutionsFailure());
      },
      (data) {
        emit(SperreAirSystemSolutionsFetched(sperreAirSystemSolutions: data));
      },
    );
  }

  void displayInitial() {
    displaySperreAirSystemSolutions(params: '');
  }
}
