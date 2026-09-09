import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/quest_definition.dart';
import '../../domain/entities/quest_instance.dart';
import '../../domain/repositories/quest_repository.dart';

class QuestRepositoryImpl implements QuestRepository {
  QuestRepositoryImpl(this._db);
  final AppDatabase _db;

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  QuestInstance _map(DailyQuestInstance row) => QuestInstance(
    id: row.id,
    questId: row.questId,
    date: DateTime.parse(row.date),
    objectiveType: QuestObjectiveType.values.byName(row.objectiveType),
    target: row.target,
    progress: row.progress,
    status: QuestStatus.values.byName(row.status),
    expReward: row.expReward,
    goldReward: row.goldReward,
    claimedAt: row.claimedAt,
  );

  @override
  Future<Result<List<QuestInstance>>> getInstancesForDate(DateTime date) async {
    try {
      final rows = await (_db.select(
        _db.dailyQuestInstances,
      )..where((t) => t.date.equals(_dateKey(date)))).get();
      return Ok(rows.map(_map).toList());
    } catch (e) {
      return Err(Failure('Failed to read quest instances', cause: e));
    }
  }

  @override
  Future<Result<QuestInstance?>> getInstanceById(String id) async {
    try {
      final row = await (_db.select(
        _db.dailyQuestInstances,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      return Ok(row == null ? null : _map(row));
    } catch (e) {
      return Err(Failure('Failed to read quest instance', cause: e));
    }
  }

  @override
  Future<Result<List<QuestInstance>>> getActiveInstancesBeforeDate(
    DateTime date,
  ) async {
    try {
      final rows =
          await (_db.select(_db.dailyQuestInstances)..where(
                (t) =>
                    t.date.isSmallerThanValue(_dateKey(date)) &
                    (t.status.equals(QuestStatus.inProgress.name) |
                        t.status.equals(QuestStatus.claimable.name)),
              ))
              .get();
      return Ok(rows.map(_map).toList());
    } catch (e) {
      return Err(Failure('Failed to read active quest instances', cause: e));
    }
  }

  @override
  Future<Result<bool>> saveInstance(QuestInstance instance) async {
    try {
      await _db
          .into(_db.dailyQuestInstances)
          .insertOnConflictUpdate(
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
      return const Ok(true);
    } catch (e) {
      AppLogger.error('quest.state', 'Failed to save quest instance', e);
      return Err(Failure('Failed to save quest instance', cause: e));
    }
  }
}

final questRepositoryProvider = Provider<QuestRepository>(
  (ref) => QuestRepositoryImpl(ref.watch(appDatabaseProvider)),
);
