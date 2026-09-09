import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
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
    await ref.read(playerControllerProvider.notifier).reload();
    await _refresh();
    return const Ok(true);
  });
}

final questControllerProvider =
    NotifierProvider<QuestController, AsyncValue<Result<List<QuestInstance>>>?>(
      QuestController.new,
    );
