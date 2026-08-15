import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class FocusGoalCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final double progress;
  final int daysRemaining;

  const FocusGoalCard({
    this.onTap,
    super.key,
    required this.title,
    required this.progress,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.champagne.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────
            // HEADER
            // ─────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.champagne.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.champagne.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    'TODAY\'S FOCUS',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.champagne,
                      fontSize: 9,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),

                const Spacer(),

                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface.withValues(alpha: 0.06),
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: AppColors.champagne,
                    size: 19,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ─────────────────────────────
            // GOAL TITLE
            // ─────────────────────────────
            Text(
              title,
              style: const TextStyle(
                color: AppColors.surface,
                fontSize: 31,
                height: 1.04,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.2,
              ),
            ),

            const SizedBox(height: 26),

            // ─────────────────────────────
            // PROGRESS HEADER
            // ─────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: AppColors.champagne,
                    fontSize: 30,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(width: 8),

                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    'complete',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  '$daysRemaining days left',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ─────────────────────────────
            // PROGRESS BAR
            // ─────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    height: 7,
                    width: double.infinity,
                    color: const Color(0xFF343330),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF80681F),
                            AppColors.gold,
                            Color(0xFFFFE58A),
                            AppColors.gold,
                          ],
                          stops: [0.0, 0.35, 0.65, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.35),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────
            // FOOTER
            // ─────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.gold,
                  size: 16,
                ),
                const SizedBox(width: 7),
                Text(
                  'Stay focused',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
