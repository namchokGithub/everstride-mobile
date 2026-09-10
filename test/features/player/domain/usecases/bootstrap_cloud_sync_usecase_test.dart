import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/repositories/health_sync_repository.dart';
import 'package:everstride/features/player/domain/entities/cloud_game_snapshot.dart';
import 'package:everstride/features/player/domain/repositories/local_game_snapshot_repository.dart';
import 'package:everstride/features/player/domain/repositories/player_cloud_repository.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/domain/usecases/bootstrap_cloud_sync_usecase.dart';
import 'package:everstride/features/settings/domain/repositories/app_settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocalSnapshots implements LocalGameSnapshotRepository {
  _FakeLocalSnapshots(this.snapshot);
  CloudGameSnapshot snapshot;
  int replacements = 0;

  @override
  Future<Result<CloudGameSnapshot>> read() async => Ok(snapshot);

  @override
  Future<Result<bool>> replace(CloudGameSnapshot value) async {
    replacements++;
    snapshot = value;
    return const Ok(true);
  }
}

class _FakeCloud implements PlayerCloudRepository {
  _FakeCloud(this.remote);
  CloudGameSnapshot? remote;
  CloudGameSnapshot? pushed;

  @override
  Future<Result<CloudGameSnapshot?>> fetch(String userId) async => Ok(remote);

  @override
  Future<Result<bool>> push(String userId, CloudGameSnapshot snapshot) async {
    pushed = snapshot;
    return const Ok(true);
  }
}

class _FakeSettings implements AppSettingsRepository {
  String? linkedUserId;

  @override
  Future<Result<String?>> getLinkedCloudUserId() async => Ok(linkedUserId);

  @override
  Future<Result<bool>> setLinkedCloudUserId(String? userId) async {
    linkedUserId = userId;
    return const Ok(true);
  }

  @override
  Future<Result<bool>> getOnboardingCompleted() async => const Ok(false);

  @override
  Future<Result<bool>> setOnboardingCompleted(bool value) async =>
      const Ok(true);
}

CloudGameSnapshot _snapshot({
  int level = 1,
  bool hasReconciledHistoricalSteps = false,
  List<HealthDailyRecord> health = const [],
}) => CloudGameSnapshot(
  schemaVersion: CloudGameSnapshot.currentSchemaVersion,
  player: PlayerState(
    level: level,
    exp: 0,
    energy: 0,
    gold: 0,
    pendingSteps: 0,
    hasReconciledHistoricalSteps: hasReconciledHistoricalSteps,
  ),
  healthDaily: health,
  dailyQuestInstances: const [],
);

void main() {
  test(
    'a device without an account link never overwrites a remote backup',
    () async {
      // This is the fresh-install failure mode: Player initialization can set
      // this flag before cloud bootstrap, even though the device has no user
      // progress that is safe to upload over the existing account backup.
      final local = _FakeLocalSnapshots(
        _snapshot(hasReconciledHistoricalSteps: true),
      );
      final remote = _snapshot(
        level: 4,
        health: [
          HealthDailyRecord(
            date: DateTime(2026, 9, 10),
            totalSteps: 500,
            rewardedSteps: 500,
            lastSyncedAt: DateTime(2026, 9, 10, 8),
          ),
        ],
      );
      final cloud = _FakeCloud(remote);
      final settings = _FakeSettings();

      final result = await BootstrapCloudSyncUseCase(
        local,
        cloud,
        settings,
      ).call('user-a');

      expect(
        (result as Ok<BootstrapCloudSyncOutcome>).value,
        BootstrapCloudSyncOutcome.requiresRestoreOrOverwriteConfirmation,
      );
      expect(local.replacements, 0);
      expect(cloud.pushed, isNull);
      expect(settings.linkedUserId, isNull);

      final restored = await BootstrapCloudSyncUseCase(
        local,
        cloud,
        settings,
      ).restoreCloudBackup('user-a');
      expect(
        (restored as Ok<BootstrapCloudSyncOutcome>).value,
        BootstrapCloudSyncOutcome.restored,
      );
      expect(local.replacements, 1);
      expect(local.snapshot.player.level, 4);
      expect(local.snapshot.healthDaily.single.rewardedSteps, 500);
      expect(settings.linkedUserId, 'user-a');
    },
  );

  test('an absent remote save pushes the complete local snapshot', () async {
    final local = _FakeLocalSnapshots(_snapshot(level: 3));
    final cloud = _FakeCloud(null);
    final settings = _FakeSettings();

    final result = await BootstrapCloudSyncUseCase(
      local,
      cloud,
      settings,
    ).call('user-a');

    expect(
      (result as Ok<BootstrapCloudSyncOutcome>).value,
      BootstrapCloudSyncOutcome.pushed,
    );
    expect(cloud.pushed?.player.level, 3);
    expect(settings.linkedUserId, 'user-a');
  });

  test('the same linked account can back up its local snapshot', () async {
    final local = _FakeLocalSnapshots(_snapshot(level: 3));
    final cloud = _FakeCloud(_snapshot(level: 7));
    final settings = _FakeSettings()..linkedUserId = 'user-a';

    final result = await BootstrapCloudSyncUseCase(
      local,
      cloud,
      settings,
    ).call('user-a');

    expect(
      (result as Ok<BootstrapCloudSyncOutcome>).value,
      BootstrapCloudSyncOutcome.pushed,
    );
    expect(cloud.pushed?.player.level, 3);
    expect(local.replacements, 0);
  });

  test(
    'another linked account requires an explicit choice before any overwrite',
    () async {
      final local = _FakeLocalSnapshots(_snapshot(level: 3));
      final cloud = _FakeCloud(_snapshot(level: 7));
      final settings = _FakeSettings()..linkedUserId = 'user-a';
      final useCase = BootstrapCloudSyncUseCase(local, cloud, settings);

      final result = await useCase.call('user-b');

      expect(
        (result as Ok<BootstrapCloudSyncOutcome>).value,
        BootstrapCloudSyncOutcome.requiresRestoreOrOverwriteConfirmation,
      );
      expect(cloud.pushed, isNull);
      expect(local.replacements, 0);

      await useCase.confirmOverwrite('user-b');
      expect(cloud.pushed?.player.level, 3);
      expect(settings.linkedUserId, 'user-b');
    },
  );
}
