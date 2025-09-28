import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordTextfieldCubit extends Cubit<PasswordFormReq> {
  PasswordTextfieldCubit() : super(const PasswordFormReq());

  void toggleObscure() => emit(state.copyWith(obscure: !state.obscure));
  void toggleOpen() => emit(state.copyWith(open: !state.open));
}
