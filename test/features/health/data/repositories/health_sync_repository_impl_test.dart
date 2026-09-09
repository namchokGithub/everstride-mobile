import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/data/repositories/health_sync_repository_impl.dart';
import 'package:everstride/features/health/domain/repositories/health_sync_repository.dart';

void main() {
  late AppDatabase database;
  late HealthSyncRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = HealthSyncRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('getMostRecentSyncedDate returns null when no rows exist', () async {
    final result = await repository.getMostRecentSyncedDate();
    expect((result as Ok<DateTime?>).value, isNull);
  });

  test('upsertRecord then getRecord round-trips the same values', () async {
    final date = DateTime(2026, 9, 8);
    final upsertResult = await repository.upsertRecord(
      HealthDailyRecord(
        date: date,
        totalSteps: 1000,
        rewardedSteps: 400,
        lastSyncedAt: date,
      ),
    );
    expect(upsertResult, isA<Ok<bool>>());

    final getResult = await repository.getRecord(date);
    final record = (getResult as Ok<HealthDailyRecord?>).value;
    expect(record, isNotNull);
    expect(record!.totalSteps, 1000);
    expect(record.rewardedSteps, 400);
  });

  test('upsertRecord overwrites the existing row for the same date', () async {
    final date = DateTime(2026, 9, 8);
    await repository.upsertRecord(
      HealthDailyRecord(
        date: date,
        totalSteps: 1000,
        rewardedSteps: 400,
        lastSyncedAt: date,
      ),
    );
    await repository.upsertRecord(
      HealthDailyRecord(
        date: date,
        totalSteps: 1500,
        rewardedSteps: 900,
        lastSyncedAt: date,
      ),
    );

    final getResult = await repository.getRecord(date);
    final record = (getResult as Ok<HealthDailyRecord?>).value!;
    expect(record.totalSteps, 1500);
    expect(record.rewardedSteps, 900);
  });

  test(
    'getMostRecentSyncedDate returns the latest date across multiple rows',
    () async {
      await repository.upsertRecord(
        HealthDailyRecord(
          date: DateTime(2026, 9, 5),
          totalSteps: 100,
          rewardedSteps: 100,
          lastSyncedAt: DateTime(2026, 9, 5),
        ),
      );
      await repository.upsertRecord(
        HealthDailyRecord(
          date: DateTime(2026, 9, 7),
          totalSteps: 200,
          rewardedSteps: 200,
          lastSyncedAt: DateTime(2026, 9, 7),
        ),
      );

      final result = await repository.getMostRecentSyncedDate();
      expect((result as Ok<DateTime?>).value, DateTime(2026, 9, 7));
    },
  );
}
