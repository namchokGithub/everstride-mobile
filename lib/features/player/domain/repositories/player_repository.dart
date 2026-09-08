import '../../../../core/errors/result.dart';

class PlayerState {
  const PlayerState({
    required this.level,
    required this.exp,
    required this.energy,
    required this.gold,
    required this.pendingSteps,
  });

  final int level;
  final int exp;
  final int energy;
  final int gold;
  final int pendingSteps;

  static int expToNextLevel(int level) => level * 100;

  PlayerState copyWith({
    int? level,
    int? exp,
    int? energy,
    int? gold,
    int? pendingSteps,
  }) {
    return PlayerState(
      level: level ?? this.level,
      exp: exp ?? this.exp,
      energy: energy ?? this.energy,
      gold: gold ?? this.gold,
      pendingSteps: pendingSteps ?? this.pendingSteps,
    );
  }
}

/// Reads/writes the single local player row. Dumb CRUD only — energy
/// conversion, spending, and leveling live in use cases, never here.
abstract class PlayerRepository {
  Future<Result<PlayerState>> getPlayer();
  Future<Result<bool>> savePlayer(PlayerState player);
}
