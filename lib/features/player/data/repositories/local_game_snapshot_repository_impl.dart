import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../health/domain/repositories/health_sync_repository.dart';
import '../../../quest/domain/entities/quest_definition.dart';
import '../../../quest/domain/entities/quest_instance.dart';
import '../../domain/entities/cloud_game_snapshot.dart';
import '../../domain/repositories/local_game_snapshot_repository.dart';
import '../../domain/repositories/player_repository.dart';

class LocalGameSnapshotRepositoryImpl implements LocalGameSnapshotRepository {
  LocalGameSnapshotRepositoryImpl(this._db);
  final AppDatabase _db;

  static const _playerId = 0;

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Result<CloudGameSnapshot>> read() async {
    try {
      final playerRow = await (_db.select(
        _db.player,
      )..where((table) => table.id.equals(_playerId))).getSingleOrNull();
      final healthRows = await _db.select(_db.healthDaily).get();
      final questRows = await _db.select(_db.dailyQuestInstances).get();
      return Ok(
        CloudGameSnapshot(
          schemaVersion: CloudGameSnapshot.currentSchemaVersion,
          player: playerRow == null
              ? const PlayerState(
                  level: 1,
                  exp: 0,
                  energy: 0,
                  gold: 0,
                  pendingSteps: 0,
                )
              : PlayerState(
                  level: playerRow.level,
                  exp: playerRow.exp,
                  energy: playerRow.energy,
                  gold: playerRow.gold,
                  pendingSteps: playerRow.pendingSteps,
                  hasReconciledHistoricalSteps:
                      playerRow.hasReconciledHistoricalSteps,
                ),
          healthDaily: healthRows
              .map(
                (row) => HealthDailyRecord(
                  date: DateTime.parse(row.date),
                  totalSteps: row.totalSteps,
                  rewardedSteps: row.rewardedSteps,
                  lastSyncedAt: row.lastSyncedAt,
                ),
              )
              .toList(),
          dailyQuestInstances: questRows
              .map(
                (row) => QuestInstance(
                  id: row.id,
                  questId: row.questId,
                  date: DateTime.parse(row.date),
                  objectiveType: QuestObjectiveType.values.byName(
                    row.objectiveType,
                  ),
                  target: row.target,
                  progress: row.progress,
                  status: QuestStatus.values.byName(row.status),
                  expReward: row.expReward,
                  goldReward: row.goldReward,
                  claimedAt: row.claimedAt,
                ),
              )
              .toList(),
        ),
      );
    } catch (e) {
      AppLogger.error('player.cloud', 'Failed to read local game snapshot', e);
      return Err(Failure('Failed to read local game snapshot', cause: e));
    }
  }

  @override
  Future<Result<bool>> replace(CloudGameSnapshot snapshot) async {
    if (snapshot.schemaVersion != CloudGameSnapshot.currentSchemaVersion) {
      return Err(Failure('Backup needs an app update'));
    }
    try {
      await _db.transaction(() async {
        await _db.delete(_db.healthDaily).go();
        await _db.delete(_db.dailyQuestInstances).go();
        await _db
            .into(_db.player)
            .insertOnConflictUpdate(
              PlayerCompanion(
                id: const Value(_playerId),
                level: Value(snapshot.player.level),
                exp: Value(snapshot.player.exp),
                energy: Value(snapshot.player.energy),
                gold: Value(snapshot.player.gold),
                pendingSteps: Value(snapshot.player.pendingSteps),
                hasReconciledHistoricalSteps: Value(
                  snapshot.player.hasReconciledHistoricalSteps,
                ),
              ),
            );
        for (final record in snapshot.healthDaily) {
          await _db
              .into(_db.healthDaily)
              .insert(
                HealthDailyCompanion.insert(
                  date: _dateKey(record.date),
                  totalSteps: record.totalSteps,
                  rewardedSteps: record.rewardedSteps,
                  lastSyncedAt: record.lastSyncedAt,
                ),
              );
        }
        for (final instance in snapshot.dailyQuestInstances) {
          await _db
              .into(_db.dailyQuestInstances)
              .insert(
                DailyQuestInstancesCompanion.insert(
                  id: instance.id,
                  questId: instance.questId,
                  date: _dateKey(instance.date),
                  objectiveType: instance.objectiveType.name,
                  target: instance.target,
                  progress: instance.progress,
                  status: instance.status.name,
                  expReward: instance.expReward,
                  goldReward: instance.goldReward,
                  claimedAt: Value(instance.claimedAt),
                ),
              );
        }
      });
      return const Ok(true);
    } catch (e) {
      AppLogger.error(
        'player.cloud',
        'Failed to replace local game snapshot',
        e,
      );
      return Err(Failure('Failed to restore local game snapshot', cause: e));
    }
  }
}

final localGameSnapshotRepositoryProvider =
    Provider<LocalGameSnapshotRepository>(
      (ref) => LocalGameSnapshotRepositoryImpl(ref.watch(appDatabaseProvider)),
    );
