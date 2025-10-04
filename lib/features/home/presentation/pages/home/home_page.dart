import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:bluedock/features/home/presentation/bloc/app_menu_cubit.dart';
import 'package:bluedock/features/home/presentation/bloc/app_menu_state.dart';
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
        BlocProvider(create: (context) => AppMenuCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<UserInfoCubit, UserInfoState>(
              listenWhen: (prev, curr) => curr is UserInfoFetched,
              listener: (context, state) {
                final user = (state as UserInfoFetched).user;
                context.read<AppMenuCubit>().displayAppMenu(user);
              },
            ),
          ],
          child: BlocBuilder<UserInfoCubit, UserInfoState>(
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
      ),
    );
  }

  Widget _homeLoading() {
    return Column(
      children: [
        Shimmer.fromColors(
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
            ],
          ),
        ),
      ],
    );
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
        Expanded(
          child: BlocBuilder<AppMenuCubit, AppMenuState>(
            builder: (context, state) {
              if (state is AppMenuLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.blue),
                );
              }
              if (state is AppMenuFetched) {
                return MenuListWidget(listAppMenu: state.appMenu);
              }
              return SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
