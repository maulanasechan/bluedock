import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlideActionWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isFirst;
  final bool isLast;
  final Color color;
  final VoidCallback? onTap;

  const SlideActionWidget({
    super.key,
    required this.icon,
    required this.label,
    this.isFirst = false,
    this.isLast = false,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      flex: 1,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      onPressed: (actionContext) {
        Slidable.of(actionContext)?.close();
        onTap?.call();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 0, 4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.border, width: 1.5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: AppColors.boxShadow,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
