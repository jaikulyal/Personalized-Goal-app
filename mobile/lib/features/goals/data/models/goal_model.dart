class GoalModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final double progress;
  final int daysRemaining;
  final bool completed;
  final DateTime? startDate;
  final DateTime? targetDate;

  const GoalModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.progress,
    required this.daysRemaining,
    required this.completed,
    this.startDate,
    this.targetDate,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final startDateValue = json['startDate'];
    final targetDateValue = json['targetDate'];

    return GoalModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      progress: _parseProgress(json['progress']),
      daysRemaining: _parseInt(json['daysRemaining']),
      completed: json['completed'] == true,
      startDate: startDateValue != null
          ? DateTime.tryParse(startDateValue.toString())
          : null,
      targetDate: targetDateValue != null
          ? DateTime.tryParse(targetDateValue.toString())
          : null,
    );
  }

  static double _parseProgress(dynamic value) {
    if (value is num) {
      return value.toDouble().clamp(0.0, 1.0);
    }

    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return 0;
  }
}
