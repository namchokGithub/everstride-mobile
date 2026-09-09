import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/player/data/repositories/player_repository_impl.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';

void main() {
  late AppDatabase database;
  late PlayerRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = PlayerRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('getPlayer returns a default state when no row exists', () async {
    final result = await repository.getPlayer();
    final player = (result as Ok<PlayerState>).value;

    expect(player.level, 1);
    expect(player.exp, 0);
    expect(player.energy, 0);
    expect(player.gold, 0);
    expect(player.pendingSteps, 0);
    expect(player.hasReconciledHistoricalSteps, isFalse);
  });

  test('savePlayer then getPlayer round-trips the same values', () async {
    const player = PlayerState(
      level: 3,
      exp: 40,
      energy: 5,
      gold: 20,
      pendingSteps: 60,
      hasReconciledHistoricalSteps: true,
    );
    final saveResult = await repository.savePlayer(player);
    expect(saveResult, isA<Ok<bool>>());

    final getResult = await repository.getPlayer();
    final loaded = (getResult as Ok<PlayerState>).value;

    expect(loaded.level, 3);
    expect(loaded.exp, 40);
    expect(loaded.energy, 5);
    expect(loaded.gold, 20);
    expect(loaded.pendingSteps, 60);
    expect(loaded.hasReconciledHistoricalSteps, isTrue);
  });

  test('savePlayer overwrites the existing row', () async {
    await repository.savePlayer(
      const PlayerState(level: 1, exp: 0, energy: 0, gold: 0, pendingSteps: 0),
    );
    await repository.savePlayer(
      const PlayerState(
        level: 2,
        exp: 10,
        energy: 5,
        gold: 30,
        pendingSteps: 15,
      ),
    );

    final result = await repository.getPlayer();
    final player = (result as Ok<PlayerState>).value;

    expect(player.level, 2);
    expect(player.exp, 10);
    expect(player.energy, 5);
    expect(player.gold, 30);
    expect(player.pendingSteps, 15);
  });
}
