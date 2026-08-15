import '../../goals/data/datasources/goals_local_datasource.dart';
import '../../goals/data/local/goal_local_model.dart';

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
}
