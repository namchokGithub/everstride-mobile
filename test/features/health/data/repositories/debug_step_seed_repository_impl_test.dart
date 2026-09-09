import 'package:drift/native.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/data/repositories/debug_step_seed_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DebugStepSeedRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DebugStepSeedRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test(
    'claims distinct slots backwards from the latest completed slot',
    () async {
      final date = DateTime(2026, 9, 10);

      final first = await repository.claimLatestPastSlot(
        date: date,
        latestAvailableSlot: 519,
      );
      final second = await repository.claimLatestPastSlot(
        date: date,
        latestAvailableSlot: 519,
      );

      expect((first as Ok<int>).value, 519);
      expect((second as Ok<int>).value, 518);
    },
  );

  test(
    'does not reuse a slot after all past slots have been claimed',
    () async {
      final date = DateTime(2026, 9, 10);

      final first = await repository.claimLatestPastSlot(
        date: date,
        latestAvailableSlot: 0,
      );
      final second = await repository.claimLatestPastSlot(
        date: date,
        latestAvailableSlot: 0,
      );

      expect(first, isA<Ok<int>>());
      expect(second, isA<Err<int>>());
    },
  );
}
