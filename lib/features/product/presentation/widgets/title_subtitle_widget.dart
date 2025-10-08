import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';

class TitleSubtitleWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleSubtitleWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: title, fontSize: 12, overflow: TextOverflow.fade),
        SizedBox(height: 4),
        TextWidget(
          text: subtitle == '' ? "-" : subtitle,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.fade,
          align: TextAlign.justify,
        ),
      ],
    );
  }
}
