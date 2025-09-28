import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/password_textfield_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/login/data/models/login_form_req.dart';
import 'package:bluedock/features/login/domain/usecases/login_usecase.dart';
import 'package:bluedock/features/login/presentation/bloc/login_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PasswordTextfieldCubit()),
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(create: (context) => LoginFormCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: true,
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              GoRouter.of(context).goNamed(AppRoutes.home);
            }
          },
          child: Center(
            child: BlocBuilder<LoginFormCubit, LoginFormReq>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 230,
                        child: Image.asset(
                          AppImages.appHorizontalLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 42),
                      TextWidget(
                        text: 'Sign In to Continue',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 42),
                      TextfieldWidget(
                        validator: AppValidators.email(),
                        initialValue: state.email,
                        hintText: 'Email',
                        suffixIcon: PhosphorIconsFill.envelopeSimple,
                        onChanged: (v) =>
                            context.read<LoginFormCubit>().setEmail(v),
                      ),
                      SizedBox(height: 20),
                      PasswordTextfieldWidget(
                        initialValue: state.password,
                        onChanged: (v) =>
                            context.read<LoginFormCubit>().setPassword(v),
                      ),
                      SizedBox(height: 42),
                      ActionButtonWidget(
                        onPressed: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          context.read<ActionButtonCubit>().execute(
                            usecase: LoginUseCase(),
                            params: context.read<LoginFormCubit>().state,
                          );
                        },
                        title: 'Sign In',
                      ),
                      SizedBox(height: 32),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.forgotPassword);
                        },
                        child: TextWidget(
                          text: 'Forgot Password?',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
