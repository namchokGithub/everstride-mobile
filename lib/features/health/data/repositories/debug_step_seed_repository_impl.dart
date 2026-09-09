import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/debug_step_seed_repository.dart';

class DebugStepSeedRepositoryImpl implements DebugStepSeedRepository {
  DebugStepSeedRepositoryImpl(this._db);

  final AppDatabase _db;

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Result<int>> claimLatestPastSlot({
    required DateTime date,
    required int latestAvailableSlot,
  }) async {
    try {
      return await _db.transaction(() async {
        final key = _dateKey(date);
        final existing = await (_db.select(
          _db.debugStepSeedCursors,
        )..where((t) => t.date.equals(key))).getSingleOrNull();
        final storedSlot = existing?.nextSlot;
        if (storedSlot != null && storedSlot < 0) {
          return const Err(
            Failure('No debug step time slots remain for this date.'),
          );
        }

        // Earlier debug builds stored a forward-moving cursor. Clamp it to
        // the latest completed slot when first using the backward strategy.
        final slot = storedSlot == null || storedSlot > latestAvailableSlot
            ? latestAvailableSlot
            : storedSlot;
        await _db
            .into(_db.debugStepSeedCursors)
            .insertOnConflictUpdate(
              DebugStepSeedCursorsCompanion.insert(
                date: key,
                nextSlot: slot - 1,
              ),
            );
        return Ok(slot);
      });
    } catch (e) {
      AppLogger.error('health.debug', 'Failed to claim a debug step slot', e);
      return Err(Failure('Failed to prepare test steps', cause: e));
    }
  }
}

final debugStepSeedRepositoryProvider = Provider<DebugStepSeedRepository>((
  ref,
) {
  return DebugStepSeedRepositoryImpl(ref.watch(appDatabaseProvider));
});
