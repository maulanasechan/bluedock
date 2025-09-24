import 'package:bluedock/features/splash/bloc/splash_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted() async {
    await Future.delayed(Duration(seconds: 2));
    // var isLoggedIn = await sl<IsLoggedInUseCase>().call();
    emit(Unauthenticated());

    // if (isLoggedIn) {
    //   emit(Authenticated());
    // } else {
    //   emit(Unauthenticated());
    // }
  }
}
