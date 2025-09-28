import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:bluedock/features/staff/domain/entities/role_entity.dart';
import 'package:bluedock/features/staff/presentation/bloc/staff_form_cubit.dart';
import 'package:bluedock/features/staff/presentation/bloc/role_display_cubit.dart';
import 'package:bluedock/features/staff/presentation/bloc/role_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleModalWidget extends StatelessWidget {
  const RoleModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleDisplayCubit, RoleDisplayState>(
      builder: (context, state) {
        if (state is RoleDisplayLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is RoleDisplayFailure) {
          return Center(child: Text(state.message));
        }
        if (state is RoleDisplayFetched) {
          return _displayRoles(state.listRoles);
        }
        return SizedBox();
      },
    );
  }

  Widget _displayRoles(List<RoleEntity> listRoles) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Choose one Role:',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<StaffFormCubit, StaffFormReq>(
              builder: (context, state) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 3),
                  itemBuilder: (context, index) {
                    final value = listRoles[index];
                    return ButtonWidget(
                      background: state.role?.roleId == value.roleId
                          ? AppColors.blue
                          : AppColors.white,
                      onPressed: () {
                        context.read<StaffFormCubit>().setRole(value);
                        Navigator.pop(context);
                      },
                      title: value.title,
                      fontColor: state.role?.roleId == value.roleId
                          ? AppColors.white
                          : AppColors.darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: listRoles.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
