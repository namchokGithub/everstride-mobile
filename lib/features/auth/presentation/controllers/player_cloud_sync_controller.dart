import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../health/presentation/controllers/health_sync_controller.dart';
import '../../../player/data/repositories/local_game_snapshot_repository_impl.dart';
import '../../../player/data/repositories/player_cloud_repository_impl.dart';
import '../../../player/domain/usecases/bootstrap_cloud_sync_usecase.dart';
import '../../../player/presentation/controllers/player_controller.dart';
import '../../../quest/presentation/controllers/quest_controller.dart';
import '../../../settings/data/repositories/app_settings_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';

enum CloudBackupState {
  unavailable,
  idle,
  syncing,
  backedUp,
  failed,
  confirmationRequired,
}

class CloudBackupStatus {
  const CloudBackupStatus(this.state, {this.message});
  const CloudBackupStatus.unavailable() : this(CloudBackupState.unavailable);
  const CloudBackupStatus.idle() : this(CloudBackupState.idle);
  const CloudBackupStatus.syncing() : this(CloudBackupState.syncing);
  const CloudBackupStatus.backedUp() : this(CloudBackupState.backedUp);
  const CloudBackupStatus.failed(String message)
    : this(CloudBackupState.failed, message: message);
  const CloudBackupStatus.confirmationRequired()
    : this(CloudBackupState.confirmationRequired);

  final CloudBackupState state;
  final String? message;
}

class PlayerCloudSyncController extends Notifier<CloudBackupStatus> {
  String? _bootstrappedUserId;
  bool _isBootstrapping = false;
  bool _isUploading = false;
  bool _uploadPending = false;

  @override
  CloudBackupStatus build() {
    final auth = ref.watch(authControllerProvider);
    final available = ref.watch(authRepositoryProvider).isAvailable;
    ref.listen<AuthUser?>(authControllerProvider, (_, user) {
      if (user == null) {
        _bootstrappedUserId = null;
        _uploadPending = false;
        state = available
            ? const CloudBackupStatus.idle()
            : const CloudBackupStatus.unavailable();
      } else {
        unawaited(_bootstrap(user));
      }
    });
    ref.listen(playerControllerProvider, (_, _) => _schedulePush());
    ref.listen(healthSyncControllerProvider, (_, _) => _schedulePush());
    ref.listen(questControllerProvider, (_, _) => _schedulePush());
    if (!available) return const CloudBackupStatus.unavailable();
    if (auth != null) unawaited(_bootstrap(auth));
    return const CloudBackupStatus.idle();
  }

  BootstrapCloudSyncUseCase? get _bootstrapUseCase {
    final cloud = ref.read(playerCloudRepositoryProvider);
    if (cloud == null) {
      return null;
    }
    return BootstrapCloudSyncUseCase(
      ref.read(localGameSnapshotRepositoryProvider),
      cloud,
      ref.read(appSettingsRepositoryProvider),
    );
  }

  Future<void> _bootstrap(AuthUser user) async {
    if (_isBootstrapping || _bootstrappedUserId == user.id) return;
    final useCase = _bootstrapUseCase;
    if (useCase == null) return;
    _isBootstrapping = true;
    state = const CloudBackupStatus.syncing();
    final result = await useCase.call(user.id);
    _isBootstrapping = false;
    switch (result) {
      case Ok(value: BootstrapCloudSyncOutcome.restored):
        _bootstrappedUserId = user.id;
        await ref.read(playerControllerProvider.notifier).reload();
        ref.invalidate(questControllerProvider);
        state = const CloudBackupStatus.backedUp();
      case Ok(value: BootstrapCloudSyncOutcome.pushed):
        _bootstrappedUserId = user.id;
        state = const CloudBackupStatus.backedUp();
      case Ok(
        value: BootstrapCloudSyncOutcome.requiresRestoreOrOverwriteConfirmation,
      ):
        state = const CloudBackupStatus.confirmationRequired();
      case Err(:final failure):
        AppLogger.error('player.cloud', 'Cloud bootstrap failed', failure);
        state = CloudBackupStatus.failed(failure.message);
    }
  }

  void _schedulePush() {
    final user = ref.read(authControllerProvider);
    if (user == null || _isBootstrapping || _bootstrappedUserId != user.id) {
      return;
    }
    if (state.state == CloudBackupState.confirmationRequired) return;
    _uploadPending = true;
    if (!_isUploading) unawaited(_drainUploads(user));
  }

  Future<void> _drainUploads(AuthUser user) async {
    _isUploading = true;
    while (_uploadPending) {
      _uploadPending = false;
      state = const CloudBackupStatus.syncing();
      final cloud = ref.read(playerCloudRepositoryProvider);
      if (cloud == null) {
        state = const CloudBackupStatus.unavailable();
        break;
      }
      final snapshot = await ref
          .read(localGameSnapshotRepositoryProvider)
          .read();
      if (snapshot case Err(:final failure)) {
        state = CloudBackupStatus.failed(failure.message);
        break;
      }
      if (ref.read(authControllerProvider)?.id != user.id) {
        break;
      }
      final pushed = await cloud.push(user.id, (snapshot as Ok).value);
      if (pushed case Err(:final failure)) {
        AppLogger.error('player.cloud', 'Cloud backup failed', failure);
        state = CloudBackupStatus.failed(failure.message);
        break;
      }
      state = const CloudBackupStatus.backedUp();
    }
    _isUploading = false;
  }

  Future<void> retry() async {
    final user = ref.read(authControllerProvider);
    if (user == null) return;
    if (_bootstrappedUserId != user.id) {
      await _bootstrap(user);
      return;
    }
    _schedulePush();
  }

  Future<void> confirmOverwrite() async {
    final user = ref.read(authControllerProvider);
    final useCase = _bootstrapUseCase;
    if (user == null ||
        useCase == null ||
        state.state != CloudBackupState.confirmationRequired) {
      return;
    }
    state = const CloudBackupStatus.syncing();
    final result = await useCase.confirmOverwrite(user.id);
    switch (result) {
      case Ok():
        _bootstrappedUserId = user.id;
        state = const CloudBackupStatus.backedUp();
      case Err(:final failure):
        state = CloudBackupStatus.failed(failure.message);
    }
  }

  Future<void> restoreCloudBackup() async {
    final user = ref.read(authControllerProvider);
    final useCase = _bootstrapUseCase;
    if (user == null ||
        useCase == null ||
        state.state != CloudBackupState.confirmationRequired) {
      return;
    }
    state = const CloudBackupStatus.syncing();
    final result = await useCase.restoreCloudBackup(user.id);
    switch (result) {
      case Ok():
        _bootstrappedUserId = user.id;
        await ref.read(playerControllerProvider.notifier).reload();
        ref.invalidate(questControllerProvider);
        state = const CloudBackupStatus.backedUp();
      case Err(:final failure):
        state = CloudBackupStatus.failed(failure.message);
    }
  }
}

final playerCloudSyncControllerProvider =
    NotifierProvider<PlayerCloudSyncController, CloudBackupStatus>(
      PlayerCloudSyncController.new,
    );
