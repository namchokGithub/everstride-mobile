import '../../../../core/errors/result.dart';

/// Persists the next non-overlapping debug Health Connect step-record slot
/// for each calendar date. This is debug tooling only; it is not gameplay
/// state and never participates in rewards.
abstract class DebugStepSeedRepository {
  Future<Result<int>> claimNextSlot({
    required DateTime date,
    required int initialSlot,
  });
}
