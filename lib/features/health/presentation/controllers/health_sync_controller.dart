import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/metrics/metrics_recorder.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/repositories/health_repository_impl.dart';
import '../../data/repositories/health_sync_repository_impl.dart';
import '../../domain/usecases/sync_health_data_usecase.dart';

final syncHealthDataUseCaseProvider = Provider<SyncHealthDataUseCase>((ref) {
  return SyncHealthDataUseCase(
    ref.watch(healthRepositoryProvider),
    ref.watch(healthSyncRepositoryProvider),
  );
});

class HealthSyncController extends Notifier<AsyncValue<Result<SyncResult>>?> {
  @override
  AsyncValue<Result<SyncResult>>? build() => null;

  Future<void> sync() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(syncHealthDataUseCaseProvider).call(),
    );
    if (result case AsyncData(value: Ok(:final value))) {
      final days = value.days
          .map(
            (day) => <String, Object>{
              'date': _dateKey(day.date),
              'rewardableSteps': day.rewardableSteps,
            },
          )
          .toList(growable: false);
      ref
          .read(metricsRecorderProvider)
          .record(
            eventType: 'health_sync',
            buildPayload: () => {
              'totalNewRewardableSteps': value.totalNewRewardableSteps,
              'dayCount': days.length,
              'days': days,
            },
          );
      AppLogger.debug(
        'health.sync',
        'Synced ${value.days.length} day(s), +${value.totalNewRewardableSteps} rewardable steps',
      );
    } else if (result case AsyncData(value: Err(:final failure))) {
      AppLogger.error('health.sync', 'Sync failed', failure);
    }
    state = result;
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

final healthSyncControllerProvider =
    NotifierProvider<HealthSyncController, AsyncValue<Result<SyncResult>>?>(
      HealthSyncController.new,
    );
