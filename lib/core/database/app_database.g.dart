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

class $PlayerTable extends Player with TableInfo<$PlayerTable, PlayerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
    'exp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
    'energy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goldMeta = const VerificationMeta('gold');
  @override
  late final GeneratedColumn<int> gold = GeneratedColumn<int>(
    'gold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingStepsMeta = const VerificationMeta(
    'pendingSteps',
  );
  @override
  late final GeneratedColumn<int> pendingSteps = GeneratedColumn<int>(
    'pending_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasReconciledHistoricalStepsMeta =
      const VerificationMeta('hasReconciledHistoricalSteps');
  @override
  late final GeneratedColumn<bool> hasReconciledHistoricalSteps =
      GeneratedColumn<bool>(
        'has_reconciled_historical_steps',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_reconciled_historical_steps" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    exp,
    energy,
    gold,
    pendingSteps,
    hasReconciledHistoricalSteps,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('exp')) {
      context.handle(
        _expMeta,
        exp.isAcceptableOrUnknown(data['exp']!, _expMeta),
      );
    } else if (isInserting) {
      context.missing(_expMeta);
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('gold')) {
      context.handle(
        _goldMeta,
        gold.isAcceptableOrUnknown(data['gold']!, _goldMeta),
      );
    } else if (isInserting) {
      context.missing(_goldMeta);
    }
    if (data.containsKey('pending_steps')) {
      context.handle(
        _pendingStepsMeta,
        pendingSteps.isAcceptableOrUnknown(
          data['pending_steps']!,
          _pendingStepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pendingStepsMeta);
    }
    if (data.containsKey('has_reconciled_historical_steps')) {
      context.handle(
        _hasReconciledHistoricalStepsMeta,
        hasReconciledHistoricalSteps.isAcceptableOrUnknown(
          data['has_reconciled_historical_steps']!,
          _hasReconciledHistoricalStepsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      exp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp'],
      )!,
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy'],
      )!,
      gold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gold'],
      )!,
      pendingSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_steps'],
      )!,
      hasReconciledHistoricalSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_reconciled_historical_steps'],
      )!,
    );
  }

  @override
  $PlayerTable createAlias(String alias) {
    return $PlayerTable(attachedDatabase, alias);
  }
}

class PlayerData extends DataClass implements Insertable<PlayerData> {
  final int id;
  final int level;
  final int exp;
  final int energy;
  final int gold;
  final int pendingSteps;
  final bool hasReconciledHistoricalSteps;
  const PlayerData({
    required this.id,
    required this.level,
    required this.exp,
    required this.energy,
    required this.gold,
    required this.pendingSteps,
    required this.hasReconciledHistoricalSteps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['exp'] = Variable<int>(exp);
    map['energy'] = Variable<int>(energy);
    map['gold'] = Variable<int>(gold);
    map['pending_steps'] = Variable<int>(pendingSteps);
    map['has_reconciled_historical_steps'] = Variable<bool>(
      hasReconciledHistoricalSteps,
    );
    return map;
  }

  PlayerCompanion toCompanion(bool nullToAbsent) {
    return PlayerCompanion(
      id: Value(id),
      level: Value(level),
      exp: Value(exp),
      energy: Value(energy),
      gold: Value(gold),
      pendingSteps: Value(pendingSteps),
      hasReconciledHistoricalSteps: Value(hasReconciledHistoricalSteps),
    );
  }

  factory PlayerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      exp: serializer.fromJson<int>(json['exp']),
      energy: serializer.fromJson<int>(json['energy']),
      gold: serializer.fromJson<int>(json['gold']),
      pendingSteps: serializer.fromJson<int>(json['pendingSteps']),
      hasReconciledHistoricalSteps: serializer.fromJson<bool>(
        json['hasReconciledHistoricalSteps'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'exp': serializer.toJson<int>(exp),
      'energy': serializer.toJson<int>(energy),
      'gold': serializer.toJson<int>(gold),
      'pendingSteps': serializer.toJson<int>(pendingSteps),
      'hasReconciledHistoricalSteps': serializer.toJson<bool>(
        hasReconciledHistoricalSteps,
      ),
    };
  }

  PlayerData copyWith({
    int? id,
    int? level,
    int? exp,
    int? energy,
    int? gold,
    int? pendingSteps,
    bool? hasReconciledHistoricalSteps,
  }) => PlayerData(
    id: id ?? this.id,
    level: level ?? this.level,
    exp: exp ?? this.exp,
    energy: energy ?? this.energy,
    gold: gold ?? this.gold,
    pendingSteps: pendingSteps ?? this.pendingSteps,
    hasReconciledHistoricalSteps:
        hasReconciledHistoricalSteps ?? this.hasReconciledHistoricalSteps,
  );
  PlayerData copyWithCompanion(PlayerCompanion data) {
    return PlayerData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      exp: data.exp.present ? data.exp.value : this.exp,
      energy: data.energy.present ? data.energy.value : this.energy,
      gold: data.gold.present ? data.gold.value : this.gold,
      pendingSteps: data.pendingSteps.present
          ? data.pendingSteps.value
          : this.pendingSteps,
      hasReconciledHistoricalSteps: data.hasReconciledHistoricalSteps.present
          ? data.hasReconciledHistoricalSteps.value
          : this.hasReconciledHistoricalSteps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('exp: $exp, ')
          ..write('energy: $energy, ')
          ..write('gold: $gold, ')
          ..write('pendingSteps: $pendingSteps, ')
          ..write('hasReconciledHistoricalSteps: $hasReconciledHistoricalSteps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    exp,
    energy,
    gold,
    pendingSteps,
    hasReconciledHistoricalSteps,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerData &&
          other.id == this.id &&
          other.level == this.level &&
          other.exp == this.exp &&
          other.energy == this.energy &&
          other.gold == this.gold &&
          other.pendingSteps == this.pendingSteps &&
          other.hasReconciledHistoricalSteps ==
              this.hasReconciledHistoricalSteps);
}

class PlayerCompanion extends UpdateCompanion<PlayerData> {
  final Value<int> id;
  final Value<int> level;
  final Value<int> exp;
  final Value<int> energy;
  final Value<int> gold;
  final Value<int> pendingSteps;
  final Value<bool> hasReconciledHistoricalSteps;
  const PlayerCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.exp = const Value.absent(),
    this.energy = const Value.absent(),
    this.gold = const Value.absent(),
    this.pendingSteps = const Value.absent(),
    this.hasReconciledHistoricalSteps = const Value.absent(),
  });
  PlayerCompanion.insert({
    this.id = const Value.absent(),
    required int level,
    required int exp,
    required int energy,
    required int gold,
    required int pendingSteps,
    this.hasReconciledHistoricalSteps = const Value.absent(),
  }) : level = Value(level),
       exp = Value(exp),
       energy = Value(energy),
       gold = Value(gold),
       pendingSteps = Value(pendingSteps);
  static Insertable<PlayerData> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<int>? exp,
    Expression<int>? energy,
    Expression<int>? gold,
    Expression<int>? pendingSteps,
    Expression<bool>? hasReconciledHistoricalSteps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (exp != null) 'exp': exp,
      if (energy != null) 'energy': energy,
      if (gold != null) 'gold': gold,
      if (pendingSteps != null) 'pending_steps': pendingSteps,
      if (hasReconciledHistoricalSteps != null)
        'has_reconciled_historical_steps': hasReconciledHistoricalSteps,
    });
  }

  PlayerCompanion copyWith({
    Value<int>? id,
    Value<int>? level,
    Value<int>? exp,
    Value<int>? energy,
    Value<int>? gold,
    Value<int>? pendingSteps,
    Value<bool>? hasReconciledHistoricalSteps,
  }) {
    return PlayerCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      energy: energy ?? this.energy,
      gold: gold ?? this.gold,
      pendingSteps: pendingSteps ?? this.pendingSteps,
      hasReconciledHistoricalSteps:
          hasReconciledHistoricalSteps ?? this.hasReconciledHistoricalSteps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (gold.present) {
      map['gold'] = Variable<int>(gold.value);
    }
    if (pendingSteps.present) {
      map['pending_steps'] = Variable<int>(pendingSteps.value);
    }
    if (hasReconciledHistoricalSteps.present) {
      map['has_reconciled_historical_steps'] = Variable<bool>(
        hasReconciledHistoricalSteps.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('exp: $exp, ')
          ..write('energy: $energy, ')
          ..write('gold: $gold, ')
          ..write('pendingSteps: $pendingSteps, ')
          ..write('hasReconciledHistoricalSteps: $hasReconciledHistoricalSteps')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, onboardingCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final bool onboardingCompleted;
  const AppSetting({required this.id, required this.onboardingCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  AppSetting copyWith({int? id, bool? onboardingCompleted}) => AppSetting(
    id: id ?? this.id,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, onboardingCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<bool> onboardingCompleted;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<bool>? onboardingCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? onboardingCompleted,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }
}

class $DebugStepSeedCursorsTable extends DebugStepSeedCursors
    with TableInfo<$DebugStepSeedCursorsTable, DebugStepSeedCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebugStepSeedCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextSlotMeta = const VerificationMeta(
    'nextSlot',
  );
  @override
  late final GeneratedColumn<int> nextSlot = GeneratedColumn<int>(
    'next_slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, nextSlot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debug_step_seed_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebugStepSeedCursor> instance, {
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
    if (data.containsKey('next_slot')) {
      context.handle(
        _nextSlotMeta,
        nextSlot.isAcceptableOrUnknown(data['next_slot']!, _nextSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_nextSlotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DebugStepSeedCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebugStepSeedCursor(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      nextSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_slot'],
      )!,
    );
  }

  @override
  $DebugStepSeedCursorsTable createAlias(String alias) {
    return $DebugStepSeedCursorsTable(attachedDatabase, alias);
  }
}

class DebugStepSeedCursor extends DataClass
    implements Insertable<DebugStepSeedCursor> {
  final String date;
  final int nextSlot;
  const DebugStepSeedCursor({required this.date, required this.nextSlot});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['next_slot'] = Variable<int>(nextSlot);
    return map;
  }

  DebugStepSeedCursorsCompanion toCompanion(bool nullToAbsent) {
    return DebugStepSeedCursorsCompanion(
      date: Value(date),
      nextSlot: Value(nextSlot),
    );
  }

  factory DebugStepSeedCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebugStepSeedCursor(
      date: serializer.fromJson<String>(json['date']),
      nextSlot: serializer.fromJson<int>(json['nextSlot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'nextSlot': serializer.toJson<int>(nextSlot),
    };
  }

  DebugStepSeedCursor copyWith({String? date, int? nextSlot}) =>
      DebugStepSeedCursor(
        date: date ?? this.date,
        nextSlot: nextSlot ?? this.nextSlot,
      );
  DebugStepSeedCursor copyWithCompanion(DebugStepSeedCursorsCompanion data) {
    return DebugStepSeedCursor(
      date: data.date.present ? data.date.value : this.date,
      nextSlot: data.nextSlot.present ? data.nextSlot.value : this.nextSlot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebugStepSeedCursor(')
          ..write('date: $date, ')
          ..write('nextSlot: $nextSlot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, nextSlot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebugStepSeedCursor &&
          other.date == this.date &&
          other.nextSlot == this.nextSlot);
}

class DebugStepSeedCursorsCompanion
    extends UpdateCompanion<DebugStepSeedCursor> {
  final Value<String> date;
  final Value<int> nextSlot;
  final Value<int> rowid;
  const DebugStepSeedCursorsCompanion({
    this.date = const Value.absent(),
    this.nextSlot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebugStepSeedCursorsCompanion.insert({
    required String date,
    required int nextSlot,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       nextSlot = Value(nextSlot);
  static Insertable<DebugStepSeedCursor> custom({
    Expression<String>? date,
    Expression<int>? nextSlot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (nextSlot != null) 'next_slot': nextSlot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebugStepSeedCursorsCompanion copyWith({
    Value<String>? date,
    Value<int>? nextSlot,
    Value<int>? rowid,
  }) {
    return DebugStepSeedCursorsCompanion(
      date: date ?? this.date,
      nextSlot: nextSlot ?? this.nextSlot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (nextSlot.present) {
      map['next_slot'] = Variable<int>(nextSlot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebugStepSeedCursorsCompanion(')
          ..write('date: $date, ')
          ..write('nextSlot: $nextSlot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestInstancesTable extends DailyQuestInstances
    with TableInfo<$DailyQuestInstancesTable, DailyQuestInstance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectiveTypeMeta = const VerificationMeta(
    'objectiveType',
  );
  @override
  late final GeneratedColumn<String> objectiveType = GeneratedColumn<String>(
    'objective_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expRewardMeta = const VerificationMeta(
    'expReward',
  );
  @override
  late final GeneratedColumn<int> expReward = GeneratedColumn<int>(
    'exp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goldRewardMeta = const VerificationMeta(
    'goldReward',
  );
  @override
  late final GeneratedColumn<int> goldReward = GeneratedColumn<int>(
    'gold_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _claimedAtMeta = const VerificationMeta(
    'claimedAt',
  );
  @override
  late final GeneratedColumn<DateTime> claimedAt = GeneratedColumn<DateTime>(
    'claimed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questId,
    date,
    objectiveType,
    target,
    progress,
    status,
    expReward,
    goldReward,
    claimedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quest_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyQuestInstance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('objective_type')) {
      context.handle(
        _objectiveTypeMeta,
        objectiveType.isAcceptableOrUnknown(
          data['objective_type']!,
          _objectiveTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objectiveTypeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('exp_reward')) {
      context.handle(
        _expRewardMeta,
        expReward.isAcceptableOrUnknown(data['exp_reward']!, _expRewardMeta),
      );
    } else if (isInserting) {
      context.missing(_expRewardMeta);
    }
    if (data.containsKey('gold_reward')) {
      context.handle(
        _goldRewardMeta,
        goldReward.isAcceptableOrUnknown(data['gold_reward']!, _goldRewardMeta),
      );
    } else if (isInserting) {
      context.missing(_goldRewardMeta);
    }
    if (data.containsKey('claimed_at')) {
      context.handle(
        _claimedAtMeta,
        claimedAt.isAcceptableOrUnknown(data['claimed_at']!, _claimedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyQuestInstance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestInstance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      objectiveType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective_type'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      expReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp_reward'],
      )!,
      goldReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gold_reward'],
      )!,
      claimedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}claimed_at'],
      ),
    );
  }

  @override
  $DailyQuestInstancesTable createAlias(String alias) {
    return $DailyQuestInstancesTable(attachedDatabase, alias);
  }
}

class DailyQuestInstance extends DataClass
    implements Insertable<DailyQuestInstance> {
  final String id;
  final String questId;
  final String date;
  final String objectiveType;
  final int target;
  final int progress;
  final String status;
  final int expReward;
  final int goldReward;
  final DateTime? claimedAt;
  const DailyQuestInstance({
    required this.id,
    required this.questId,
    required this.date,
    required this.objectiveType,
    required this.target,
    required this.progress,
    required this.status,
    required this.expReward,
    required this.goldReward,
    this.claimedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quest_id'] = Variable<String>(questId);
    map['date'] = Variable<String>(date);
    map['objective_type'] = Variable<String>(objectiveType);
    map['target'] = Variable<int>(target);
    map['progress'] = Variable<int>(progress);
    map['status'] = Variable<String>(status);
    map['exp_reward'] = Variable<int>(expReward);
    map['gold_reward'] = Variable<int>(goldReward);
    if (!nullToAbsent || claimedAt != null) {
      map['claimed_at'] = Variable<DateTime>(claimedAt);
    }
    return map;
  }

  DailyQuestInstancesCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestInstancesCompanion(
      id: Value(id),
      questId: Value(questId),
      date: Value(date),
      objectiveType: Value(objectiveType),
      target: Value(target),
      progress: Value(progress),
      status: Value(status),
      expReward: Value(expReward),
      goldReward: Value(goldReward),
      claimedAt: claimedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(claimedAt),
    );
  }

  factory DailyQuestInstance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestInstance(
      id: serializer.fromJson<String>(json['id']),
      questId: serializer.fromJson<String>(json['questId']),
      date: serializer.fromJson<String>(json['date']),
      objectiveType: serializer.fromJson<String>(json['objectiveType']),
      target: serializer.fromJson<int>(json['target']),
      progress: serializer.fromJson<int>(json['progress']),
      status: serializer.fromJson<String>(json['status']),
      expReward: serializer.fromJson<int>(json['expReward']),
      goldReward: serializer.fromJson<int>(json['goldReward']),
      claimedAt: serializer.fromJson<DateTime?>(json['claimedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questId': serializer.toJson<String>(questId),
      'date': serializer.toJson<String>(date),
      'objectiveType': serializer.toJson<String>(objectiveType),
      'target': serializer.toJson<int>(target),
      'progress': serializer.toJson<int>(progress),
      'status': serializer.toJson<String>(status),
      'expReward': serializer.toJson<int>(expReward),
      'goldReward': serializer.toJson<int>(goldReward),
      'claimedAt': serializer.toJson<DateTime?>(claimedAt),
    };
  }

  DailyQuestInstance copyWith({
    String? id,
    String? questId,
    String? date,
    String? objectiveType,
    int? target,
    int? progress,
    String? status,
    int? expReward,
    int? goldReward,
    Value<DateTime?> claimedAt = const Value.absent(),
  }) => DailyQuestInstance(
    id: id ?? this.id,
    questId: questId ?? this.questId,
    date: date ?? this.date,
    objectiveType: objectiveType ?? this.objectiveType,
    target: target ?? this.target,
    progress: progress ?? this.progress,
    status: status ?? this.status,
    expReward: expReward ?? this.expReward,
    goldReward: goldReward ?? this.goldReward,
    claimedAt: claimedAt.present ? claimedAt.value : this.claimedAt,
  );
  DailyQuestInstance copyWithCompanion(DailyQuestInstancesCompanion data) {
    return DailyQuestInstance(
      id: data.id.present ? data.id.value : this.id,
      questId: data.questId.present ? data.questId.value : this.questId,
      date: data.date.present ? data.date.value : this.date,
      objectiveType: data.objectiveType.present
          ? data.objectiveType.value
          : this.objectiveType,
      target: data.target.present ? data.target.value : this.target,
      progress: data.progress.present ? data.progress.value : this.progress,
      status: data.status.present ? data.status.value : this.status,
      expReward: data.expReward.present ? data.expReward.value : this.expReward,
      goldReward: data.goldReward.present
          ? data.goldReward.value
          : this.goldReward,
      claimedAt: data.claimedAt.present ? data.claimedAt.value : this.claimedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestInstance(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('date: $date, ')
          ..write('objectiveType: $objectiveType, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('status: $status, ')
          ..write('expReward: $expReward, ')
          ..write('goldReward: $goldReward, ')
          ..write('claimedAt: $claimedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    questId,
    date,
    objectiveType,
    target,
    progress,
    status,
    expReward,
    goldReward,
    claimedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestInstance &&
          other.id == this.id &&
          other.questId == this.questId &&
          other.date == this.date &&
          other.objectiveType == this.objectiveType &&
          other.target == this.target &&
          other.progress == this.progress &&
          other.status == this.status &&
          other.expReward == this.expReward &&
          other.goldReward == this.goldReward &&
          other.claimedAt == this.claimedAt);
}

class DailyQuestInstancesCompanion extends UpdateCompanion<DailyQuestInstance> {
  final Value<String> id;
  final Value<String> questId;
  final Value<String> date;
  final Value<String> objectiveType;
  final Value<int> target;
  final Value<int> progress;
  final Value<String> status;
  final Value<int> expReward;
  final Value<int> goldReward;
  final Value<DateTime?> claimedAt;
  final Value<int> rowid;
  const DailyQuestInstancesCompanion({
    this.id = const Value.absent(),
    this.questId = const Value.absent(),
    this.date = const Value.absent(),
    this.objectiveType = const Value.absent(),
    this.target = const Value.absent(),
    this.progress = const Value.absent(),
    this.status = const Value.absent(),
    this.expReward = const Value.absent(),
    this.goldReward = const Value.absent(),
    this.claimedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestInstancesCompanion.insert({
    required String id,
    required String questId,
    required String date,
    required String objectiveType,
    required int target,
    required int progress,
    required String status,
    required int expReward,
    required int goldReward,
    this.claimedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       questId = Value(questId),
       date = Value(date),
       objectiveType = Value(objectiveType),
       target = Value(target),
       progress = Value(progress),
       status = Value(status),
       expReward = Value(expReward),
       goldReward = Value(goldReward);
  static Insertable<DailyQuestInstance> custom({
    Expression<String>? id,
    Expression<String>? questId,
    Expression<String>? date,
    Expression<String>? objectiveType,
    Expression<int>? target,
    Expression<int>? progress,
    Expression<String>? status,
    Expression<int>? expReward,
    Expression<int>? goldReward,
    Expression<DateTime>? claimedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questId != null) 'quest_id': questId,
      if (date != null) 'date': date,
      if (objectiveType != null) 'objective_type': objectiveType,
      if (target != null) 'target': target,
      if (progress != null) 'progress': progress,
      if (status != null) 'status': status,
      if (expReward != null) 'exp_reward': expReward,
      if (goldReward != null) 'gold_reward': goldReward,
      if (claimedAt != null) 'claimed_at': claimedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestInstancesCompanion copyWith({
    Value<String>? id,
    Value<String>? questId,
    Value<String>? date,
    Value<String>? objectiveType,
    Value<int>? target,
    Value<int>? progress,
    Value<String>? status,
    Value<int>? expReward,
    Value<int>? goldReward,
    Value<DateTime?>? claimedAt,
    Value<int>? rowid,
  }) {
    return DailyQuestInstancesCompanion(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      date: date ?? this.date,
      objectiveType: objectiveType ?? this.objectiveType,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      expReward: expReward ?? this.expReward,
      goldReward: goldReward ?? this.goldReward,
      claimedAt: claimedAt ?? this.claimedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (objectiveType.present) {
      map['objective_type'] = Variable<String>(objectiveType.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (expReward.present) {
      map['exp_reward'] = Variable<int>(expReward.value);
    }
    if (goldReward.present) {
      map['gold_reward'] = Variable<int>(goldReward.value);
    }
    if (claimedAt.present) {
      map['claimed_at'] = Variable<DateTime>(claimedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestInstancesCompanion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('date: $date, ')
          ..write('objectiveType: $objectiveType, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('status: $status, ')
          ..write('expReward: $expReward, ')
          ..write('goldReward: $goldReward, ')
          ..write('claimedAt: $claimedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HealthDailyTable healthDaily = $HealthDailyTable(this);
  late final $PlayerTable player = $PlayerTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $DebugStepSeedCursorsTable debugStepSeedCursors =
      $DebugStepSeedCursorsTable(this);
  late final $DailyQuestInstancesTable dailyQuestInstances =
      $DailyQuestInstancesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    healthDaily,
    player,
    appSettings,
    debugStepSeedCursors,
    dailyQuestInstances,
  ];
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
typedef $$PlayerTableCreateCompanionBuilder = PlayerCompanion Function({
  Value<int> id,
  required int level,
  required int exp,
  required int energy,
  required int gold,
  required int pendingSteps,
  Value<bool> hasReconciledHistoricalSteps,
});
typedef $$PlayerTableUpdateCompanionBuilder = PlayerCompanion Function({
  Value<int> id,
  Value<int> level,
  Value<int> exp,
  Value<int> energy,
  Value<int> gold,
  Value<int> pendingSteps,
  Value<bool> hasReconciledHistoricalSteps,
});

class $$PlayerTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerTable> {
  $$PlayerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gold => $composableBuilder(
    column: $table.gold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingSteps => $composableBuilder(
    column: $table.pendingSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasReconciledHistoricalSteps => $composableBuilder(
    column: $table.hasReconciledHistoricalSteps,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerTable> {
  $$PlayerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gold => $composableBuilder(
    column: $table.gold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingSteps => $composableBuilder(
    column: $table.pendingSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasReconciledHistoricalSteps => $composableBuilder(
    column: $table.hasReconciledHistoricalSteps,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerTable> {
  $$PlayerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<int> get gold =>
      $composableBuilder(column: $table.gold, builder: (column) => column);

  GeneratedColumn<int> get pendingSteps => $composableBuilder(
    column: $table.pendingSteps,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasReconciledHistoricalSteps => $composableBuilder(
    column: $table.hasReconciledHistoricalSteps,
    builder: (column) => column,
  );
}

class $$PlayerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerTable,
          PlayerData,
          $$PlayerTableFilterComposer,
          $$PlayerTableOrderingComposer,
          $$PlayerTableAnnotationComposer,
          $$PlayerTableCreateCompanionBuilder,
          $$PlayerTableUpdateCompanionBuilder,
          (PlayerData, BaseReferences<_$AppDatabase, $PlayerTable, PlayerData>),
          PlayerData,
          PrefetchHooks Function()
        > {
  $$PlayerTableTableManager(_$AppDatabase db, $PlayerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> exp = const Value.absent(),
                Value<int> energy = const Value.absent(),
                Value<int> gold = const Value.absent(),
                Value<int> pendingSteps = const Value.absent(),
                Value<bool> hasReconciledHistoricalSteps = const Value.absent(),
              }) => PlayerCompanion(
                id: id,
                level: level,
                exp: exp,
                energy: energy,
                gold: gold,
                pendingSteps: pendingSteps,
                hasReconciledHistoricalSteps: hasReconciledHistoricalSteps,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int level,
                required int exp,
                required int energy,
                required int gold,
                required int pendingSteps,
                Value<bool> hasReconciledHistoricalSteps = const Value.absent(),
              }) => PlayerCompanion.insert(
                id: id,
                level: level,
                exp: exp,
                energy: energy,
                gold: gold,
                pendingSteps: pendingSteps,
                hasReconciledHistoricalSteps: hasReconciledHistoricalSteps,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlayerTable, PlayerData>(table),
                  BaseReferences<_$AppDatabase, $PlayerTable, PlayerData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerTable,
      PlayerData,
      $$PlayerTableFilterComposer,
      $$PlayerTableOrderingComposer,
      $$PlayerTableAnnotationComposer,
      $$PlayerTableCreateCompanionBuilder,
      $$PlayerTableUpdateCompanionBuilder,
      (PlayerData, BaseReferences<_$AppDatabase, $PlayerTable, PlayerData>),
      PlayerData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingCompleted,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingCompleted,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                onboardingCompleted: onboardingCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                onboardingCompleted: onboardingCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$DebugStepSeedCursorsTableCreateCompanionBuilder =
    DebugStepSeedCursorsCompanion Function({
      required String date,
      required int nextSlot,
      Value<int> rowid,
    });
typedef $$DebugStepSeedCursorsTableUpdateCompanionBuilder =
    DebugStepSeedCursorsCompanion Function({
      Value<String> date,
      Value<int> nextSlot,
      Value<int> rowid,
    });

class $$DebugStepSeedCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $DebugStepSeedCursorsTable> {
  $$DebugStepSeedCursorsTableFilterComposer({
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

  ColumnFilters<int> get nextSlot => $composableBuilder(
    column: $table.nextSlot,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebugStepSeedCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebugStepSeedCursorsTable> {
  $$DebugStepSeedCursorsTableOrderingComposer({
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

  ColumnOrderings<int> get nextSlot => $composableBuilder(
    column: $table.nextSlot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebugStepSeedCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebugStepSeedCursorsTable> {
  $$DebugStepSeedCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get nextSlot =>
      $composableBuilder(column: $table.nextSlot, builder: (column) => column);
}

class $$DebugStepSeedCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebugStepSeedCursorsTable,
          DebugStepSeedCursor,
          $$DebugStepSeedCursorsTableFilterComposer,
          $$DebugStepSeedCursorsTableOrderingComposer,
          $$DebugStepSeedCursorsTableAnnotationComposer,
          $$DebugStepSeedCursorsTableCreateCompanionBuilder,
          $$DebugStepSeedCursorsTableUpdateCompanionBuilder,
          (
            DebugStepSeedCursor,
            BaseReferences<
              _$AppDatabase,
              $DebugStepSeedCursorsTable,
              DebugStepSeedCursor
            >,
          ),
          DebugStepSeedCursor,
          PrefetchHooks Function()
        > {
  $$DebugStepSeedCursorsTableTableManager(
    _$AppDatabase db,
    $DebugStepSeedCursorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebugStepSeedCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebugStepSeedCursorsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DebugStepSeedCursorsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> nextSlot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebugStepSeedCursorsCompanion(
                date: date,
                nextSlot: nextSlot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int nextSlot,
                Value<int> rowid = const Value.absent(),
              }) => DebugStepSeedCursorsCompanion.insert(
                date: date,
                nextSlot: nextSlot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DebugStepSeedCursorsTable, DebugStepSeedCursor>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DebugStepSeedCursorsTable,
                    DebugStepSeedCursor
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebugStepSeedCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebugStepSeedCursorsTable,
      DebugStepSeedCursor,
      $$DebugStepSeedCursorsTableFilterComposer,
      $$DebugStepSeedCursorsTableOrderingComposer,
      $$DebugStepSeedCursorsTableAnnotationComposer,
      $$DebugStepSeedCursorsTableCreateCompanionBuilder,
      $$DebugStepSeedCursorsTableUpdateCompanionBuilder,
      (
        DebugStepSeedCursor,
        BaseReferences<
          _$AppDatabase,
          $DebugStepSeedCursorsTable,
          DebugStepSeedCursor
        >,
      ),
      DebugStepSeedCursor,
      PrefetchHooks Function()
    >;
typedef $$DailyQuestInstancesTableCreateCompanionBuilder =
    DailyQuestInstancesCompanion Function({
      required String id,
      required String questId,
      required String date,
      required String objectiveType,
      required int target,
      required int progress,
      required String status,
      required int expReward,
      required int goldReward,
      Value<DateTime?> claimedAt,
      Value<int> rowid,
    });
typedef $$DailyQuestInstancesTableUpdateCompanionBuilder =
    DailyQuestInstancesCompanion Function({
      Value<String> id,
      Value<String> questId,
      Value<String> date,
      Value<String> objectiveType,
      Value<int> target,
      Value<int> progress,
      Value<String> status,
      Value<int> expReward,
      Value<int> goldReward,
      Value<DateTime?> claimedAt,
      Value<int> rowid,
    });

class $$DailyQuestInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyQuestInstancesTable> {
  $$DailyQuestInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectiveType => $composableBuilder(
    column: $table.objectiveType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expReward => $composableBuilder(
    column: $table.expReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goldReward => $composableBuilder(
    column: $table.goldReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get claimedAt => $composableBuilder(
    column: $table.claimedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyQuestInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyQuestInstancesTable> {
  $$DailyQuestInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectiveType => $composableBuilder(
    column: $table.objectiveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expReward => $composableBuilder(
    column: $table.expReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goldReward => $composableBuilder(
    column: $table.goldReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get claimedAt => $composableBuilder(
    column: $table.claimedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyQuestInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyQuestInstancesTable> {
  $$DailyQuestInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get objectiveType => $composableBuilder(
    column: $table.objectiveType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get expReward =>
      $composableBuilder(column: $table.expReward, builder: (column) => column);

  GeneratedColumn<int> get goldReward => $composableBuilder(
    column: $table.goldReward,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get claimedAt =>
      $composableBuilder(column: $table.claimedAt, builder: (column) => column);
}

class $$DailyQuestInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyQuestInstancesTable,
          DailyQuestInstance,
          $$DailyQuestInstancesTableFilterComposer,
          $$DailyQuestInstancesTableOrderingComposer,
          $$DailyQuestInstancesTableAnnotationComposer,
          $$DailyQuestInstancesTableCreateCompanionBuilder,
          $$DailyQuestInstancesTableUpdateCompanionBuilder,
          (
            DailyQuestInstance,
            BaseReferences<
              _$AppDatabase,
              $DailyQuestInstancesTable,
              DailyQuestInstance
            >,
          ),
          DailyQuestInstance,
          PrefetchHooks Function()
        > {
  $$DailyQuestInstancesTableTableManager(
    _$AppDatabase db,
    $DailyQuestInstancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestInstancesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyQuestInstancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> questId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> objectiveType = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> expReward = const Value.absent(),
                Value<int> goldReward = const Value.absent(),
                Value<DateTime?> claimedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestInstancesCompanion(
                id: id,
                questId: questId,
                date: date,
                objectiveType: objectiveType,
                target: target,
                progress: progress,
                status: status,
                expReward: expReward,
                goldReward: goldReward,
                claimedAt: claimedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String questId,
                required String date,
                required String objectiveType,
                required int target,
                required int progress,
                required String status,
                required int expReward,
                required int goldReward,
                Value<DateTime?> claimedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestInstancesCompanion.insert(
                id: id,
                questId: questId,
                date: date,
                objectiveType: objectiveType,
                target: target,
                progress: progress,
                status: status,
                expReward: expReward,
                goldReward: goldReward,
                claimedAt: claimedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyQuestInstancesTable, DailyQuestInstance>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyQuestInstancesTable,
                    DailyQuestInstance
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyQuestInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyQuestInstancesTable,
      DailyQuestInstance,
      $$DailyQuestInstancesTableFilterComposer,
      $$DailyQuestInstancesTableOrderingComposer,
      $$DailyQuestInstancesTableAnnotationComposer,
      $$DailyQuestInstancesTableCreateCompanionBuilder,
      $$DailyQuestInstancesTableUpdateCompanionBuilder,
      (
        DailyQuestInstance,
        BaseReferences<
          _$AppDatabase,
          $DailyQuestInstancesTable,
          DailyQuestInstance
        >,
      ),
      DailyQuestInstance,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HealthDailyTableTableManager get healthDaily =>
      $$HealthDailyTableTableManager(_db, _db.healthDaily);
  $$PlayerTableTableManager get player =>
      $$PlayerTableTableManager(_db, _db.player);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$DebugStepSeedCursorsTableTableManager get debugStepSeedCursors =>
      $$DebugStepSeedCursorsTableTableManager(_db, _db.debugStepSeedCursors);
  $$DailyQuestInstancesTableTableManager get dailyQuestInstances =>
      $$DailyQuestInstancesTableTableManager(_db, _db.dailyQuestInstances);
}
