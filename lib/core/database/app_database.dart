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
  BoolColumn get hasReconciledHistoricalSteps =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  IntColumn get id => integer()();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get linkedCloudUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Debug-only cursor for Health Connect step records. It prevents debug
/// inserts from reusing a time window after the app process restarts.
class DebugStepSeedCursors extends Table {
  TextColumn get date => text()();
  IntColumn get nextSlot => integer()();

  @override
  Set<Column> get primaryKey => {date};
}

class DailyQuestInstances extends Table {
  TextColumn get id => text()();
  TextColumn get questId => text()();
  TextColumn get date => text()();
  TextColumn get objectiveType => text()();
  IntColumn get target => integer()();
  IntColumn get progress => integer()();
  TextColumn get status => text()();
  IntColumn get expReward => integer()();
  IntColumn get goldReward => integer()();
  DateTimeColumn get claimedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only, local-only observations for balancing analysis. Gameplay never
/// reads this table and cloud snapshots deliberately exclude it.
class MetricEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get localDate => text()();
  TextColumn get eventType => text()();
  TextColumn get payload => text()();
}

@DriftDatabase(
  tables: [
    HealthDaily,
    Player,
    AppSettings,
    DebugStepSeedCursors,
    DailyQuestInstances,
    MetricEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 8;

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
      if (from < 5) {
        await m.createTable(debugStepSeedCursors);
      }
      if (from < 6) {
        await m.createTable(dailyQuestInstances);
      }
      if (from < 7) {
        await m.addColumn(appSettings, appSettings.linkedCloudUserId);
      }
      if (from < 8) {
        await m.createTable(metricEvents);
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
