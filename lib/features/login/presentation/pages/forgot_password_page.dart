import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/login/domain/usecases/send_password_reset_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      hideBack: false,
      body: BlocProvider(
        create: (context) => ActionButtonCubit(),
        child: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              context.goNamed(AppRoutes.sendEmail);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextWidget(
                  text: 'Forgot Password',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 30),
                TextfieldWidget(
                  controller: _emailCon,
                  validator: AppValidators.email(),
                  hintText: 'Email',
                  suffixIcon: PhosphorIconsFill.envelopeSimple,
                ),
                SizedBox(height: 42),
                Builder(
                  builder: (context) {
                    return ActionButtonWidget(
                      onPressed: () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) return;

                        context.read<ActionButtonCubit>().execute(
                          usecase: SendPasswordResetUsecase(),
                          params: _emailCon.text,
                        );
                      },
                      title: 'Send to Email',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
