import 'package:flutter_test/flutter_test.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/domain/usecases/spend_energy_for_adventure_usecase.dart';

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
  test('sufficient energy, no level-up: updates energy/exp/gold, level unchanged', () async {
    final repo = _FakePlayerRepository(
      const PlayerState(level: 1, exp: 0, energy: 20, gold: 0, pendingSteps: 0),
    );
    final useCase = SpendEnergyForAdventureUseCase(repo);

    final result = await useCase.call();
    final player = (result as Ok<PlayerState>).value;

    expect(player.energy, 10);
    expect(player.exp, 25);
    expect(player.gold, 10);
    expect(player.level, 1);
  });

  test('sufficient energy, exactly enough exp to level up once', () async {
    // Level 1 needs 100 exp to reach level 2. Starting at 75 + 25 reward = exactly 100.
    final repo = _FakePlayerRepository(
      const PlayerState(level: 1, exp: 75, energy: 10, gold: 0, pendingSteps: 0),
    );
    final useCase = SpendEnergyForAdventureUseCase(repo);

    final result = await useCase.call();
    final player = (result as Ok<PlayerState>).value;

    expect(player.level, 2);
    expect(player.exp, 0);
  });

  test('a large reward crosses two level thresholds in one grant', () async {
    // This starting exp (280) is a deliberately synthetic edge case chosen
    // to exercise the while-loop's multi-level-up path — a fixed +25
    // reward per call can never naturally reach this state through normal
    // play (each call always leaves exp below the next threshold), but the
    // use case must still handle it correctly if it's ever reached.
    // 280 + 25 = 305. Level 1 needs 100: 305-100=205, level -> 2.
    // Level 2 needs 200: 205-200=5, level -> 3. 5 < 300 (level 3's
    // threshold), loop stops.
    final repo = _FakePlayerRepository(
      const PlayerState(level: 1, exp: 280, energy: 10, gold: 0, pendingSteps: 0),
    );
    final useCase = SpendEnergyForAdventureUseCase(repo);

    final result = await useCase.call();
    final player = (result as Ok<PlayerState>).value;

    expect(player.level, 3);
    expect(player.exp, 5);
  });

  test('insufficient energy returns Err and leaves player state unchanged', () async {
    final repo = _FakePlayerRepository(
      const PlayerState(level: 1, exp: 0, energy: 5, gold: 0, pendingSteps: 0),
    );
    final useCase = SpendEnergyForAdventureUseCase(repo);

    final result = await useCase.call();

    expect(result, isA<Err<PlayerState>>());
    expect(repo.state.energy, 5);
    expect(repo.state.exp, 0);
    expect(repo.state.gold, 0);
  });
}
