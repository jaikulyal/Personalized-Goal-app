import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../models/goal_model.dart';

class GoalsRemoteDataSource {
  final ApiClient _apiClient;

  GoalsRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<GoalModel> createGoal({
    required String title,
    required String category,
    String? description,
    String? startDate,
    String? targetDate,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.goals,
      body: {
        'title': title,
        'category': category,
        if (description != null && description.isNotEmpty)
          'description': description,
        'startDate': ?startDate,
        'targetDate': ?targetDate,
      },
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid goal response.');
    }

    return GoalModel.fromJson(data);
  }

  Future<List<GoalModel>> getGoals() async {
    final response = await _apiClient.get(ApiConfig.goals);

    final data = response['data'];

    if (data is! List) {
      throw Exception('Invalid goals response.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(GoalModel.fromJson)
        .toList();
  }

  Future<void> deleteGoal(String goalId) async {
    await _apiClient.delete('${ApiConfig.goals}/$goalId');
  }
}
