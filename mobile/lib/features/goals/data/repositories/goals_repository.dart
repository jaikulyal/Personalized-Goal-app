import '../datasources/goals_remote_datasource.dart';
import '../models/goal_model.dart';

class GoalsRepository {
  final GoalsRemoteDataSource _remoteDataSource;

  GoalsRepository({GoalsRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? GoalsRemoteDataSource();

  Future<GoalModel> createGoal({
    required String title,
    required String category,
    String? description,
    String? startDate,
    String? targetDate,
  }) {
    return _remoteDataSource.createGoal(
      title: title,
      category: category,
      description: description,
      startDate: startDate,
      targetDate: targetDate,
    );
  }

  Future<List<GoalModel>> getGoals() {
    return _remoteDataSource.getGoals();
  }

  Future<void> deleteGoal(String goalId) {
    return _remoteDataSource.deleteGoal(goalId);
  }
}
