import 'package:bluedock/common/widgets/slideAction/slide_action_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/staff/domain/entities/staff_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class StaffCardWidget extends StatelessWidget {
  final StaffEntity? staff;
  const StaffCardWidget({super.key, this.staff});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlideActionWidget(
            onTap: () {
              context.pushNamed(AppRoutes.addOrUpdateStaff, extra: staff);
            },
            icon: PhosphorIconsBold.gearFine,
            label: 'Update',
            color: AppColors.orange,
          ),
          SlideActionWidget(
            icon: PhosphorIconsBold.trash,
            label: 'Delete',
            color: AppColors.red,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.staffDetail, extra: staff);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
          width: double.maxFinite,
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=2',
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: staff != null
                              ? staff!.fullName
                              : 'Dava Valubia',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        if (staff!.lastOnline != Timestamp(0, 0))
                          TextWidget(
                            text: 'Online',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: staff != null
                              ? staff!.role.title
                              : 'Chief Technical Support',
                          fontSize: 12,
                        ),
                        TextWidget(
                          text: staff != null
                              ? staff!.lastOnline != Timestamp(0, 0)
                                    ? timeago.format(staff!.lastOnline.toDate())
                                    : ''
                              : '3 days ago',
                          fontSize: 12,
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
