import 'package:everstride/features/quest/domain/entities/quest_definition.dart';
import 'package:everstride/features/quest/domain/quest_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daily catalog matches the documented three quests', () {
    expect(dailyQuestCatalog, hasLength(3));
    final steps = dailyQuestCatalog.firstWhere(
      (quest) => quest.id == 'daily_steps_1000',
    );
    expect(steps.objectiveType, QuestObjectiveType.dailySteps);
    expect(steps.target, 1000);
    expect(steps.expReward, 10);
    expect(steps.goldReward, 5);
    final adventure = dailyQuestCatalog.firstWhere(
      (quest) => quest.id == 'daily_adventure_1',
    );
    expect(adventure.target, 1);
    expect(adventure.expReward, 15);
    expect(adventure.goldReward, 10);
  });
}
