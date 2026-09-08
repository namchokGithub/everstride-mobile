import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/health_sync_repository.dart';

class HealthSyncRepositoryImpl implements HealthSyncRepository {
  HealthSyncRepositoryImpl(this._db);

  final AppDatabase _db;

  /// The stored primary key for a calendar date: `yyyy-MM-dd`, timezone-free.
  /// Zero-padding means lexicographic ordering equals chronological ordering,
  /// so `OrderingTerm.desc(t.date)` below still gives the most recent row.
  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Result<DateTime?>> getMostRecentSyncedDate() async {
    try {
      final query = _db.select(_db.healthDaily)
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(1);
      final row = await query.getSingleOrNull();
      return Ok(row == null ? null : DateTime.parse(row.date));
    } catch (e) {
      AppLogger.error('health.sync', 'Failed to read most recent synced date', e);
      return Err(Failure('Failed to read most recent synced date', cause: e));
    }
  }

  @override
  Future<Result<HealthDailyRecord?>> getRecord(DateTime date) async {
    try {
      final row = await (_db.select(_db.healthDaily)..where((t) => t.date.equals(_dateKey(date))))
          .getSingleOrNull();
      if (row == null) return const Ok(null);
      return Ok(HealthDailyRecord(
        date: DateTime.parse(row.date),
        totalSteps: row.totalSteps,
        rewardedSteps: row.rewardedSteps,
        lastSyncedAt: row.lastSyncedAt,
      ));
    } catch (e) {
      AppLogger.error('health.sync', 'Failed to read health_daily record for $date', e);
      return Err(Failure('Failed to read health_daily record', cause: e));
    }
  }

  @override
  Future<Result<bool>> upsertRecord(HealthDailyRecord record) async {
    try {
      await _db.into(_db.healthDaily).insertOnConflictUpdate(
            HealthDailyCompanion.insert(
              date: _dateKey(record.date),
              totalSteps: record.totalSteps,
              rewardedSteps: record.rewardedSteps,
              lastSyncedAt: record.lastSyncedAt,
            ),
          );
      AppLogger.debug('health.sync', 'Upserted health_daily row for ${record.date}');
      return const Ok(true);
    } catch (e) {
      AppLogger.error('health.sync', 'Failed to write health_daily record for ${record.date}', e);
      return Err(Failure('Failed to write health_daily record', cause: e));
    }
  }
}

final healthSyncRepositoryProvider = Provider<HealthSyncRepository>((ref) {
  return HealthSyncRepositoryImpl(ref.watch(appDatabaseProvider));
});
