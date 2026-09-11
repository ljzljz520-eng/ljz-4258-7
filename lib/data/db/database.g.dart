// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VatsTable extends Vats with TableInfo<$VatsTable, Vat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _milkBatchMeta = const VerificationMeta(
    'milkBatch',
  );
  @override
  late final GeneratedColumn<String> milkBatch = GeneratedColumn<String>(
    'milk_batch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    qrCode,
    milkBatch,
    startedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vats';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_qrCodeMeta);
    }
    if (data.containsKey('milk_batch')) {
      context.handle(
        _milkBatchMeta,
        milkBatch.isAcceptableOrUnknown(data['milk_batch']!, _milkBatchMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      )!,
      milkBatch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}milk_batch'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
    );
  }

  @override
  $VatsTable createAlias(String alias) {
    return $VatsTable(attachedDatabase, alias);
  }
}

class Vat extends DataClass implements Insertable<Vat> {
  final String id;
  final String code;
  final String qrCode;
  final String? milkBatch;
  final DateTime? startedAt;
  const Vat({
    required this.id,
    required this.code,
    required this.qrCode,
    this.milkBatch,
    this.startedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['qr_code'] = Variable<String>(qrCode);
    if (!nullToAbsent || milkBatch != null) {
      map['milk_batch'] = Variable<String>(milkBatch);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    return map;
  }

  VatsCompanion toCompanion(bool nullToAbsent) {
    return VatsCompanion(
      id: Value(id),
      code: Value(code),
      qrCode: Value(qrCode),
      milkBatch: milkBatch == null && nullToAbsent
          ? const Value.absent()
          : Value(milkBatch),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
    );
  }

  factory Vat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vat(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      qrCode: serializer.fromJson<String>(json['qrCode']),
      milkBatch: serializer.fromJson<String?>(json['milkBatch']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'qrCode': serializer.toJson<String>(qrCode),
      'milkBatch': serializer.toJson<String?>(milkBatch),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
    };
  }

  Vat copyWith({
    String? id,
    String? code,
    String? qrCode,
    Value<String?> milkBatch = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
  }) => Vat(
    id: id ?? this.id,
    code: code ?? this.code,
    qrCode: qrCode ?? this.qrCode,
    milkBatch: milkBatch.present ? milkBatch.value : this.milkBatch,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
  );
  Vat copyWithCompanion(VatsCompanion data) {
    return Vat(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
      milkBatch: data.milkBatch.present ? data.milkBatch.value : this.milkBatch,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vat(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('qrCode: $qrCode, ')
          ..write('milkBatch: $milkBatch, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, qrCode, milkBatch, startedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vat &&
          other.id == this.id &&
          other.code == this.code &&
          other.qrCode == this.qrCode &&
          other.milkBatch == this.milkBatch &&
          other.startedAt == this.startedAt);
}

class VatsCompanion extends UpdateCompanion<Vat> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> qrCode;
  final Value<String?> milkBatch;
  final Value<DateTime?> startedAt;
  final Value<int> rowid;
  const VatsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.milkBatch = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VatsCompanion.insert({
    required String id,
    required String code,
    required String qrCode,
    this.milkBatch = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       qrCode = Value(qrCode);
  static Insertable<Vat> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? qrCode,
    Expression<String>? milkBatch,
    Expression<DateTime>? startedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (qrCode != null) 'qr_code': qrCode,
      if (milkBatch != null) 'milk_batch': milkBatch,
      if (startedAt != null) 'started_at': startedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VatsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? qrCode,
    Value<String?>? milkBatch,
    Value<DateTime?>? startedAt,
    Value<int>? rowid,
  }) {
    return VatsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      qrCode: qrCode ?? this.qrCode,
      milkBatch: milkBatch ?? this.milkBatch,
      startedAt: startedAt ?? this.startedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (milkBatch.present) {
      map['milk_batch'] = Variable<String>(milkBatch.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VatsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('qrCode: $qrCode, ')
          ..write('milkBatch: $milkBatch, ')
          ..write('startedAt: $startedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProcessVersionsTable extends ProcessVersions
    with TableInfo<$ProcessVersionsTable, ProcessVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProcessVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frozenByMeta = const VerificationMeta(
    'frozenBy',
  );
  @override
  late final GeneratedColumn<String> frozenBy = GeneratedColumn<String>(
    'frozen_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frozenAtMeta = const VerificationMeta(
    'frozenAt',
  );
  @override
  late final GeneratedColumn<DateTime> frozenAt = GeneratedColumn<DateTime>(
    'frozen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepOrderJsonMeta = const VerificationMeta(
    'stepOrderJson',
  );
  @override
  late final GeneratedColumn<String> stepOrderJson = GeneratedColumn<String>(
    'step_order_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tolerancesJsonMeta = const VerificationMeta(
    'tolerancesJson',
  );
  @override
  late final GeneratedColumn<String> tolerancesJson = GeneratedColumn<String>(
    'tolerances_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    frozenBy,
    frozenAt,
    stepOrderJson,
    tolerancesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'process_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProcessVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('frozen_by')) {
      context.handle(
        _frozenByMeta,
        frozenBy.isAcceptableOrUnknown(data['frozen_by']!, _frozenByMeta),
      );
    } else if (isInserting) {
      context.missing(_frozenByMeta);
    }
    if (data.containsKey('frozen_at')) {
      context.handle(
        _frozenAtMeta,
        frozenAt.isAcceptableOrUnknown(data['frozen_at']!, _frozenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_frozenAtMeta);
    }
    if (data.containsKey('step_order_json')) {
      context.handle(
        _stepOrderJsonMeta,
        stepOrderJson.isAcceptableOrUnknown(
          data['step_order_json']!,
          _stepOrderJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stepOrderJsonMeta);
    }
    if (data.containsKey('tolerances_json')) {
      context.handle(
        _tolerancesJsonMeta,
        tolerancesJson.isAcceptableOrUnknown(
          data['tolerances_json']!,
          _tolerancesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tolerancesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProcessVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProcessVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      frozenBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frozen_by'],
      )!,
      frozenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}frozen_at'],
      )!,
      stepOrderJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_order_json'],
      )!,
      tolerancesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tolerances_json'],
      )!,
    );
  }

  @override
  $ProcessVersionsTable createAlias(String alias) {
    return $ProcessVersionsTable(attachedDatabase, alias);
  }
}

class ProcessVersion extends DataClass implements Insertable<ProcessVersion> {
  final String id;
  final String name;
  final String frozenBy;
  final DateTime frozenAt;
  final String stepOrderJson;
  final String tolerancesJson;
  const ProcessVersion({
    required this.id,
    required this.name,
    required this.frozenBy,
    required this.frozenAt,
    required this.stepOrderJson,
    required this.tolerancesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['frozen_by'] = Variable<String>(frozenBy);
    map['frozen_at'] = Variable<DateTime>(frozenAt);
    map['step_order_json'] = Variable<String>(stepOrderJson);
    map['tolerances_json'] = Variable<String>(tolerancesJson);
    return map;
  }

  ProcessVersionsCompanion toCompanion(bool nullToAbsent) {
    return ProcessVersionsCompanion(
      id: Value(id),
      name: Value(name),
      frozenBy: Value(frozenBy),
      frozenAt: Value(frozenAt),
      stepOrderJson: Value(stepOrderJson),
      tolerancesJson: Value(tolerancesJson),
    );
  }

  factory ProcessVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProcessVersion(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      frozenBy: serializer.fromJson<String>(json['frozenBy']),
      frozenAt: serializer.fromJson<DateTime>(json['frozenAt']),
      stepOrderJson: serializer.fromJson<String>(json['stepOrderJson']),
      tolerancesJson: serializer.fromJson<String>(json['tolerancesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'frozenBy': serializer.toJson<String>(frozenBy),
      'frozenAt': serializer.toJson<DateTime>(frozenAt),
      'stepOrderJson': serializer.toJson<String>(stepOrderJson),
      'tolerancesJson': serializer.toJson<String>(tolerancesJson),
    };
  }

  ProcessVersion copyWith({
    String? id,
    String? name,
    String? frozenBy,
    DateTime? frozenAt,
    String? stepOrderJson,
    String? tolerancesJson,
  }) => ProcessVersion(
    id: id ?? this.id,
    name: name ?? this.name,
    frozenBy: frozenBy ?? this.frozenBy,
    frozenAt: frozenAt ?? this.frozenAt,
    stepOrderJson: stepOrderJson ?? this.stepOrderJson,
    tolerancesJson: tolerancesJson ?? this.tolerancesJson,
  );
  ProcessVersion copyWithCompanion(ProcessVersionsCompanion data) {
    return ProcessVersion(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      frozenBy: data.frozenBy.present ? data.frozenBy.value : this.frozenBy,
      frozenAt: data.frozenAt.present ? data.frozenAt.value : this.frozenAt,
      stepOrderJson: data.stepOrderJson.present
          ? data.stepOrderJson.value
          : this.stepOrderJson,
      tolerancesJson: data.tolerancesJson.present
          ? data.tolerancesJson.value
          : this.tolerancesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProcessVersion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('frozenBy: $frozenBy, ')
          ..write('frozenAt: $frozenAt, ')
          ..write('stepOrderJson: $stepOrderJson, ')
          ..write('tolerancesJson: $tolerancesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, frozenBy, frozenAt, stepOrderJson, tolerancesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProcessVersion &&
          other.id == this.id &&
          other.name == this.name &&
          other.frozenBy == this.frozenBy &&
          other.frozenAt == this.frozenAt &&
          other.stepOrderJson == this.stepOrderJson &&
          other.tolerancesJson == this.tolerancesJson);
}

class ProcessVersionsCompanion extends UpdateCompanion<ProcessVersion> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> frozenBy;
  final Value<DateTime> frozenAt;
  final Value<String> stepOrderJson;
  final Value<String> tolerancesJson;
  final Value<int> rowid;
  const ProcessVersionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.frozenBy = const Value.absent(),
    this.frozenAt = const Value.absent(),
    this.stepOrderJson = const Value.absent(),
    this.tolerancesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProcessVersionsCompanion.insert({
    required String id,
    required String name,
    required String frozenBy,
    required DateTime frozenAt,
    required String stepOrderJson,
    required String tolerancesJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       frozenBy = Value(frozenBy),
       frozenAt = Value(frozenAt),
       stepOrderJson = Value(stepOrderJson),
       tolerancesJson = Value(tolerancesJson);
  static Insertable<ProcessVersion> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? frozenBy,
    Expression<DateTime>? frozenAt,
    Expression<String>? stepOrderJson,
    Expression<String>? tolerancesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (frozenBy != null) 'frozen_by': frozenBy,
      if (frozenAt != null) 'frozen_at': frozenAt,
      if (stepOrderJson != null) 'step_order_json': stepOrderJson,
      if (tolerancesJson != null) 'tolerances_json': tolerancesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProcessVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? frozenBy,
    Value<DateTime>? frozenAt,
    Value<String>? stepOrderJson,
    Value<String>? tolerancesJson,
    Value<int>? rowid,
  }) {
    return ProcessVersionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      frozenBy: frozenBy ?? this.frozenBy,
      frozenAt: frozenAt ?? this.frozenAt,
      stepOrderJson: stepOrderJson ?? this.stepOrderJson,
      tolerancesJson: tolerancesJson ?? this.tolerancesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (frozenBy.present) {
      map['frozen_by'] = Variable<String>(frozenBy.value);
    }
    if (frozenAt.present) {
      map['frozen_at'] = Variable<DateTime>(frozenAt.value);
    }
    if (stepOrderJson.present) {
      map['step_order_json'] = Variable<String>(stepOrderJson.value);
    }
    if (tolerancesJson.present) {
      map['tolerances_json'] = Variable<String>(tolerancesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProcessVersionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('frozenBy: $frozenBy, ')
          ..write('frozenAt: $frozenAt, ')
          ..write('stepOrderJson: $stepOrderJson, ')
          ..write('tolerancesJson: $tolerancesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActionEventsTable extends ActionEvents
    with TableInfo<$ActionEventsTable, ActionEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StepKind, int> step =
      GeneratedColumn<int>(
        'step',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StepKind>($ActionEventsTable.$converterstep);
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatorIdMeta = const VerificationMeta(
    'operatorId',
  );
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
    'operator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processVersionIdMeta = const VerificationMeta(
    'processVersionId',
  );
  @override
  late final GeneratedColumn<String> processVersionId = GeneratedColumn<String>(
    'process_version_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureCMeta = const VerificationMeta(
    'temperatureC',
  );
  @override
  late final GeneratedColumn<double> temperatureC = GeneratedColumn<double>(
    'temperature_c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VisualState?, int> visualState =
      GeneratedColumn<int>(
        'visual_state',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<VisualState?>($ActionEventsTable.$convertervisualStaten);
  static const VerificationMeta _cutSizeMmMeta = const VerificationMeta(
    'cutSizeMm',
  );
  @override
  late final GeneratedColumn<double> cutSizeMm = GeneratedColumn<double>(
    'cut_size_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VatZone?, int> zone =
      GeneratedColumn<int>(
        'zone',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<VatZone?>($ActionEventsTable.$converterzonen);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vatId,
    step,
    performedAt,
    operatorId,
    processVersionId,
    temperatureC,
    visualState,
    cutSizeMm,
    zone,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'action_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActionEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
        _operatorIdMeta,
        operatorId.isAcceptableOrUnknown(data['operator_id']!, _operatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('process_version_id')) {
      context.handle(
        _processVersionIdMeta,
        processVersionId.isAcceptableOrUnknown(
          data['process_version_id']!,
          _processVersionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processVersionIdMeta);
    }
    if (data.containsKey('temperature_c')) {
      context.handle(
        _temperatureCMeta,
        temperatureC.isAcceptableOrUnknown(
          data['temperature_c']!,
          _temperatureCMeta,
        ),
      );
    }
    if (data.containsKey('cut_size_mm')) {
      context.handle(
        _cutSizeMmMeta,
        cutSizeMm.isAcceptableOrUnknown(data['cut_size_mm']!, _cutSizeMmMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActionEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      step: $ActionEventsTable.$converterstep.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}step'],
        )!,
      ),
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
      operatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_id'],
      )!,
      processVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_version_id'],
      )!,
      temperatureC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature_c'],
      ),
      visualState: $ActionEventsTable.$convertervisualStaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}visual_state'],
        ),
      ),
      cutSizeMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cut_size_mm'],
      ),
      zone: $ActionEventsTable.$converterzonen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}zone'],
        ),
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ActionEventsTable createAlias(String alias) {
    return $ActionEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StepKind, int, int> $converterstep =
      const EnumIndexConverter<StepKind>(StepKind.values);
  static JsonTypeConverter2<VisualState, int, int> $convertervisualState =
      const EnumIndexConverter<VisualState>(VisualState.values);
  static JsonTypeConverter2<VisualState?, int?, int?> $convertervisualStaten =
      JsonTypeConverter2.asNullable($convertervisualState);
  static JsonTypeConverter2<VatZone, int, int> $converterzone =
      const EnumIndexConverter<VatZone>(VatZone.values);
  static JsonTypeConverter2<VatZone?, int?, int?> $converterzonen =
      JsonTypeConverter2.asNullable($converterzone);
}

class ActionEvent extends DataClass implements Insertable<ActionEvent> {
  final String id;
  final String vatId;
  final StepKind step;
  final DateTime performedAt;
  final String operatorId;
  final String processVersionId;
  final double? temperatureC;
  final VisualState? visualState;
  final double? cutSizeMm;
  final VatZone? zone;
  final String? note;
  const ActionEvent({
    required this.id,
    required this.vatId,
    required this.step,
    required this.performedAt,
    required this.operatorId,
    required this.processVersionId,
    this.temperatureC,
    this.visualState,
    this.cutSizeMm,
    this.zone,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vat_id'] = Variable<String>(vatId);
    {
      map['step'] = Variable<int>(
        $ActionEventsTable.$converterstep.toSql(step),
      );
    }
    map['performed_at'] = Variable<DateTime>(performedAt);
    map['operator_id'] = Variable<String>(operatorId);
    map['process_version_id'] = Variable<String>(processVersionId);
    if (!nullToAbsent || temperatureC != null) {
      map['temperature_c'] = Variable<double>(temperatureC);
    }
    if (!nullToAbsent || visualState != null) {
      map['visual_state'] = Variable<int>(
        $ActionEventsTable.$convertervisualStaten.toSql(visualState),
      );
    }
    if (!nullToAbsent || cutSizeMm != null) {
      map['cut_size_mm'] = Variable<double>(cutSizeMm);
    }
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<int>(
        $ActionEventsTable.$converterzonen.toSql(zone),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ActionEventsCompanion toCompanion(bool nullToAbsent) {
    return ActionEventsCompanion(
      id: Value(id),
      vatId: Value(vatId),
      step: Value(step),
      performedAt: Value(performedAt),
      operatorId: Value(operatorId),
      processVersionId: Value(processVersionId),
      temperatureC: temperatureC == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureC),
      visualState: visualState == null && nullToAbsent
          ? const Value.absent()
          : Value(visualState),
      cutSizeMm: cutSizeMm == null && nullToAbsent
          ? const Value.absent()
          : Value(cutSizeMm),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ActionEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActionEvent(
      id: serializer.fromJson<String>(json['id']),
      vatId: serializer.fromJson<String>(json['vatId']),
      step: $ActionEventsTable.$converterstep.fromJson(
        serializer.fromJson<int>(json['step']),
      ),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      processVersionId: serializer.fromJson<String>(json['processVersionId']),
      temperatureC: serializer.fromJson<double?>(json['temperatureC']),
      visualState: $ActionEventsTable.$convertervisualStaten.fromJson(
        serializer.fromJson<int?>(json['visualState']),
      ),
      cutSizeMm: serializer.fromJson<double?>(json['cutSizeMm']),
      zone: $ActionEventsTable.$converterzonen.fromJson(
        serializer.fromJson<int?>(json['zone']),
      ),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vatId': serializer.toJson<String>(vatId),
      'step': serializer.toJson<int>(
        $ActionEventsTable.$converterstep.toJson(step),
      ),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'operatorId': serializer.toJson<String>(operatorId),
      'processVersionId': serializer.toJson<String>(processVersionId),
      'temperatureC': serializer.toJson<double?>(temperatureC),
      'visualState': serializer.toJson<int?>(
        $ActionEventsTable.$convertervisualStaten.toJson(visualState),
      ),
      'cutSizeMm': serializer.toJson<double?>(cutSizeMm),
      'zone': serializer.toJson<int?>(
        $ActionEventsTable.$converterzonen.toJson(zone),
      ),
      'note': serializer.toJson<String?>(note),
    };
  }

  ActionEvent copyWith({
    String? id,
    String? vatId,
    StepKind? step,
    DateTime? performedAt,
    String? operatorId,
    String? processVersionId,
    Value<double?> temperatureC = const Value.absent(),
    Value<VisualState?> visualState = const Value.absent(),
    Value<double?> cutSizeMm = const Value.absent(),
    Value<VatZone?> zone = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => ActionEvent(
    id: id ?? this.id,
    vatId: vatId ?? this.vatId,
    step: step ?? this.step,
    performedAt: performedAt ?? this.performedAt,
    operatorId: operatorId ?? this.operatorId,
    processVersionId: processVersionId ?? this.processVersionId,
    temperatureC: temperatureC.present ? temperatureC.value : this.temperatureC,
    visualState: visualState.present ? visualState.value : this.visualState,
    cutSizeMm: cutSizeMm.present ? cutSizeMm.value : this.cutSizeMm,
    zone: zone.present ? zone.value : this.zone,
    note: note.present ? note.value : this.note,
  );
  ActionEvent copyWithCompanion(ActionEventsCompanion data) {
    return ActionEvent(
      id: data.id.present ? data.id.value : this.id,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      step: data.step.present ? data.step.value : this.step,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      operatorId: data.operatorId.present
          ? data.operatorId.value
          : this.operatorId,
      processVersionId: data.processVersionId.present
          ? data.processVersionId.value
          : this.processVersionId,
      temperatureC: data.temperatureC.present
          ? data.temperatureC.value
          : this.temperatureC,
      visualState: data.visualState.present
          ? data.visualState.value
          : this.visualState,
      cutSizeMm: data.cutSizeMm.present ? data.cutSizeMm.value : this.cutSizeMm,
      zone: data.zone.present ? data.zone.value : this.zone,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActionEvent(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('step: $step, ')
          ..write('performedAt: $performedAt, ')
          ..write('operatorId: $operatorId, ')
          ..write('processVersionId: $processVersionId, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('visualState: $visualState, ')
          ..write('cutSizeMm: $cutSizeMm, ')
          ..write('zone: $zone, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vatId,
    step,
    performedAt,
    operatorId,
    processVersionId,
    temperatureC,
    visualState,
    cutSizeMm,
    zone,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionEvent &&
          other.id == this.id &&
          other.vatId == this.vatId &&
          other.step == this.step &&
          other.performedAt == this.performedAt &&
          other.operatorId == this.operatorId &&
          other.processVersionId == this.processVersionId &&
          other.temperatureC == this.temperatureC &&
          other.visualState == this.visualState &&
          other.cutSizeMm == this.cutSizeMm &&
          other.zone == this.zone &&
          other.note == this.note);
}

class ActionEventsCompanion extends UpdateCompanion<ActionEvent> {
  final Value<String> id;
  final Value<String> vatId;
  final Value<StepKind> step;
  final Value<DateTime> performedAt;
  final Value<String> operatorId;
  final Value<String> processVersionId;
  final Value<double?> temperatureC;
  final Value<VisualState?> visualState;
  final Value<double?> cutSizeMm;
  final Value<VatZone?> zone;
  final Value<String?> note;
  final Value<int> rowid;
  const ActionEventsCompanion({
    this.id = const Value.absent(),
    this.vatId = const Value.absent(),
    this.step = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.processVersionId = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.visualState = const Value.absent(),
    this.cutSizeMm = const Value.absent(),
    this.zone = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActionEventsCompanion.insert({
    required String id,
    required String vatId,
    required StepKind step,
    required DateTime performedAt,
    required String operatorId,
    required String processVersionId,
    this.temperatureC = const Value.absent(),
    this.visualState = const Value.absent(),
    this.cutSizeMm = const Value.absent(),
    this.zone = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vatId = Value(vatId),
       step = Value(step),
       performedAt = Value(performedAt),
       operatorId = Value(operatorId),
       processVersionId = Value(processVersionId);
  static Insertable<ActionEvent> custom({
    Expression<String>? id,
    Expression<String>? vatId,
    Expression<int>? step,
    Expression<DateTime>? performedAt,
    Expression<String>? operatorId,
    Expression<String>? processVersionId,
    Expression<double>? temperatureC,
    Expression<int>? visualState,
    Expression<double>? cutSizeMm,
    Expression<int>? zone,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vatId != null) 'vat_id': vatId,
      if (step != null) 'step': step,
      if (performedAt != null) 'performed_at': performedAt,
      if (operatorId != null) 'operator_id': operatorId,
      if (processVersionId != null) 'process_version_id': processVersionId,
      if (temperatureC != null) 'temperature_c': temperatureC,
      if (visualState != null) 'visual_state': visualState,
      if (cutSizeMm != null) 'cut_size_mm': cutSizeMm,
      if (zone != null) 'zone': zone,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActionEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? vatId,
    Value<StepKind>? step,
    Value<DateTime>? performedAt,
    Value<String>? operatorId,
    Value<String>? processVersionId,
    Value<double?>? temperatureC,
    Value<VisualState?>? visualState,
    Value<double?>? cutSizeMm,
    Value<VatZone?>? zone,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return ActionEventsCompanion(
      id: id ?? this.id,
      vatId: vatId ?? this.vatId,
      step: step ?? this.step,
      performedAt: performedAt ?? this.performedAt,
      operatorId: operatorId ?? this.operatorId,
      processVersionId: processVersionId ?? this.processVersionId,
      temperatureC: temperatureC ?? this.temperatureC,
      visualState: visualState ?? this.visualState,
      cutSizeMm: cutSizeMm ?? this.cutSizeMm,
      zone: zone ?? this.zone,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(
        $ActionEventsTable.$converterstep.toSql(step.value),
      );
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (processVersionId.present) {
      map['process_version_id'] = Variable<String>(processVersionId.value);
    }
    if (temperatureC.present) {
      map['temperature_c'] = Variable<double>(temperatureC.value);
    }
    if (visualState.present) {
      map['visual_state'] = Variable<int>(
        $ActionEventsTable.$convertervisualStaten.toSql(visualState.value),
      );
    }
    if (cutSizeMm.present) {
      map['cut_size_mm'] = Variable<double>(cutSizeMm.value);
    }
    if (zone.present) {
      map['zone'] = Variable<int>(
        $ActionEventsTable.$converterzonen.toSql(zone.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionEventsCompanion(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('step: $step, ')
          ..write('performedAt: $performedAt, ')
          ..write('operatorId: $operatorId, ')
          ..write('processVersionId: $processVersionId, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('visualState: $visualState, ')
          ..write('cutSizeMm: $cutSizeMm, ')
          ..write('zone: $zone, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WheyTanksTable extends WheyTanks
    with TableInfo<$WheyTanksTable, WheyTank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WheyTanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, qrCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whey_tanks';
  @override
  VerificationContext validateIntegrity(
    Insertable<WheyTank> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_qrCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WheyTank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WheyTank(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      )!,
    );
  }

  @override
  $WheyTanksTable createAlias(String alias) {
    return $WheyTanksTable(attachedDatabase, alias);
  }
}

class WheyTank extends DataClass implements Insertable<WheyTank> {
  final String id;
  final String code;
  final String qrCode;
  const WheyTank({required this.id, required this.code, required this.qrCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['qr_code'] = Variable<String>(qrCode);
    return map;
  }

  WheyTanksCompanion toCompanion(bool nullToAbsent) {
    return WheyTanksCompanion(
      id: Value(id),
      code: Value(code),
      qrCode: Value(qrCode),
    );
  }

  factory WheyTank.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WheyTank(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      qrCode: serializer.fromJson<String>(json['qrCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'qrCode': serializer.toJson<String>(qrCode),
    };
  }

  WheyTank copyWith({String? id, String? code, String? qrCode}) => WheyTank(
    id: id ?? this.id,
    code: code ?? this.code,
    qrCode: qrCode ?? this.qrCode,
  );
  WheyTank copyWithCompanion(WheyTanksCompanion data) {
    return WheyTank(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WheyTank(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('qrCode: $qrCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, qrCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WheyTank &&
          other.id == this.id &&
          other.code == this.code &&
          other.qrCode == this.qrCode);
}

class WheyTanksCompanion extends UpdateCompanion<WheyTank> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> qrCode;
  final Value<int> rowid;
  const WheyTanksCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WheyTanksCompanion.insert({
    required String id,
    required String code,
    required String qrCode,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       qrCode = Value(qrCode);
  static Insertable<WheyTank> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? qrCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (qrCode != null) 'qr_code': qrCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WheyTanksCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? qrCode,
    Value<int>? rowid,
  }) {
    return WheyTanksCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      qrCode: qrCode ?? this.qrCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WheyTanksCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('qrCode: $qrCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WheyTransfersTable extends WheyTransfers
    with TableInfo<$WheyTransfersTable, WheyTransfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WheyTransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tankIdMeta = const VerificationMeta('tankId');
  @override
  late final GeneratedColumn<String> tankId = GeneratedColumn<String>(
    'tank_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transferredAtMeta = const VerificationMeta(
    'transferredAt',
  );
  @override
  late final GeneratedColumn<DateTime> transferredAt =
      GeneratedColumn<DateTime>(
        'transferred_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _amountLMeta = const VerificationMeta(
    'amountL',
  );
  @override
  late final GeneratedColumn<double> amountL = GeneratedColumn<double>(
    'amount_l',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vatId,
    tankId,
    transferredAt,
    amountL,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whey_transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<WheyTransfer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('tank_id')) {
      context.handle(
        _tankIdMeta,
        tankId.isAcceptableOrUnknown(data['tank_id']!, _tankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tankIdMeta);
    }
    if (data.containsKey('transferred_at')) {
      context.handle(
        _transferredAtMeta,
        transferredAt.isAcceptableOrUnknown(
          data['transferred_at']!,
          _transferredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transferredAtMeta);
    }
    if (data.containsKey('amount_l')) {
      context.handle(
        _amountLMeta,
        amountL.isAcceptableOrUnknown(data['amount_l']!, _amountLMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WheyTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WheyTransfer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      tankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tank_id'],
      )!,
      transferredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transferred_at'],
      )!,
      amountL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_l'],
      ),
    );
  }

  @override
  $WheyTransfersTable createAlias(String alias) {
    return $WheyTransfersTable(attachedDatabase, alias);
  }
}

class WheyTransfer extends DataClass implements Insertable<WheyTransfer> {
  final String id;
  final String vatId;
  final String tankId;
  final DateTime transferredAt;
  final double? amountL;
  const WheyTransfer({
    required this.id,
    required this.vatId,
    required this.tankId,
    required this.transferredAt,
    this.amountL,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vat_id'] = Variable<String>(vatId);
    map['tank_id'] = Variable<String>(tankId);
    map['transferred_at'] = Variable<DateTime>(transferredAt);
    if (!nullToAbsent || amountL != null) {
      map['amount_l'] = Variable<double>(amountL);
    }
    return map;
  }

  WheyTransfersCompanion toCompanion(bool nullToAbsent) {
    return WheyTransfersCompanion(
      id: Value(id),
      vatId: Value(vatId),
      tankId: Value(tankId),
      transferredAt: Value(transferredAt),
      amountL: amountL == null && nullToAbsent
          ? const Value.absent()
          : Value(amountL),
    );
  }

  factory WheyTransfer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WheyTransfer(
      id: serializer.fromJson<String>(json['id']),
      vatId: serializer.fromJson<String>(json['vatId']),
      tankId: serializer.fromJson<String>(json['tankId']),
      transferredAt: serializer.fromJson<DateTime>(json['transferredAt']),
      amountL: serializer.fromJson<double?>(json['amountL']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vatId': serializer.toJson<String>(vatId),
      'tankId': serializer.toJson<String>(tankId),
      'transferredAt': serializer.toJson<DateTime>(transferredAt),
      'amountL': serializer.toJson<double?>(amountL),
    };
  }

  WheyTransfer copyWith({
    String? id,
    String? vatId,
    String? tankId,
    DateTime? transferredAt,
    Value<double?> amountL = const Value.absent(),
  }) => WheyTransfer(
    id: id ?? this.id,
    vatId: vatId ?? this.vatId,
    tankId: tankId ?? this.tankId,
    transferredAt: transferredAt ?? this.transferredAt,
    amountL: amountL.present ? amountL.value : this.amountL,
  );
  WheyTransfer copyWithCompanion(WheyTransfersCompanion data) {
    return WheyTransfer(
      id: data.id.present ? data.id.value : this.id,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      tankId: data.tankId.present ? data.tankId.value : this.tankId,
      transferredAt: data.transferredAt.present
          ? data.transferredAt.value
          : this.transferredAt,
      amountL: data.amountL.present ? data.amountL.value : this.amountL,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WheyTransfer(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('tankId: $tankId, ')
          ..write('transferredAt: $transferredAt, ')
          ..write('amountL: $amountL')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vatId, tankId, transferredAt, amountL);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WheyTransfer &&
          other.id == this.id &&
          other.vatId == this.vatId &&
          other.tankId == this.tankId &&
          other.transferredAt == this.transferredAt &&
          other.amountL == this.amountL);
}

class WheyTransfersCompanion extends UpdateCompanion<WheyTransfer> {
  final Value<String> id;
  final Value<String> vatId;
  final Value<String> tankId;
  final Value<DateTime> transferredAt;
  final Value<double?> amountL;
  final Value<int> rowid;
  const WheyTransfersCompanion({
    this.id = const Value.absent(),
    this.vatId = const Value.absent(),
    this.tankId = const Value.absent(),
    this.transferredAt = const Value.absent(),
    this.amountL = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WheyTransfersCompanion.insert({
    required String id,
    required String vatId,
    required String tankId,
    required DateTime transferredAt,
    this.amountL = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vatId = Value(vatId),
       tankId = Value(tankId),
       transferredAt = Value(transferredAt);
  static Insertable<WheyTransfer> custom({
    Expression<String>? id,
    Expression<String>? vatId,
    Expression<String>? tankId,
    Expression<DateTime>? transferredAt,
    Expression<double>? amountL,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vatId != null) 'vat_id': vatId,
      if (tankId != null) 'tank_id': tankId,
      if (transferredAt != null) 'transferred_at': transferredAt,
      if (amountL != null) 'amount_l': amountL,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WheyTransfersCompanion copyWith({
    Value<String>? id,
    Value<String>? vatId,
    Value<String>? tankId,
    Value<DateTime>? transferredAt,
    Value<double?>? amountL,
    Value<int>? rowid,
  }) {
    return WheyTransfersCompanion(
      id: id ?? this.id,
      vatId: vatId ?? this.vatId,
      tankId: tankId ?? this.tankId,
      transferredAt: transferredAt ?? this.transferredAt,
      amountL: amountL ?? this.amountL,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (tankId.present) {
      map['tank_id'] = Variable<String>(tankId.value);
    }
    if (transferredAt.present) {
      map['transferred_at'] = Variable<DateTime>(transferredAt.value);
    }
    if (amountL.present) {
      map['amount_l'] = Variable<double>(amountL.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WheyTransfersCompanion(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('tankId: $tankId, ')
          ..write('transferredAt: $transferredAt, ')
          ..write('amountL: $amountL, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoldBatchesTable extends MoldBatches
    with TableInfo<$MoldBatchesTable, MoldBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoldBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, vatId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mold_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoldBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoldBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoldBatche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MoldBatchesTable createAlias(String alias) {
    return $MoldBatchesTable(attachedDatabase, alias);
  }
}

class MoldBatche extends DataClass implements Insertable<MoldBatche> {
  final String id;
  final String code;
  final String vatId;
  final DateTime createdAt;
  const MoldBatche({
    required this.id,
    required this.code,
    required this.vatId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['vat_id'] = Variable<String>(vatId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MoldBatchesCompanion toCompanion(bool nullToAbsent) {
    return MoldBatchesCompanion(
      id: Value(id),
      code: Value(code),
      vatId: Value(vatId),
      createdAt: Value(createdAt),
    );
  }

  factory MoldBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoldBatche(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      vatId: serializer.fromJson<String>(json['vatId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'vatId': serializer.toJson<String>(vatId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MoldBatche copyWith({
    String? id,
    String? code,
    String? vatId,
    DateTime? createdAt,
  }) => MoldBatche(
    id: id ?? this.id,
    code: code ?? this.code,
    vatId: vatId ?? this.vatId,
    createdAt: createdAt ?? this.createdAt,
  );
  MoldBatche copyWithCompanion(MoldBatchesCompanion data) {
    return MoldBatche(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoldBatche(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('vatId: $vatId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, vatId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoldBatche &&
          other.id == this.id &&
          other.code == this.code &&
          other.vatId == this.vatId &&
          other.createdAt == this.createdAt);
}

class MoldBatchesCompanion extends UpdateCompanion<MoldBatche> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> vatId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MoldBatchesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.vatId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoldBatchesCompanion.insert({
    required String id,
    required String code,
    required String vatId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       vatId = Value(vatId),
       createdAt = Value(createdAt);
  static Insertable<MoldBatche> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? vatId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (vatId != null) 'vat_id': vatId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoldBatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? vatId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MoldBatchesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      vatId: vatId ?? this.vatId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoldBatchesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('vatId: $vatId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoldsTable extends Molds with TableInfo<$MoldsTable, Mold> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _weightGMeta = const VerificationMeta(
    'weightG',
  );
  @override
  late final GeneratedColumn<double> weightG = GeneratedColumn<double>(
    'weight_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moldedAtMeta = const VerificationMeta(
    'moldedAt',
  );
  @override
  late final GeneratedColumn<DateTime> moldedAt = GeneratedColumn<DateTime>(
    'molded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pressedAtMeta = const VerificationMeta(
    'pressedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pressedAt = GeneratedColumn<DateTime>(
    'pressed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoldedFromIdMeta = const VerificationMeta(
    'remoldedFromId',
  );
  @override
  late final GeneratedColumn<String> remoldedFromId = GeneratedColumn<String>(
    'remolded_from_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoldedAtMeta = const VerificationMeta(
    'remoldedAt',
  );
  @override
  late final GeneratedColumn<DateTime> remoldedAt = GeneratedColumn<DateTime>(
    'remolded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitFromMoldIdMeta = const VerificationMeta(
    'splitFromMoldId',
  );
  @override
  late final GeneratedColumn<String> splitFromMoldId = GeneratedColumn<String>(
    'split_from_mold_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitAtMeta = const VerificationMeta(
    'splitAt',
  );
  @override
  late final GeneratedColumn<DateTime> splitAt = GeneratedColumn<DateTime>(
    'split_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    vatId,
    qrCode,
    weightG,
    moldedAt,
    pressedAt,
    remoldedFromId,
    remoldedAt,
    splitFromMoldId,
    splitAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'molds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mold> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_qrCodeMeta);
    }
    if (data.containsKey('weight_g')) {
      context.handle(
        _weightGMeta,
        weightG.isAcceptableOrUnknown(data['weight_g']!, _weightGMeta),
      );
    }
    if (data.containsKey('molded_at')) {
      context.handle(
        _moldedAtMeta,
        moldedAt.isAcceptableOrUnknown(data['molded_at']!, _moldedAtMeta),
      );
    }
    if (data.containsKey('pressed_at')) {
      context.handle(
        _pressedAtMeta,
        pressedAt.isAcceptableOrUnknown(data['pressed_at']!, _pressedAtMeta),
      );
    }
    if (data.containsKey('remolded_from_id')) {
      context.handle(
        _remoldedFromIdMeta,
        remoldedFromId.isAcceptableOrUnknown(
          data['remolded_from_id']!,
          _remoldedFromIdMeta,
        ),
      );
    }
    if (data.containsKey('remolded_at')) {
      context.handle(
        _remoldedAtMeta,
        remoldedAt.isAcceptableOrUnknown(data['remolded_at']!, _remoldedAtMeta),
      );
    }
    if (data.containsKey('split_from_mold_id')) {
      context.handle(
        _splitFromMoldIdMeta,
        splitFromMoldId.isAcceptableOrUnknown(
          data['split_from_mold_id']!,
          _splitFromMoldIdMeta,
        ),
      );
    }
    if (data.containsKey('split_at')) {
      context.handle(
        _splitAtMeta,
        splitAt.isAcceptableOrUnknown(data['split_at']!, _splitAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mold map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mold(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      )!,
      weightG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_g'],
      ),
      moldedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}molded_at'],
      ),
      pressedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pressed_at'],
      ),
      remoldedFromId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remolded_from_id'],
      ),
      remoldedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remolded_at'],
      ),
      splitFromMoldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_from_mold_id'],
      ),
      splitAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}split_at'],
      ),
    );
  }

  @override
  $MoldsTable createAlias(String alias) {
    return $MoldsTable(attachedDatabase, alias);
  }
}

class Mold extends DataClass implements Insertable<Mold> {
  final String id;
  final String batchId;
  final String vatId;
  final String qrCode;
  final double? weightG;
  final DateTime? moldedAt;
  final DateTime? pressedAt;
  final String? remoldedFromId;
  final DateTime? remoldedAt;

  /// 裂成两件时，第二件指向原模具。
  final String? splitFromMoldId;
  final DateTime? splitAt;
  const Mold({
    required this.id,
    required this.batchId,
    required this.vatId,
    required this.qrCode,
    this.weightG,
    this.moldedAt,
    this.pressedAt,
    this.remoldedFromId,
    this.remoldedAt,
    this.splitFromMoldId,
    this.splitAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['batch_id'] = Variable<String>(batchId);
    map['vat_id'] = Variable<String>(vatId);
    map['qr_code'] = Variable<String>(qrCode);
    if (!nullToAbsent || weightG != null) {
      map['weight_g'] = Variable<double>(weightG);
    }
    if (!nullToAbsent || moldedAt != null) {
      map['molded_at'] = Variable<DateTime>(moldedAt);
    }
    if (!nullToAbsent || pressedAt != null) {
      map['pressed_at'] = Variable<DateTime>(pressedAt);
    }
    if (!nullToAbsent || remoldedFromId != null) {
      map['remolded_from_id'] = Variable<String>(remoldedFromId);
    }
    if (!nullToAbsent || remoldedAt != null) {
      map['remolded_at'] = Variable<DateTime>(remoldedAt);
    }
    if (!nullToAbsent || splitFromMoldId != null) {
      map['split_from_mold_id'] = Variable<String>(splitFromMoldId);
    }
    if (!nullToAbsent || splitAt != null) {
      map['split_at'] = Variable<DateTime>(splitAt);
    }
    return map;
  }

  MoldsCompanion toCompanion(bool nullToAbsent) {
    return MoldsCompanion(
      id: Value(id),
      batchId: Value(batchId),
      vatId: Value(vatId),
      qrCode: Value(qrCode),
      weightG: weightG == null && nullToAbsent
          ? const Value.absent()
          : Value(weightG),
      moldedAt: moldedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(moldedAt),
      pressedAt: pressedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pressedAt),
      remoldedFromId: remoldedFromId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoldedFromId),
      remoldedAt: remoldedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoldedAt),
      splitFromMoldId: splitFromMoldId == null && nullToAbsent
          ? const Value.absent()
          : Value(splitFromMoldId),
      splitAt: splitAt == null && nullToAbsent
          ? const Value.absent()
          : Value(splitAt),
    );
  }

  factory Mold.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mold(
      id: serializer.fromJson<String>(json['id']),
      batchId: serializer.fromJson<String>(json['batchId']),
      vatId: serializer.fromJson<String>(json['vatId']),
      qrCode: serializer.fromJson<String>(json['qrCode']),
      weightG: serializer.fromJson<double?>(json['weightG']),
      moldedAt: serializer.fromJson<DateTime?>(json['moldedAt']),
      pressedAt: serializer.fromJson<DateTime?>(json['pressedAt']),
      remoldedFromId: serializer.fromJson<String?>(json['remoldedFromId']),
      remoldedAt: serializer.fromJson<DateTime?>(json['remoldedAt']),
      splitFromMoldId: serializer.fromJson<String?>(json['splitFromMoldId']),
      splitAt: serializer.fromJson<DateTime?>(json['splitAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'batchId': serializer.toJson<String>(batchId),
      'vatId': serializer.toJson<String>(vatId),
      'qrCode': serializer.toJson<String>(qrCode),
      'weightG': serializer.toJson<double?>(weightG),
      'moldedAt': serializer.toJson<DateTime?>(moldedAt),
      'pressedAt': serializer.toJson<DateTime?>(pressedAt),
      'remoldedFromId': serializer.toJson<String?>(remoldedFromId),
      'remoldedAt': serializer.toJson<DateTime?>(remoldedAt),
      'splitFromMoldId': serializer.toJson<String?>(splitFromMoldId),
      'splitAt': serializer.toJson<DateTime?>(splitAt),
    };
  }

  Mold copyWith({
    String? id,
    String? batchId,
    String? vatId,
    String? qrCode,
    Value<double?> weightG = const Value.absent(),
    Value<DateTime?> moldedAt = const Value.absent(),
    Value<DateTime?> pressedAt = const Value.absent(),
    Value<String?> remoldedFromId = const Value.absent(),
    Value<DateTime?> remoldedAt = const Value.absent(),
    Value<String?> splitFromMoldId = const Value.absent(),
    Value<DateTime?> splitAt = const Value.absent(),
  }) => Mold(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    vatId: vatId ?? this.vatId,
    qrCode: qrCode ?? this.qrCode,
    weightG: weightG.present ? weightG.value : this.weightG,
    moldedAt: moldedAt.present ? moldedAt.value : this.moldedAt,
    pressedAt: pressedAt.present ? pressedAt.value : this.pressedAt,
    remoldedFromId: remoldedFromId.present
        ? remoldedFromId.value
        : this.remoldedFromId,
    remoldedAt: remoldedAt.present ? remoldedAt.value : this.remoldedAt,
    splitFromMoldId: splitFromMoldId.present
        ? splitFromMoldId.value
        : this.splitFromMoldId,
    splitAt: splitAt.present ? splitAt.value : this.splitAt,
  );
  Mold copyWithCompanion(MoldsCompanion data) {
    return Mold(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
      weightG: data.weightG.present ? data.weightG.value : this.weightG,
      moldedAt: data.moldedAt.present ? data.moldedAt.value : this.moldedAt,
      pressedAt: data.pressedAt.present ? data.pressedAt.value : this.pressedAt,
      remoldedFromId: data.remoldedFromId.present
          ? data.remoldedFromId.value
          : this.remoldedFromId,
      remoldedAt: data.remoldedAt.present
          ? data.remoldedAt.value
          : this.remoldedAt,
      splitFromMoldId: data.splitFromMoldId.present
          ? data.splitFromMoldId.value
          : this.splitFromMoldId,
      splitAt: data.splitAt.present ? data.splitAt.value : this.splitAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mold(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('vatId: $vatId, ')
          ..write('qrCode: $qrCode, ')
          ..write('weightG: $weightG, ')
          ..write('moldedAt: $moldedAt, ')
          ..write('pressedAt: $pressedAt, ')
          ..write('remoldedFromId: $remoldedFromId, ')
          ..write('remoldedAt: $remoldedAt, ')
          ..write('splitFromMoldId: $splitFromMoldId, ')
          ..write('splitAt: $splitAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batchId,
    vatId,
    qrCode,
    weightG,
    moldedAt,
    pressedAt,
    remoldedFromId,
    remoldedAt,
    splitFromMoldId,
    splitAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mold &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.vatId == this.vatId &&
          other.qrCode == this.qrCode &&
          other.weightG == this.weightG &&
          other.moldedAt == this.moldedAt &&
          other.pressedAt == this.pressedAt &&
          other.remoldedFromId == this.remoldedFromId &&
          other.remoldedAt == this.remoldedAt &&
          other.splitFromMoldId == this.splitFromMoldId &&
          other.splitAt == this.splitAt);
}

class MoldsCompanion extends UpdateCompanion<Mold> {
  final Value<String> id;
  final Value<String> batchId;
  final Value<String> vatId;
  final Value<String> qrCode;
  final Value<double?> weightG;
  final Value<DateTime?> moldedAt;
  final Value<DateTime?> pressedAt;
  final Value<String?> remoldedFromId;
  final Value<DateTime?> remoldedAt;
  final Value<String?> splitFromMoldId;
  final Value<DateTime?> splitAt;
  final Value<int> rowid;
  const MoldsCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.vatId = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.weightG = const Value.absent(),
    this.moldedAt = const Value.absent(),
    this.pressedAt = const Value.absent(),
    this.remoldedFromId = const Value.absent(),
    this.remoldedAt = const Value.absent(),
    this.splitFromMoldId = const Value.absent(),
    this.splitAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoldsCompanion.insert({
    required String id,
    required String batchId,
    required String vatId,
    required String qrCode,
    this.weightG = const Value.absent(),
    this.moldedAt = const Value.absent(),
    this.pressedAt = const Value.absent(),
    this.remoldedFromId = const Value.absent(),
    this.remoldedAt = const Value.absent(),
    this.splitFromMoldId = const Value.absent(),
    this.splitAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       batchId = Value(batchId),
       vatId = Value(vatId),
       qrCode = Value(qrCode);
  static Insertable<Mold> custom({
    Expression<String>? id,
    Expression<String>? batchId,
    Expression<String>? vatId,
    Expression<String>? qrCode,
    Expression<double>? weightG,
    Expression<DateTime>? moldedAt,
    Expression<DateTime>? pressedAt,
    Expression<String>? remoldedFromId,
    Expression<DateTime>? remoldedAt,
    Expression<String>? splitFromMoldId,
    Expression<DateTime>? splitAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (vatId != null) 'vat_id': vatId,
      if (qrCode != null) 'qr_code': qrCode,
      if (weightG != null) 'weight_g': weightG,
      if (moldedAt != null) 'molded_at': moldedAt,
      if (pressedAt != null) 'pressed_at': pressedAt,
      if (remoldedFromId != null) 'remolded_from_id': remoldedFromId,
      if (remoldedAt != null) 'remolded_at': remoldedAt,
      if (splitFromMoldId != null) 'split_from_mold_id': splitFromMoldId,
      if (splitAt != null) 'split_at': splitAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoldsCompanion copyWith({
    Value<String>? id,
    Value<String>? batchId,
    Value<String>? vatId,
    Value<String>? qrCode,
    Value<double?>? weightG,
    Value<DateTime?>? moldedAt,
    Value<DateTime?>? pressedAt,
    Value<String?>? remoldedFromId,
    Value<DateTime?>? remoldedAt,
    Value<String?>? splitFromMoldId,
    Value<DateTime?>? splitAt,
    Value<int>? rowid,
  }) {
    return MoldsCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      vatId: vatId ?? this.vatId,
      qrCode: qrCode ?? this.qrCode,
      weightG: weightG ?? this.weightG,
      moldedAt: moldedAt ?? this.moldedAt,
      pressedAt: pressedAt ?? this.pressedAt,
      remoldedFromId: remoldedFromId ?? this.remoldedFromId,
      remoldedAt: remoldedAt ?? this.remoldedAt,
      splitFromMoldId: splitFromMoldId ?? this.splitFromMoldId,
      splitAt: splitAt ?? this.splitAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (weightG.present) {
      map['weight_g'] = Variable<double>(weightG.value);
    }
    if (moldedAt.present) {
      map['molded_at'] = Variable<DateTime>(moldedAt.value);
    }
    if (pressedAt.present) {
      map['pressed_at'] = Variable<DateTime>(pressedAt.value);
    }
    if (remoldedFromId.present) {
      map['remolded_from_id'] = Variable<String>(remoldedFromId.value);
    }
    if (remoldedAt.present) {
      map['remolded_at'] = Variable<DateTime>(remoldedAt.value);
    }
    if (splitFromMoldId.present) {
      map['split_from_mold_id'] = Variable<String>(splitFromMoldId.value);
    }
    if (splitAt.present) {
      map['split_at'] = Variable<DateTime>(splitAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoldsCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('vatId: $vatId, ')
          ..write('qrCode: $qrCode, ')
          ..write('weightG: $weightG, ')
          ..write('moldedAt: $moldedAt, ')
          ..write('pressedAt: $pressedAt, ')
          ..write('remoldedFromId: $remoldedFromId, ')
          ..write('remoldedAt: $remoldedAt, ')
          ..write('splitFromMoldId: $splitFromMoldId, ')
          ..write('splitAt: $splitAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoldTurnsTable extends MoldTurns
    with TableInfo<$MoldTurnsTable, MoldTurn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoldTurnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moldIdMeta = const VerificationMeta('moldId');
  @override
  late final GeneratedColumn<String> moldId = GeneratedColumn<String>(
    'mold_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnedAtMeta = const VerificationMeta(
    'turnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> turnedAt = GeneratedColumn<DateTime>(
    'turned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TurnDamage, int> damage =
      GeneratedColumn<int>(
        'damage',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TurnDamage>($MoldTurnsTable.$converterdamage);
  static const VerificationMeta _pressPlateIdMeta = const VerificationMeta(
    'pressPlateId',
  );
  @override
  late final GeneratedColumn<String> pressPlateId = GeneratedColumn<String>(
    'press_plate_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    moldId,
    vatId,
    round,
    position,
    turnedAt,
    recordedAt,
    damage,
    pressPlateId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mold_turns';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoldTurn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mold_id')) {
      context.handle(
        _moldIdMeta,
        moldId.isAcceptableOrUnknown(data['mold_id']!, _moldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moldIdMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('turned_at')) {
      context.handle(
        _turnedAtMeta,
        turnedAt.isAcceptableOrUnknown(data['turned_at']!, _turnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_turnedAtMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('press_plate_id')) {
      context.handle(
        _pressPlateIdMeta,
        pressPlateId.isAcceptableOrUnknown(
          data['press_plate_id']!,
          _pressPlateIdMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoldTurn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoldTurn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      moldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mold_id'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      turnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}turned_at'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      damage: $MoldTurnsTable.$converterdamage.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}damage'],
        )!,
      ),
      pressPlateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}press_plate_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MoldTurnsTable createAlias(String alias) {
    return $MoldTurnsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TurnDamage, int, int> $converterdamage =
      const EnumIndexConverter<TurnDamage>(TurnDamage.values);
}

class MoldTurn extends DataClass implements Insertable<MoldTurn> {
  final String id;
  final String moldId;
  final String vatId;
  final int round;
  final String position;
  final DateTime turnedAt;
  final DateTime recordedAt;
  final TurnDamage damage;
  final String? pressPlateId;
  final String? note;
  const MoldTurn({
    required this.id,
    required this.moldId,
    required this.vatId,
    required this.round,
    required this.position,
    required this.turnedAt,
    required this.recordedAt,
    required this.damage,
    this.pressPlateId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mold_id'] = Variable<String>(moldId);
    map['vat_id'] = Variable<String>(vatId);
    map['round'] = Variable<int>(round);
    map['position'] = Variable<String>(position);
    map['turned_at'] = Variable<DateTime>(turnedAt);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    {
      map['damage'] = Variable<int>(
        $MoldTurnsTable.$converterdamage.toSql(damage),
      );
    }
    if (!nullToAbsent || pressPlateId != null) {
      map['press_plate_id'] = Variable<String>(pressPlateId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MoldTurnsCompanion toCompanion(bool nullToAbsent) {
    return MoldTurnsCompanion(
      id: Value(id),
      moldId: Value(moldId),
      vatId: Value(vatId),
      round: Value(round),
      position: Value(position),
      turnedAt: Value(turnedAt),
      recordedAt: Value(recordedAt),
      damage: Value(damage),
      pressPlateId: pressPlateId == null && nullToAbsent
          ? const Value.absent()
          : Value(pressPlateId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MoldTurn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoldTurn(
      id: serializer.fromJson<String>(json['id']),
      moldId: serializer.fromJson<String>(json['moldId']),
      vatId: serializer.fromJson<String>(json['vatId']),
      round: serializer.fromJson<int>(json['round']),
      position: serializer.fromJson<String>(json['position']),
      turnedAt: serializer.fromJson<DateTime>(json['turnedAt']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      damage: $MoldTurnsTable.$converterdamage.fromJson(
        serializer.fromJson<int>(json['damage']),
      ),
      pressPlateId: serializer.fromJson<String?>(json['pressPlateId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moldId': serializer.toJson<String>(moldId),
      'vatId': serializer.toJson<String>(vatId),
      'round': serializer.toJson<int>(round),
      'position': serializer.toJson<String>(position),
      'turnedAt': serializer.toJson<DateTime>(turnedAt),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'damage': serializer.toJson<int>(
        $MoldTurnsTable.$converterdamage.toJson(damage),
      ),
      'pressPlateId': serializer.toJson<String?>(pressPlateId),
      'note': serializer.toJson<String?>(note),
    };
  }

  MoldTurn copyWith({
    String? id,
    String? moldId,
    String? vatId,
    int? round,
    String? position,
    DateTime? turnedAt,
    DateTime? recordedAt,
    TurnDamage? damage,
    Value<String?> pressPlateId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => MoldTurn(
    id: id ?? this.id,
    moldId: moldId ?? this.moldId,
    vatId: vatId ?? this.vatId,
    round: round ?? this.round,
    position: position ?? this.position,
    turnedAt: turnedAt ?? this.turnedAt,
    recordedAt: recordedAt ?? this.recordedAt,
    damage: damage ?? this.damage,
    pressPlateId: pressPlateId.present ? pressPlateId.value : this.pressPlateId,
    note: note.present ? note.value : this.note,
  );
  MoldTurn copyWithCompanion(MoldTurnsCompanion data) {
    return MoldTurn(
      id: data.id.present ? data.id.value : this.id,
      moldId: data.moldId.present ? data.moldId.value : this.moldId,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      round: data.round.present ? data.round.value : this.round,
      position: data.position.present ? data.position.value : this.position,
      turnedAt: data.turnedAt.present ? data.turnedAt.value : this.turnedAt,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      damage: data.damage.present ? data.damage.value : this.damage,
      pressPlateId: data.pressPlateId.present
          ? data.pressPlateId.value
          : this.pressPlateId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoldTurn(')
          ..write('id: $id, ')
          ..write('moldId: $moldId, ')
          ..write('vatId: $vatId, ')
          ..write('round: $round, ')
          ..write('position: $position, ')
          ..write('turnedAt: $turnedAt, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('damage: $damage, ')
          ..write('pressPlateId: $pressPlateId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    moldId,
    vatId,
    round,
    position,
    turnedAt,
    recordedAt,
    damage,
    pressPlateId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoldTurn &&
          other.id == this.id &&
          other.moldId == this.moldId &&
          other.vatId == this.vatId &&
          other.round == this.round &&
          other.position == this.position &&
          other.turnedAt == this.turnedAt &&
          other.recordedAt == this.recordedAt &&
          other.damage == this.damage &&
          other.pressPlateId == this.pressPlateId &&
          other.note == this.note);
}

class MoldTurnsCompanion extends UpdateCompanion<MoldTurn> {
  final Value<String> id;
  final Value<String> moldId;
  final Value<String> vatId;
  final Value<int> round;
  final Value<String> position;
  final Value<DateTime> turnedAt;
  final Value<DateTime> recordedAt;
  final Value<TurnDamage> damage;
  final Value<String?> pressPlateId;
  final Value<String?> note;
  final Value<int> rowid;
  const MoldTurnsCompanion({
    this.id = const Value.absent(),
    this.moldId = const Value.absent(),
    this.vatId = const Value.absent(),
    this.round = const Value.absent(),
    this.position = const Value.absent(),
    this.turnedAt = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.damage = const Value.absent(),
    this.pressPlateId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoldTurnsCompanion.insert({
    required String id,
    required String moldId,
    required String vatId,
    required int round,
    required String position,
    required DateTime turnedAt,
    required DateTime recordedAt,
    required TurnDamage damage,
    this.pressPlateId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       moldId = Value(moldId),
       vatId = Value(vatId),
       round = Value(round),
       position = Value(position),
       turnedAt = Value(turnedAt),
       recordedAt = Value(recordedAt),
       damage = Value(damage);
  static Insertable<MoldTurn> custom({
    Expression<String>? id,
    Expression<String>? moldId,
    Expression<String>? vatId,
    Expression<int>? round,
    Expression<String>? position,
    Expression<DateTime>? turnedAt,
    Expression<DateTime>? recordedAt,
    Expression<int>? damage,
    Expression<String>? pressPlateId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moldId != null) 'mold_id': moldId,
      if (vatId != null) 'vat_id': vatId,
      if (round != null) 'round': round,
      if (position != null) 'position': position,
      if (turnedAt != null) 'turned_at': turnedAt,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (damage != null) 'damage': damage,
      if (pressPlateId != null) 'press_plate_id': pressPlateId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoldTurnsCompanion copyWith({
    Value<String>? id,
    Value<String>? moldId,
    Value<String>? vatId,
    Value<int>? round,
    Value<String>? position,
    Value<DateTime>? turnedAt,
    Value<DateTime>? recordedAt,
    Value<TurnDamage>? damage,
    Value<String?>? pressPlateId,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MoldTurnsCompanion(
      id: id ?? this.id,
      moldId: moldId ?? this.moldId,
      vatId: vatId ?? this.vatId,
      round: round ?? this.round,
      position: position ?? this.position,
      turnedAt: turnedAt ?? this.turnedAt,
      recordedAt: recordedAt ?? this.recordedAt,
      damage: damage ?? this.damage,
      pressPlateId: pressPlateId ?? this.pressPlateId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moldId.present) {
      map['mold_id'] = Variable<String>(moldId.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (turnedAt.present) {
      map['turned_at'] = Variable<DateTime>(turnedAt.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (damage.present) {
      map['damage'] = Variable<int>(
        $MoldTurnsTable.$converterdamage.toSql(damage.value),
      );
    }
    if (pressPlateId.present) {
      map['press_plate_id'] = Variable<String>(pressPlateId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoldTurnsCompanion(')
          ..write('id: $id, ')
          ..write('moldId: $moldId, ')
          ..write('vatId: $vatId, ')
          ..write('round: $round, ')
          ..write('position: $position, ')
          ..write('turnedAt: $turnedAt, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('damage: $damage, ')
          ..write('pressPlateId: $pressPlateId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabSamplesTable extends LabSamples
    with TableInfo<$LabSamplesTable, LabSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moldIdMeta = const VerificationMeta('moldId');
  @override
  late final GeneratedColumn<String> moldId = GeneratedColumn<String>(
    'mold_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StepKind, int> step =
      GeneratedColumn<int>(
        'step',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StepKind>($LabSamplesTable.$converterstep);
  static const VerificationMeta _sampledAtMeta = const VerificationMeta(
    'sampledAt',
  );
  @override
  late final GeneratedColumn<DateTime> sampledAt = GeneratedColumn<DateTime>(
    'sampled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moisturePctMeta = const VerificationMeta(
    'moisturePct',
  );
  @override
  late final GeneratedColumn<double> moisturePct = GeneratedColumn<double>(
    'moisture_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acidityPhMeta = const VerificationMeta(
    'acidityPh',
  );
  @override
  late final GeneratedColumn<double> acidityPh = GeneratedColumn<double>(
    'acidity_ph',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labIdMeta = const VerificationMeta('labId');
  @override
  late final GeneratedColumn<String> labId = GeneratedColumn<String>(
    'lab_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vatId,
    moldId,
    step,
    sampledAt,
    receivedAt,
    moisturePct,
    acidityPh,
    labId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('mold_id')) {
      context.handle(
        _moldIdMeta,
        moldId.isAcceptableOrUnknown(data['mold_id']!, _moldIdMeta),
      );
    }
    if (data.containsKey('sampled_at')) {
      context.handle(
        _sampledAtMeta,
        sampledAt.isAcceptableOrUnknown(data['sampled_at']!, _sampledAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sampledAtMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    if (data.containsKey('moisture_pct')) {
      context.handle(
        _moisturePctMeta,
        moisturePct.isAcceptableOrUnknown(
          data['moisture_pct']!,
          _moisturePctMeta,
        ),
      );
    }
    if (data.containsKey('acidity_ph')) {
      context.handle(
        _acidityPhMeta,
        acidityPh.isAcceptableOrUnknown(data['acidity_ph']!, _acidityPhMeta),
      );
    }
    if (data.containsKey('lab_id')) {
      context.handle(
        _labIdMeta,
        labId.isAcceptableOrUnknown(data['lab_id']!, _labIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabSample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      moldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mold_id'],
      ),
      step: $LabSamplesTable.$converterstep.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}step'],
        )!,
      ),
      sampledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sampled_at'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      ),
      moisturePct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}moisture_pct'],
      ),
      acidityPh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}acidity_ph'],
      ),
      labId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lab_id'],
      ),
    );
  }

  @override
  $LabSamplesTable createAlias(String alias) {
    return $LabSamplesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StepKind, int, int> $converterstep =
      const EnumIndexConverter<StepKind>(StepKind.values);
}

class LabSample extends DataClass implements Insertable<LabSample> {
  final String id;
  final String vatId;
  final String? moldId;
  final StepKind step;
  final DateTime sampledAt;
  final DateTime? receivedAt;
  final double? moisturePct;
  final double? acidityPh;
  final String? labId;
  const LabSample({
    required this.id,
    required this.vatId,
    this.moldId,
    required this.step,
    required this.sampledAt,
    this.receivedAt,
    this.moisturePct,
    this.acidityPh,
    this.labId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vat_id'] = Variable<String>(vatId);
    if (!nullToAbsent || moldId != null) {
      map['mold_id'] = Variable<String>(moldId);
    }
    {
      map['step'] = Variable<int>($LabSamplesTable.$converterstep.toSql(step));
    }
    map['sampled_at'] = Variable<DateTime>(sampledAt);
    if (!nullToAbsent || receivedAt != null) {
      map['received_at'] = Variable<DateTime>(receivedAt);
    }
    if (!nullToAbsent || moisturePct != null) {
      map['moisture_pct'] = Variable<double>(moisturePct);
    }
    if (!nullToAbsent || acidityPh != null) {
      map['acidity_ph'] = Variable<double>(acidityPh);
    }
    if (!nullToAbsent || labId != null) {
      map['lab_id'] = Variable<String>(labId);
    }
    return map;
  }

  LabSamplesCompanion toCompanion(bool nullToAbsent) {
    return LabSamplesCompanion(
      id: Value(id),
      vatId: Value(vatId),
      moldId: moldId == null && nullToAbsent
          ? const Value.absent()
          : Value(moldId),
      step: Value(step),
      sampledAt: Value(sampledAt),
      receivedAt: receivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedAt),
      moisturePct: moisturePct == null && nullToAbsent
          ? const Value.absent()
          : Value(moisturePct),
      acidityPh: acidityPh == null && nullToAbsent
          ? const Value.absent()
          : Value(acidityPh),
      labId: labId == null && nullToAbsent
          ? const Value.absent()
          : Value(labId),
    );
  }

  factory LabSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabSample(
      id: serializer.fromJson<String>(json['id']),
      vatId: serializer.fromJson<String>(json['vatId']),
      moldId: serializer.fromJson<String?>(json['moldId']),
      step: $LabSamplesTable.$converterstep.fromJson(
        serializer.fromJson<int>(json['step']),
      ),
      sampledAt: serializer.fromJson<DateTime>(json['sampledAt']),
      receivedAt: serializer.fromJson<DateTime?>(json['receivedAt']),
      moisturePct: serializer.fromJson<double?>(json['moisturePct']),
      acidityPh: serializer.fromJson<double?>(json['acidityPh']),
      labId: serializer.fromJson<String?>(json['labId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vatId': serializer.toJson<String>(vatId),
      'moldId': serializer.toJson<String?>(moldId),
      'step': serializer.toJson<int>(
        $LabSamplesTable.$converterstep.toJson(step),
      ),
      'sampledAt': serializer.toJson<DateTime>(sampledAt),
      'receivedAt': serializer.toJson<DateTime?>(receivedAt),
      'moisturePct': serializer.toJson<double?>(moisturePct),
      'acidityPh': serializer.toJson<double?>(acidityPh),
      'labId': serializer.toJson<String?>(labId),
    };
  }

  LabSample copyWith({
    String? id,
    String? vatId,
    Value<String?> moldId = const Value.absent(),
    StepKind? step,
    DateTime? sampledAt,
    Value<DateTime?> receivedAt = const Value.absent(),
    Value<double?> moisturePct = const Value.absent(),
    Value<double?> acidityPh = const Value.absent(),
    Value<String?> labId = const Value.absent(),
  }) => LabSample(
    id: id ?? this.id,
    vatId: vatId ?? this.vatId,
    moldId: moldId.present ? moldId.value : this.moldId,
    step: step ?? this.step,
    sampledAt: sampledAt ?? this.sampledAt,
    receivedAt: receivedAt.present ? receivedAt.value : this.receivedAt,
    moisturePct: moisturePct.present ? moisturePct.value : this.moisturePct,
    acidityPh: acidityPh.present ? acidityPh.value : this.acidityPh,
    labId: labId.present ? labId.value : this.labId,
  );
  LabSample copyWithCompanion(LabSamplesCompanion data) {
    return LabSample(
      id: data.id.present ? data.id.value : this.id,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      moldId: data.moldId.present ? data.moldId.value : this.moldId,
      step: data.step.present ? data.step.value : this.step,
      sampledAt: data.sampledAt.present ? data.sampledAt.value : this.sampledAt,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      moisturePct: data.moisturePct.present
          ? data.moisturePct.value
          : this.moisturePct,
      acidityPh: data.acidityPh.present ? data.acidityPh.value : this.acidityPh,
      labId: data.labId.present ? data.labId.value : this.labId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabSample(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('moldId: $moldId, ')
          ..write('step: $step, ')
          ..write('sampledAt: $sampledAt, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('moisturePct: $moisturePct, ')
          ..write('acidityPh: $acidityPh, ')
          ..write('labId: $labId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vatId,
    moldId,
    step,
    sampledAt,
    receivedAt,
    moisturePct,
    acidityPh,
    labId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabSample &&
          other.id == this.id &&
          other.vatId == this.vatId &&
          other.moldId == this.moldId &&
          other.step == this.step &&
          other.sampledAt == this.sampledAt &&
          other.receivedAt == this.receivedAt &&
          other.moisturePct == this.moisturePct &&
          other.acidityPh == this.acidityPh &&
          other.labId == this.labId);
}

class LabSamplesCompanion extends UpdateCompanion<LabSample> {
  final Value<String> id;
  final Value<String> vatId;
  final Value<String?> moldId;
  final Value<StepKind> step;
  final Value<DateTime> sampledAt;
  final Value<DateTime?> receivedAt;
  final Value<double?> moisturePct;
  final Value<double?> acidityPh;
  final Value<String?> labId;
  final Value<int> rowid;
  const LabSamplesCompanion({
    this.id = const Value.absent(),
    this.vatId = const Value.absent(),
    this.moldId = const Value.absent(),
    this.step = const Value.absent(),
    this.sampledAt = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.moisturePct = const Value.absent(),
    this.acidityPh = const Value.absent(),
    this.labId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabSamplesCompanion.insert({
    required String id,
    required String vatId,
    this.moldId = const Value.absent(),
    required StepKind step,
    required DateTime sampledAt,
    this.receivedAt = const Value.absent(),
    this.moisturePct = const Value.absent(),
    this.acidityPh = const Value.absent(),
    this.labId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vatId = Value(vatId),
       step = Value(step),
       sampledAt = Value(sampledAt);
  static Insertable<LabSample> custom({
    Expression<String>? id,
    Expression<String>? vatId,
    Expression<String>? moldId,
    Expression<int>? step,
    Expression<DateTime>? sampledAt,
    Expression<DateTime>? receivedAt,
    Expression<double>? moisturePct,
    Expression<double>? acidityPh,
    Expression<String>? labId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vatId != null) 'vat_id': vatId,
      if (moldId != null) 'mold_id': moldId,
      if (step != null) 'step': step,
      if (sampledAt != null) 'sampled_at': sampledAt,
      if (receivedAt != null) 'received_at': receivedAt,
      if (moisturePct != null) 'moisture_pct': moisturePct,
      if (acidityPh != null) 'acidity_ph': acidityPh,
      if (labId != null) 'lab_id': labId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabSamplesCompanion copyWith({
    Value<String>? id,
    Value<String>? vatId,
    Value<String?>? moldId,
    Value<StepKind>? step,
    Value<DateTime>? sampledAt,
    Value<DateTime?>? receivedAt,
    Value<double?>? moisturePct,
    Value<double?>? acidityPh,
    Value<String?>? labId,
    Value<int>? rowid,
  }) {
    return LabSamplesCompanion(
      id: id ?? this.id,
      vatId: vatId ?? this.vatId,
      moldId: moldId ?? this.moldId,
      step: step ?? this.step,
      sampledAt: sampledAt ?? this.sampledAt,
      receivedAt: receivedAt ?? this.receivedAt,
      moisturePct: moisturePct ?? this.moisturePct,
      acidityPh: acidityPh ?? this.acidityPh,
      labId: labId ?? this.labId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (moldId.present) {
      map['mold_id'] = Variable<String>(moldId.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(
        $LabSamplesTable.$converterstep.toSql(step.value),
      );
    }
    if (sampledAt.present) {
      map['sampled_at'] = Variable<DateTime>(sampledAt.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (moisturePct.present) {
      map['moisture_pct'] = Variable<double>(moisturePct.value);
    }
    if (acidityPh.present) {
      map['acidity_ph'] = Variable<double>(acidityPh.value);
    }
    if (labId.present) {
      map['lab_id'] = Variable<String>(labId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabSamplesCompanion(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('moldId: $moldId, ')
          ..write('step: $step, ')
          ..write('sampledAt: $sampledAt, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('moisturePct: $moisturePct, ')
          ..write('acidityPh: $acidityPh, ')
          ..write('labId: $labId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurdPhotosTable extends CurdPhotos
    with TableInfo<$CurdPhotosTable, CurdPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurdPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatIdMeta = const VerificationMeta('vatId');
  @override
  late final GeneratedColumn<String> vatId = GeneratedColumn<String>(
    'vat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VatZone, int> zone =
      GeneratedColumn<int>(
        'zone',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<VatZone>($CurdPhotosTable.$converterzone);
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _standardBackgroundMeta =
      const VerificationMeta('standardBackground');
  @override
  late final GeneratedColumn<bool> standardBackground = GeneratedColumn<bool>(
    'standard_background',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("standard_background" IN (0, 1))',
    ),
  );
  static const VerificationMeta _grainSizeMmMeta = const VerificationMeta(
    'grainSizeMm',
  );
  @override
  late final GeneratedColumn<double> grainSizeMm = GeneratedColumn<double>(
    'grain_size_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vatId,
    zone,
    takenAt,
    filePath,
    standardBackground,
    grainSizeMm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curd_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurdPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vat_id')) {
      context.handle(
        _vatIdMeta,
        vatId.isAcceptableOrUnknown(data['vat_id']!, _vatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vatIdMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('standard_background')) {
      context.handle(
        _standardBackgroundMeta,
        standardBackground.isAcceptableOrUnknown(
          data['standard_background']!,
          _standardBackgroundMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_standardBackgroundMeta);
    }
    if (data.containsKey('grain_size_mm')) {
      context.handle(
        _grainSizeMmMeta,
        grainSizeMm.isAcceptableOrUnknown(
          data['grain_size_mm']!,
          _grainSizeMmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurdPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurdPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_id'],
      )!,
      zone: $CurdPhotosTable.$converterzone.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}zone'],
        )!,
      ),
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      standardBackground: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}standard_background'],
      )!,
      grainSizeMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grain_size_mm'],
      ),
    );
  }

  @override
  $CurdPhotosTable createAlias(String alias) {
    return $CurdPhotosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<VatZone, int, int> $converterzone =
      const EnumIndexConverter<VatZone>(VatZone.values);
}

class CurdPhoto extends DataClass implements Insertable<CurdPhoto> {
  final String id;
  final String vatId;
  final VatZone zone;
  final DateTime takenAt;
  final String filePath;
  final bool standardBackground;
  final double? grainSizeMm;
  const CurdPhoto({
    required this.id,
    required this.vatId,
    required this.zone,
    required this.takenAt,
    required this.filePath,
    required this.standardBackground,
    this.grainSizeMm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vat_id'] = Variable<String>(vatId);
    {
      map['zone'] = Variable<int>($CurdPhotosTable.$converterzone.toSql(zone));
    }
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['file_path'] = Variable<String>(filePath);
    map['standard_background'] = Variable<bool>(standardBackground);
    if (!nullToAbsent || grainSizeMm != null) {
      map['grain_size_mm'] = Variable<double>(grainSizeMm);
    }
    return map;
  }

  CurdPhotosCompanion toCompanion(bool nullToAbsent) {
    return CurdPhotosCompanion(
      id: Value(id),
      vatId: Value(vatId),
      zone: Value(zone),
      takenAt: Value(takenAt),
      filePath: Value(filePath),
      standardBackground: Value(standardBackground),
      grainSizeMm: grainSizeMm == null && nullToAbsent
          ? const Value.absent()
          : Value(grainSizeMm),
    );
  }

  factory CurdPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurdPhoto(
      id: serializer.fromJson<String>(json['id']),
      vatId: serializer.fromJson<String>(json['vatId']),
      zone: $CurdPhotosTable.$converterzone.fromJson(
        serializer.fromJson<int>(json['zone']),
      ),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      filePath: serializer.fromJson<String>(json['filePath']),
      standardBackground: serializer.fromJson<bool>(json['standardBackground']),
      grainSizeMm: serializer.fromJson<double?>(json['grainSizeMm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vatId': serializer.toJson<String>(vatId),
      'zone': serializer.toJson<int>(
        $CurdPhotosTable.$converterzone.toJson(zone),
      ),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'filePath': serializer.toJson<String>(filePath),
      'standardBackground': serializer.toJson<bool>(standardBackground),
      'grainSizeMm': serializer.toJson<double?>(grainSizeMm),
    };
  }

  CurdPhoto copyWith({
    String? id,
    String? vatId,
    VatZone? zone,
    DateTime? takenAt,
    String? filePath,
    bool? standardBackground,
    Value<double?> grainSizeMm = const Value.absent(),
  }) => CurdPhoto(
    id: id ?? this.id,
    vatId: vatId ?? this.vatId,
    zone: zone ?? this.zone,
    takenAt: takenAt ?? this.takenAt,
    filePath: filePath ?? this.filePath,
    standardBackground: standardBackground ?? this.standardBackground,
    grainSizeMm: grainSizeMm.present ? grainSizeMm.value : this.grainSizeMm,
  );
  CurdPhoto copyWithCompanion(CurdPhotosCompanion data) {
    return CurdPhoto(
      id: data.id.present ? data.id.value : this.id,
      vatId: data.vatId.present ? data.vatId.value : this.vatId,
      zone: data.zone.present ? data.zone.value : this.zone,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      standardBackground: data.standardBackground.present
          ? data.standardBackground.value
          : this.standardBackground,
      grainSizeMm: data.grainSizeMm.present
          ? data.grainSizeMm.value
          : this.grainSizeMm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurdPhoto(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('zone: $zone, ')
          ..write('takenAt: $takenAt, ')
          ..write('filePath: $filePath, ')
          ..write('standardBackground: $standardBackground, ')
          ..write('grainSizeMm: $grainSizeMm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vatId,
    zone,
    takenAt,
    filePath,
    standardBackground,
    grainSizeMm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurdPhoto &&
          other.id == this.id &&
          other.vatId == this.vatId &&
          other.zone == this.zone &&
          other.takenAt == this.takenAt &&
          other.filePath == this.filePath &&
          other.standardBackground == this.standardBackground &&
          other.grainSizeMm == this.grainSizeMm);
}

class CurdPhotosCompanion extends UpdateCompanion<CurdPhoto> {
  final Value<String> id;
  final Value<String> vatId;
  final Value<VatZone> zone;
  final Value<DateTime> takenAt;
  final Value<String> filePath;
  final Value<bool> standardBackground;
  final Value<double?> grainSizeMm;
  final Value<int> rowid;
  const CurdPhotosCompanion({
    this.id = const Value.absent(),
    this.vatId = const Value.absent(),
    this.zone = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.standardBackground = const Value.absent(),
    this.grainSizeMm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurdPhotosCompanion.insert({
    required String id,
    required String vatId,
    required VatZone zone,
    required DateTime takenAt,
    required String filePath,
    required bool standardBackground,
    this.grainSizeMm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vatId = Value(vatId),
       zone = Value(zone),
       takenAt = Value(takenAt),
       filePath = Value(filePath),
       standardBackground = Value(standardBackground);
  static Insertable<CurdPhoto> custom({
    Expression<String>? id,
    Expression<String>? vatId,
    Expression<int>? zone,
    Expression<DateTime>? takenAt,
    Expression<String>? filePath,
    Expression<bool>? standardBackground,
    Expression<double>? grainSizeMm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vatId != null) 'vat_id': vatId,
      if (zone != null) 'zone': zone,
      if (takenAt != null) 'taken_at': takenAt,
      if (filePath != null) 'file_path': filePath,
      if (standardBackground != null) 'standard_background': standardBackground,
      if (grainSizeMm != null) 'grain_size_mm': grainSizeMm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurdPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? vatId,
    Value<VatZone>? zone,
    Value<DateTime>? takenAt,
    Value<String>? filePath,
    Value<bool>? standardBackground,
    Value<double?>? grainSizeMm,
    Value<int>? rowid,
  }) {
    return CurdPhotosCompanion(
      id: id ?? this.id,
      vatId: vatId ?? this.vatId,
      zone: zone ?? this.zone,
      takenAt: takenAt ?? this.takenAt,
      filePath: filePath ?? this.filePath,
      standardBackground: standardBackground ?? this.standardBackground,
      grainSizeMm: grainSizeMm ?? this.grainSizeMm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vatId.present) {
      map['vat_id'] = Variable<String>(vatId.value);
    }
    if (zone.present) {
      map['zone'] = Variable<int>(
        $CurdPhotosTable.$converterzone.toSql(zone.value),
      );
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (standardBackground.present) {
      map['standard_background'] = Variable<bool>(standardBackground.value);
    }
    if (grainSizeMm.present) {
      map['grain_size_mm'] = Variable<double>(grainSizeMm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurdPhotosCompanion(')
          ..write('id: $id, ')
          ..write('vatId: $vatId, ')
          ..write('zone: $zone, ')
          ..write('takenAt: $takenAt, ')
          ..write('filePath: $filePath, ')
          ..write('standardBackground: $standardBackground, ')
          ..write('grainSizeMm: $grainSizeMm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CheeseTraceDatabase extends GeneratedDatabase {
  _$CheeseTraceDatabase(QueryExecutor e) : super(e);
  $CheeseTraceDatabaseManager get managers => $CheeseTraceDatabaseManager(this);
  late final $VatsTable vats = $VatsTable(this);
  late final $ProcessVersionsTable processVersions = $ProcessVersionsTable(
    this,
  );
  late final $ActionEventsTable actionEvents = $ActionEventsTable(this);
  late final $WheyTanksTable wheyTanks = $WheyTanksTable(this);
  late final $WheyTransfersTable wheyTransfers = $WheyTransfersTable(this);
  late final $MoldBatchesTable moldBatches = $MoldBatchesTable(this);
  late final $MoldsTable molds = $MoldsTable(this);
  late final $MoldTurnsTable moldTurns = $MoldTurnsTable(this);
  late final $LabSamplesTable labSamples = $LabSamplesTable(this);
  late final $CurdPhotosTable curdPhotos = $CurdPhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vats,
    processVersions,
    actionEvents,
    wheyTanks,
    wheyTransfers,
    moldBatches,
    molds,
    moldTurns,
    labSamples,
    curdPhotos,
  ];
}

typedef $$VatsTableCreateCompanionBuilder =
    VatsCompanion Function({
      required String id,
      required String code,
      required String qrCode,
      Value<String?> milkBatch,
      Value<DateTime?> startedAt,
      Value<int> rowid,
    });
typedef $$VatsTableUpdateCompanionBuilder =
    VatsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> qrCode,
      Value<String?> milkBatch,
      Value<DateTime?> startedAt,
      Value<int> rowid,
    });

class $$VatsTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $VatsTable> {
  $$VatsTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get milkBatch => $composableBuilder(
    column: $table.milkBatch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VatsTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $VatsTable> {
  $$VatsTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get milkBatch => $composableBuilder(
    column: $table.milkBatch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VatsTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $VatsTable> {
  $$VatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);

  GeneratedColumn<String> get milkBatch =>
      $composableBuilder(column: $table.milkBatch, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);
}

class $$VatsTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $VatsTable,
          Vat,
          $$VatsTableFilterComposer,
          $$VatsTableOrderingComposer,
          $$VatsTableAnnotationComposer,
          $$VatsTableCreateCompanionBuilder,
          $$VatsTableUpdateCompanionBuilder,
          (Vat, BaseReferences<_$CheeseTraceDatabase, $VatsTable, Vat>),
          Vat,
          PrefetchHooks Function()
        > {
  $$VatsTableTableManager(_$CheeseTraceDatabase db, $VatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> qrCode = const Value.absent(),
                Value<String?> milkBatch = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VatsCompanion(
                id: id,
                code: code,
                qrCode: qrCode,
                milkBatch: milkBatch,
                startedAt: startedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String qrCode,
                Value<String?> milkBatch = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VatsCompanion.insert(
                id: id,
                code: code,
                qrCode: qrCode,
                milkBatch: milkBatch,
                startedAt: startedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VatsTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $VatsTable,
      Vat,
      $$VatsTableFilterComposer,
      $$VatsTableOrderingComposer,
      $$VatsTableAnnotationComposer,
      $$VatsTableCreateCompanionBuilder,
      $$VatsTableUpdateCompanionBuilder,
      (Vat, BaseReferences<_$CheeseTraceDatabase, $VatsTable, Vat>),
      Vat,
      PrefetchHooks Function()
    >;
typedef $$ProcessVersionsTableCreateCompanionBuilder =
    ProcessVersionsCompanion Function({
      required String id,
      required String name,
      required String frozenBy,
      required DateTime frozenAt,
      required String stepOrderJson,
      required String tolerancesJson,
      Value<int> rowid,
    });
typedef $$ProcessVersionsTableUpdateCompanionBuilder =
    ProcessVersionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> frozenBy,
      Value<DateTime> frozenAt,
      Value<String> stepOrderJson,
      Value<String> tolerancesJson,
      Value<int> rowid,
    });

class $$ProcessVersionsTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $ProcessVersionsTable> {
  $$ProcessVersionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frozenBy => $composableBuilder(
    column: $table.frozenBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get frozenAt => $composableBuilder(
    column: $table.frozenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepOrderJson => $composableBuilder(
    column: $table.stepOrderJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tolerancesJson => $composableBuilder(
    column: $table.tolerancesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProcessVersionsTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $ProcessVersionsTable> {
  $$ProcessVersionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frozenBy => $composableBuilder(
    column: $table.frozenBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get frozenAt => $composableBuilder(
    column: $table.frozenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepOrderJson => $composableBuilder(
    column: $table.stepOrderJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tolerancesJson => $composableBuilder(
    column: $table.tolerancesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProcessVersionsTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $ProcessVersionsTable> {
  $$ProcessVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get frozenBy =>
      $composableBuilder(column: $table.frozenBy, builder: (column) => column);

  GeneratedColumn<DateTime> get frozenAt =>
      $composableBuilder(column: $table.frozenAt, builder: (column) => column);

  GeneratedColumn<String> get stepOrderJson => $composableBuilder(
    column: $table.stepOrderJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tolerancesJson => $composableBuilder(
    column: $table.tolerancesJson,
    builder: (column) => column,
  );
}

class $$ProcessVersionsTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $ProcessVersionsTable,
          ProcessVersion,
          $$ProcessVersionsTableFilterComposer,
          $$ProcessVersionsTableOrderingComposer,
          $$ProcessVersionsTableAnnotationComposer,
          $$ProcessVersionsTableCreateCompanionBuilder,
          $$ProcessVersionsTableUpdateCompanionBuilder,
          (
            ProcessVersion,
            BaseReferences<
              _$CheeseTraceDatabase,
              $ProcessVersionsTable,
              ProcessVersion
            >,
          ),
          ProcessVersion,
          PrefetchHooks Function()
        > {
  $$ProcessVersionsTableTableManager(
    _$CheeseTraceDatabase db,
    $ProcessVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProcessVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProcessVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProcessVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> frozenBy = const Value.absent(),
                Value<DateTime> frozenAt = const Value.absent(),
                Value<String> stepOrderJson = const Value.absent(),
                Value<String> tolerancesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProcessVersionsCompanion(
                id: id,
                name: name,
                frozenBy: frozenBy,
                frozenAt: frozenAt,
                stepOrderJson: stepOrderJson,
                tolerancesJson: tolerancesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String frozenBy,
                required DateTime frozenAt,
                required String stepOrderJson,
                required String tolerancesJson,
                Value<int> rowid = const Value.absent(),
              }) => ProcessVersionsCompanion.insert(
                id: id,
                name: name,
                frozenBy: frozenBy,
                frozenAt: frozenAt,
                stepOrderJson: stepOrderJson,
                tolerancesJson: tolerancesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProcessVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $ProcessVersionsTable,
      ProcessVersion,
      $$ProcessVersionsTableFilterComposer,
      $$ProcessVersionsTableOrderingComposer,
      $$ProcessVersionsTableAnnotationComposer,
      $$ProcessVersionsTableCreateCompanionBuilder,
      $$ProcessVersionsTableUpdateCompanionBuilder,
      (
        ProcessVersion,
        BaseReferences<
          _$CheeseTraceDatabase,
          $ProcessVersionsTable,
          ProcessVersion
        >,
      ),
      ProcessVersion,
      PrefetchHooks Function()
    >;
typedef $$ActionEventsTableCreateCompanionBuilder =
    ActionEventsCompanion Function({
      required String id,
      required String vatId,
      required StepKind step,
      required DateTime performedAt,
      required String operatorId,
      required String processVersionId,
      Value<double?> temperatureC,
      Value<VisualState?> visualState,
      Value<double?> cutSizeMm,
      Value<VatZone?> zone,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$ActionEventsTableUpdateCompanionBuilder =
    ActionEventsCompanion Function({
      Value<String> id,
      Value<String> vatId,
      Value<StepKind> step,
      Value<DateTime> performedAt,
      Value<String> operatorId,
      Value<String> processVersionId,
      Value<double?> temperatureC,
      Value<VisualState?> visualState,
      Value<double?> cutSizeMm,
      Value<VatZone?> zone,
      Value<String?> note,
      Value<int> rowid,
    });

class $$ActionEventsTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $ActionEventsTable> {
  $$ActionEventsTableFilterComposer({
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

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StepKind, StepKind, int> get step =>
      $composableBuilder(
        column: $table.step,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processVersionId => $composableBuilder(
    column: $table.processVersionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VisualState?, VisualState, int>
  get visualState => $composableBuilder(
    column: $table.visualState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get cutSizeMm => $composableBuilder(
    column: $table.cutSizeMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VatZone?, VatZone, int> get zone =>
      $composableBuilder(
        column: $table.zone,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActionEventsTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $ActionEventsTable> {
  $$ActionEventsTableOrderingComposer({
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

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processVersionId => $composableBuilder(
    column: $table.processVersionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visualState => $composableBuilder(
    column: $table.visualState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cutSizeMm => $composableBuilder(
    column: $table.cutSizeMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActionEventsTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $ActionEventsTable> {
  $$ActionEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StepKind, int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processVersionId => $composableBuilder(
    column: $table.processVersionId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<VisualState?, int> get visualState =>
      $composableBuilder(
        column: $table.visualState,
        builder: (column) => column,
      );

  GeneratedColumn<double> get cutSizeMm =>
      $composableBuilder(column: $table.cutSizeMm, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VatZone?, int> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ActionEventsTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $ActionEventsTable,
          ActionEvent,
          $$ActionEventsTableFilterComposer,
          $$ActionEventsTableOrderingComposer,
          $$ActionEventsTableAnnotationComposer,
          $$ActionEventsTableCreateCompanionBuilder,
          $$ActionEventsTableUpdateCompanionBuilder,
          (
            ActionEvent,
            BaseReferences<
              _$CheeseTraceDatabase,
              $ActionEventsTable,
              ActionEvent
            >,
          ),
          ActionEvent,
          PrefetchHooks Function()
        > {
  $$ActionEventsTableTableManager(
    _$CheeseTraceDatabase db,
    $ActionEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<StepKind> step = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<String> operatorId = const Value.absent(),
                Value<String> processVersionId = const Value.absent(),
                Value<double?> temperatureC = const Value.absent(),
                Value<VisualState?> visualState = const Value.absent(),
                Value<double?> cutSizeMm = const Value.absent(),
                Value<VatZone?> zone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionEventsCompanion(
                id: id,
                vatId: vatId,
                step: step,
                performedAt: performedAt,
                operatorId: operatorId,
                processVersionId: processVersionId,
                temperatureC: temperatureC,
                visualState: visualState,
                cutSizeMm: cutSizeMm,
                zone: zone,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vatId,
                required StepKind step,
                required DateTime performedAt,
                required String operatorId,
                required String processVersionId,
                Value<double?> temperatureC = const Value.absent(),
                Value<VisualState?> visualState = const Value.absent(),
                Value<double?> cutSizeMm = const Value.absent(),
                Value<VatZone?> zone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionEventsCompanion.insert(
                id: id,
                vatId: vatId,
                step: step,
                performedAt: performedAt,
                operatorId: operatorId,
                processVersionId: processVersionId,
                temperatureC: temperatureC,
                visualState: visualState,
                cutSizeMm: cutSizeMm,
                zone: zone,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActionEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $ActionEventsTable,
      ActionEvent,
      $$ActionEventsTableFilterComposer,
      $$ActionEventsTableOrderingComposer,
      $$ActionEventsTableAnnotationComposer,
      $$ActionEventsTableCreateCompanionBuilder,
      $$ActionEventsTableUpdateCompanionBuilder,
      (
        ActionEvent,
        BaseReferences<_$CheeseTraceDatabase, $ActionEventsTable, ActionEvent>,
      ),
      ActionEvent,
      PrefetchHooks Function()
    >;
typedef $$WheyTanksTableCreateCompanionBuilder =
    WheyTanksCompanion Function({
      required String id,
      required String code,
      required String qrCode,
      Value<int> rowid,
    });
typedef $$WheyTanksTableUpdateCompanionBuilder =
    WheyTanksCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> qrCode,
      Value<int> rowid,
    });

class $$WheyTanksTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $WheyTanksTable> {
  $$WheyTanksTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WheyTanksTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $WheyTanksTable> {
  $$WheyTanksTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WheyTanksTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $WheyTanksTable> {
  $$WheyTanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);
}

class $$WheyTanksTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $WheyTanksTable,
          WheyTank,
          $$WheyTanksTableFilterComposer,
          $$WheyTanksTableOrderingComposer,
          $$WheyTanksTableAnnotationComposer,
          $$WheyTanksTableCreateCompanionBuilder,
          $$WheyTanksTableUpdateCompanionBuilder,
          (
            WheyTank,
            BaseReferences<_$CheeseTraceDatabase, $WheyTanksTable, WheyTank>,
          ),
          WheyTank,
          PrefetchHooks Function()
        > {
  $$WheyTanksTableTableManager(_$CheeseTraceDatabase db, $WheyTanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WheyTanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WheyTanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WheyTanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> qrCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WheyTanksCompanion(
                id: id,
                code: code,
                qrCode: qrCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String qrCode,
                Value<int> rowid = const Value.absent(),
              }) => WheyTanksCompanion.insert(
                id: id,
                code: code,
                qrCode: qrCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WheyTanksTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $WheyTanksTable,
      WheyTank,
      $$WheyTanksTableFilterComposer,
      $$WheyTanksTableOrderingComposer,
      $$WheyTanksTableAnnotationComposer,
      $$WheyTanksTableCreateCompanionBuilder,
      $$WheyTanksTableUpdateCompanionBuilder,
      (
        WheyTank,
        BaseReferences<_$CheeseTraceDatabase, $WheyTanksTable, WheyTank>,
      ),
      WheyTank,
      PrefetchHooks Function()
    >;
typedef $$WheyTransfersTableCreateCompanionBuilder =
    WheyTransfersCompanion Function({
      required String id,
      required String vatId,
      required String tankId,
      required DateTime transferredAt,
      Value<double?> amountL,
      Value<int> rowid,
    });
typedef $$WheyTransfersTableUpdateCompanionBuilder =
    WheyTransfersCompanion Function({
      Value<String> id,
      Value<String> vatId,
      Value<String> tankId,
      Value<DateTime> transferredAt,
      Value<double?> amountL,
      Value<int> rowid,
    });

class $$WheyTransfersTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $WheyTransfersTable> {
  $$WheyTransfersTableFilterComposer({
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

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tankId => $composableBuilder(
    column: $table.tankId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transferredAt => $composableBuilder(
    column: $table.transferredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountL => $composableBuilder(
    column: $table.amountL,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WheyTransfersTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $WheyTransfersTable> {
  $$WheyTransfersTableOrderingComposer({
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

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tankId => $composableBuilder(
    column: $table.tankId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transferredAt => $composableBuilder(
    column: $table.transferredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountL => $composableBuilder(
    column: $table.amountL,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WheyTransfersTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $WheyTransfersTable> {
  $$WheyTransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumn<String> get tankId =>
      $composableBuilder(column: $table.tankId, builder: (column) => column);

  GeneratedColumn<DateTime> get transferredAt => $composableBuilder(
    column: $table.transferredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountL =>
      $composableBuilder(column: $table.amountL, builder: (column) => column);
}

class $$WheyTransfersTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $WheyTransfersTable,
          WheyTransfer,
          $$WheyTransfersTableFilterComposer,
          $$WheyTransfersTableOrderingComposer,
          $$WheyTransfersTableAnnotationComposer,
          $$WheyTransfersTableCreateCompanionBuilder,
          $$WheyTransfersTableUpdateCompanionBuilder,
          (
            WheyTransfer,
            BaseReferences<
              _$CheeseTraceDatabase,
              $WheyTransfersTable,
              WheyTransfer
            >,
          ),
          WheyTransfer,
          PrefetchHooks Function()
        > {
  $$WheyTransfersTableTableManager(
    _$CheeseTraceDatabase db,
    $WheyTransfersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WheyTransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WheyTransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WheyTransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<String> tankId = const Value.absent(),
                Value<DateTime> transferredAt = const Value.absent(),
                Value<double?> amountL = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WheyTransfersCompanion(
                id: id,
                vatId: vatId,
                tankId: tankId,
                transferredAt: transferredAt,
                amountL: amountL,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vatId,
                required String tankId,
                required DateTime transferredAt,
                Value<double?> amountL = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WheyTransfersCompanion.insert(
                id: id,
                vatId: vatId,
                tankId: tankId,
                transferredAt: transferredAt,
                amountL: amountL,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WheyTransfersTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $WheyTransfersTable,
      WheyTransfer,
      $$WheyTransfersTableFilterComposer,
      $$WheyTransfersTableOrderingComposer,
      $$WheyTransfersTableAnnotationComposer,
      $$WheyTransfersTableCreateCompanionBuilder,
      $$WheyTransfersTableUpdateCompanionBuilder,
      (
        WheyTransfer,
        BaseReferences<
          _$CheeseTraceDatabase,
          $WheyTransfersTable,
          WheyTransfer
        >,
      ),
      WheyTransfer,
      PrefetchHooks Function()
    >;
typedef $$MoldBatchesTableCreateCompanionBuilder =
    MoldBatchesCompanion Function({
      required String id,
      required String code,
      required String vatId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MoldBatchesTableUpdateCompanionBuilder =
    MoldBatchesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> vatId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MoldBatchesTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $MoldBatchesTable> {
  $$MoldBatchesTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoldBatchesTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $MoldBatchesTable> {
  $$MoldBatchesTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoldBatchesTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $MoldBatchesTable> {
  $$MoldBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MoldBatchesTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $MoldBatchesTable,
          MoldBatche,
          $$MoldBatchesTableFilterComposer,
          $$MoldBatchesTableOrderingComposer,
          $$MoldBatchesTableAnnotationComposer,
          $$MoldBatchesTableCreateCompanionBuilder,
          $$MoldBatchesTableUpdateCompanionBuilder,
          (
            MoldBatche,
            BaseReferences<
              _$CheeseTraceDatabase,
              $MoldBatchesTable,
              MoldBatche
            >,
          ),
          MoldBatche,
          PrefetchHooks Function()
        > {
  $$MoldBatchesTableTableManager(
    _$CheeseTraceDatabase db,
    $MoldBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoldBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoldBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoldBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoldBatchesCompanion(
                id: id,
                code: code,
                vatId: vatId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String vatId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MoldBatchesCompanion.insert(
                id: id,
                code: code,
                vatId: vatId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoldBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $MoldBatchesTable,
      MoldBatche,
      $$MoldBatchesTableFilterComposer,
      $$MoldBatchesTableOrderingComposer,
      $$MoldBatchesTableAnnotationComposer,
      $$MoldBatchesTableCreateCompanionBuilder,
      $$MoldBatchesTableUpdateCompanionBuilder,
      (
        MoldBatche,
        BaseReferences<_$CheeseTraceDatabase, $MoldBatchesTable, MoldBatche>,
      ),
      MoldBatche,
      PrefetchHooks Function()
    >;
typedef $$MoldsTableCreateCompanionBuilder =
    MoldsCompanion Function({
      required String id,
      required String batchId,
      required String vatId,
      required String qrCode,
      Value<double?> weightG,
      Value<DateTime?> moldedAt,
      Value<DateTime?> pressedAt,
      Value<String?> remoldedFromId,
      Value<DateTime?> remoldedAt,
      Value<String?> splitFromMoldId,
      Value<DateTime?> splitAt,
      Value<int> rowid,
    });
typedef $$MoldsTableUpdateCompanionBuilder =
    MoldsCompanion Function({
      Value<String> id,
      Value<String> batchId,
      Value<String> vatId,
      Value<String> qrCode,
      Value<double?> weightG,
      Value<DateTime?> moldedAt,
      Value<DateTime?> pressedAt,
      Value<String?> remoldedFromId,
      Value<DateTime?> remoldedAt,
      Value<String?> splitFromMoldId,
      Value<DateTime?> splitAt,
      Value<int> rowid,
    });

class $$MoldsTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $MoldsTable> {
  $$MoldsTableFilterComposer({
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

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightG => $composableBuilder(
    column: $table.weightG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get moldedAt => $composableBuilder(
    column: $table.moldedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pressedAt => $composableBuilder(
    column: $table.pressedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoldedFromId => $composableBuilder(
    column: $table.remoldedFromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remoldedAt => $composableBuilder(
    column: $table.remoldedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitFromMoldId => $composableBuilder(
    column: $table.splitFromMoldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get splitAt => $composableBuilder(
    column: $table.splitAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoldsTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $MoldsTable> {
  $$MoldsTableOrderingComposer({
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

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightG => $composableBuilder(
    column: $table.weightG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get moldedAt => $composableBuilder(
    column: $table.moldedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pressedAt => $composableBuilder(
    column: $table.pressedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoldedFromId => $composableBuilder(
    column: $table.remoldedFromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remoldedAt => $composableBuilder(
    column: $table.remoldedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitFromMoldId => $composableBuilder(
    column: $table.splitFromMoldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get splitAt => $composableBuilder(
    column: $table.splitAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoldsTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $MoldsTable> {
  $$MoldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);

  GeneratedColumn<double> get weightG =>
      $composableBuilder(column: $table.weightG, builder: (column) => column);

  GeneratedColumn<DateTime> get moldedAt =>
      $composableBuilder(column: $table.moldedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get pressedAt =>
      $composableBuilder(column: $table.pressedAt, builder: (column) => column);

  GeneratedColumn<String> get remoldedFromId => $composableBuilder(
    column: $table.remoldedFromId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get remoldedAt => $composableBuilder(
    column: $table.remoldedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get splitFromMoldId => $composableBuilder(
    column: $table.splitFromMoldId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get splitAt =>
      $composableBuilder(column: $table.splitAt, builder: (column) => column);
}

class $$MoldsTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $MoldsTable,
          Mold,
          $$MoldsTableFilterComposer,
          $$MoldsTableOrderingComposer,
          $$MoldsTableAnnotationComposer,
          $$MoldsTableCreateCompanionBuilder,
          $$MoldsTableUpdateCompanionBuilder,
          (Mold, BaseReferences<_$CheeseTraceDatabase, $MoldsTable, Mold>),
          Mold,
          PrefetchHooks Function()
        > {
  $$MoldsTableTableManager(_$CheeseTraceDatabase db, $MoldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> batchId = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<String> qrCode = const Value.absent(),
                Value<double?> weightG = const Value.absent(),
                Value<DateTime?> moldedAt = const Value.absent(),
                Value<DateTime?> pressedAt = const Value.absent(),
                Value<String?> remoldedFromId = const Value.absent(),
                Value<DateTime?> remoldedAt = const Value.absent(),
                Value<String?> splitFromMoldId = const Value.absent(),
                Value<DateTime?> splitAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoldsCompanion(
                id: id,
                batchId: batchId,
                vatId: vatId,
                qrCode: qrCode,
                weightG: weightG,
                moldedAt: moldedAt,
                pressedAt: pressedAt,
                remoldedFromId: remoldedFromId,
                remoldedAt: remoldedAt,
                splitFromMoldId: splitFromMoldId,
                splitAt: splitAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String batchId,
                required String vatId,
                required String qrCode,
                Value<double?> weightG = const Value.absent(),
                Value<DateTime?> moldedAt = const Value.absent(),
                Value<DateTime?> pressedAt = const Value.absent(),
                Value<String?> remoldedFromId = const Value.absent(),
                Value<DateTime?> remoldedAt = const Value.absent(),
                Value<String?> splitFromMoldId = const Value.absent(),
                Value<DateTime?> splitAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoldsCompanion.insert(
                id: id,
                batchId: batchId,
                vatId: vatId,
                qrCode: qrCode,
                weightG: weightG,
                moldedAt: moldedAt,
                pressedAt: pressedAt,
                remoldedFromId: remoldedFromId,
                remoldedAt: remoldedAt,
                splitFromMoldId: splitFromMoldId,
                splitAt: splitAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoldsTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $MoldsTable,
      Mold,
      $$MoldsTableFilterComposer,
      $$MoldsTableOrderingComposer,
      $$MoldsTableAnnotationComposer,
      $$MoldsTableCreateCompanionBuilder,
      $$MoldsTableUpdateCompanionBuilder,
      (Mold, BaseReferences<_$CheeseTraceDatabase, $MoldsTable, Mold>),
      Mold,
      PrefetchHooks Function()
    >;
typedef $$MoldTurnsTableCreateCompanionBuilder =
    MoldTurnsCompanion Function({
      required String id,
      required String moldId,
      required String vatId,
      required int round,
      required String position,
      required DateTime turnedAt,
      required DateTime recordedAt,
      required TurnDamage damage,
      Value<String?> pressPlateId,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$MoldTurnsTableUpdateCompanionBuilder =
    MoldTurnsCompanion Function({
      Value<String> id,
      Value<String> moldId,
      Value<String> vatId,
      Value<int> round,
      Value<String> position,
      Value<DateTime> turnedAt,
      Value<DateTime> recordedAt,
      Value<TurnDamage> damage,
      Value<String?> pressPlateId,
      Value<String?> note,
      Value<int> rowid,
    });

class $$MoldTurnsTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $MoldTurnsTable> {
  $$MoldTurnsTableFilterComposer({
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

  ColumnFilters<String> get moldId => $composableBuilder(
    column: $table.moldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get turnedAt => $composableBuilder(
    column: $table.turnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TurnDamage, TurnDamage, int> get damage =>
      $composableBuilder(
        column: $table.damage,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get pressPlateId => $composableBuilder(
    column: $table.pressPlateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoldTurnsTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $MoldTurnsTable> {
  $$MoldTurnsTableOrderingComposer({
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

  ColumnOrderings<String> get moldId => $composableBuilder(
    column: $table.moldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get turnedAt => $composableBuilder(
    column: $table.turnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pressPlateId => $composableBuilder(
    column: $table.pressPlateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoldTurnsTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $MoldTurnsTable> {
  $$MoldTurnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moldId =>
      $composableBuilder(column: $table.moldId, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get turnedAt =>
      $composableBuilder(column: $table.turnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TurnDamage, int> get damage =>
      $composableBuilder(column: $table.damage, builder: (column) => column);

  GeneratedColumn<String> get pressPlateId => $composableBuilder(
    column: $table.pressPlateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MoldTurnsTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $MoldTurnsTable,
          MoldTurn,
          $$MoldTurnsTableFilterComposer,
          $$MoldTurnsTableOrderingComposer,
          $$MoldTurnsTableAnnotationComposer,
          $$MoldTurnsTableCreateCompanionBuilder,
          $$MoldTurnsTableUpdateCompanionBuilder,
          (
            MoldTurn,
            BaseReferences<_$CheeseTraceDatabase, $MoldTurnsTable, MoldTurn>,
          ),
          MoldTurn,
          PrefetchHooks Function()
        > {
  $$MoldTurnsTableTableManager(_$CheeseTraceDatabase db, $MoldTurnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoldTurnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoldTurnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoldTurnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> moldId = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<DateTime> turnedAt = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<TurnDamage> damage = const Value.absent(),
                Value<String?> pressPlateId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoldTurnsCompanion(
                id: id,
                moldId: moldId,
                vatId: vatId,
                round: round,
                position: position,
                turnedAt: turnedAt,
                recordedAt: recordedAt,
                damage: damage,
                pressPlateId: pressPlateId,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String moldId,
                required String vatId,
                required int round,
                required String position,
                required DateTime turnedAt,
                required DateTime recordedAt,
                required TurnDamage damage,
                Value<String?> pressPlateId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoldTurnsCompanion.insert(
                id: id,
                moldId: moldId,
                vatId: vatId,
                round: round,
                position: position,
                turnedAt: turnedAt,
                recordedAt: recordedAt,
                damage: damage,
                pressPlateId: pressPlateId,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoldTurnsTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $MoldTurnsTable,
      MoldTurn,
      $$MoldTurnsTableFilterComposer,
      $$MoldTurnsTableOrderingComposer,
      $$MoldTurnsTableAnnotationComposer,
      $$MoldTurnsTableCreateCompanionBuilder,
      $$MoldTurnsTableUpdateCompanionBuilder,
      (
        MoldTurn,
        BaseReferences<_$CheeseTraceDatabase, $MoldTurnsTable, MoldTurn>,
      ),
      MoldTurn,
      PrefetchHooks Function()
    >;
typedef $$LabSamplesTableCreateCompanionBuilder =
    LabSamplesCompanion Function({
      required String id,
      required String vatId,
      Value<String?> moldId,
      required StepKind step,
      required DateTime sampledAt,
      Value<DateTime?> receivedAt,
      Value<double?> moisturePct,
      Value<double?> acidityPh,
      Value<String?> labId,
      Value<int> rowid,
    });
typedef $$LabSamplesTableUpdateCompanionBuilder =
    LabSamplesCompanion Function({
      Value<String> id,
      Value<String> vatId,
      Value<String?> moldId,
      Value<StepKind> step,
      Value<DateTime> sampledAt,
      Value<DateTime?> receivedAt,
      Value<double?> moisturePct,
      Value<double?> acidityPh,
      Value<String?> labId,
      Value<int> rowid,
    });

class $$LabSamplesTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $LabSamplesTable> {
  $$LabSamplesTableFilterComposer({
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

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moldId => $composableBuilder(
    column: $table.moldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StepKind, StepKind, int> get step =>
      $composableBuilder(
        column: $table.step,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get sampledAt => $composableBuilder(
    column: $table.sampledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get moisturePct => $composableBuilder(
    column: $table.moisturePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get acidityPh => $composableBuilder(
    column: $table.acidityPh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labId => $composableBuilder(
    column: $table.labId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LabSamplesTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $LabSamplesTable> {
  $$LabSamplesTableOrderingComposer({
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

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moldId => $composableBuilder(
    column: $table.moldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sampledAt => $composableBuilder(
    column: $table.sampledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get moisturePct => $composableBuilder(
    column: $table.moisturePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get acidityPh => $composableBuilder(
    column: $table.acidityPh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labId => $composableBuilder(
    column: $table.labId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabSamplesTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $LabSamplesTable> {
  $$LabSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumn<String> get moldId =>
      $composableBuilder(column: $table.moldId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StepKind, int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<DateTime> get sampledAt =>
      $composableBuilder(column: $table.sampledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get moisturePct => $composableBuilder(
    column: $table.moisturePct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get acidityPh =>
      $composableBuilder(column: $table.acidityPh, builder: (column) => column);

  GeneratedColumn<String> get labId =>
      $composableBuilder(column: $table.labId, builder: (column) => column);
}

class $$LabSamplesTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $LabSamplesTable,
          LabSample,
          $$LabSamplesTableFilterComposer,
          $$LabSamplesTableOrderingComposer,
          $$LabSamplesTableAnnotationComposer,
          $$LabSamplesTableCreateCompanionBuilder,
          $$LabSamplesTableUpdateCompanionBuilder,
          (
            LabSample,
            BaseReferences<_$CheeseTraceDatabase, $LabSamplesTable, LabSample>,
          ),
          LabSample,
          PrefetchHooks Function()
        > {
  $$LabSamplesTableTableManager(
    _$CheeseTraceDatabase db,
    $LabSamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<String?> moldId = const Value.absent(),
                Value<StepKind> step = const Value.absent(),
                Value<DateTime> sampledAt = const Value.absent(),
                Value<DateTime?> receivedAt = const Value.absent(),
                Value<double?> moisturePct = const Value.absent(),
                Value<double?> acidityPh = const Value.absent(),
                Value<String?> labId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabSamplesCompanion(
                id: id,
                vatId: vatId,
                moldId: moldId,
                step: step,
                sampledAt: sampledAt,
                receivedAt: receivedAt,
                moisturePct: moisturePct,
                acidityPh: acidityPh,
                labId: labId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vatId,
                Value<String?> moldId = const Value.absent(),
                required StepKind step,
                required DateTime sampledAt,
                Value<DateTime?> receivedAt = const Value.absent(),
                Value<double?> moisturePct = const Value.absent(),
                Value<double?> acidityPh = const Value.absent(),
                Value<String?> labId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabSamplesCompanion.insert(
                id: id,
                vatId: vatId,
                moldId: moldId,
                step: step,
                sampledAt: sampledAt,
                receivedAt: receivedAt,
                moisturePct: moisturePct,
                acidityPh: acidityPh,
                labId: labId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LabSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $LabSamplesTable,
      LabSample,
      $$LabSamplesTableFilterComposer,
      $$LabSamplesTableOrderingComposer,
      $$LabSamplesTableAnnotationComposer,
      $$LabSamplesTableCreateCompanionBuilder,
      $$LabSamplesTableUpdateCompanionBuilder,
      (
        LabSample,
        BaseReferences<_$CheeseTraceDatabase, $LabSamplesTable, LabSample>,
      ),
      LabSample,
      PrefetchHooks Function()
    >;
typedef $$CurdPhotosTableCreateCompanionBuilder =
    CurdPhotosCompanion Function({
      required String id,
      required String vatId,
      required VatZone zone,
      required DateTime takenAt,
      required String filePath,
      required bool standardBackground,
      Value<double?> grainSizeMm,
      Value<int> rowid,
    });
typedef $$CurdPhotosTableUpdateCompanionBuilder =
    CurdPhotosCompanion Function({
      Value<String> id,
      Value<String> vatId,
      Value<VatZone> zone,
      Value<DateTime> takenAt,
      Value<String> filePath,
      Value<bool> standardBackground,
      Value<double?> grainSizeMm,
      Value<int> rowid,
    });

class $$CurdPhotosTableFilterComposer
    extends Composer<_$CheeseTraceDatabase, $CurdPhotosTable> {
  $$CurdPhotosTableFilterComposer({
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

  ColumnFilters<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VatZone, VatZone, int> get zone =>
      $composableBuilder(
        column: $table.zone,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get standardBackground => $composableBuilder(
    column: $table.standardBackground,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grainSizeMm => $composableBuilder(
    column: $table.grainSizeMm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurdPhotosTableOrderingComposer
    extends Composer<_$CheeseTraceDatabase, $CurdPhotosTable> {
  $$CurdPhotosTableOrderingComposer({
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

  ColumnOrderings<String> get vatId => $composableBuilder(
    column: $table.vatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get standardBackground => $composableBuilder(
    column: $table.standardBackground,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grainSizeMm => $composableBuilder(
    column: $table.grainSizeMm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurdPhotosTableAnnotationComposer
    extends Composer<_$CheeseTraceDatabase, $CurdPhotosTable> {
  $$CurdPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vatId =>
      $composableBuilder(column: $table.vatId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VatZone, int> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get standardBackground => $composableBuilder(
    column: $table.standardBackground,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grainSizeMm => $composableBuilder(
    column: $table.grainSizeMm,
    builder: (column) => column,
  );
}

class $$CurdPhotosTableTableManager
    extends
        RootTableManager<
          _$CheeseTraceDatabase,
          $CurdPhotosTable,
          CurdPhoto,
          $$CurdPhotosTableFilterComposer,
          $$CurdPhotosTableOrderingComposer,
          $$CurdPhotosTableAnnotationComposer,
          $$CurdPhotosTableCreateCompanionBuilder,
          $$CurdPhotosTableUpdateCompanionBuilder,
          (
            CurdPhoto,
            BaseReferences<_$CheeseTraceDatabase, $CurdPhotosTable, CurdPhoto>,
          ),
          CurdPhoto,
          PrefetchHooks Function()
        > {
  $$CurdPhotosTableTableManager(
    _$CheeseTraceDatabase db,
    $CurdPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurdPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurdPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurdPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vatId = const Value.absent(),
                Value<VatZone> zone = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<bool> standardBackground = const Value.absent(),
                Value<double?> grainSizeMm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurdPhotosCompanion(
                id: id,
                vatId: vatId,
                zone: zone,
                takenAt: takenAt,
                filePath: filePath,
                standardBackground: standardBackground,
                grainSizeMm: grainSizeMm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vatId,
                required VatZone zone,
                required DateTime takenAt,
                required String filePath,
                required bool standardBackground,
                Value<double?> grainSizeMm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurdPhotosCompanion.insert(
                id: id,
                vatId: vatId,
                zone: zone,
                takenAt: takenAt,
                filePath: filePath,
                standardBackground: standardBackground,
                grainSizeMm: grainSizeMm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurdPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$CheeseTraceDatabase,
      $CurdPhotosTable,
      CurdPhoto,
      $$CurdPhotosTableFilterComposer,
      $$CurdPhotosTableOrderingComposer,
      $$CurdPhotosTableAnnotationComposer,
      $$CurdPhotosTableCreateCompanionBuilder,
      $$CurdPhotosTableUpdateCompanionBuilder,
      (
        CurdPhoto,
        BaseReferences<_$CheeseTraceDatabase, $CurdPhotosTable, CurdPhoto>,
      ),
      CurdPhoto,
      PrefetchHooks Function()
    >;

class $CheeseTraceDatabaseManager {
  final _$CheeseTraceDatabase _db;
  $CheeseTraceDatabaseManager(this._db);
  $$VatsTableTableManager get vats => $$VatsTableTableManager(_db, _db.vats);
  $$ProcessVersionsTableTableManager get processVersions =>
      $$ProcessVersionsTableTableManager(_db, _db.processVersions);
  $$ActionEventsTableTableManager get actionEvents =>
      $$ActionEventsTableTableManager(_db, _db.actionEvents);
  $$WheyTanksTableTableManager get wheyTanks =>
      $$WheyTanksTableTableManager(_db, _db.wheyTanks);
  $$WheyTransfersTableTableManager get wheyTransfers =>
      $$WheyTransfersTableTableManager(_db, _db.wheyTransfers);
  $$MoldBatchesTableTableManager get moldBatches =>
      $$MoldBatchesTableTableManager(_db, _db.moldBatches);
  $$MoldsTableTableManager get molds =>
      $$MoldsTableTableManager(_db, _db.molds);
  $$MoldTurnsTableTableManager get moldTurns =>
      $$MoldTurnsTableTableManager(_db, _db.moldTurns);
  $$LabSamplesTableTableManager get labSamples =>
      $$LabSamplesTableTableManager(_db, _db.labSamples);
  $$CurdPhotosTableTableManager get curdPhotos =>
      $$CurdPhotosTableTableManager(_db, _db.curdPhotos);
}
