// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HealthDailyTable extends HealthDaily
    with TableInfo<$HealthDailyTable, HealthDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalStepsMeta = const VerificationMeta(
    'totalSteps',
  );
  @override
  late final GeneratedColumn<int> totalSteps = GeneratedColumn<int>(
    'total_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardedStepsMeta = const VerificationMeta(
    'rewardedSteps',
  );
  @override
  late final GeneratedColumn<int> rewardedSteps = GeneratedColumn<int>(
    'rewarded_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    totalSteps,
    rewardedSteps,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthDailyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_steps')) {
      context.handle(
        _totalStepsMeta,
        totalSteps.isAcceptableOrUnknown(data['total_steps']!, _totalStepsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalStepsMeta);
    }
    if (data.containsKey('rewarded_steps')) {
      context.handle(
        _rewardedStepsMeta,
        rewardedSteps.isAcceptableOrUnknown(
          data['rewarded_steps']!,
          _rewardedStepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardedStepsMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  HealthDailyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthDailyData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      totalSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_steps'],
      )!,
      rewardedSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rewarded_steps'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      )!,
    );
  }

  @override
  $HealthDailyTable createAlias(String alias) {
    return $HealthDailyTable(attachedDatabase, alias);
  }
}

class HealthDailyData extends DataClass implements Insertable<HealthDailyData> {
  /// Local calendar date as `yyyy-MM-dd` — deliberately NOT a DateTimeColumn.
  /// Drift stores DateTime as an absolute instant, so a device timezone
  /// change would change this row's key for the same calendar day and
  /// duplicate-reward it. See
  /// everstride-docs/specs/2026-09-08-phase2-local-health-sync-design.md.
  final String date;
  final int totalSteps;
  final int rewardedSteps;
  final DateTime lastSyncedAt;
  const HealthDailyData({
    required this.date,
    required this.totalSteps,
    required this.rewardedSteps,
    required this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['total_steps'] = Variable<int>(totalSteps);
    map['rewarded_steps'] = Variable<int>(rewardedSteps);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    return map;
  }

  HealthDailyCompanion toCompanion(bool nullToAbsent) {
    return HealthDailyCompanion(
      date: Value(date),
      totalSteps: Value(totalSteps),
      rewardedSteps: Value(rewardedSteps),
      lastSyncedAt: Value(lastSyncedAt),
    );
  }

  factory HealthDailyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthDailyData(
      date: serializer.fromJson<String>(json['date']),
      totalSteps: serializer.fromJson<int>(json['totalSteps']),
      rewardedSteps: serializer.fromJson<int>(json['rewardedSteps']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'totalSteps': serializer.toJson<int>(totalSteps),
      'rewardedSteps': serializer.toJson<int>(rewardedSteps),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  HealthDailyData copyWith({
    String? date,
    int? totalSteps,
    int? rewardedSteps,
    DateTime? lastSyncedAt,
  }) => HealthDailyData(
    date: date ?? this.date,
    totalSteps: totalSteps ?? this.totalSteps,
    rewardedSteps: rewardedSteps ?? this.rewardedSteps,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );
  HealthDailyData copyWithCompanion(HealthDailyCompanion data) {
    return HealthDailyData(
      date: data.date.present ? data.date.value : this.date,
      totalSteps: data.totalSteps.present
          ? data.totalSteps.value
          : this.totalSteps,
      rewardedSteps: data.rewardedSteps.present
          ? data.rewardedSteps.value
          : this.rewardedSteps,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthDailyData(')
          ..write('date: $date, ')
          ..write('totalSteps: $totalSteps, ')
          ..write('rewardedSteps: $rewardedSteps, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, totalSteps, rewardedSteps, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthDailyData &&
          other.date == this.date &&
          other.totalSteps == this.totalSteps &&
          other.rewardedSteps == this.rewardedSteps &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class HealthDailyCompanion extends UpdateCompanion<HealthDailyData> {
  final Value<String> date;
  final Value<int> totalSteps;
  final Value<int> rewardedSteps;
  final Value<DateTime> lastSyncedAt;
  final Value<int> rowid;
  const HealthDailyCompanion({
    this.date = const Value.absent(),
    this.totalSteps = const Value.absent(),
    this.rewardedSteps = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthDailyCompanion.insert({
    required String date,
    required int totalSteps,
    required int rewardedSteps,
    required DateTime lastSyncedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       totalSteps = Value(totalSteps),
       rewardedSteps = Value(rewardedSteps),
       lastSyncedAt = Value(lastSyncedAt);
  static Insertable<HealthDailyData> custom({
    Expression<String>? date,
    Expression<int>? totalSteps,
    Expression<int>? rewardedSteps,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (totalSteps != null) 'total_steps': totalSteps,
      if (rewardedSteps != null) 'rewarded_steps': rewardedSteps,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthDailyCompanion copyWith({
    Value<String>? date,
    Value<int>? totalSteps,
    Value<int>? rewardedSteps,
    Value<DateTime>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return HealthDailyCompanion(
      date: date ?? this.date,
      totalSteps: totalSteps ?? this.totalSteps,
      rewardedSteps: rewardedSteps ?? this.rewardedSteps,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (totalSteps.present) {
      map['total_steps'] = Variable<int>(totalSteps.value);
    }
    if (rewardedSteps.present) {
      map['rewarded_steps'] = Variable<int>(rewardedSteps.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthDailyCompanion(')
          ..write('date: $date, ')
          ..write('totalSteps: $totalSteps, ')
          ..write('rewardedSteps: $rewardedSteps, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HealthDailyTable healthDaily = $HealthDailyTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [healthDaily];
}

typedef $$HealthDailyTableCreateCompanionBuilder =
    HealthDailyCompanion Function({
      required String date,
      required int totalSteps,
      required int rewardedSteps,
      required DateTime lastSyncedAt,
      Value<int> rowid,
    });
typedef $$HealthDailyTableUpdateCompanionBuilder =
    HealthDailyCompanion Function({
      Value<String> date,
      Value<int> totalSteps,
      Value<int> rewardedSteps,
      Value<DateTime> lastSyncedAt,
      Value<int> rowid,
    });

class $$HealthDailyTableFilterComposer
    extends Composer<_$AppDatabase, $HealthDailyTable> {
  $$HealthDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSteps => $composableBuilder(
    column: $table.totalSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardedSteps => $composableBuilder(
    column: $table.rewardedSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthDailyTable> {
  $$HealthDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSteps => $composableBuilder(
    column: $table.totalSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardedSteps => $composableBuilder(
    column: $table.rewardedSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthDailyTable> {
  $$HealthDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalSteps => $composableBuilder(
    column: $table.totalSteps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardedSteps => $composableBuilder(
    column: $table.rewardedSteps,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$HealthDailyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthDailyTable,
          HealthDailyData,
          $$HealthDailyTableFilterComposer,
          $$HealthDailyTableOrderingComposer,
          $$HealthDailyTableAnnotationComposer,
          $$HealthDailyTableCreateCompanionBuilder,
          $$HealthDailyTableUpdateCompanionBuilder,
          (
            HealthDailyData,
            BaseReferences<_$AppDatabase, $HealthDailyTable, HealthDailyData>,
          ),
          HealthDailyData,
          PrefetchHooks Function()
        > {
  $$HealthDailyTableTableManager(_$AppDatabase db, $HealthDailyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> totalSteps = const Value.absent(),
                Value<int> rewardedSteps = const Value.absent(),
                Value<DateTime> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthDailyCompanion(
                date: date,
                totalSteps: totalSteps,
                rewardedSteps: rewardedSteps,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int totalSteps,
                required int rewardedSteps,
                required DateTime lastSyncedAt,
                Value<int> rowid = const Value.absent(),
              }) => HealthDailyCompanion.insert(
                date: date,
                totalSteps: totalSteps,
                rewardedSteps: rewardedSteps,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HealthDailyTable, HealthDailyData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $HealthDailyTable,
                    HealthDailyData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthDailyTable,
      HealthDailyData,
      $$HealthDailyTableFilterComposer,
      $$HealthDailyTableOrderingComposer,
      $$HealthDailyTableAnnotationComposer,
      $$HealthDailyTableCreateCompanionBuilder,
      $$HealthDailyTableUpdateCompanionBuilder,
      (
        HealthDailyData,
        BaseReferences<_$AppDatabase, $HealthDailyTable, HealthDailyData>,
      ),
      HealthDailyData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HealthDailyTableTableManager get healthDaily =>
      $$HealthDailyTableTableManager(_db, _db.healthDaily);
}
