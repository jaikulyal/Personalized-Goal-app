enum GoalProgressStatus { ahead, onTrack, needsAttention, behind, completed }

class GoalProgressSummary {
  final String goalId;
  final String title;
  final String category;

  /// Actual completed progress, from 0.0 to 1.0.
  final double progress;

  /// Progress expected based on the goal's timeframe.
  final double expectedProgress;

  /// Number of planned actions.
  final int plannedActions;

  /// Number of completed actions.
  final int completedActions;

  /// Number of missed actions.
  final int missedActions;

  /// Calculated status.
  final GoalProgressStatus status;

  const GoalProgressSummary({
    required this.goalId,
    required this.title,
    required this.category,
    required this.progress,
    required this.expectedProgress,
    required this.plannedActions,
    required this.completedActions,
    required this.missedActions,
    required this.status,
  });
}

class WeeklyProgressSummary {
  final int plannedActions;
  final int completedActions;
  final int missedActions;

  const WeeklyProgressSummary({
    required this.plannedActions,
    required this.completedActions,
    required this.missedActions,
  });

  double get progress {
    if (plannedActions == 0) return 0;

    return (completedActions / plannedActions).clamp(0.0, 1.0);
  }
}

class ConsistencySummary {
  final int currentDays;
  final int weeklyCompleted;
  final int weeklyPlanned;
  final double monthlyPercentage;

  const ConsistencySummary({
    required this.currentDays,
    required this.weeklyCompleted,
    required this.weeklyPlanned,
    required this.monthlyPercentage,
  });

  double get weeklyPercentage {
    if (weeklyPlanned == 0) return 0;

    return (weeklyCompleted / weeklyPlanned).clamp(0.0, 1.0);
  }
}

class WeeklyReflection {
  final String? whatWentWell;
  final String? whatWasDifficult;
  final String? whatToImprove;
  final DateTime weekStart;

  const WeeklyReflection({
    required this.whatWentWell,
    required this.whatWasDifficult,
    required this.whatToImprove,
    required this.weekStart,
  });
}
