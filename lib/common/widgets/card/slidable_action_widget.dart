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
  final bool isDeleted;
  final bool isUpdated;
  final double extentRatio;
  final Color? updateColor;
  final Color? deleteColor;
  final String updateText;
  final String deleteText;
  final bool isSlideable;
  final PhosphorIconData? updateIcon;
  final PhosphorIconData? deleteIcon;

  const SlidableActionWidget({
    super.key,
    required this.onUpdateTap,
    required this.onDeleteTap,
    required this.child,
    required this.deleteParams,
    this.extraActions,
    this.isDeleted = true,
    this.isUpdated = true,
    this.extentRatio = 0.4,
    this.updateColor,
    this.deleteColor,
    this.updateText = 'Update',
    this.deleteText = 'Delete',
    this.isSlideable = true,
    this.deleteIcon,
    this.updateIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: isSlideable,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: extentRatio,
        children: [
          if (extraActions != null) ...extraActions!,
          if (isUpdated == true)
            SlideActionWidget(
              onTap: onUpdateTap,
              icon: updateIcon ?? PhosphorIconsBold.gearFine,
              label: updateText,
              color: updateColor ?? AppColors.orange,
            ),
          if (isDeleted == true)
            SlideActionWidget(
              onTap: onDeleteTap,
              icon: deleteIcon ?? PhosphorIconsBold.trash,
              label: deleteText,
              color: deleteColor ?? AppColors.red,
            ),
        ],
      ),
      child: child,
    );
  }
}
