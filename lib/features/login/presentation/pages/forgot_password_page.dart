import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return GradientScaffoldWidget(
      hideBack: false,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextWidget(
              text: 'Forgot Password',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 30),
            TextfieldWidget(
              validator: AppValidators.email(),
              hintText: 'Email',
              suffixIcon: PhosphorIconsFill.envelopeSimple,
            ),
            SizedBox(height: 42),
            ButtonWidget(
              onPressed: () {
                // final isValid = formKey.currentState?.validate() ?? false;
                // if (!isValid) return;
                context.goNamed(AppRoutes.sendEmail);
              },
              title: 'Send to Email',
            ),
          ],
        ),
      ),
    );
  }
}
