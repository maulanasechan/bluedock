import 'package:bluedock/features/login/data/models/login_form_req.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormCubit extends Cubit<LoginFormReq> {
  LoginFormCubit() : super(const LoginFormReq());
  void setEmail(String v) => emit(state.copyWith(email: v));
  void setPassword(String v) => emit(state.copyWith(password: v));
}
