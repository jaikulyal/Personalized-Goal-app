import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'task_tile.dart';

class HomeTodaySection extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final void Function(int index) onTaskTap;

  const HomeTodaySection({
    super.key,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks
        .where((task) => task['completed'] == true)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Today', style: AppTextStyles.title),

            const Spacer(),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey(completedCount),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: completedCount == tasks.length
                      ? AppColors.gold.withValues(alpha: 0.14)
                      : AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$completedCount of ${tasks.length} complete',
                  style: AppTextStyles.label.copyWith(
                    color: completedCount == tasks.length
                        ? AppColors.goldDark
                        : AppColors.muted,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        ...List.generate(tasks.length, (index) {
          final task = tasks[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == tasks.length - 1 ? 0 : AppSpacing.sm,
            ),
            child: TaskTile(
              title: task['title'] as String,
              completed: task['completed'] as bool,
              onTap: () => onTaskTap(index),
            ),
          );
        }),
      ],
    );
  }
}
