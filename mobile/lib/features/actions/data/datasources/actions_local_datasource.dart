import '../../../../core/storage/local_storage.dart';
import '../local/action_local_model.dart';
import '../../domain/action_models.dart';

class ActionsLocalDataSource {
  Future<void> saveAction(ActionLocalModel action) async {
    await LocalStorage.actionsBox.put(action.id, action.toMap());
  }

  Future<List<ActionLocalModel>> getActions() async {
    final values = LocalStorage.actionsBox.values;

    return values.whereType<Map>().map(ActionLocalModel.fromMap).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  Future<List<ActionLocalModel>> getActionsForGoal(String goalId) async {
    final actions = await getActions();

    return actions.where((action) => action.goalId == goalId).toList();
  }

  Future<ActionLocalModel?> getActionById(String id) async {
    final data = LocalStorage.actionsBox.get(id);

    if (data is! Map) {
      return null;
    }

    return ActionLocalModel.fromMap(data);
  }

  Future<void> updateAction(ActionLocalModel action) async {
    await saveAction(action);
  }

  Future<void> deleteAction(String id) async {
    await LocalStorage.actionsBox.delete(id);
  }

  Future<void> deleteActionsForGoal(String goalId) async {
    final actions = await getActionsForGoal(goalId);

    for (final action in actions) {
      await deleteAction(action.id);
    }
  }

  Future<ActionLocalModel?> toggleAction(String id) async {
    final action = await getActionById(id);

    if (action == null) {
      return null;
    }

    final now = DateTime.now();

    final updatedAction = action.copyWith(
      isCompleted: !action.isCompleted,
      completedAt: action.isCompleted ? null : now,
      updatedAt: now,
    );

    await updateAction(updatedAction);

    return updatedAction;
  }

  Future<ActionSummary> getSummaryForGoal(
    String goalId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var actions = await getActionsForGoal(goalId);

    if (startDate != null) {
      actions = actions
          .where((action) => !action.scheduledDate.isBefore(startDate))
          .toList();
    }

    if (endDate != null) {
      actions = actions
          .where((action) => !action.scheduledDate.isAfter(endDate))
          .toList();
    }

    final planned = actions.length;

    final completed = actions.where((action) => action.isCompleted).length;

    final today = _dateOnly(DateTime.now());

    final missed = actions.where((action) {
      return !action.isCompleted &&
          _dateOnly(action.scheduledDate).isBefore(today);
    }).length;

    return ActionSummary(
      planned: planned,
      completed: completed,
      missed: missed,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> clearAll() async {
    await LocalStorage.actionsBox.clear();
  }
}
