import 'package:flutter_test/flutter_test.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/domain/usecases/credit_energy_from_steps_usecase.dart';

class _FakePlayerRepository implements PlayerRepository {
  _FakePlayerRepository([PlayerState? initial])
    : state =
          initial ??
          const PlayerState(
            level: 1,
            exp: 0,
            energy: 0,
            gold: 0,
            pendingSteps: 0,
          );

  PlayerState state;

  @override
  Future<Result<PlayerState>> getPlayer() async => Ok(state);

  @override
  Future<Result<bool>> savePlayer(PlayerState player) async {
    state = player;
    return const Ok(true);
  }
}

void main() {
  test(
    '250 new steps with 0 pending grants 2 energy, banks 50 pending',
    () async {
      final repo = _FakePlayerRepository();
      final useCase = CreditEnergyFromStepsUseCase(repo);

      final result = await useCase.call(250);

      expect((result as Ok<int>).value, 2);
      expect(repo.state.energy, 2);
      expect(repo.state.pendingSteps, 50);
    },
  );

  test(
    '50 new steps with 70 pending grants 1 energy, banks 20 pending',
    () async {
      final repo = _FakePlayerRepository(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 0,
          gold: 0,
          pendingSteps: 70,
        ),
      );
      final useCase = CreditEnergyFromStepsUseCase(repo);

      final result = await useCase.call(50);

      expect((result as Ok<int>).value, 1);
      expect(repo.state.energy, 1);
      expect(repo.state.pendingSteps, 20);
    },
  );

  test('0 new steps is a no-op', () async {
    final repo = _FakePlayerRepository();
    final useCase = CreditEnergyFromStepsUseCase(repo);

    final result = await useCase.call(0);

    expect((result as Ok<int>).value, 0);
    expect(repo.state.energy, 0);
    expect(repo.state.pendingSteps, 0);
  });

  test(
    'repeated small syncs accumulate the same energy as one combined sync',
    () async {
      final repoRepeated = _FakePlayerRepository();
      final useCaseRepeated = CreditEnergyFromStepsUseCase(repoRepeated);
      await useCaseRepeated.call(30);
      await useCaseRepeated.call(30);
      await useCaseRepeated.call(30);

      final repoCombined = _FakePlayerRepository();
      final useCaseCombined = CreditEnergyFromStepsUseCase(repoCombined);
      await useCaseCombined.call(90);

      expect(repoRepeated.state.energy, repoCombined.state.energy);
      expect(repoRepeated.state.pendingSteps, repoCombined.state.pendingSteps);
    },
  );
}
