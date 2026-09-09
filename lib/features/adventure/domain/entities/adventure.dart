/// Static game content — not a record of a player currently traveling.
/// See everstride-docs/game-design/adventure-system.md.
class AdventureDifficulty {
  const AdventureDifficulty({
    required this.id,
    required this.label,
    required this.energyCost,
    required this.expReward,
    required this.goldReward,
  });

  final String id;
  final String label;
  final int energyCost;
  final int expReward;
  final int goldReward;
}

class Adventure {
  const Adventure({
    required this.id,
    required this.name,
    required this.description,
    required this.difficultyOptions,
    required this.defaultDifficultyId,
  });

  final String id;
  final String name;
  final String description;
  final List<AdventureDifficulty> difficultyOptions;
  final String defaultDifficultyId;

  AdventureDifficulty get defaultDifficulty =>
      difficultyById(defaultDifficultyId);

  AdventureDifficulty difficultyById(String id) =>
      difficultyOptions.firstWhere((difficulty) => difficulty.id == id);
}
