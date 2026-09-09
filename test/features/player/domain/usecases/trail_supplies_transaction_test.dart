import 'package:drift/native.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/player/data/repositories/player_repository_impl.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/domain/usecases/spend_energy_for_adventure_usecase.dart';
import 'package:everstride/features/quest/data/repositories/quest_repository_impl.dart';
import 'package:everstride/features/quest/domain/entities/quest_definition.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:everstride/features/quest/domain/usecases/claim_daily_quest_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'concurrent Quest claim and Supplies Adventure retain both updates',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final players = PlayerRepositoryImpl(database);
      final quests = QuestRepositoryImpl(database);
      final quest = QuestInstance(
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
      await players.savePlayer(
        const PlayerState(
          level: 1,
          exp: 0,
          energy: 10,
          gold: 50,
          pendingSteps: 0,
        ),
      );
      await quests.saveInstance(quest);

      final outcomes = await Future.wait([
        ClaimDailyQuestUseCase(quests, players, database).call(quest),
        SpendEnergyForAdventureUseCase(players, database).call(
          energyCost: 10,
          expReward: 37,
          goldReward: 15,
          additionalGoldCost: 30,
        ),
      ]);

      expect(outcomes.every((outcome) => outcome is Ok<PlayerState>), isTrue);
      final player = (await players.getPlayer() as Ok<PlayerState>).value;
      expect(player.energy, 0);
      expect(player.exp, 47);
      expect(player.gold, 40); // 50 + 5 - 30 + 15
      final storedQuest =
          (await quests.getInstanceById(quest.id) as Ok<QuestInstance?>).value;
      expect(storedQuest?.status, QuestStatus.claimed);
    },
  );
}
