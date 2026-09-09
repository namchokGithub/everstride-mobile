import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/repositories/health_sync_repository.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:everstride/features/quest/domain/repositories/quest_repository.dart';
import 'package:everstride/features/quest/domain/usecases/ensure_daily_quests_usecase.dart';
import 'package:everstride/features/quest/domain/usecases/record_adventure_completion_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _Store implements QuestRepository {
  final rows = <String, QuestInstance>{};
  @override
  Future<Result<List<QuestInstance>>> getInstancesForDate(
    DateTime date,
  ) async => Ok(
    rows.values
        .where(
          (row) =>
              row.date.year == date.year &&
              row.date.month == date.month &&
              row.date.day == date.day,
        )
        .toList(),
  );
  @override
  Future<Result<QuestInstance?>> getInstanceById(String id) async =>
      Ok(rows[id]);
  @override
  Future<Result<List<QuestInstance>>> getActiveInstancesBeforeDate(
    DateTime date,
  ) async => const Ok([]);
  @override
  Future<Result<bool>> saveInstance(QuestInstance instance) async {
    rows[instance.id] = instance;
    return const Ok(true);
  }
}

class _Health implements HealthSyncRepository {
  @override
  Future<Result<HealthDailyRecord?>> getRecord(DateTime date) async =>
      const Ok(null);
  @override
  Future<Result<int>> getTotalRewardedSteps() async => const Ok(0);
  @override
  Future<Result<DateTime?>> getMostRecentSyncedDate() async => const Ok(null);
  @override
  Future<Result<bool>> upsertRecord(HealthDailyRecord record) async =>
      const Ok(true);
}

void main() {
  test('successful completion makes Trailbound claimable once', () async {
    final store = _Store();
    final today = DateTime(2026, 9, 10);
    final useCase = RecordAdventureCompletionUseCase(
      store,
      EnsureDailyQuestsUseCase(store, _Health()),
    );
    await useCase.call(now: today);
    final trailbound = store.rows['2026-09-10_daily_adventure_1']!;
    expect(trailbound.progress, 1);
    expect(trailbound.status, QuestStatus.claimable);
  });
}
