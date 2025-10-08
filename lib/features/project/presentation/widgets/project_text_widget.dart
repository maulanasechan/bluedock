import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';

class ProjectTextWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final double bottom;
  const ProjectTextWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.bottom = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextWidget(text: title, fontWeight: FontWeight.w700, fontSize: 16),
        SizedBox(height: 4),
        TextWidget(text: subTitle, fontSize: 16, overflow: TextOverflow.fade),
        SizedBox(height: bottom),
      ],
    );
  }
}
