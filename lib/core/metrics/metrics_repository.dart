import '../errors/result.dart';

/// Write-only local event storage used for balancing observations.
abstract class MetricsRepository {
  Future<Result<bool>> logEvent({
    required String eventType,
    required Map<String, Object?> payload,
    required DateTime occurredAt,
  });
}
