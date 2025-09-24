import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/password_textfield_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PasswordTextfieldCubit())],
      child: GradientScaffoldWidget(
        hideBack: true,
        body: Center(
          child: Form(
            key: formKey,
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
                  hintText: 'Email',
                  suffixIcon: PhosphorIconsFill.envelopeSimple,
                ),
                SizedBox(height: 20),
                PasswordTextfieldWidget(),
                SizedBox(height: 42),
                ButtonWidget(
                  onPressed: () {
                    // final isValid = formKey.currentState?.validate() ?? false;
                    // if (!isValid) return;
                    context.goNamed(AppRoutes.home);
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
          ),
        ),
      ),
    );
  }
}
