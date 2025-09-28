import 'package:bluedock/features/home/domain/usecases/get_user_usecase.dart';
import 'package:bluedock/features/home/presentation/bloc/user_info_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoLoading());

  void displayUserInfo() async {
    var returnedData = await sl<GetUserUseCase>().call();
    returnedData.fold(
      (error) {
        emit(UserInfoFailure());
      },
      (data) {
        emit(UserInfoFetched(user: data));
      },
    );
  }
}
