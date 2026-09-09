enum QuestObjectiveType { dailySteps, adventureCompletions }

class QuestDefinition {
  const QuestDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.objectiveType,
    required this.target,
    required this.expReward,
    required this.goldReward,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String description;
  final QuestObjectiveType objectiveType;
  final int target;
  final int expReward;
  final int goldReward;
  final int sortOrder;
}
