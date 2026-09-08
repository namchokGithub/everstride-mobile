import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/data/repositories/health_sync_repository_impl.dart';
import 'package:everstride/features/health/domain/repositories/health_repository.dart';
import 'package:everstride/features/health/domain/repositories/health_sync_repository.dart';
import 'package:everstride/features/health/domain/usecases/sync_health_data_usecase.dart';

class _FakeHealthRepository implements HealthRepository {
  _FakeHealthRepository(this.stepsByDate, {this.failOnDate});

  final Map<DateTime, int> stepsByDate;
  final DateTime? failOnDate;

  @override
  Future<Result<int>> getStepsForDate(DateTime date) async {
    if (failOnDate != null && date == failOnDate) {
      return Err(Failure('Simulated failure for $date'));
    }
    return Ok(stepsByDate[date] ?? 0);
  }

  @override
  Future<Result<int>> getTodaySteps() => getStepsForDate(DateTime.now());

  @override
  Future<Result<bool>> isAvailable() => throw UnimplementedError();

  @override
  Future<Result<bool>> promptInstallOrUpdate() => throw UnimplementedError();

  @override
  Future<Result<bool>> hasPermission() => throw UnimplementedError();

  @override
  Future<Result<bool>> requestPermissions() => throw UnimplementedError();
}

class _FailingSyncRepository implements HealthSyncRepository {
  @override
  Future<Result<int>> getTotalRewardedSteps() => throw UnimplementedError();

  @override
  Future<Result<DateTime?>> getMostRecentSyncedDate() async =>
      const Err(Failure('simulated failure'));

  @override
  Future<Result<HealthDailyRecord?>> getRecord(DateTime date) => throw UnimplementedError();

  @override
  Future<Result<bool>> upsertRecord(HealthDailyRecord record) => throw UnimplementedError();
}

void main() {
  late AppDatabase database;
  late HealthSyncRepositoryImpl syncRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    syncRepository = HealthSyncRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('first sync of the day rewards the full total', () async {
    final today = DateTime(2026, 9, 8);
    final useCase = SyncHealthDataUseCase(_FakeHealthRepository({today: 2500}), syncRepository);

    final result = await useCase.call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 2500);
    expect(syncResult.days.length, 7);
    expect(syncResult.days.last, DailySyncResult(date: today, rewardableSteps: 2500));
  });

  test('second sync same day with the same total rewards nothing new', () async {
    final today = DateTime(2026, 9, 8);
    final useCase = SyncHealthDataUseCase(_FakeHealthRepository({today: 2500}), syncRepository);

    await useCase.call(now: today);
    final result = await useCase.call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 0);
  });

  test('an increased total rewards only the increase', () async {
    final today = DateTime(2026, 9, 8);
    await SyncHealthDataUseCase(_FakeHealthRepository({today: 2500}), syncRepository).call(now: today);

    final result =
        await SyncHealthDataUseCase(_FakeHealthRepository({today: 4000}), syncRepository).call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 1500);
  });

  test('a decreased total (correction) rewards nothing and does not go negative', () async {
    final today = DateTime(2026, 9, 8);
    await SyncHealthDataUseCase(_FakeHealthRepository({today: 2500}), syncRepository).call(now: today);

    final result =
        await SyncHealthDataUseCase(_FakeHealthRepository({today: 1000}), syncRepository).call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 0);

    final recordResult = await syncRepository.getRecord(today);
    final record = (recordResult as Ok<HealthDailyRecord?>).value!;
    expect(record.totalSteps, 1000);
    expect(record.rewardedSteps, 2500);
  });

  test('first-ever sync caps the catch-up window to 7 days', () async {
    final today = DateTime(2026, 9, 8);
    final stepsByDate = {for (var i = 0; i < 30; i++) today.subtract(Duration(days: i)): 100};
    final useCase = SyncHealthDataUseCase(_FakeHealthRepository(stepsByDate), syncRepository);

    final result = await useCase.call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.days.length, 7);
    expect(syncResult.totalNewRewardableSteps, 700);
  });

  test('catches up missed days plus today', () async {
    final lastSynced = DateTime(2026, 9, 5);
    final today = DateTime(2026, 9, 8);
    await syncRepository.upsertRecord(HealthDailyRecord(
      date: lastSynced,
      totalSteps: 1000,
      rewardedSteps: 1000,
      lastSyncedAt: lastSynced,
    ));

    final useCase = SyncHealthDataUseCase(
      _FakeHealthRepository({
        lastSynced: 1000,
        DateTime(2026, 9, 6): 2000,
        DateTime(2026, 9, 7): 3000,
        today: 500,
      }),
      syncRepository,
    );

    final result = await useCase.call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 2000 + 3000 + 500);
    expect(syncResult.days.length, 4);
  });

  test('a failure on the only date walked returns Err', () async {
    final today = DateTime(2026, 9, 8);
    await syncRepository.upsertRecord(HealthDailyRecord(
      date: today,
      totalSteps: 100,
      rewardedSteps: 100,
      lastSyncedAt: today,
    ));
    final useCase = SyncHealthDataUseCase(_FakeHealthRepository({}, failOnDate: today), syncRepository);

    final result = await useCase.call(now: today);
    expect(result, isA<Err<SyncResult>>());
  });

  test('a failed date after a successful one returns the partial result', () async {
    final dayBefore = DateTime(2026, 9, 7);
    final today = DateTime(2026, 9, 8);
    await syncRepository.upsertRecord(HealthDailyRecord(
      date: dayBefore,
      totalSteps: 0,
      rewardedSteps: 0,
      lastSyncedAt: dayBefore,
    ));

    final useCase = SyncHealthDataUseCase(
      _FakeHealthRepository({dayBefore: 1000}, failOnDate: today),
      syncRepository,
    );

    final result = await useCase.call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 1000);
    expect(syncResult.days, [DailySyncResult(date: dayBefore, rewardableSteps: 1000)]);
  });

  test('a failure reading the most recent synced date returns Err immediately', () async {
    final today = DateTime(2026, 9, 8);
    final useCase =
        SyncHealthDataUseCase(_FakeHealthRepository({today: 100}), _FailingSyncRepository());

    final result = await useCase.call(now: today);
    expect(result, isA<Err<SyncResult>>());
  });

  test('after a downward correction, a later increase rewards only the new increase', () async {
    final today = DateTime(2026, 9, 8);
    await SyncHealthDataUseCase(_FakeHealthRepository({today: 2500}), syncRepository).call(now: today);
    await SyncHealthDataUseCase(_FakeHealthRepository({today: 1000}), syncRepository).call(now: today);

    final result =
        await SyncHealthDataUseCase(_FakeHealthRepository({today: 3000}), syncRepository).call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    expect(syncResult.totalNewRewardableSteps, 500);
  });

  test('walked days are unique, consecutive calendar dates with no gaps or repeats', () async {
    final today = DateTime(2026, 9, 8);
    final useCase = SyncHealthDataUseCase(_FakeHealthRepository({today: 100}), syncRepository);

    final result = await useCase.call(now: today);
    final syncResult = (result as Ok<SyncResult>).value;

    final dates = syncResult.days.map((d) => d.date).toList();
    expect(dates.toSet().length, dates.length, reason: 'no date should be walked twice');
    for (var i = 1; i < dates.length; i++) {
      expect(
        dates[i].difference(dates[i - 1]).inDays,
        1,
        reason: 'consecutive walked dates must be exactly one calendar day apart',
      );
    }
  });
}
