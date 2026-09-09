import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../repositories/player_repository.dart';

/// Resolves an Adventure attempt using the caller-provided cost and rewards.
/// This use case owns Player-state updates, not Adventure content.
class SpendEnergyForAdventureUseCase {
  SpendEnergyForAdventureUseCase(this._playerRepository, this._db);

  final PlayerRepository _playerRepository;
  final AppDatabase _db;

  Future<Result<PlayerState>> call({
    required int energyCost,
    required int expReward,
    required int goldReward,
    int additionalGoldCost = 0,
  }) async {
    if (additionalGoldCost < 0) {
      return const Err(Failure('Invalid additional Gold cost'));
    }

    return _db.transaction(() async {
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
      if (player.gold < additionalGoldCost) {
        return const Err(Failure('Not enough Gold'));
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
        gold: player.gold - additionalGoldCost + goldReward,
      );

      final saveResult = await _playerRepository.savePlayer(updated);
      if (saveResult case Err(:final failure)) {
        return Err(failure);
      }

      return Ok(updated);
    });
  }
}
