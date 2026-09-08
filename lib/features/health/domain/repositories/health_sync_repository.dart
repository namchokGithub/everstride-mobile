import '../../../../core/errors/result.dart';

class HealthDailyRecord {
  const HealthDailyRecord({
    required this.date,
    required this.totalSteps,
    required this.rewardedSteps,
    required this.lastSyncedAt,
  });

  final DateTime date;
  final int totalSteps;
  final int rewardedSteps;
  final DateTime lastSyncedAt;
}

/// Reads/writes the local `health_daily` table. Only called from
/// SyncHealthDataUseCase — never directly from UI.
abstract class HealthSyncRepository {
  Future<Result<int>> getTotalRewardedSteps();
  Future<Result<DateTime?>> getMostRecentSyncedDate();
  Future<Result<HealthDailyRecord?>> getRecord(DateTime date);
  Future<Result<bool>> upsertRecord(HealthDailyRecord record);
}
