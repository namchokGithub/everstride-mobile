import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/health_repository_impl.dart';

class HealthPermissionController extends Notifier<AsyncValue<Result<bool>>?> {
  @override
  AsyncValue<Result<bool>>? build() {
    // Recheck the real OS permission state on load, instead of assuming
    // "not requested" — the displayed status must never go stale relative
    // to what Health Connect actually has granted.
    _recheckCurrentStatus();
    return null;
  }

  Future<void> _recheckCurrentStatus() async {
    state = await AsyncValue.guard(
      () => ref.read(healthRepositoryProvider).hasPermission(),
    );
  }

  Future<void> requestPermission() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(healthRepositoryProvider).requestPermissions(),
    );
  }
}

final healthPermissionControllerProvider =
    NotifierProvider<HealthPermissionController, AsyncValue<Result<bool>>?>(
      HealthPermissionController.new,
    );
