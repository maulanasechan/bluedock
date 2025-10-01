import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/staff/domain/entities/staff_entity.dart';
import 'package:bluedock/features/staff/domain/usecases/delete_staff_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class StaffDetailPage extends StatelessWidget {
  final StaffEntity staff;
  const StaffDetailPage({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ActionButtonCubit())],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: BlocListener<ActionButtonCubit, ActionButtonState>(
            listener: (context, state) {
              if (state is ActionButtonFailure) {
                var snackbar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ActionButtonSuccess) {
                context.goNamed(
                  AppRoutes.successStaff,
                  extra: 'User had been deleted',
                );
              }
            },
            child: Column(
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
                SizedBox(height: 32),
                _bottomNavWidget(context, staff),
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
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(text: 'Last Online', fontSize: 14),
            SizedBox(width: 10),
            TextWidget(
              text: staff.lastOnline == Timestamp(0, 0)
                  ? '-'
                  : timeago.format(staff.lastOnline.toDate()),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
            ),
          ],
        ),
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
            TextWidget(text: staff.nip, fontSize: 16),
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
                text: DateFormat(
                  'dd MMM yyyy, HH:mm',
                ).format(staff.updatedAt!.toDate()),
                fontSize: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavWidget(BuildContext context, StaffEntity staff) {
    return Builder(
      builder: (context) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _contentWidget(),
                SizedBox(height: 50),
                ButtonWidget(
                  onPressed: () async {
                    final changed = await context.pushNamed(
                      AppRoutes.addOrUpdateStaff,
                      extra: staff,
                    );
                    if (changed == true && context.mounted) {
                      context.pop(true);
                    }
                  },
                  background: AppColors.orange,
                  title: 'Update Staff',
                  fontSize: 16,
                ),
                SizedBox(height: 16),
                ButtonWidget(
                  onPressed: () async {
                    final actionCubit = context.read<ActionButtonCubit>();
                    final changed = await CenterModalWidget.display(
                      context: context,
                      title: 'Remove Staff',
                      subtitle: "Are you sure to remove ${staff.fullName}?",
                      yesButton: 'Remove',
                      actionCubit: actionCubit,
                      yesButtonOnTap: () {
                        context.read<ActionButtonCubit>().execute(
                          usecase: DeleteStaffUsecase(),
                          params: staff.staffId,
                        );
                      },
                    );
                    if (changed == true && context.mounted) {
                      final change = await context.pushNamed(
                        AppRoutes.successStaff,
                        extra: '${staff.fullName} has been removed',
                      );

                      if (change == true && context.mounted) {
                        context.pop(true);
                      }
                    }
                  },
                  background: AppColors.red,
                  title: 'Delete Staff',
                  fontSize: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
