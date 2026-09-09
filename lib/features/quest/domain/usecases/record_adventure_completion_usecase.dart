import '../../../../core/errors/result.dart';
import '../entities/quest_definition.dart';
import '../entities/quest_instance.dart';
import '../repositories/quest_repository.dart';
import 'ensure_daily_quests_usecase.dart';

class RecordAdventureCompletionUseCase {
  RecordAdventureCompletionUseCase(this._repository, this._ensure);
  final QuestRepository _repository;
  final EnsureDailyQuestsUseCase _ensure;
  Future<Result<void>> call({DateTime? now}) async {
    final ensured = await _ensure.call(now: now);
    final List<QuestInstance> instances;
    switch (ensured) {
      case Ok(value: final value):
        instances = value;
      case Err(:final failure):
        return Err(failure);
    }
    for (final instance in instances.where(
      (i) =>
          i.objectiveType == QuestObjectiveType.adventureCompletions &&
          i.status != QuestStatus.claimed &&
          i.status != QuestStatus.expired,
    )) {
      final progress = instance.progress + 1;
      final saved = await _repository.saveInstance(
        instance.copyWith(
          progress: progress,
          status: progress >= instance.target
              ? QuestStatus.claimable
              : QuestStatus.inProgress,
        ),
      );
      if (saved case Err(:final failure)) return Err(failure);
    }
    return const Ok(null);
  }
}
