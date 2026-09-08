import '../../../../core/errors/result.dart';
import '../repositories/player_repository.dart';

/// Converts newly-rewardable steps (from Phase 2's sync) into Energy,
/// banking any leftover remainder in `pendingSteps` so nothing is lost
/// across repeated small syncs. See
/// everstride-docs/specs/2026-09-08-phase3-player-progression-design.md.
class CreditEnergyFromStepsUseCase {
  CreditEnergyFromStepsUseCase(this._playerRepository);

  final PlayerRepository _playerRepository;

  static const stepsPerEnergy = 100;

  Future<Result<int>> call(int newRewardableSteps) async {
    final playerResult = await _playerRepository.getPlayer();
    final PlayerState player;
    switch (playerResult) {
      case Ok(value: final v):
        player = v;
      case Err(:final failure):
        return Err(failure);
    }

    final totalPending = player.pendingSteps + newRewardableSteps;
    final energyGained = totalPending ~/ stepsPerEnergy;
    final newPendingSteps = totalPending % stepsPerEnergy;

    final updated = player.copyWith(
      energy: player.energy + energyGained,
      pendingSteps: newPendingSteps,
    );

    final saveResult = await _playerRepository.savePlayer(updated);
    if (saveResult case Err(:final failure)) {
      return Err(failure);
    }

    return Ok(energyGained);
  }
}
