import 'package:bluedock/common/widgets/text/text_widget.dart';
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
  final bool toogle;

  const PasswordTextfieldWidget({
    super.key,
    this.onChanged,
    this.initialValue,
    this.title,
    this.controller,
    this.toogle = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordTextfieldCubit, PasswordFormReq>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: title!,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  if (toogle)
                    SizedBox(
                      height: 40,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: state.open,
                          onChanged: (_) => context
                              .read<PasswordTextfieldCubit>()
                              .toggleOpen(),
                        ),
                      ),
                    ),
                ],
              ),
            if (title != null) SizedBox(height: 12),
            toogle
                ? state.open
                      ? _textField(context, state.obscure)
                      : SizedBox()
                : _textField(context, state.obscure),
          ],
        );
      },
    );
  }

  Widget _textField(BuildContext context, bool state) {
    return TextfieldWidget(
      initialValue: initialValue,
      onChanged: onChanged,
      validator: AppValidators.password(),
      controller: controller,
      obscure: state,
      hintText: 'Password',
      suffixIcon: state ? PhosphorIconsFill.eyeSlash : PhosphorIconsFill.eye,
      suffixOnTap: () {
        context.read<PasswordTextfieldCubit>().toggleObscure();
      },
    );
  }
}
