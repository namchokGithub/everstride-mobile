import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/health_repository_impl.dart';

class HealthPermissionController extends Notifier<AsyncValue<Result<bool>>?> {
  @override
  AsyncValue<Result<bool>>? build() => null;

  Future<void> requestPermission() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(healthRepositoryProvider).requestPermissions());
  }
}

final healthPermissionControllerProvider =
    NotifierProvider<HealthPermissionController, AsyncValue<Result<bool>>?>(HealthPermissionController.new);
