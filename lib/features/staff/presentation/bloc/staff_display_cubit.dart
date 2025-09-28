import 'package:bluedock/features/staff/domain/usecases/get_all_staff_usecase.dart';
import 'package:bluedock/features/staff/presentation/bloc/staff_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffDisplayCubit extends Cubit<StaffDisplayState> {
  StaffDisplayCubit() : super(StaffDisplayLoading());

  void displayStaff() async {
    var returnedData = await sl<GetAllStaffUseCase>().call();

    returnedData.fold(
      (error) {
        emit(StaffDisplayFailure(message: error));
      },
      (data) {
        emit(StaffDisplayFetched(listStaff: data));
      },
    );
  }
}
