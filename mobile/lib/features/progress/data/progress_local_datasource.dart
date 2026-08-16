import '../../goals/data/datasources/goals_local_datasource.dart';
import '../../goals/data/local/goal_local_model.dart';
import '../domain/progress_models.dart';

class ProgressLocalDataSource {
  final GoalsLocalDataSource _goalsDataSource;

  ProgressLocalDataSource({GoalsLocalDataSource? goalsDataSource})
    : _goalsDataSource = goalsDataSource ?? GoalsLocalDataSource();

  Future<List<GoalLocalModel>> getGoals() async {
    return _goalsDataSource.getGoals();
  }

  Future<GoalLocalModel?> getGoalById(String id) async {
    return _goalsDataSource.getGoalById(id);
  }

  // ------------------------------------------------------------
  // WEEKLY REFLECTION
  // ------------------------------------------------------------

  WeeklyReflection? _reflection;

  Future<WeeklyReflection?> getWeeklyReflection() async {
    return _reflection;
  }

  Future<void> saveWeeklyReflection({
    required String? whatWentWell,
    required String? whatWasDifficult,
    required String? whatToImprove,
  }) async {
    final now = DateTime.now();

    // Start of the current week (Monday).
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    _reflection = WeeklyReflection(
      whatWentWell: _cleanText(whatWentWell),
      whatWasDifficult: _cleanText(whatWasDifficult),
      whatToImprove: _cleanText(whatToImprove),
      weekStart: weekStart,
    );
  }

  String? _cleanText(String? value) {
    final text = value?.trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }
}
