import 'entities/quest_definition.dart';

const dailyQuestCatalog = [
  QuestDefinition(
    id: 'daily_steps_1000',
    title: 'First Steps',
    description: 'Walk 1,000 Steps today.',
    objectiveType: QuestObjectiveType.dailySteps,
    target: 1000,
    expReward: 10,
    goldReward: 5,
    sortOrder: 0,
  ),
  QuestDefinition(
    id: 'daily_steps_3000',
    title: "Wanderer's Path",
    description: 'Walk 3,000 Steps today.',
    objectiveType: QuestObjectiveType.dailySteps,
    target: 3000,
    expReward: 20,
    goldReward: 10,
    sortOrder: 1,
  ),
  QuestDefinition(
    id: 'daily_adventure_1',
    title: 'Trailbound',
    description: 'Complete 1 Adventure today.',
    objectiveType: QuestObjectiveType.adventureCompletions,
    target: 1,
    expReward: 15,
    goldReward: 10,
    sortOrder: 2,
  ),
];
