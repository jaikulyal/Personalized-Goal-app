class ActionLocalModel {
  final String id;
  final String goalId;
  final String title;
  final DateTime scheduledDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActionLocalModel({
    required this.id,
    required this.goalId,
    required this.title,
    required this.scheduledDate,
    required this.isCompleted,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalId': goalId,
      'title': title,
      'scheduledDate': scheduledDate.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ActionLocalModel.fromMap(Map<dynamic, dynamic> map) {
    return ActionLocalModel(
      id: map['id'] as String,
      goalId: map['goalId'] as String,
      title: map['title'] as String,
      scheduledDate: DateTime.parse(map['scheduledDate'] as String),
      isCompleted: map['isCompleted'] as bool? ?? false,
      completedAt: map['completedAt'] == null
          ? null
          : DateTime.parse(map['completedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  ActionLocalModel copyWith({
    String? title,
    DateTime? scheduledDate,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) {
    return ActionLocalModel(
      id: id,
      goalId: goalId,
      title: title ?? this.title,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
