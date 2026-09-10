import '../../../../core/errors/result.dart';

/// Reads and writes the single local app-settings row.
abstract class AppSettingsRepository {
  Future<Result<bool>> getOnboardingCompleted();
  Future<Result<bool>> setOnboardingCompleted(bool value);
  Future<Result<String?>> getLinkedCloudUserId();
  Future<Result<bool>> setLinkedCloudUserId(String? userId);
}
