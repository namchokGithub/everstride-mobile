import '../../../../core/errors/result.dart';

/// Persists the next non-overlapping, completed debug Health Connect
/// step-record slot for each calendar date. This is debug tooling only; it is
/// not gameplay state and never participates in rewards.
abstract class DebugStepSeedRepository {
  Future<Result<int>> claimLatestPastSlot({
    required DateTime date,
    required int latestAvailableSlot,
  });
}
