import 'dart:async';

import 'package:everstride/core/errors/result.dart';
import 'package:everstride/core/metrics/metrics_recorder.dart';
import 'package:everstride/core/metrics/metrics_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _MetricsStore implements MetricsRepository {
  final events =
      <
        ({String eventType, Map<String, Object?> payload, DateTime occurredAt})
      >[];
  Object? error;
  Completer<void>? block;

  @override
  Future<Result<bool>> logEvent({
    required String eventType,
    required Map<String, Object?> payload,
    required DateTime occurredAt,
  }) async {
    await block?.future;
    if (error != null) throw error!;
    events.add((
      eventType: eventType,
      payload: payload,
      occurredAt: occurredAt,
    ));
    return const Ok(true);
  }
}

void main() {
  test(
    'defers work, injects schema version, and captures observation time',
    () async {
      final store = _MetricsStore();
      final recorder = MetricsRecorder(store);
      final occurredAt = DateTime(2026, 9, 10, 9);
      var builderRan = false;

      recorder.record(
        eventType: 'health_sync',
        now: occurredAt,
        buildPayload: () {
          builderRan = true;
          return {'totalNewRewardableSteps': 0};
        },
      );

      expect(builderRan, isFalse);
      await Future<void>.delayed(Duration.zero);
      expect(store.events, hasLength(1));
      expect(store.events.single.eventType, 'health_sync');
      expect(store.events.single.occurredAt, occurredAt);
      expect(store.events.single.payload, {
        'totalNewRewardableSteps': 0,
        'schemaVersion': 1,
      });
    },
  );

  test('skips null payloads and contains asynchronous failures', () async {
    final store = _MetricsStore()..error = StateError('closed');
    final recorder = MetricsRecorder(store);

    recorder.record(eventType: 'ignored', buildPayload: () => null);
    recorder.record(
      eventType: 'failed',
      buildPayload: () async => throw StateError('builder failed'),
    );
    recorder.record(eventType: 'storage_failed', buildPayload: () => {});

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(store.events, isEmpty);
  });
}
