import '../../../../core/errors/result.dart';
import '../../../health/domain/repositories/health_sync_repository.dart';
import '../repositories/player_repository.dart';
import 'credit_energy_from_steps_usecase.dart';

/// Credits health-sync rewards created before a Player row existed.
///
/// The migration is intentionally one-time and only applies to a pristine
/// player, so upgrading an already-progressing player cannot duplicate energy.
class ReconcileHistoricalEnergyUseCase {
  ReconcileHistoricalEnergyUseCase(
    this._playerRepository,
    this._healthSyncRepository,
  );

  final PlayerRepository _playerRepository;
  final HealthSyncRepository _healthSyncRepository;

  Future<Result<int>> call() async {
    final playerResult = await _playerRepository.getPlayer();
    final PlayerState player;
    switch (playerResult) {
      case Ok(value: final value):
        player = value;
      case Err(:final failure):
        return Err(failure);
    }

    if (player.hasReconciledHistoricalSteps) return const Ok(0);

    if (!_isPristine(player)) {
      final saveResult = await _playerRepository.savePlayer(
        player.copyWith(hasReconciledHistoricalSteps: true),
      );
      return switch (saveResult) {
        Ok() => const Ok(0),
        Err(:final failure) => Err(failure),
      };
    }

    final stepsResult = await _healthSyncRepository.getTotalRewardedSteps();
    final int historicSteps;
    switch (stepsResult) {
      case Ok(value: final value):
        historicSteps = value;
      case Err(:final failure):
        return Err(failure);
    }

    final totalPending = player.pendingSteps + historicSteps;
    final energyGained =
        totalPending ~/ CreditEnergyFromStepsUseCase.stepsPerEnergy;
    final updated = player.copyWith(
      energy: player.energy + energyGained,
      pendingSteps: totalPending % CreditEnergyFromStepsUseCase.stepsPerEnergy,
      hasReconciledHistoricalSteps: true,
    );
    final saveResult = await _playerRepository.savePlayer(updated);
    return switch (saveResult) {
      Ok() => Ok(energyGained),
      Err(:final failure) => Err(failure),
    };
  }

  bool _isPristine(PlayerState player) {
    return player.level == 1 &&
        player.exp == 0 &&
        player.energy == 0 &&
        player.gold == 0 &&
        player.pendingSteps == 0;
  }
}
