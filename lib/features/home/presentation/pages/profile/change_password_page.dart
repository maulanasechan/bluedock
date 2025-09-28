import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
import 'package:bluedock/common/widgets/textfield/widgets/password_textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/home/data/models/change_password_req.dart';
import 'package:bluedock/features/home/domain/usecases/change_password_usecase.dart';
import 'package:bluedock/features/home/presentation/bloc/change_password_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(create: (context) => ChangePasswordFormCubit()),
        BlocProvider(create: (context) => PasswordTextfieldCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Change Password',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final router = GoRouter.of(context);

              Future.delayed(const Duration(seconds: 1), () {
                router.goNamed(AppRoutes.home);
              });
            }
          },
          child: BlocBuilder<ChangePasswordFormCubit, ChangePasswordReq>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    PasswordTextfieldWidget(
                      title: 'Old Password',
                      onChanged: (v) => context
                          .read<ChangePasswordFormCubit>()
                          .setOldPassword(v),
                    ),
                    SizedBox(height: 24),
                    PasswordTextfieldWidget(
                      title: 'New Password',
                      onChanged: (v) => context
                          .read<ChangePasswordFormCubit>()
                          .setNewPassword(v),
                    ),
                    SizedBox(height: 50),
                    ActionButtonWidget(
                      onPressed: () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) return;

                        context.read<ActionButtonCubit>().execute(
                          usecase: ChangePasswordUsecase(),
                          params: context.read<ChangePasswordFormCubit>().state,
                        );
                      },
                      title: 'Change Password',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
