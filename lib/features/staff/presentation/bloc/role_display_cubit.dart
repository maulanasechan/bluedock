import 'package:bluedock/features/staff/domain/usecases/get_roles_usecase.dart';
import 'package:bluedock/features/staff/presentation/bloc/role_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleDisplayCubit extends Cubit<RoleDisplayState> {
  RoleDisplayCubit() : super(RoleDisplayLoading());

  void displayRoles() async {
    var returnedData = await sl<GetRolesUseCase>().call();

    returnedData.fold(
      (error) {
        emit(RoleDisplayFailure(message: error));
      },
      (data) {
        emit(RoleDisplayFetched(listRoles: data));
      },
    );
  }
}
