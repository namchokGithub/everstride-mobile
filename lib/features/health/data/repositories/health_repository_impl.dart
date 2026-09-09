import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_connect_data_source.dart';

class HealthRepositoryImpl implements HealthRepository {
  HealthRepositoryImpl(this._dataSource);

  final HealthConnectDataSource _dataSource;

  @override
  Future<Result<bool>> isAvailable() async {
    try {
      final status = await _dataSource.getSdkStatus();
      final available = status == HealthConnectSdkStatus.sdkAvailable;
      AppLogger.debug(
        'health.availability',
        'Health Connect status: $status (available: $available)',
      );
      return Ok(available);
    } catch (e) {
      AppLogger.error(
        'health.availability',
        'Failed to check Health Connect availability',
        e,
      );
      return Err(
        Failure('Failed to check Health Connect availability', cause: e),
      );
    }
  }

  @override
  Future<Result<bool>> promptInstallOrUpdate() async {
    try {
      await _dataSource.promptInstallOrUpdate();
      AppLogger.debug(
        'health.availability',
        'Opened Health Connect install/update flow',
      );
      return const Ok(true);
    } catch (e) {
      AppLogger.error(
        'health.availability',
        'Failed to open Health Connect install/update',
        e,
      );
      return Err(
        Failure('Failed to open Health Connect install/update', cause: e),
      );
    }
  }

  @override
  Future<Result<bool>> hasPermission() async {
    try {
      final granted = await _dataSource.hasStepsPermission();
      AppLogger.debug(
        'health.permission',
        'Current steps permission status: $granted',
      );
      return Ok(granted);
    } catch (e) {
      AppLogger.error(
        'health.permission',
        'Failed to check current permission status',
        e,
      );
      return Err(Failure('Failed to check permission status', cause: e));
    }
  }

  @override
  Future<Result<bool>> requestPermissions() async {
    try {
      if (await _dataSource.hasStepsPermission()) {
        AppLogger.debug(
          'health.permission',
          'Steps permission already granted',
        );
        return const Ok(true);
      }
      final granted = await _dataSource.requestStepsPermission();
      AppLogger.debug(
        'health.permission',
        'Steps permission request result: $granted',
      );
      return Ok(granted);
    } catch (e) {
      AppLogger.error(
        'health.permission',
        'Failed to request Health Connect permissions',
        e,
      );
      return Err(
        Failure('Failed to request Health Connect permissions', cause: e),
      );
    }
  }

  @override
  Future<Result<int>> getTodaySteps() => getStepsForDate(DateTime.now());

  @override
  Future<Result<int>> getStepsForDate(DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      // Calendar arithmetic, not Duration: adding 24 absolute hours lands off
      // midnight across a DST transition (a 23- or 25-hour local day).
      final end = DateTime(start.year, start.month, start.day + 1);
      final steps = await _dataSource.getTotalSteps(start: start, end: end);
      AppLogger.debug(
        'health.query',
        'Read $steps steps for ${start.toIso8601String().split('T').first}',
      );
      return Ok(steps);
    } catch (e) {
      AppLogger.error(
        'health.query',
        'Failed to read steps for ${date.toIso8601String().split('T').first}',
        e,
      );
      return Err(Failure('Failed to read steps', cause: e));
    }
  }
}

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepositoryImpl(HealthConnectDataSource());
});
