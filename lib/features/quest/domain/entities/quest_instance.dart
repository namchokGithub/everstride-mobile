import 'quest_definition.dart';

enum QuestStatus { inProgress, claimable, claimed, expired }

class QuestInstance {
  const QuestInstance({
    required this.id,
    required this.questId,
    required this.date,
    required this.objectiveType,
    required this.target,
    required this.progress,
    required this.status,
    required this.expReward,
    required this.goldReward,
    this.claimedAt,
  });
  final String id;
  final String questId;
  final DateTime date;
  final QuestObjectiveType objectiveType;
  final int target;
  final int progress;
  final QuestStatus status;
  final int expReward;
  final int goldReward;
  final DateTime? claimedAt;

  QuestInstance copyWith({
    int? progress,
    QuestStatus? status,
    DateTime? claimedAt,
  }) => QuestInstance(
    id: id,
    questId: questId,
    date: date,
    objectiveType: objectiveType,
    target: target,
    progress: progress ?? this.progress,
    status: status ?? this.status,
    expReward: expReward,
    goldReward: goldReward,
    claimedAt: claimedAt ?? this.claimedAt,
  );
}
