import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/home/data/models/app_menu_model.dart';
import 'package:bluedock/features/home/data/sources/app_menu_service.dart';
import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:bluedock/features/home/presentation/bloc/user_info_cubit.dart';
import 'package:bluedock/features/home/presentation/bloc/user_info_state.dart';
import 'package:bluedock/features/home/presentation/widgets/home_avatar_widget.dart';
import 'package:bluedock/features/home/presentation/widgets/menu_list_widget.dart';
import 'package:bluedock/features/home/presentation/widgets/notification_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserInfoCubit()..displayUserInfo()),
      ],
      child: GradientScaffoldWidget(
        hideBack: true,
        body: BlocBuilder<UserInfoCubit, UserInfoState>(
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return _homeLoading();
            }
            if (state is UserInfoFetched) {
              return _homeFetched(context, state.user);
            }
            if (state is UserInfoFailure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(AppRoutes.login);
              });
            }
            return Column();
          },
        ),
      ),
    );
  }

  Widget _homeLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.baseLoading,
      highlightColor: AppColors.highlightLoading,
      child: Column(
        children: [
          SizedBox(height: 90),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [HomeAvatarWidget(), NotificationButtonWidget()],
          ),
          SizedBox(height: 50),
          Expanded(child: MenuListWidget(listAppMenu: listAppMenu)),
        ],
      ),
    );
  }

  List<AppMenuModel> _filterMenusByRole(UserEntity user) {
    final allowedIds = user.role.listAppMenu;
    if (allowedIds.isEmpty) return const <AppMenuModel>[];

    final allowedSet = allowedIds.toSet();
    return listAppMenu.where((m) => allowedSet.contains(m.appMenuId)).toList();
  }

  Widget _homeFetched(BuildContext context, UserEntity user) {
    return Column(
      children: [
        SizedBox(height: 90),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeAvatarWidget(
              user: user,
              onTap: () {
                context.pushNamed(AppRoutes.profile, extra: user);
              },
            ),
            NotificationButtonWidget(),
          ],
        ),
        SizedBox(height: 50),
        Expanded(child: MenuListWidget(listAppMenu: _filterMenusByRole(user))),
      ],
    );
  }
}
