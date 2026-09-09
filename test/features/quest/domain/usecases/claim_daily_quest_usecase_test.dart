import 'package:drift/native.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/player/data/repositories/player_repository_impl.dart';
import 'package:everstride/features/quest/data/repositories/quest_repository_impl.dart';
import 'package:everstride/features/quest/domain/entities/quest_definition.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:everstride/features/quest/domain/usecases/claim_daily_quest_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late QuestRepositoryImpl quests;
  late PlayerRepositoryImpl players;
  late ClaimDailyQuestUseCase useCase;
  final instance = QuestInstance(
    id: '2026-09-10_daily_steps_1000',
    questId: 'daily_steps_1000',
    date: DateTime(2026, 9, 10),
    objectiveType: QuestObjectiveType.dailySteps,
    target: 1000,
    progress: 1000,
    status: QuestStatus.claimable,
    expReward: 10,
    goldReward: 5,
  );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    quests = QuestRepositoryImpl(db);
    players = PlayerRepositoryImpl(db);
    useCase = ClaimDailyQuestUseCase(quests, players, db);
  });
  tearDown(() => db.close());

  test(
    'claims stored reward exactly once even with a stale duplicate object',
    () async {
      await quests.saveInstance(instance);
      expect(await useCase.call(instance), isA<Ok>());
      expect(await useCase.call(instance), isA<Err>());
      final player = (await players.getPlayer() as Ok).value;
      expect(player.exp, 10);
      expect(player.gold, 5);
      final stored =
          (await quests.getInstanceById(instance.id) as Ok).value
              as QuestInstance;
      expect(stored.status, QuestStatus.claimed);
    },
  );
}
