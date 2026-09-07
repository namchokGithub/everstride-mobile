import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

import '../../../../core/errors/result.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_connect_data_source.dart';

class HealthRepositoryImpl implements HealthRepository {
  HealthRepositoryImpl(this._dataSource);

  final HealthConnectDataSource _dataSource;

  @override
  Future<Result<bool>> isAvailable() async {
    try {
      final status = await _dataSource.getSdkStatus();
      return Ok(status == HealthConnectSdkStatus.sdkAvailable);
    } catch (e) {
      return Err(Failure('Failed to check Health Connect availability', cause: e));
    }
  }

  @override
  Future<Result<bool>> requestPermissions() async {
    try {
      if (await _dataSource.hasStepsPermission()) return const Ok(true);
      final granted = await _dataSource.requestStepsPermission();
      return Ok(granted);
    } catch (e) {
      return Err(Failure('Failed to request Health Connect permissions', cause: e));
    }
  }

  @override
  Future<Result<int>> getTodaySteps() => getStepsForDate(DateTime.now());

  @override
  Future<Result<int>> getStepsForDate(DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      final steps = await _dataSource.getTotalSteps(start: start, end: end);
      return Ok(steps);
    } catch (e) {
      return Err(Failure('Failed to read steps', cause: e));
    }
  }
}

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepositoryImpl(HealthConnectDataSource());
});
