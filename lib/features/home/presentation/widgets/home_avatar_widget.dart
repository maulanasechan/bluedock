import 'package:bluedock/common/helper/greetings/greetings_helper.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class HomeAvatarWidget extends StatelessWidget {
  final UserEntity? user;
  final Function()? onTap;
  const HomeAvatarWidget({super.key, this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Material(
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.border, width: 1.5),
            ),
            elevation: 4,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                user != null ? user!.image : 'https://i.pravatar.cc/150?img=3',
              ),
            ),
          ),
        ),
        SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: 'Hello, ${greetingMessage()}!', fontSize: 14),
            SizedBox(height: 4),
            TextWidget(
              text: user != null ? user!.fullName : 'Dava Valubia',
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }
}
