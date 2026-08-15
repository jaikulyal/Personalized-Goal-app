import '../data/progress_local_datasource.dart';
import 'progress_calculator.dart';
import 'progress_models.dart';

class ProgressRepository {
  final ProgressLocalDataSource _dataSource;
  final ProgressCalculator _calculator;

  ProgressRepository({
    ProgressLocalDataSource? dataSource,
    ProgressCalculator? calculator,
  }) : _dataSource = dataSource ?? ProgressLocalDataSource(),
       _calculator = calculator ?? const ProgressCalculator();

  Future<List<GoalProgressSummary>> getGoalProgress() async {
    final goals = await _dataSource.getGoals();

    return goals.map(_calculator.createGoalSummary).toList();
  }
}
