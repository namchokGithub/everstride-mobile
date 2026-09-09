import 'package:drift/native.dart';
import 'package:everstride/core/database/app_database.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/settings/data/repositories/app_settings_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late AppSettingsRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = AppSettingsRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('getOnboardingCompleted returns false when no row exists', () async {
    final result = await repository.getOnboardingCompleted();
    expect((result as Ok<bool>).value, false);
  });

  test(
    'setOnboardingCompleted(true) then getOnboardingCompleted returns true',
    () async {
      final setResult = await repository.setOnboardingCompleted(true);
      expect(setResult, isA<Ok<bool>>());

      final getResult = await repository.getOnboardingCompleted();
      expect((getResult as Ok<bool>).value, true);
    },
  );

  test('setOnboardingCompleted overwrites the existing row', () async {
    await repository.setOnboardingCompleted(true);
    await repository.setOnboardingCompleted(false);

    final result = await repository.getOnboardingCompleted();
    expect((result as Ok<bool>).value, false);
  });
}
