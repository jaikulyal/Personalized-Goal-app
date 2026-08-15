import '../../../../core/storage/local_storage.dart';
import '../local/goal_local_model.dart';

class GoalsLocalDataSource {
  Future<void> saveGoal(GoalLocalModel goal) async {
    await LocalStorage.goalsBox.put(goal.id, goal.toMap());
  }

  Future<List<GoalLocalModel>> getGoals() async {
    final values = LocalStorage.goalsBox.values;

    return values.whereType<Map>().map(GoalLocalModel.fromMap).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<GoalLocalModel?> getGoalById(String id) async {
    final data = LocalStorage.goalsBox.get(id);

    if (data is! Map) {
      return null;
    }

    return GoalLocalModel.fromMap(data);
  }

  Future<void> updateGoal(GoalLocalModel goal) async {
    await saveGoal(goal);
  }

  Future<void> deleteGoal(String id) async {
    await LocalStorage.goalsBox.delete(id);
  }

  Future<void> clearGoals() async {
    await LocalStorage.goalsBox.clear();
  }
}
