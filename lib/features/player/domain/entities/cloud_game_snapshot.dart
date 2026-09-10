import '../../../health/domain/repositories/health_sync_repository.dart';
import '../../../quest/domain/entities/quest_definition.dart';
import '../../../quest/domain/entities/quest_instance.dart';
import '../repositories/player_repository.dart';

/// The entire locally persisted game state backed up by Phase 6.
class CloudGameSnapshot {
  const CloudGameSnapshot({
    required this.schemaVersion,
    required this.player,
    required this.healthDaily,
    required this.dailyQuestInstances,
  });

  static const currentSchemaVersion = 1;

  final int schemaVersion;
  final PlayerState player;
  final List<HealthDailyRecord> healthDaily;
  final List<QuestInstance> dailyQuestInstances;

  bool get isPristine =>
      player.level == 1 &&
      player.exp == 0 &&
      player.energy == 0 &&
      player.gold == 0 &&
      player.pendingSteps == 0 &&
      !player.hasReconciledHistoricalSteps &&
      healthDaily.isEmpty &&
      dailyQuestInstances.isEmpty;

  Map<String, Object?> toCloudRow(String userId) => {
    'user_id': userId,
    'level': player.level,
    'exp': player.exp,
    'energy': player.energy,
    'gold': player.gold,
    'pending_steps': player.pendingSteps,
    'has_reconciled_historical_steps': player.hasReconciledHistoricalSteps,
    'health_daily': healthDaily.map((record) => record.toJson()).toList(),
    'daily_quest_instances': dailyQuestInstances
        .map((instance) => instance.toJson())
        .toList(),
    'schema_version': schemaVersion,
  };

  static CloudGameSnapshot fromCloudRow(Map<String, dynamic> row) {
    final schemaVersion = row['schema_version'] as int? ?? 1;
    if (schemaVersion != currentSchemaVersion) {
      throw FormatException('Unsupported cloud save version: $schemaVersion');
    }
    return CloudGameSnapshot(
      schemaVersion: schemaVersion,
      player: PlayerState(
        level: row['level'] as int,
        exp: row['exp'] as int,
        energy: row['energy'] as int,
        gold: row['gold'] as int,
        pendingSteps: row['pending_steps'] as int,
        hasReconciledHistoricalSteps:
            row['has_reconciled_historical_steps'] as bool? ?? false,
      ),
      healthDaily: ((row['health_daily'] as List<dynamic>? ?? const [])
          .map(
            (value) =>
                _healthDailyRecordFromJson(value as Map<String, dynamic>),
          )
          .toList()),
      dailyQuestInstances:
          ((row['daily_quest_instances'] as List<dynamic>? ?? const [])
              .map(
                (value) =>
                    _questInstanceFromJson(value as Map<String, dynamic>),
              )
              .toList()),
    );
  }
}

extension HealthDailyRecordCloudJson on HealthDailyRecord {
  Map<String, Object> toJson() => {
    'date':
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    'total_steps': totalSteps,
    'rewarded_steps': rewardedSteps,
    'last_synced_at': lastSyncedAt.toUtc().toIso8601String(),
  };
}

HealthDailyRecord _healthDailyRecordFromJson(Map<String, dynamic> json) =>
    HealthDailyRecord(
      date: DateTime.parse(json['date'] as String),
      totalSteps: json['total_steps'] as int,
      rewardedSteps: json['rewarded_steps'] as int,
      lastSyncedAt: DateTime.parse(json['last_synced_at'] as String),
    );

extension QuestInstanceCloudJson on QuestInstance {
  Map<String, Object?> toJson() => {
    'id': id,
    'quest_id': questId,
    'date':
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    'objective_type': objectiveType.name,
    'target': target,
    'progress': progress,
    'status': status.name,
    'exp_reward': expReward,
    'gold_reward': goldReward,
    'claimed_at': claimedAt?.toUtc().toIso8601String(),
  };
}

QuestInstance _questInstanceFromJson(Map<String, dynamic> json) =>
    QuestInstance(
      id: json['id'] as String,
      questId: json['quest_id'] as String,
      date: DateTime.parse(json['date'] as String),
      objectiveType: QuestObjectiveType.values.byName(
        json['objective_type'] as String,
      ),
      target: json['target'] as int,
      progress: json['progress'] as int,
      status: QuestStatus.values.byName(json['status'] as String),
      expReward: json['exp_reward'] as int,
      goldReward: json['gold_reward'] as int,
      claimedAt: json['claimed_at'] == null
          ? null
          : DateTime.parse(json['claimed_at'] as String),
    );
