import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../health/data/repositories/health_sync_repository_impl.dart';
import '../../../health/presentation/controllers/health_sync_controller.dart';
import '../../data/repositories/player_repository_impl.dart';
import '../../domain/repositories/player_repository.dart';
import '../../domain/usecases/credit_energy_from_steps_usecase.dart';
import '../../domain/usecases/reconcile_historical_energy_usecase.dart';
import '../../domain/usecases/spend_energy_for_adventure_usecase.dart';

final creditEnergyFromStepsUseCaseProvider =
    Provider<CreditEnergyFromStepsUseCase>((ref) {
      return CreditEnergyFromStepsUseCase(ref.watch(playerRepositoryProvider));
    });

final spendEnergyForAdventureUseCaseProvider =
    Provider<SpendEnergyForAdventureUseCase>((ref) {
      return SpendEnergyForAdventureUseCase(
        ref.watch(playerRepositoryProvider),
      );
    });

final reconcileHistoricalEnergyUseCaseProvider =
    Provider<ReconcileHistoricalEnergyUseCase>((ref) {
      return ReconcileHistoricalEnergyUseCase(
        ref.watch(playerRepositoryProvider),
        ref.watch(healthSyncRepositoryProvider),
      );
    });

class PlayerController extends Notifier<AsyncValue<Result<PlayerState>>?> {
  Future<void> _mutationQueue = Future.value();
  int _pendingMutations = 0;

  bool get isMutating => _pendingMutations > 0;

  @override
  AsyncValue<Result<PlayerState>>? build() {
    // Reactive composition with Phase 2: credit energy automatically
    // whenever a sync completes with new rewardable steps, from any
    // trigger — no changes to HealthSyncController/the health feature.
    ref.listen(healthSyncControllerProvider, (previous, next) {
      if (next case AsyncData(value: Ok(:final value))
          when value.totalNewRewardableSteps > 0) {
        _runExclusive(() => _creditEnergy(value.totalNewRewardableSteps));
      }
    });
    _initializePlayer();
    return null;
  }

  Future<void> _loadPlayer() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(playerRepositoryProvider).getPlayer(),
    );
  }

  Future<void> reload() => _loadPlayer();

  Future<void> _initializePlayer() async {
    await _runExclusive(() async {
      final result = await ref
          .read(reconcileHistoricalEnergyUseCaseProvider)
          .call();
      if (result case Err(:final failure)) {
        AppLogger.error(
          'player.state',
          'Failed to reconcile historical energy',
          failure,
        );
      }
      await _loadPlayer();
    });
  }

  Future<void> _creditEnergy(int newRewardableSteps) async {
    final result = await ref
        .read(creditEnergyFromStepsUseCaseProvider)
        .call(newRewardableSteps);
    if (result case Err(:final failure)) {
      AppLogger.error(
        'player.state',
        'Failed to credit energy from steps',
        failure,
      );
      return;
    }
    await _loadPlayer();
  }

  /// Runs [action] only after any already-queued mutation finishes, so
  /// concurrent credit/spend calls never interleave their read-modify-write
  /// of the single player row (each fully completes, including its own
  /// getPlayer/savePlayer round trip, before the next one starts).
  Future<T> _runExclusive<T>(Future<T> Function() action) {
    _pendingMutations++;
    final previous = _mutationQueue;
    final completer = Completer<T>();
    _mutationQueue = previous.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      } finally {
        _pendingMutations--;
      }
    });
    return completer.future;
  }

  /// Returns the spend result so the caller can show "not enough energy"
  /// feedback; on success, also refreshes the persisted player state.
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
  }) {
    return _runExclusive(() async {
      final result = await ref
          .read(spendEnergyForAdventureUseCaseProvider)
          .call(
            energyCost: energyCost,
            expReward: expReward,
            goldReward: goldReward,
          );
      if (result case Ok()) {
        await _loadPlayer();
      }
      return result;
    });
  }
}

final playerControllerProvider =
    NotifierProvider<PlayerController, AsyncValue<Result<PlayerState>>?>(
      PlayerController.new,
    );
