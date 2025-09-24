import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordTextfieldCubit extends Cubit<bool> {
  PasswordTextfieldCubit() : super(true);

  void toggle() => emit(!state);
}
