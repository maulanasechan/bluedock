import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CenterModalWidget {
  static Future<bool?> display({
    required BuildContext context,
    required String title,
    required String subtitle,
    String? yesButton,
    required VoidCallback yesButtonOnTap,
    ActionButtonCubit? actionCubit,
    Color? yesButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        Widget child = Builder(
          builder: (ctx) {
            final state = ctx.watch<ActionButtonCubit>().state;
            final isLoading = state is ActionButtonLoading;

            return PopScope(
              canPop: !isLoading,
              child: AlertDialog(
                title: TextWidget(
                  text: title,
                  align: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                content: TextWidget(
                  text: subtitle,
                  align: TextAlign.center,
                  fontSize: 16,
                  overflow: TextOverflow.fade,
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 140),
                        child: ButtonWidget(
                          height: 45,
                          onPressed: isLoading
                              ? () {}
                              : () => context.pop(false),
                          title: 'Close',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 140),
                        child: ActionButtonWidget(
                          onPressed: isLoading ? () {} : yesButtonOnTap,
                          height: 45,
                          title: yesButton ?? 'Delete',
                          fontSize: 16,
                          background: yesButtonColor ?? AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

        if (actionCubit != null) {
          actionCubit.reset();
          return BlocProvider.value(value: actionCubit, child: child);
        } else {
          return BlocProvider(create: (_) => ActionButtonCubit(), child: child);
        }
      },
    );
  }
}
