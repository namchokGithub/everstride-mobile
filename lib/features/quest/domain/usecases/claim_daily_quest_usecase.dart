import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../player/domain/repositories/player_repository.dart';
import '../entities/quest_instance.dart';
import '../repositories/quest_repository.dart';

class _ClaimFailure implements Exception {
  _ClaimFailure(this.failure);
  final Failure failure;
}

class ClaimDailyQuestUseCase {
  ClaimDailyQuestUseCase(
    this._questRepository,
    this._playerRepository,
    this._db,
  );
  final QuestRepository _questRepository;
  final PlayerRepository _playerRepository;
  final AppDatabase _db;

  Future<Result<PlayerState>> call(QuestInstance instance) async {
    try {
      return await _db.transaction(() async {
        final storedResult = await _questRepository.getInstanceById(
          instance.id,
        );
        final QuestInstance? stored;
        switch (storedResult) {
          case Ok(value: final value):
            stored = value;
          case Err(:final failure):
            throw _ClaimFailure(failure);
        }
        if (stored == null || stored.status != QuestStatus.claimable) {
          throw _ClaimFailure(
            const Failure('This quest cannot be claimed right now'),
          );
        }
        final playerResult = await _playerRepository.getPlayer();
        final PlayerState player;
        switch (playerResult) {
          case Ok(value: final value):
            player = value;
          case Err(:final failure):
            throw _ClaimFailure(failure);
        }
        var exp = player.exp + stored.expReward;
        var level = player.level;
        while (exp >= PlayerState.expToNextLevel(level)) {
          exp -= PlayerState.expToNextLevel(level);
          level++;
        }
        final updated = player.copyWith(
          level: level,
          exp: exp,
          gold: player.gold + stored.goldReward,
        );
        final playerSaved = await _playerRepository.savePlayer(updated);
        if (playerSaved case Err(:final failure)) throw _ClaimFailure(failure);
        final questSaved = await _questRepository.saveInstance(
          stored.copyWith(
            status: QuestStatus.claimed,
            claimedAt: DateTime.now(),
          ),
        );
        if (questSaved case Err(:final failure)) throw _ClaimFailure(failure);
        return Ok(updated);
      });
    } on _ClaimFailure catch (error) {
      return Err(error.failure);
    } catch (error) {
      return Err(Failure('Failed to claim quest', cause: error));
    }
  }
}
