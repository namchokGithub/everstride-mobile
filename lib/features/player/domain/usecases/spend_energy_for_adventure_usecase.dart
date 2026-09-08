import '../../../../core/errors/result.dart';
import '../repositories/player_repository.dart';

/// Temporary placeholder Adventure (Phase 4 replaces this with a real
/// Adventure system) — fixed cost/reward taken directly from the plan's
/// own Phase 4 example ("Forest Path"). See
/// everstride-docs/specs/2026-09-08-phase3-player-progression-design.md.
class SpendEnergyForAdventureUseCase {
  SpendEnergyForAdventureUseCase(this._playerRepository);

  final PlayerRepository _playerRepository;

  static const energyCost = 10;
  static const expReward = 25;
  static const goldReward = 10;

  Future<Result<PlayerState>> call() async {
    final playerResult = await _playerRepository.getPlayer();
    final PlayerState player;
    switch (playerResult) {
      case Ok(value: final v):
        player = v;
      case Err(:final failure):
        return Err(failure);
    }

    if (player.energy < energyCost) {
      return const Err(Failure('Not enough energy'));
    }

    var newExp = player.exp + expReward;
    var newLevel = player.level;
    var expToNext = PlayerState.expToNextLevel(newLevel);
    while (newExp >= expToNext) {
      newExp -= expToNext;
      newLevel++;
      expToNext = PlayerState.expToNextLevel(newLevel);
    }

    final updated = player.copyWith(
      energy: player.energy - energyCost,
      exp: newExp,
      level: newLevel,
      gold: player.gold + goldReward,
    );

    final saveResult = await _playerRepository.savePlayer(updated);
    if (saveResult case Err(:final failure)) {
      return Err(failure);
    }

    return Ok(updated);
  }
}
