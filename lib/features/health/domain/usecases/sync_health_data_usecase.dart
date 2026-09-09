import 'dart:math';

import '../../../../core/errors/result.dart';
import '../repositories/health_repository.dart';
import '../repositories/health_sync_repository.dart';

class DailySyncResult {
  const DailySyncResult({required this.date, required this.rewardableSteps});

  final DateTime date;
  final int rewardableSteps;

  @override
  bool operator ==(Object other) =>
      other is DailySyncResult &&
      other.date == date &&
      other.rewardableSteps == rewardableSteps;

  @override
  int get hashCode => Object.hash(date, rewardableSteps);

  @override
  String toString() =>
      'DailySyncResult(date: $date, rewardableSteps: $rewardableSteps)';
}

class SyncResult {
  const SyncResult({required this.totalNewRewardableSteps, required this.days});

  final int totalNewRewardableSteps;
  final List<DailySyncResult> days;
}

/// Walks forward from the last-synced date (or a capped catch-up window on
/// the very first sync) through today, safely computing
/// `rewardable = max(0, total - alreadyRewarded)` per date and storing it.
/// See everstride-docs/specs/2026-09-08-phase2-local-health-sync-design.md.
class SyncHealthDataUseCase {
  SyncHealthDataUseCase(this._healthRepository, this._syncRepository);

  final HealthRepository _healthRepository;
  final HealthSyncRepository _syncRepository;

  static const _firstSyncCatchUpDays = 7;

  Future<Result<SyncResult>> call({DateTime? now}) async {
    final resolvedNow = now ?? DateTime.now();
    final today = _atMidnight(resolvedNow);

    final sinceResult = await _syncRepository.getMostRecentSyncedDate();
    DateTime sinceDate;
    switch (sinceResult) {
      case Ok(value: final mostRecent):
        sinceDate = mostRecent != null
            ? _atMidnight(mostRecent)
            : DateTime(
                today.year,
                today.month,
                today.day - (_firstSyncCatchUpDays - 1),
              );
      case Err(:final failure):
        return Err(failure);
    }

    // A row dated in the future (e.g. left behind by manually moving the
    // device clock forward while testing day rollover) would otherwise make
    // the walk below never execute, wedging sync into a permanent no-op.
    if (sinceDate.isAfter(today)) {
      sinceDate = today;
    }

    final days = <DailySyncResult>[];
    var totalNewRewardableSteps = 0;

    // Calendar arithmetic via the DateTime constructor (not Duration) so a
    // DST transition can't drift the walk off local midnight — DateTime
    // normalizes month/year rollover for us.
    for (
      var date = sinceDate;
      !date.isAfter(today);
      date = DateTime(date.year, date.month, date.day + 1)
    ) {
      final stepsResult = await _healthRepository.getStepsForDate(date);
      final int totalSteps;
      switch (stepsResult) {
        case Ok(value: final v):
          totalSteps = v;
        case Err(:final failure):
          return days.isEmpty
              ? Err(failure)
              : Ok(
                  SyncResult(
                    totalNewRewardableSteps: totalNewRewardableSteps,
                    days: days,
                  ),
                );
      }

      final existingResult = await _syncRepository.getRecord(date);
      final HealthDailyRecord? existing;
      switch (existingResult) {
        case Ok(value: final v):
          existing = v;
        case Err(:final failure):
          return days.isEmpty
              ? Err(failure)
              : Ok(
                  SyncResult(
                    totalNewRewardableSteps: totalNewRewardableSteps,
                    days: days,
                  ),
                );
      }

      final rewardedSoFar = existing?.rewardedSteps ?? 0;
      final delta = max(0, totalSteps - rewardedSoFar);

      final upsertResult = await _syncRepository.upsertRecord(
        HealthDailyRecord(
          date: date,
          totalSteps: totalSteps,
          rewardedSteps: rewardedSoFar + delta,
          lastSyncedAt: resolvedNow,
        ),
      );
      if (upsertResult case Err(:final failure)) {
        return days.isEmpty
            ? Err(failure)
            : Ok(
                SyncResult(
                  totalNewRewardableSteps: totalNewRewardableSteps,
                  days: days,
                ),
              );
      }

      days.add(DailySyncResult(date: date, rewardableSteps: delta));
      totalNewRewardableSteps += delta;
    }

    return Ok(
      SyncResult(totalNewRewardableSteps: totalNewRewardableSteps, days: days),
    );
  }

  DateTime _atMidnight(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
