import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_state.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PasswordTextfieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? title;

  const PasswordTextfieldWidget({
    super.key,
    this.onChanged,
    this.initialValue,
    this.title,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordTextfieldCubit, PasswordFormReq>(
      builder: (context, state) {
        return TextfieldWidget(
          title: title,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: AppValidators.password(),
          controller: controller,
          obscure: state.obscure,
          hintText: 'Password',
          suffixIcon: state.obscure
              ? PhosphorIconsFill.eyeSlash
              : PhosphorIconsFill.eye,
          suffixOnTap: () {
            context.read<PasswordTextfieldCubit>().toggleObscure();
          },
        );
      },
    );
  }
}
