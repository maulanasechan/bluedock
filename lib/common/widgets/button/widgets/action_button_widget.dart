import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Widget? content;
  final double? height;
  final double? width;
  final Color? background;
  final Widget? prefix;
  final Widget? suffix;
  final FontWeight fontWeight;
  final double fontSize;
  final String successText;

  const ActionButtonWidget({
    required this.onPressed,
    this.title = '',
    this.height = 50,
    this.width,
    this.content,
    this.background = AppColors.blue,
    this.prefix,
    this.suffix,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.successText = 'Successfull',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionButtonCubit, ActionButtonState>(
      builder: (context, state) {
        if (state is ActionButtonLoading) {
          return _loadingWidget();
        }

        if (state is ActionButtonSuccess) {
          return _successWidget();
        }

        return ButtonWidget(
          onPressed: onPressed,
          title: title,
          height: height,
          width: width,
          content: content,
          background: background,
          prefix: prefix,
          suffix: suffix,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );
      },
    );
  }

  Widget _loadingWidget() {
    return ButtonWidget(
      background: AppColors.grey,
      onPressed: () {},
      content: Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _successWidget() {
    return ButtonWidget(
      onPressed: () {},
      background: Colors.green,
      title: successText,
    );
  }
}
