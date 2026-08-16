class ActionSummary {
  final int planned;
  final int completed;
  final int missed;

  const ActionSummary({
    required this.planned,
    required this.completed,
    required this.missed,
  });

  double get completionRate {
    if (planned == 0) {
      return 0;
    }

    return (completed / planned).clamp(0.0, 1.0);
  }

  double get percentage {
    return completionRate * 100;
  }
}
