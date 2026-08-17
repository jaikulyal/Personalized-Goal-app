import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    const weekdays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];

    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];

    final dateText =
        '${weekdays[now.weekday - 1]}, '
        '${months[now.month - 1]} ${now.day}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              dateText,
              style: AppTextStyles.label.copyWith(
                letterSpacing: 1.4,
                fontSize: 10,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'Good morning,',
          style: AppTextStyles.headline.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Make today count.',
          style: AppTextStyles.display.copyWith(
            fontSize: 36,
            letterSpacing: -1.4,
          ),
        ),
      ],
    );
  }
}
