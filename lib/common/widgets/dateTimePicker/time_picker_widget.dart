import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TimePickerWidget extends StatelessWidget {
  final String title;
  final TimeOfDay? selected;
  final ValueChanged<TimeOfDay?> onChanged;
  final bool use24h;
  final FormFieldValidator<TimeOfDay?>? validator;

  const TimePickerWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
    this.validator,
    this.use24h = true,
  });

  Future<void> _pick(
    BuildContext context,
    FormFieldState<TimeOfDay?> field,
  ) async {
    final initial = field.value ?? selected ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: use24h),
          child: child!,
        );
      },
    );

    if (picked != null) {
      field.didChange(picked); // <- update nilai FormField
      onChanged(picked); // <- kabari cubit/parent
    }
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    if (use24h) {
      final dt = DateTime(2020, 1, 1, time.hour, time.minute);
      return DateFormat('HH:mm').format(dt);
    }
    final l = MaterialLocalizations.of(context);
    return l.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay?>(
      key: ValueKey('${selected?.hour}:${selected?.minute}'),
      initialValue: selected,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator ?? (v) => v == null ? '$title is required.' : null,
      builder: (field) {
        final hasError = field.hasError;
        final display = field.value != null
            ? _formatTime(context, field.value!)
            : title;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.w500),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _pick(context, field), // <- pass field ke picker
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 1.5,
                      color: hasError ? AppColors.blue : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: display,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      PhosphorIcon(
                        PhosphorIconsBold.clock,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (hasError) const SizedBox(height: 8),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: AppColors.blue, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
