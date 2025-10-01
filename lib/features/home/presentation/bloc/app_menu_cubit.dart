import 'package:bluedock/features/home/domain/usecases/get_app_menu_usecase.dart';
import 'package:bluedock/features/home/presentation/bloc/app_menu_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppMenuCubit extends Cubit<AppMenuState> {
  AppMenuCubit() : super(AppMenuLoading());

  void displayAppMenu() async {
    var returnedData = await sl<GetAppMenuUseCase>().call();
    returnedData.fold(
      (error) {
        emit(AppMenuFailure());
      },
      (data) {
        emit(AppMenuFetched(appMenu: data));
      },
    );
  }
}
