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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HealthDailyTable healthDaily = $HealthDailyTable(this);
  late final $PlayerTable player = $PlayerTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    healthDaily,
    player,
    appSettings,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HealthDailyTableTableManager get healthDaily =>
      $$HealthDailyTableTableManager(_db, _db.healthDaily);
  $$PlayerTableTableManager get player =>
      $$PlayerTableTableManager(_db, _db.player);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
