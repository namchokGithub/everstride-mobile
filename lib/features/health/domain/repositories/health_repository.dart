import '../../../../core/errors/result.dart';

/// Abstracts Health Connect so UI/use cases never call it directly.
abstract class HealthRepository {
  Future<Result<bool>> isAvailable();
  Future<Result<bool>> promptInstallOrUpdate();
  Future<Result<bool>> hasPermission();
  Future<Result<bool>> requestPermissions();
  Future<Result<int>> getTodaySteps();
  Future<Result<int>> getStepsForDate(DateTime date);
}
