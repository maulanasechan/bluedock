import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/staff/presentation/widgets/staff_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ManageStaffPage extends StatelessWidget {
  const ManageStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(children: [StaffCardWidget()]),
    );
  }
}
