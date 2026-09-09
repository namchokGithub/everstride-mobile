import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/repositories/health_sync_repository.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:everstride/features/quest/domain/repositories/quest_repository.dart';
import 'package:everstride/features/quest/domain/usecases/ensure_daily_quests_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _QuestStore implements QuestRepository {
  final rows = <String, QuestInstance>{};
  String _key(DateTime date) => '${date.year}-${date.month}-${date.day}';
  @override
  Future<Result<List<QuestInstance>>> getInstancesForDate(
    DateTime date,
  ) async =>
      Ok(rows.values.where((row) => _key(row.date) == _key(date)).toList());
  @override
  Future<Result<QuestInstance?>> getInstanceById(String id) async =>
      Ok(rows[id]);
  @override
  Future<Result<List<QuestInstance>>> getActiveInstancesBeforeDate(
    DateTime date,
  ) async => Ok(
    rows.values
        .where(
          (row) =>
              row.date.isBefore(date) &&
              (row.status == QuestStatus.inProgress ||
                  row.status == QuestStatus.claimable),
        )
        .toList(),
  );
  @override
  Future<Result<bool>> saveInstance(QuestInstance instance) async {
    rows[instance.id] = instance;
    return const Ok(true);
  }
}

class _Health implements HealthSyncRepository {
  _Health(this.steps);
  final int steps;
  @override
  Future<Result<HealthDailyRecord?>> getRecord(DateTime date) async => Ok(
    HealthDailyRecord(
      date: date,
      totalSteps: steps,
      rewardedSteps: 0,
      lastSyncedAt: date,
    ),
  );
  @override
  Future<Result<int>> getTotalRewardedSteps() async => const Ok(0);
  @override
  Future<Result<DateTime?>> getMostRecentSyncedDate() async => const Ok(null);
  @override
  Future<Result<bool>> upsertRecord(HealthDailyRecord record) async =>
      const Ok(true);
}

void main() {
  test('creates three quests, refreshes total-Step progress, and expires yesterday', () async {
    final store = _QuestStore();
    final yesterday = DateTime(2026, 9, 9);
    await EnsureDailyQuestsUseCase(store, _Health(1200)).call(now: yesterday);
    final today = DateTime(2026, 9, 10);
    final result = await EnsureDailyQuestsUseCase(
      store,
      _Health(0),
    ).call(now: today);
    final todayRows = (result as Ok<List<QuestInstance>>).value;
    expect(todayRows, hasLength(3));
    expect(todayRows.every((row) => row.progress == 0), isTrue);
    expect(
      store.rows.values
          .where((row) => row.date == yesterday)
          .every((row) => row.status == QuestStatus.expired),
      isTrue,
    );
  });
}
