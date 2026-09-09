import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/domain/usecases/spend_energy_for_adventure_usecase.dart';
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

void main() {
  test(
    'sufficient energy, no level-up: updates energy/exp/gold, level unchanged',
    () async {
      final repo = _FakePlayerRepository(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 20,
          gold: 0,
          pendingSteps: 0,
        ),
      );
      final useCase = SpendEnergyForAdventureUseCase(repo);

      final result = await useCase.call(
        energyCost: 10,
        expReward: 25,
        goldReward: 10,
      );
      final player = (result as Ok<PlayerState>).value;

      expect(player.energy, 10);
      expect(player.exp, 25);
      expect(player.gold, 10);
      expect(player.level, 1);
    },
  );

  test('sufficient energy, exactly enough exp to level up once', () async {
    final repo = _FakePlayerRepository(
      const PlayerState(
        level: 1,
        exp: 75,
        energy: 10,
        gold: 0,
        pendingSteps: 0,
      ),
    );
    final useCase = SpendEnergyForAdventureUseCase(repo);

    final result = await useCase.call(
      energyCost: 10,
      expReward: 25,
      goldReward: 10,
    );
    final player = (result as Ok<PlayerState>).value;

    expect(player.level, 2);
    expect(player.exp, 0);
  });

  test('a large reward crosses two level thresholds in one grant', () async {
    final repo = _FakePlayerRepository(
      const PlayerState(
        level: 1,
        exp: 280,
        energy: 10,
        gold: 0,
        pendingSteps: 0,
      ),
    );
    final useCase = SpendEnergyForAdventureUseCase(repo);

    final result = await useCase.call(
      energyCost: 10,
      expReward: 25,
      goldReward: 10,
    );
    final player = (result as Ok<PlayerState>).value;

    expect(player.level, 3);
    expect(player.exp, 5);
  });

  test(
    'insufficient energy returns Err and leaves player state unchanged',
    () async {
      final repo = _FakePlayerRepository(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 5,
          gold: 0,
          pendingSteps: 0,
        ),
      );
      final useCase = SpendEnergyForAdventureUseCase(repo);

      final result = await useCase.call(
        energyCost: 10,
        expReward: 25,
        goldReward: 10,
      );

      expect(result, isA<Err<PlayerState>>());
      expect(repo.state.energy, 5);
      expect(repo.state.exp, 0);
      expect(repo.state.gold, 0);
    },
  );

  test(
    'Normal-tier values apply exactly as given, not the old fixed values',
    () async {
      final repo = _FakePlayerRepository(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 20,
          gold: 0,
          pendingSteps: 0,
        ),
      );
      final useCase = SpendEnergyForAdventureUseCase(repo);

      final result = await useCase.call(
        energyCost: 20,
        expReward: 55,
        goldReward: 22,
      );
      final player = (result as Ok<PlayerState>).value;

      expect(player.energy, 0);
      expect(player.exp, 55);
      expect(player.gold, 22);
    },
  );

  test(
    'Hard-tier cost is rejected when energy only covers Normal tier',
    () async {
      final repo = _FakePlayerRepository(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 20,
          gold: 0,
          pendingSteps: 0,
        ),
      );
      final useCase = SpendEnergyForAdventureUseCase(repo);

      final result = await useCase.call(
        energyCost: 30,
        expReward: 90,
        goldReward: 36,
      );

      expect(result, isA<Err<PlayerState>>());
      expect(repo.state.energy, 20);
    },
  );
}
