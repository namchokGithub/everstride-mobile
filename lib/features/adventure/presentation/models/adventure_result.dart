import '../../../player/domain/repositories/player_repository.dart';

/// UI-transport data for the Adventure result screen. Phase 4 does not
/// persist Adventure runs or result history.
class AdventureResult {
  const AdventureResult({
    required this.adventureName,
    required this.difficultyLabel,
    required this.energySpent,
    required this.expGained,
    required this.goldGained,
    required this.levelBefore,
    required this.playerAfter,
  });

  final String adventureName;
  final String difficultyLabel;
  final int energySpent;
  final int expGained;
  final int goldGained;
  final int levelBefore;
  final PlayerState playerAfter;

  bool get leveledUp => playerAfter.level > levelBefore;
}
