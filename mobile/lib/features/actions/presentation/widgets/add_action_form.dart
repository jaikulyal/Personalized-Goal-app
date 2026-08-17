import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'action_date_time_selector.dart';

class AddActionForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;

  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;

  final String Function(DateTime date) formatDate;
  final String Function(TimeOfDay time) formatTime;

  const AddActionForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.formatDate,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('ACTION TITLE'),

          const SizedBox(height: AppSpacing.sm),

          TextFormField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            style: AppTextStyles.body.copyWith(color: AppColors.primary),
            decoration: InputDecoration(
              hintText: 'e.g. Read 10 pages',
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.muted,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.07),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.07),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an action title.';
              }

              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          ActionDateTimeSelector(
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            onSelectDate: onSelectDate,
            onSelectTime: onSelectTime,
            formatDate: formatDate,
            formatTime: formatTime,
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        fontSize: 9,
        letterSpacing: 1.1,
        color: AppColors.muted,
      ),
    );
  }
}
