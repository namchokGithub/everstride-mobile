import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/result.dart';
import '../utils/app_logger.dart';
import 'metrics_repository.dart';
import 'metrics_repository_impl.dart';

/// Best-effort instrumentation boundary. It intentionally never exposes a
/// Future to gameplay callers, so metrics cannot change gameplay outcomes.
class MetricsRecorder {
  MetricsRecorder(this._repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final MetricsRepository _repository;
  final DateTime Function() _clock;

  void record({
    required String eventType,
    required FutureOr<Map<String, Object?>?> Function() buildPayload,
    DateTime? now,
  }) {
    final DateTime occurredAt;
    try {
      occurredAt = now ?? _clock();
    } catch (error) {
      AppLogger.error(
        'metrics.recorder',
        'Failed to capture event time',
        error,
      );
      return;
    }

    // Future() defers even synchronous builders out of the gameplay call
    // stack. All paths below are caught, preventing an unhandled Future.
    unawaited(
      Future<void>(() async {
        try {
          final payload = await buildPayload();
          if (payload == null) return;
          final result = await _repository.logEvent(
            eventType: eventType,
            payload: {...payload, 'schemaVersion': 1},
            occurredAt: occurredAt,
          );
          if (result case Err(:final failure)) {
            AppLogger.error(
              'metrics.recorder',
              'Failed to record $eventType',
              failure,
            );
          }
        } catch (error) {
          AppLogger.error(
            'metrics.recorder',
            'Failed to record $eventType',
            error,
          );
        }
      }),
    );
  }
}

final metricsRecorderProvider = Provider<MetricsRecorder>((ref) {
  return MetricsRecorder(ref.watch(metricsRepositoryProvider));
});
