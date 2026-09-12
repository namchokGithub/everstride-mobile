import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/metrics/metrics_recorder.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../health/data/repositories/health_sync_repository_impl.dart';
import '../../../health/presentation/controllers/health_sync_controller.dart';
import '../../../player/data/repositories/player_repository_impl.dart';
import '../../../player/presentation/controllers/player_controller.dart';
import '../../data/repositories/quest_repository_impl.dart';
import '../../domain/entities/quest_instance.dart';
import '../../domain/usecases/claim_daily_quest_usecase.dart';
import '../../domain/usecases/ensure_daily_quests_usecase.dart';
import '../../domain/usecases/record_adventure_completion_usecase.dart';

final ensureDailyQuestsUseCaseProvider = Provider<EnsureDailyQuestsUseCase>(
  (ref) => EnsureDailyQuestsUseCase(
    ref.watch(questRepositoryProvider),
    ref.watch(healthSyncRepositoryProvider),
    ref.watch(metricsRecorderProvider),
  ),
);
final recordAdventureCompletionUseCaseProvider =
    Provider<RecordAdventureCompletionUseCase>(
      (ref) => RecordAdventureCompletionUseCase(
        ref.watch(questRepositoryProvider),
        ref.watch(ensureDailyQuestsUseCaseProvider),
      ),
    );
final claimDailyQuestUseCaseProvider = Provider<ClaimDailyQuestUseCase>(
  (ref) => ClaimDailyQuestUseCase(
    ref.watch(questRepositoryProvider),
    ref.watch(playerRepositoryProvider),
    ref.watch(appDatabaseProvider),
  ),
);

class QuestController
    extends Notifier<AsyncValue<Result<List<QuestInstance>>>?> {
  Future<void> _queue = Future.value();
  int _pending = 0;
  bool get isMutating => _pending > 0;

  @override
  AsyncValue<Result<List<QuestInstance>>>? build() {
    ref.listen(healthSyncControllerProvider, (_, next) {
      if (next is AsyncData) unawaited(_runExclusive(_refresh));
    });
    unawaited(_runExclusive(_refresh));
    return null;
  }

  Future<void> _refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(ensureDailyQuestsUseCaseProvider).call(),
    );
  }

  Future<T> _runExclusive<T>(Future<T> Function() action) {
    _pending++;
    final completer = Completer<T>();
    _queue = _queue.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stack) {
        completer.completeError(error, stack);
      } finally {
        _pending--;
      }
    });
    return completer.future;
  }

  Future<void> recordAdventureCompletion() => _runExclusive(() async {
    final result = await ref
        .read(recordAdventureCompletionUseCaseProvider)
        .call();
    if (result case Err(:final failure)) {
      AppLogger.error(
        'quest.state',
        'Failed to record Adventure completion',
        failure,
      );
    }
    await _refresh();
  });
  Future<Result<bool>> claim(QuestInstance instance) => _runExclusive(() async {
    final result = await ref
        .read(claimDailyQuestUseCaseProvider)
        .call(instance);
    if (result case Err(:final failure)) return Err(failure);
    final instanceId = instance.id;
    final questRepository = ref.read(questRepositoryProvider);
    ref
        .read(metricsRecorderProvider)
        .record(
          eventType: 'quest_claimed',
          buildPayload: () async {
            final storedResult = await questRepository.getInstanceById(
              instanceId,
            );
            final stored = switch (storedResult) {
              Ok(value: final value) => value,
              Err() => null,
            };
            if (stored == null) {
              AppLogger.error(
                'metrics.quest',
                'Could not read persisted quest for claim metric',
              );
              return null;
            }
            if (stored.id != instanceId ||
                stored.status != QuestStatus.claimed ||
                stored.claimedAt == null) {
              AppLogger.error(
                'metrics.quest',
                'Persisted quest was not claimed for claim metric',
              );
              return null;
            }
            return {
              'instanceId': stored.id,
              'questId': stored.questId,
              'date': _dateKey(stored.date),
              'expGranted': stored.expReward,
              'goldGranted': stored.goldReward,
            };
          },
        );
    await ref.read(playerControllerProvider.notifier).reload();
    await _refresh();
    return const Ok(true);
  });

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

final questControllerProvider =
    NotifierProvider<QuestController, AsyncValue<Result<List<QuestInstance>>>?>(
      QuestController.new,
    );
