import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class HealthDaily extends Table {
  /// Local calendar date as `yyyy-MM-dd` — deliberately NOT a DateTimeColumn.
  /// Drift stores DateTime as an absolute instant, so a device timezone
  /// change would change this row's key for the same calendar day and
  /// duplicate-reward it. See
  /// everstride-docs/specs/2026-09-08-phase2-local-health-sync-design.md.
  TextColumn get date => text()();
  IntColumn get totalSteps => integer()();
  IntColumn get rewardedSteps => integer()();
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

class Player extends Table {
  IntColumn get id => integer()();
  IntColumn get level => integer()();
  IntColumn get exp => integer()();
  IntColumn get energy => integer()();
  IntColumn get gold => integer()();
  IntColumn get pendingSteps => integer()();
  BoolColumn get hasReconciledHistoricalSteps => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  IntColumn get id => integer()();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [HealthDaily, Player, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(player);
          }
          if (from < 3) {
            await m.createTable(appSettings);
          }
          if (from < 4) {
            await m.addColumn(player, player.hasReconciledHistoricalSteps);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'everstride.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
