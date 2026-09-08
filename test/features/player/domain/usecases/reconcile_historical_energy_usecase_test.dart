import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/repositories/health_sync_repository.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/domain/usecases/reconcile_historical_energy_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePlayerRepository implements PlayerRepository {
  _FakePlayerRepository(this.state);

  PlayerState state;

  @override
  Future<Result<PlayerState>> getPlayer() async => Ok(state);

  @override
  Future<Result<bool>> savePlayer(PlayerState player) async {
    state = player;
    return const Ok(true);
  }
}

class _FakeHealthSyncRepository implements HealthSyncRepository {
  _FakeHealthSyncRepository(this.totalRewardedSteps);

  final int totalRewardedSteps;

  @override
  Future<Result<int>> getTotalRewardedSteps() async => Ok(totalRewardedSteps);

  @override
  Future<Result<DateTime?>> getMostRecentSyncedDate() =>
      throw UnimplementedError();

  @override
  Future<Result<HealthDailyRecord?>> getRecord(DateTime date) =>
      throw UnimplementedError();

  @override
  Future<Result<bool>> upsertRecord(HealthDailyRecord record) =>
      throw UnimplementedError();
}

void main() {
  test(
    'credits historic rewarded steps exactly once for a new Player state',
    () async {
      final playerRepository = _FakePlayerRepository(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 0,
          gold: 0,
          pendingSteps: 0,
        ),
      );
      final useCase = ReconcileHistoricalEnergyUseCase(
        playerRepository,
        _FakeHealthSyncRepository(6670),
      );

      final result = await useCase.call();

      expect((result as Ok<int>).value, 66);
      expect(playerRepository.state.energy, 66);
      expect(playerRepository.state.pendingSteps, 70);
      expect(playerRepository.state.hasReconciledHistoricalSteps, isTrue);

      await useCase.call();
      expect(playerRepository.state.energy, 66);
      expect(playerRepository.state.pendingSteps, 70);
    },
  );
}
