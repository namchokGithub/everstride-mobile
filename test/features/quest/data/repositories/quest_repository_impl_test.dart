import 'package:drift/native.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/quest/data/repositories/quest_repository_impl.dart';
import 'package:everstride/features/quest/domain/entities/quest_definition.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late QuestRepositoryImpl repository;
  final quest = QuestInstance(
    id: '2026-09-10_daily_steps_1000',
    questId: 'daily_steps_1000',
    date: DateTime(2026, 9, 10),
    objectiveType: QuestObjectiveType.dailySteps,
    target: 1000,
    progress: 0,
    status: QuestStatus.inProgress,
    expReward: 10,
    goldReward: 5,
  );
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = QuestRepositoryImpl(db);
  });
  tearDown(() => db.close());
  test('round-trips instances and returns the current row by id', () async {
    await repository.saveInstance(quest);
    await repository.saveInstance(
      quest.copyWith(progress: 1000, status: QuestStatus.claimable),
    );
    final byDate = (await repository.getInstancesForDate(
      quest.date,
    ) as Ok<List<QuestInstance>>).value;
    final byId = (await repository.getInstanceById(
      quest.id,
    ) as Ok<QuestInstance?>).value;
    expect(byDate, hasLength(1));
    expect(byId?.status, QuestStatus.claimable);
  });
}
