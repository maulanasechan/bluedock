import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/splash/bloc/splash_cubit.dart';
import 'package:bluedock/features/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.goNamed(AppRoutes.login);
        }
        if (state is Authenticated) {
          // context.goNamed(AppRoutes.home);
        }
      },
      child: GradientScaffoldWidget(
        body: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
            child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
