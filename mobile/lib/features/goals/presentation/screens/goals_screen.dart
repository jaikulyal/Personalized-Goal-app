import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/goal_model.dart';
import '../widgets/goal_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  static const List<GoalModel> _goals = [
    GoalModel(
      id: '1',
      title: 'Build my Goal App',
      category: 'Development',
      description: 'Complete the MVP and prepare it for evaluation.',
      progress: 0.72,
      daysRemaining: 3,
      completed: false,
    ),
    GoalModel(
      id: '2',
      title: 'Learn Flutter',
      category: 'Learning',
      description: 'Improve Flutter architecture and UI development.',
      progress: 0.45,
      daysRemaining: 18,
      completed: false,
    ),
    GoalModel(
      id: '3',
      title: 'Complete Portfolio',
      category: 'Career',
      description: 'Finish the personal portfolio project.',
      progress: 1.0,
      daysRemaining: 0,
      completed: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeGoals = _goals.where((goal) => !goal.completed).toList();

    final completedGoals = _goals.where((goal) => goal.completed).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.lg,
              AppSpacing.screen,
              100,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'YOUR GOALS',
                  style: AppTextStyles.label.copyWith(letterSpacing: 1.5),
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  'Turn intentions\ninto progress.',
                  style: AppTextStyles.display.copyWith(fontSize: 38),
                ),

                const SizedBox(height: AppSpacing.xxl),

                _buildStats(activeGoals.length, completedGoals.length),

                const SizedBox(height: AppSpacing.xxl),

                Text(
                  'ACTIVE',
                  style: AppTextStyles.label.copyWith(letterSpacing: 1.3),
                ),

                const SizedBox(height: AppSpacing.md),

                ...activeGoals.map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GoalCard(goal: goal),
                  ),
                ),

                if (completedGoals.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'COMPLETED',
                    style: AppTextStyles.label.copyWith(letterSpacing: 1.3),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  ...completedGoals.map(
                    (goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GoalCard(goal: goal),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(int active, int completed) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(value: '$active', label: 'ACTIVE'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(value: '$completed', label: 'COMPLETED'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.display.copyWith(fontSize: 30)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}
