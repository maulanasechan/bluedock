import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButtonWidget extends StatelessWidget {
  final String text;
  const CopyButtonWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: AppColors.blue,
      icon: const Icon(Icons.copy),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: text));
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
        }
      },
    );
  }
}
