import 'package:health/health.dart';

/// Thin wrapper around the `health` package's Health Connect calls.
class HealthConnectDataSource {
  HealthConnectDataSource({Health? health}) : _health = health ?? Health();

  final Health _health;

  static const _dataTypes = [HealthDataType.STEPS];
  static const _access = [HealthDataAccess.READ];

  Future<HealthConnectSdkStatus> getSdkStatus() async {
    return await _health.getHealthConnectSdkStatus() ??
        HealthConnectSdkStatus.sdkUnavailable;
  }

  Future<void> promptInstallOrUpdate() => _health.installHealthConnect();

  Future<bool> hasStepsPermission() async {
    return await _health.hasPermissions(_dataTypes, permissions: _access) ??
        false;
  }

  Future<bool> requestStepsPermission() {
    return _health.requestAuthorization(_dataTypes, permissions: _access);
  }

  Future<int> getTotalSteps({
    required DateTime start,
    required DateTime end,
  }) async {
    return await _health.getTotalStepsInInterval(start, end) ?? 0;
  }
}
