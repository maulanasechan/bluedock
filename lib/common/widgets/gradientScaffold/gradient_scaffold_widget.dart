import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class GradientScaffoldWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final LinearGradient gradientColor;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool hideBack;
  final String? appbarTitle;
  final Widget? appbarAction;
  final bool loading;
  final double fontSizeTitle;
  final EdgeInsets? padding;

  const GradientScaffoldWidget({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.gradientColor = AppColors.scaffoldBackground,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.hideBack = true,
    this.appbarTitle,
    this.fontSizeTitle = 18,
    this.appbarAction,
    this.loading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: gradientColor)),
          if (body != null)
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: loading
                  ? _loadingWidget()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hideBack)
                          Padding(
                            padding:
                                padding ?? EdgeInsets.fromLTRB(0, 90, 0, 40),
                            child: SizedBox(
                              height: 40,
                              child: Stack(
                                children: [
                                  IconButtonWidget(
                                    onPressed: () {
                                      context.pop(true);
                                    },
                                  ),
                                  if (appbarTitle != null)
                                    Align(
                                      alignment: Alignment.center,
                                      child: TextWidget(
                                        text: appbarTitle!,
                                        fontWeight: FontWeight.w700,
                                        fontSize: fontSizeTitle,
                                      ),
                                    ),
                                  if (appbarAction != null)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: appbarAction!,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        Expanded(child: body!),
                      ],
                    ),
            ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return Shimmer.fromColors(
      baseColor: AppColors.baseLoading,
      highlightColor: AppColors.highlightLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hideBack)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 90, 0, 40),
              child: SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    IconButtonWidget(),
                    if (appbarTitle != null)
                      Align(
                        alignment: Alignment.center,
                        child: TextWidget(
                          text: appbarTitle!,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    if (appbarAction != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: appbarAction!,
                      ),
                  ],
                ),
              ),
            ),
          Expanded(child: body!),
        ],
      ),
    );
  }
}
