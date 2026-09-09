import '../../../../core/errors/result.dart';
import '../repositories/player_repository.dart';

/// Resolves an Adventure attempt using the caller-provided cost and rewards.
/// This use case owns Player-state updates, not Adventure content.
class SpendEnergyForAdventureUseCase {
  SpendEnergyForAdventureUseCase(this._playerRepository);

  final PlayerRepository _playerRepository;

  Future<Result<PlayerState>> call({
    required int energyCost,
    required int expReward,
    required int goldReward,
  }) async {
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
