import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../goals/data/local/goal_local_model.dart';
import '../../data/progress_local_datasource.dart';
import '../../domain/progress_calculator.dart';
import '../../domain/progress_models.dart';
import '../widgets/consistency_card.dart';
import '../widgets/goal_progress_tile.dart';
import '../widgets/progress_status_card.dart';
import '../widgets/weekly_progress_card.dart';
import '../widgets/weekly_reflection_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  final ProgressLocalDataSource _dataSource = ProgressLocalDataSource();
  final ProgressCalculator _calculator = const ProgressCalculator();

  bool _isLoading = true;

  List<GoalLocalModel> _goals = [];
  List<GoalProgressSummary> _summaries = [];

  @override
  void initState() {
    super.initState();
    refreshProgress();
  }

  Future<void> refreshProgress() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final goals = await _dataSource.getGoals();

      final now = DateTime.now();

      final summaries = goals
          .map((goal) => _calculator.createGoalSummary(goal, now: now))
          .toList();

      if (!mounted) return;

      setState(() {
        _goals = goals;
        _summaries = summaries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Progress loading error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.gold,
          backgroundColor: AppColors.primary,
          onRefresh: refreshProgress,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  40,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),

                    const SizedBox(height: AppSpacing.xxl),

                    if (_isLoading)
                      const _ProgressLoadingState()
                    else
                      _buildContent(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROGRESS',
          style: AppTextStyles.label.copyWith(
            letterSpacing: 1.4,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Your momentum.', style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'A clearer view of how you are moving forward.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_goals.isEmpty || _summaries.isEmpty) {
      return const _EmptyProgressState();
    }

    final weekly = _buildWeeklySummary();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ------------------------------------------------------------
        // WEEKLY PROGRESS
        // ------------------------------------------------------------
        WeeklyProgressCard(
          completedActions: weekly.completedActions,
          plannedActions: weekly.plannedActions,
        ),

        const SizedBox(height: AppSpacing.lg),

        // ------------------------------------------------------------
        // CONSISTENCY
        // ------------------------------------------------------------
        ConsistencyCard(
          currentDays: _calculateCurrentConsistency(),
          weeklyCompleted: weekly.completedActions,
          weeklyPlanned: weekly.plannedActions,
          monthlyPercentage: _calculateMonthlyPercentage(),
        ),

        const SizedBox(height: AppSpacing.xxl),

        // ------------------------------------------------------------
        // GOAL-LEVEL PROGRESS
        // ------------------------------------------------------------
        _sectionTitle('Goal progress'),

        const SizedBox(height: AppSpacing.md),

        ..._summaries.map(
          (summary) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GoalProgressTile(summary: summary),
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),

        // ------------------------------------------------------------
        // CURRENT STATUS
        // ------------------------------------------------------------
        _sectionTitle('Current status'),

        const SizedBox(height: AppSpacing.md),

        ..._summaries
            .take(3)
            .map(
              (summary) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ProgressStatusCard(summary: summary),
              ),
            ),

        const SizedBox(height: AppSpacing.xxl),

        // ------------------------------------------------------------
        // WEEKLY REFLECTION
        // ------------------------------------------------------------
        _sectionTitle('Weekly reflection'),

        const SizedBox(height: AppSpacing.md),

        const WeeklyReflectionCard(),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTextStyles.title);
  }

  // ------------------------------------------------------------
  // WEEKLY SUMMARY
  // ------------------------------------------------------------

  WeeklyProgressSummary _buildWeeklySummary() {
    final completed = _summaries.fold<int>(0, (total, summary) {
      return total + summary.completedActions;
    });

    final missed = _summaries.fold<int>(0, (total, summary) {
      return total + summary.missedActions;
    });

    final planned = _summaries.fold<int>(0, (total, summary) {
      return total + summary.plannedActions;
    });

    return WeeklyProgressSummary(
      plannedActions: planned,
      completedActions: completed,
      missedActions: missed,
    );
  }

  // ------------------------------------------------------------
  // CONSISTENCY
  // ------------------------------------------------------------

  int _calculateCurrentConsistency() {
    if (_summaries.isEmpty) {
      return 0;
    }

    int consistencyDays = 0;

    for (final summary in _summaries) {
      if (summary.completedActions > 0 && summary.missedActions == 0) {
        consistencyDays++;
      }
    }

    return consistencyDays;
  }

  // ------------------------------------------------------------
  // MONTHLY PROGRESS
  // ------------------------------------------------------------

  double _calculateMonthlyPercentage() {
    if (_summaries.isEmpty) {
      return 0;
    }

    final completed = _summaries.fold<int>(0, (total, summary) {
      return total + summary.completedActions;
    });

    final planned = _summaries.fold<int>(0, (total, summary) {
      return total + summary.plannedActions;
    });

    if (planned == 0) {
      return 0;
    }

    return ((completed / planned) * 100).clamp(0.0, 100.0);
  }
}

// ================================================================
// LOADING STATE
// ================================================================

class _ProgressLoadingState extends StatelessWidget {
  const _ProgressLoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 280,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(AppColors.gold),
        ),
      ),
    );
  }
}

// ================================================================
// EMPTY STATE
// ================================================================

class _EmptyProgressState extends StatelessWidget {
  const _EmptyProgressState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.insights_outlined, color: AppColors.gold, size: 32),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Your progress starts here.',
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            'Create a goal and start taking action.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
