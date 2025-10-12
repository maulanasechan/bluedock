import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/bloc/staff/staff_display_cubit.dart';
import 'package:bluedock/common/bloc/staff/staff_display_state.dart';
import 'package:bluedock/features/staff/presentation/widgets/staff_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ManageStaffPage extends StatelessWidget {
  const ManageStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StaffDisplayCubit()..displayStaff(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Manage Staff',
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsBold.userCirclePlus,
              iconSize: 26,
              onPressed: () async {
                final staffCubit = ctx.read<StaffDisplayCubit>();
                final changed = await ctx.pushNamed(AppRoutes.addOrUpdateStaff);
                if (changed == true && ctx.mounted) {
                  staffCubit.displayStaff(params: '');
                }
              },
            );
          },
        ),
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return TextfieldWidget(
                  prefixIcon: PhosphorIconsBold.magnifyingGlass,
                  borderRadius: 60,
                  iconColor: AppColors.darkBlue,
                  hintText: 'Search by name',
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<StaffDisplayCubit>().displayInitial();
                    } else {
                      context.read<StaffDisplayCubit>().displayStaff(
                        params: value,
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            BlocBuilder<StaffDisplayCubit, StaffDisplayState>(
              builder: (context, state) {
                if (state is StaffDisplayLoading) {
                  return _manageStaffLoading();
                }
                if (state is StaffDisplayFetched) {
                  return _manageStaffFetched(context, state.listStaff);
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _manageStaffLoading() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: AppColors.baseLoading,
        highlightColor: AppColors.highlightLoading,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Container(
              width: double.maxFinite,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: 6,
        ),
      ),
    );
  }

  Widget _manageStaffFetched(
    BuildContext context,
    List<StaffEntity> listStaff,
  ) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return StaffCardWidget(staff: listStaff[index]);
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: listStaff.length,
      ),
    );
  }
}
