import 'package:bluedock/common/widgets/slideAction/slide_action_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SlidableActionWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onUpdateTap;
  final VoidCallback onDeleteTap;
  final String deleteParams;
  final List<Widget>? extraActions;

  const SlidableActionWidget({
    super.key,
    required this.onUpdateTap,
    required this.onDeleteTap,
    required this.child,
    required this.deleteParams,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (extraActions != null) ...extraActions!,
          SlideActionWidget(
            onTap: onUpdateTap,
            icon: PhosphorIconsBold.gearFine,
            label: 'Update',
            color: AppColors.orange,
          ),
          SlideActionWidget(
            onTap: onDeleteTap,
            icon: PhosphorIconsBold.trash,
            label: 'Delete',
            color: AppColors.red,
          ),
        ],
      ),
      child: child,
    );
  }
}
