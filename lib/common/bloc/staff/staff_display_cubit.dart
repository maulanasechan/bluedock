import 'package:bluedock/common/domain/usecases/get_user_usecase.dart';
import 'package:bluedock/common/domain/usecases/search_staff_by_name_usecase.dart';
import 'package:bluedock/common/bloc/staff/staff_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffDisplayCubit extends Cubit<StaffDisplayState> {
  StaffDisplayCubit() : super(StaffDisplayInitial());

  int _reqId = 0;

  void displayStaff({String? params}) async {
    final myReq = ++_reqId;
    emit(StaffDisplayLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchStaffByNameUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(StaffDisplayFailure(message: error));
      },
      (data) {
        emit(StaffDisplayFetched(listStaff: data));
      },
    );
  }

  void displayInitial() {
    displayStaff(params: '');
  }

  void displayUserInfo() async {
    var returnedData = await sl<GetUserUseCase>().call();
    returnedData.fold(
      (error) {
        emit(StaffDisplayFailure(message: error));
      },
      (data) {
        emit(UserInfoFetched(user: data));
      },
    );
  }
}
