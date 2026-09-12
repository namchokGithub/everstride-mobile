import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../errors/result.dart';
import '../utils/app_logger.dart';
import 'metrics_repository.dart';

class MetricsRepositoryImpl implements MetricsRepository {
  MetricsRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Result<bool>> logEvent({
    required String eventType,
    required Map<String, Object?> payload,
    required DateTime occurredAt,
  }) async {
    try {
      await _database
          .into(_database.metricEvents)
          .insert(
            MetricEventsCompanion.insert(
              occurredAt: occurredAt,
              localDate: _dateKey(occurredAt.toLocal()),
              eventType: eventType,
              payload: jsonEncode(payload),
            ),
          );
      return const Ok(true);
    } catch (error) {
      AppLogger.error('metrics.storage', 'Failed to store metric event', error);
      return Err(Failure('Failed to store metric event', cause: error));
    }
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

final metricsRepositoryProvider = Provider<MetricsRepository>((ref) {
  return MetricsRepositoryImpl(ref.watch(appDatabaseProvider));
});
