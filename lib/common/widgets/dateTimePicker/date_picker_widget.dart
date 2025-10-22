import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DatePickerWidget extends StatelessWidget {
  final String title;
  final DateTime? selected;
  final ValueChanged<DateTime?> onChanged;
  const DatePickerWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
  });

  Future<void> pick(BuildContext context) async {
    final firstDate = DateTime(2000, 1, 1);
    final lastDate = DateTime(2100, 12, 31);
    final fallback = DateTime.now();
    final initial = selected ?? fallback;

    final initSafe = (initial.isBefore(firstDate) || initial.isAfter(lastDate))
        ? fallback
        : initial;

    final picked = await showDatePicker(
      context: context,
      initialDate: initSafe,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = selected != null;
    final text = hasValue
        ? DateFormat('EEEE, dd MMMM yyyy').format(selected!)
        : 'Select a date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.w500),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => pick(context),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(width: 1.5, color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      text: text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  PhosphorIcon(
                    PhosphorIconsBold.calendarDots,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
