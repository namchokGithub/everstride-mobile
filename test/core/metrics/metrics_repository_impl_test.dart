import 'dart:convert';

import 'package:drift/native.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/core/metrics/metrics_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late MetricsRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = MetricsRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test(
    'appends JSON events using the supplied instant and local date',
    () async {
      final occurredAt = DateTime(2026, 9, 10, 14, 30);

      final first = await repository.logEvent(
        eventType: 'health_sync',
        payload: {'totalNewRewardableSteps': 500},
        occurredAt: occurredAt,
      );
      final second = await repository.logEvent(
        eventType: 'energy_credited',
        payload: {'energyGained': 5},
        occurredAt: occurredAt,
      );

      expect(first, isA<Ok<bool>>());
      expect(second, isA<Ok<bool>>());
      final rows = await database.select(database.metricEvents).get();
      expect(rows, hasLength(2));
      expect(rows.first.occurredAt, occurredAt);
      expect(rows.first.localDate, '2026-09-10');
      expect(rows.first.eventType, 'health_sync');
      expect(jsonDecode(rows.first.payload), {'totalNewRewardableSteps': 500});
    },
  );
}
