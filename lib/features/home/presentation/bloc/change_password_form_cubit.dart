import 'package:bluedock/features/home/data/models/change_password_req.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordFormCubit extends Cubit<ChangePasswordReq> {
  ChangePasswordFormCubit() : super(const ChangePasswordReq());
  void setOldPassword(String v) => emit(state.copyWith(oldPassword: v));
  void setNewPassword(String v) => emit(state.copyWith(newPassword: v));
}
