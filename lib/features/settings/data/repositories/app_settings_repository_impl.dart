import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  AppSettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _settingsId = 0;

  @override
  Future<Result<bool>> getOnboardingCompleted() async {
    try {
      final row = await (_db.select(_db.appSettings)..where((t) => t.id.equals(_settingsId))).getSingleOrNull();
      return Ok(row?.onboardingCompleted ?? false);
    } catch (e) {
      AppLogger.error('settings.state', 'Failed to read onboarding status', e);
      return Err(Failure('Failed to read onboarding status', cause: e));
    }
  }

  @override
  Future<Result<bool>> setOnboardingCompleted(bool value) async {
    try {
      await _db.into(_db.appSettings).insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              id: Value(_settingsId),
              onboardingCompleted: Value(value),
            ),
          );
      AppLogger.debug('settings.state', 'Set onboardingCompleted=$value');
      return const Ok(true);
    } catch (e) {
      AppLogger.error('settings.state', 'Failed to save onboarding status', e);
      return Err(Failure('Failed to save onboarding status', cause: e));
    }
  }
}

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepositoryImpl(ref.watch(appDatabaseProvider));
});
