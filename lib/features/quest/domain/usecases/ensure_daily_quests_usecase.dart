import '../../../../core/errors/result.dart';
import '../../../../core/metrics/metrics_recorder.dart';
import '../../../health/domain/repositories/health_sync_repository.dart';
import '../entities/quest_definition.dart';
import '../entities/quest_instance.dart';
import '../quest_catalog.dart';
import '../repositories/quest_repository.dart';

class EnsureDailyQuestsUseCase {
  EnsureDailyQuestsUseCase(
    this._questRepository,
    this._healthSyncRepository, [
    this._metricsRecorder,
  ]);
  final QuestRepository _questRepository;
  final HealthSyncRepository _healthSyncRepository;
  final MetricsRecorder? _metricsRecorder;

  Future<Result<List<QuestInstance>>> call({DateTime? now}) async {
    final today = _midnight(now ?? DateTime.now());
    final staleResult = await _questRepository.getActiveInstancesBeforeDate(
      today,
    );
    switch (staleResult) {
      case Err(:final failure):
        return Err(failure);
      case Ok(value: final stale):
        final expired = <QuestInstance>[];
        for (final instance in stale) {
          final saved = await _questRepository.saveInstance(
            instance.copyWith(status: QuestStatus.expired),
          );
          if (saved case Err(:final failure)) {
            _recordRollover(today, expired);
            return Err(failure);
          }
          expired.add(instance);
        }
        _recordRollover(today, expired);
    }
    final existingResult = await _questRepository.getInstancesForDate(today);
    final List<QuestInstance> existing;
    switch (existingResult) {
      case Ok(value: final value):
        existing = value;
      case Err(:final failure):
        return Err(failure);
    }
    final ids = existing.map((instance) => instance.questId).toSet();
    for (final definition in dailyQuestCatalog) {
      if (ids.contains(definition.id)) continue;
      final saved = await _questRepository.saveInstance(
        QuestInstance(
          id: '${_dateKey(today)}_${definition.id}',
          questId: definition.id,
          date: today,
          objectiveType: definition.objectiveType,
          target: definition.target,
          progress: 0,
          status: QuestStatus.inProgress,
          expReward: definition.expReward,
          goldReward: definition.goldReward,
        ),
      );
      if (saved case Err(:final failure)) return Err(failure);
    }
    final healthResult = await _healthSyncRepository.getRecord(today);
    final int totalSteps;
    switch (healthResult) {
      case Ok(value: final record):
        totalSteps = record?.totalSteps ?? 0;
      case Err(:final failure):
        return Err(failure);
    }
    final instancesResult = await _questRepository.getInstancesForDate(today);
    final List<QuestInstance> instances;
    switch (instancesResult) {
      case Ok(value: final value):
        instances = value;
      case Err(:final failure):
        return Err(failure);
    }
    final refreshed = <QuestInstance>[];
    for (final instance in instances) {
      if (instance.status == QuestStatus.claimed ||
          instance.status == QuestStatus.expired) {
        refreshed.add(instance);
        continue;
      }
      final progress = instance.objectiveType == QuestObjectiveType.dailySteps
          ? totalSteps
          : instance.progress;
      final updated = instance.copyWith(
        progress: progress,
        status: progress >= instance.target
            ? QuestStatus.claimable
            : QuestStatus.inProgress,
      );
      final saved = await _questRepository.saveInstance(updated);
      if (saved case Err(:final failure)) return Err(failure);
      refreshed.add(updated);
    }
    return Ok(refreshed);
  }

  DateTime _midnight(DateTime value) =>
      DateTime(value.year, value.month, value.day);
  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  void _recordRollover(DateTime rolloverDate, List<QuestInstance> expired) {
    if (expired.isEmpty) return;
    final instances = expired
        .map(
          (instance) => <String, Object>{
            'instanceId': instance.id,
            'questId': instance.questId,
            'date': _dateKey(instance.date),
            'previousStatus': instance.status.name,
            'progress': instance.progress,
            'target': instance.target,
          },
        )
        .toList(growable: false);
    _metricsRecorder?.record(
      eventType: 'quest_rollover',
      buildPayload: () => {
        'rolloverDate': _dateKey(rolloverDate),
        'expiredCount': instances.length,
        'instances': instances,
      },
    );
  }
}
