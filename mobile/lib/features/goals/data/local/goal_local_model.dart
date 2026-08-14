class GoalLocalModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime startDate;
  final DateTime? targetDate;
  final double progress;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GoalLocalModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.startDate,
    this.targetDate,
    required this.progress,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'progress': progress,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory GoalLocalModel.fromMap(Map<dynamic, dynamic> map) {
    return GoalLocalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      description: map['description'] as String? ?? '',
      startDate: DateTime.parse(map['startDate'] as String),
      targetDate: map['targetDate'] == null
          ? null
          : DateTime.parse(map['targetDate'] as String),
      progress: (map['progress'] as num?)?.toDouble() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  GoalLocalModel copyWith({
    String? title,
    String? category,
    String? description,
    DateTime? startDate,
    DateTime? targetDate,
    double? progress,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return GoalLocalModel(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
