import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _playerId = 0;

  @override
  Future<Result<PlayerState>> getPlayer() async {
    try {
      final row =
          await (_db.select(_db.player)..where((t) => t.id.equals(_playerId))).getSingleOrNull();
      if (row == null) {
        return const Ok(PlayerState(level: 1, exp: 0, energy: 0, gold: 0, pendingSteps: 0));
      }
      return Ok(PlayerState(
        level: row.level,
        exp: row.exp,
        energy: row.energy,
        gold: row.gold,
        pendingSteps: row.pendingSteps,
      ));
    } catch (e) {
      AppLogger.error('player.state', 'Failed to read player state', e);
      return Err(Failure('Failed to read player state', cause: e));
    }
  }

  @override
  Future<Result<bool>> savePlayer(PlayerState player) async {
    try {
      await _db.into(_db.player).insertOnConflictUpdate(
            PlayerCompanion(
              id: Value(_playerId),
              level: Value(player.level),
              exp: Value(player.exp),
              energy: Value(player.energy),
              gold: Value(player.gold),
              pendingSteps: Value(player.pendingSteps),
            ),
          );
      AppLogger.debug(
        'player.state',
        'Saved player state: level=${player.level}, energy=${player.energy}',
      );
      return const Ok(true);
    } catch (e) {
      AppLogger.error('player.state', 'Failed to save player state', e);
      return Err(Failure('Failed to save player state', cause: e));
    }
  }
}

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepositoryImpl(ref.watch(appDatabaseProvider));
});
