import '../../../../core/errors/result.dart';
import '../../../settings/domain/repositories/app_settings_repository.dart';
import '../entities/cloud_game_snapshot.dart';
import '../repositories/local_game_snapshot_repository.dart';
import '../repositories/player_cloud_repository.dart';

enum BootstrapCloudSyncOutcome {
  restored,
  pushed,
  requiresRestoreOrOverwriteConfirmation,
}

class BootstrapCloudSyncUseCase {
  BootstrapCloudSyncUseCase(this._localSnapshots, this._cloud, this._settings);

  final LocalGameSnapshotRepository _localSnapshots;
  final PlayerCloudRepository _cloud;
  final AppSettingsRepository _settings;

  Future<Result<BootstrapCloudSyncOutcome>> call(String userId) async {
    final local = await _localSnapshots.read();
    if (local case Err(:final failure)) return Err(failure);
    final remote = await _cloud.fetch(userId);
    if (remote case Err(:final failure)) return Err(failure);
    final linkedUserId = await _settings.getLinkedCloudUserId();
    if (linkedUserId case Err(:final failure)) return Err(failure);

    final localSnapshot = (local as Ok<CloudGameSnapshot>).value;
    final remoteSnapshot = (remote as Ok<CloudGameSnapshot?>).value;
    final linkedId = (linkedUserId as Ok<String?>).value;
    // A remote save belongs to an account, not to this device. In particular,
    // a newly installed app has no linked ID, but startup reconciliation may
    // already have made its local snapshot non-pristine. Never let that local
    // state overwrite an existing account backup without an explicit choice.
    if (remoteSnapshot != null && linkedId != userId) {
      return const Ok(
        BootstrapCloudSyncOutcome.requiresRestoreOrOverwriteConfirmation,
      );
    }
    return _pushAndLink(userId, localSnapshot);
  }

  Future<Result<BootstrapCloudSyncOutcome>> restoreCloudBackup(
    String userId,
  ) async {
    final remote = await _cloud.fetch(userId);
    if (remote case Err(:final failure)) return Err(failure);
    final remoteSnapshot = (remote as Ok<CloudGameSnapshot?>).value;
    if (remoteSnapshot == null) {
      return const Err(Failure('Cloud backup is no longer available'));
    }
    final replaced = await _localSnapshots.replace(remoteSnapshot);
    if (replaced case Err(:final failure)) return Err(failure);
    return _linkAndReturn(userId, BootstrapCloudSyncOutcome.restored);
  }

  Future<Result<BootstrapCloudSyncOutcome>> confirmOverwrite(
    String userId,
  ) async {
    final local = await _localSnapshots.read();
    if (local case Err(:final failure)) return Err(failure);
    return _pushAndLink(userId, (local as Ok<CloudGameSnapshot>).value);
  }

  Future<Result<BootstrapCloudSyncOutcome>> _pushAndLink(
    String userId,
    CloudGameSnapshot snapshot,
  ) async {
    final pushed = await _cloud.push(userId, snapshot);
    if (pushed case Err(:final failure)) return Err(failure);
    return _linkAndReturn(userId, BootstrapCloudSyncOutcome.pushed);
  }

  Future<Result<BootstrapCloudSyncOutcome>> _linkAndReturn(
    String userId,
    BootstrapCloudSyncOutcome outcome,
  ) async {
    final linked = await _settings.setLinkedCloudUserId(userId);
    return switch (linked) {
      Ok() => Ok(outcome),
      Err(:final failure) => Err(failure),
    };
  }
}
