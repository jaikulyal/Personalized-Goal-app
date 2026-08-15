import 'progress_models.dart';
import '../../goals/data/local/goal_local_model.dart';

class ProgressCalculator {
  const ProgressCalculator();

  GoalProgressStatus calculateStatus({
    required double actualProgress,
    required double expectedProgress,
    required int plannedActions,
    required int completedActions,
    required int missedActions,
  }) {
    if (actualProgress >= 1.0) {
      return GoalProgressStatus.completed;
    }

    if (plannedActions == 0) {
      return GoalProgressStatus.onTrack;
    }

    final completionRate = completedActions / plannedActions;

    /*
     * We compare actual progress against expected progress.
     *
     * A small tolerance prevents tiny differences from
     * making the status jump between states.
     */
    const tolerance = 0.08;

    if (completionRate >= expectedProgress + tolerance) {
      return GoalProgressStatus.ahead;
    }

    if (completionRate >= expectedProgress - tolerance) {
      return GoalProgressStatus.onTrack;
    }

    /*
     * Missing a significant portion of planned actions
     * means the user needs attention.
     */
    final missedRate = missedActions / plannedActions;

    if (missedRate >= 0.35) {
      return GoalProgressStatus.behind;
    }

    return GoalProgressStatus.needsAttention;
  }

  double calculateExpectedProgress({
    required DateTime startDate,
    required DateTime targetDate,
    DateTime? now,
  }) {
    final currentDate = now ?? DateTime.now();

    final totalDuration = targetDate.difference(startDate).inSeconds;

    if (totalDuration <= 0) {
      return 1.0;
    }

    final elapsedDuration = currentDate.difference(startDate).inSeconds;

    if (elapsedDuration <= 0) {
      return 0.0;
    }

    if (elapsedDuration >= totalDuration) {
      return 1.0;
    }

    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }

  double calculateGoalProgress({
    required int completedActions,
    required int plannedActions,
  }) {
    if (plannedActions <= 0) {
      return 0.0;
    }

    return (completedActions / plannedActions).clamp(0.0, 1.0);
  }

  double calculateWeeklyProgress({
    required int completedActions,
    required int plannedActions,
  }) {
    if (plannedActions <= 0) {
      return 0.0;
    }

    return (completedActions / plannedActions).clamp(0.0, 1.0);
  }

  GoalProgressSummary createGoalSummary(GoalLocalModel goal, {DateTime? now}) {
    final currentDate = now ?? DateTime.now();

    final expectedProgress = goal.targetDate == null
        ? goal.progress
        : calculateExpectedProgress(
            startDate: goal.startDate,
            targetDate: goal.targetDate!,
            now: currentDate,
          );

    final actualProgress = goal.progress.clamp(0.0, 1.0);

    final plannedActions = 1;
    final completedActions = goal.isCompleted ? 1 : 0;
    final missedActions =
        (!goal.isCompleted &&
            goal.targetDate != null &&
            currentDate.isAfter(goal.targetDate!))
        ? 1
        : 0;

    final status = calculateStatus(
      actualProgress: actualProgress,
      expectedProgress: expectedProgress,
      plannedActions: plannedActions,
      completedActions: completedActions,
      missedActions: missedActions,
    );

    return GoalProgressSummary(
      goalId: goal.id,
      title: goal.title,
      category: goal.category,
      progress: actualProgress,
      expectedProgress: expectedProgress,
      plannedActions: plannedActions,
      completedActions: completedActions,
      missedActions: missedActions,
      status: status,
    );
  }
}
