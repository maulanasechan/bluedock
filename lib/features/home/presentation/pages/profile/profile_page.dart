import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:bluedock/features/home/domain/usecases/logout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity staff;
  const ProfilePage({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ActionButtonCubit())],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 20),
          child: BlocListener<ActionButtonCubit, ActionButtonState>(
            listener: (context, state) {
              if (state is ActionButtonFailure) {
                var snackbar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ActionButtonSuccess) {
                context.goNamed(AppRoutes.login);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButtonWidget(),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: _avatarWidget(),
                    ),
                  ],
                ),
                _bottomNavWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarWidget() {
    return Column(
      children: [
        Material(
          shape: CircleBorder(),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=2'),
            ),
          ),
        ),
        SizedBox(height: 24),
        TextWidget(
          text: staff.fullName,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(height: 32),
        _contentWidget(),
      ],
    );
  }

  Widget _contentWidget() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: 'NIP', fontWeight: FontWeight.w700, fontSize: 16),
            SizedBox(height: 4),
            TextWidget(text: staff.nik, fontSize: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextWidget(
                text: 'NIK',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            TextWidget(text: staff.nik, fontSize: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextWidget(
                text: 'Email',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            TextWidget(text: staff.email, fontSize: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextWidget(
                text: 'Address',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            TextWidget(
              overflow: TextOverflow.fade,
              text: staff.address,
              fontSize: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextWidget(
                text: 'Role',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            TextWidget(text: staff.role.title, fontSize: 16),
            if (staff.updatedBy != '')
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: TextWidget(
                  text: 'Updated By',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            if (staff.updatedBy != '')
              TextWidget(text: staff.updatedBy, fontSize: 16),
            if (staff.updatedAt != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: TextWidget(
                  text: 'Updated At',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            if (staff.updatedAt != null)
              TextWidget(
                text: staff.updatedAt!.toDate().toString(),
                fontSize: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavWidget(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            ButtonWidget(
              onPressed: () {
                context.pushNamed(AppRoutes.changePassword);
              },
              background: AppColors.orange,
              title: 'Change Password',
              fontSize: 16,
            ),
            SizedBox(height: 16),
            ActionButtonWidget(
              onPressed: () {
                context.read<ActionButtonCubit>().execute(
                  usecase: LogoutUseCase(),
                );
              },
              background: AppColors.red,
              title: 'Logout',
              fontSize: 16,
            ),
          ],
        );
      },
    );
  }
}
