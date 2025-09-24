import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
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
    return BlocBuilder<PasswordTextfieldCubit, bool>(
      builder: (context, obscure) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              TextWidget(
                text: title!,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            if (title != null) SizedBox(height: 12),
            TextfieldWidget(
              initialValue: initialValue,
              onChanged: onChanged,
              validator: AppValidators.password(),
              controller: controller,
              obscure: obscure,
              hintText: 'Password',
              suffixIcon: obscure
                  ? PhosphorIconsFill.eyeSlash
                  : PhosphorIconsFill.eye,
              suffixOnTap: () {
                context.read<PasswordTextfieldCubit>().toggle();
              },
            ),
          ],
        );
      },
    );
  }
}
