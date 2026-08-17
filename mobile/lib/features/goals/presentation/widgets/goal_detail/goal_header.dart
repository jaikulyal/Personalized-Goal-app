import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class GoalHeader extends StatelessWidget {
  final String title;
  final String category;

  const GoalHeader({super.key, required this.title, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.champagneSoft,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            category.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: AppColors.goldDark,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          title,
          style: AppTextStyles.display.copyWith(
            fontSize: 38,
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }
}
