import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:everstride/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('inserts and reads back a health_daily row', () async {
    final date = DateTime(2026, 9, 8);
    await database.into(database.healthDaily).insertOnConflictUpdate(
          HealthDailyCompanion.insert(
            date: '2026-09-08',
            totalSteps: 1000,
            rewardedSteps: 400,
            lastSyncedAt: date,
          ),
        );

    final row = await (database.select(database.healthDaily)
          ..where((t) => t.date.equals('2026-09-08')))
        .getSingle();

    expect(row.totalSteps, 1000);
    expect(row.rewardedSteps, 400);
  });
}
