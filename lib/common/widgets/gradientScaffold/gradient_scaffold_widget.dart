import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
  final EdgeInsets? bodyPadding;
  final bool showBottomNavigation;
  final int currentIndex;

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
    this.bodyPadding,
    this.showBottomNavigation = false,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      AppRoutes.home,
      AppRoutes.dailyTask,
      AppRoutes.notification,
      AppRoutes.profile,
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      extendBody: true,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNavigation
          ? Container(
              padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.boxShadow,
                    spreadRadius: 0,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentIndex,
                  onTap: (i) => context.goNamed(tabs[i]),
                  backgroundColor: AppColors.white,
                  selectedItemColor: AppColors.blue,
                  unselectedItemColor: AppColors.darkBlue,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  iconSize: 26,
                  items: [
                    BottomNavigationBarItem(
                      icon: PhosphorIcon(PhosphorIconsBold.houseLine),
                      activeIcon: PhosphorIcon(PhosphorIconsFill.houseLine),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: PhosphorIcon(PhosphorIconsBold.calendarCheck),
                      activeIcon: PhosphorIcon(PhosphorIconsFill.calendarCheck),
                      label: 'Daily Task',
                    ),
                    BottomNavigationBarItem(
                      icon: PhosphorIcon(PhosphorIconsBold.bellRinging),
                      activeIcon: PhosphorIcon(PhosphorIconsFill.bellRinging),
                      label: 'Notification',
                    ),
                    BottomNavigationBarItem(
                      icon: PhosphorIcon(PhosphorIconsBold.userCircle),
                      activeIcon: PhosphorIcon(PhosphorIconsFill.userCircle),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(),
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: gradientColor)),
          if (body != null)
            Padding(
              padding: bodyPadding ?? EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: loading
                  ? _loadingWidget()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hideBack)
                          Padding(
                            padding:
                                padding ?? EdgeInsets.fromLTRB(0, 90, 0, 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: IconButtonWidget(
                                    onPressed: () {
                                      context.pop(true);
                                    },
                                  ),
                                ),
                                if (appbarTitle != null)
                                  SizedBox(
                                    width: 250,
                                    child: TextWidget(
                                      text: appbarTitle!,
                                      fontWeight: FontWeight.w700,
                                      fontSize: fontSizeTitle,
                                      overflow: TextOverflow.fade,
                                      align: TextAlign.center,
                                    ),
                                  ),
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: appbarAction,
                                ),
                              ],
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
