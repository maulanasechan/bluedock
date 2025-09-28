import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/staff/domain/entities/staff_entity.dart';
import 'package:bluedock/features/staff/presentation/bloc/staff_display_cubit.dart';
import 'package:bluedock/features/staff/presentation/bloc/staff_display_state.dart';
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
        BlocProvider(create: (context) => StaffDisplayCubit()..displayStaff()),
      ],
      child: BlocBuilder<StaffDisplayCubit, StaffDisplayState>(
        builder: (context, state) {
          if (state is StaffDisplayLoading) {
            return _manageStaffLoading();
          }
          if (state is StaffDisplayFetched) {
            return _manageStaffFetched(context, state.listStaff);
          }
          return GradientScaffoldWidget();
        },
      ),
    );
  }

  Widget _manageStaffLoading() {
    return GradientScaffoldWidget(
      hideBack: false,
      appbarTitle: 'Manage Staff',
      appbarAction: IconButtonWidget(
        iconColor: AppColors.orange,
        onPressed: () {},
      ),
      loading: true,
      body: Shimmer.fromColors(
        baseColor: AppColors.baseLoading,
        highlightColor: AppColors.highlightLoading,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return StaffCardWidget();
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
    return GradientScaffoldWidget(
      hideBack: false,
      appbarTitle: 'Manage Staff',
      appbarAction: IconButtonWidget(
        icon: PhosphorIconsFill.userCirclePlus,
        iconColor: AppColors.orange,
        iconSize: 28,
        onPressed: () {
          context.pushNamed(AppRoutes.addOrUpdateStaff);
        },
      ),
      body: ListView.separated(
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
