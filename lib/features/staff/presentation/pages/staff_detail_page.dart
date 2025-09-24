import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StaffDetailPage extends StatelessWidget {
  const StaffDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 90, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Align(alignment: Alignment.topLeft, child: IconButtonWidget()),
                Align(alignment: Alignment.topCenter, child: _avatarWidget()),
              ],
            ),
            _bottomNavWidget(),
          ],
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
          text: 'Dava Valubia Ramadhan',
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
              text: '3 days ago',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
            ),
          ],
        ),
        SizedBox(height: 32),
        _contentWidget(),
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
            TextWidget(text: 'NIK', fontWeight: FontWeight.w700, fontSize: 16),
            SizedBox(height: 4),
            TextWidget(text: '30578040204970005', fontSize: 16),
            SizedBox(height: 16),
            TextWidget(
              text: 'Email',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            SizedBox(height: 4),
            TextWidget(text: 'dava@gmail.com', fontSize: 16),
            SizedBox(height: 16),
            TextWidget(
              text: 'Password',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            SizedBox(height: 4),
            TextWidget(text: 'kaka12345', fontSize: 16),
            SizedBox(height: 16),
            TextWidget(
              text: 'Address',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            SizedBox(height: 4),
            TextWidget(
              overflow: TextOverflow.fade,
              text: 'bagong ginayan 50/60, surabaya, medokan, jawa timur',
              fontSize: 16,
            ),
            SizedBox(height: 16),
            TextWidget(text: 'Role', fontWeight: FontWeight.w700, fontSize: 16),
            SizedBox(height: 4),
            TextWidget(text: 'Chief Technical Support', fontSize: 16),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavWidget() {
    return Column(
      children: [
        ButtonWidget(
          onPressed: () {},
          background: AppColors.orange,
          title: 'Update Staff',
          fontSize: 16,
        ),
        SizedBox(height: 16),
        ButtonWidget(
          onPressed: () {},
          background: AppColors.red,
          title: 'Delete Staff',
          fontSize: 16,
        ),
      ],
    );
  }
}
