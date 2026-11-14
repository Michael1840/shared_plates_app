// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TagKind>($TagsTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<CoverStyle, String> coverStyle =
      GeneratedColumn<String>(
        'cover_style',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CoverStyle>($TagsTable.$convertercoverStyle);
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    label,
    kind,
    coverStyle,
    position,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: $TagsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      coverStyle: $TagsTable.$convertercoverStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cover_style'],
        )!,
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TagKind, String, String> $converterkind =
      const EnumNameConverter<TagKind>(TagKind.values);
  static JsonTypeConverter2<CoverStyle, String, String> $convertercoverStyle =
      const EnumNameConverter<CoverStyle>(CoverStyle.values);
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final int id;
  final String slug;
  final String label;
  final TagKind kind;
  final CoverStyle coverStyle;
  final int position;
  final DateTime updatedAt;
  const TagRow({
    required this.id,
    required this.slug,
    required this.label,
    required this.kind,
    required this.coverStyle,
    required this.position,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    map['label'] = Variable<String>(label);
    {
      map['kind'] = Variable<String>($TagsTable.$converterkind.toSql(kind));
    }
    {
      map['cover_style'] = Variable<String>(
        $TagsTable.$convertercoverStyle.toSql(coverStyle),
      );
    }
    map['position'] = Variable<int>(position);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      slug: Value(slug),
      label: Value(label),
      kind: Value(kind),
      coverStyle: Value(coverStyle),
      position: Value(position),
      updatedAt: Value(updatedAt),
    );
  }

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      label: serializer.fromJson<String>(json['label']),
      kind: $TagsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      coverStyle: $TagsTable.$convertercoverStyle.fromJson(
        serializer.fromJson<String>(json['coverStyle']),
      ),
      position: serializer.fromJson<int>(json['position']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>($TagsTable.$converterkind.toJson(kind)),
      'coverStyle': serializer.toJson<String>(
        $TagsTable.$convertercoverStyle.toJson(coverStyle),
      ),
      'position': serializer.toJson<int>(position),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TagRow copyWith({
    int? id,
    String? slug,
    String? label,
    TagKind? kind,
    CoverStyle? coverStyle,
    int? position,
    DateTime? updatedAt,
  }) => TagRow(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    coverStyle: coverStyle ?? this.coverStyle,
    position: position ?? this.position,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      coverStyle: data.coverStyle.present
          ? data.coverStyle.value
          : this.coverStyle,
      position: data.position.present ? data.position.value : this.position,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('coverStyle: $coverStyle, ')
          ..write('position: $position, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, slug, label, kind, coverStyle, position, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.coverStyle == this.coverStyle &&
          other.position == this.position &&
          other.updatedAt == this.updatedAt);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<int> id;
  final Value<String> slug;
  final Value<String> label;
  final Value<TagKind> kind;
  final Value<CoverStyle> coverStyle;
  final Value<int> position;
  final Value<DateTime> updatedAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.coverStyle = const Value.absent(),
    this.position = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required String label,
    required TagKind kind,
    required CoverStyle coverStyle,
    this.position = const Value.absent(),
    required DateTime updatedAt,
  }) : slug = Value(slug),
       label = Value(label),
       kind = Value(kind),
       coverStyle = Value(coverStyle),
       updatedAt = Value(updatedAt);
  static Insertable<TagRow> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<String>? coverStyle,
    Expression<int>? position,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (coverStyle != null) 'cover_style': coverStyle,
      if (position != null) 'position': position,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? slug,
    Value<String>? label,
    Value<TagKind>? kind,
    Value<CoverStyle>? coverStyle,
    Value<int>? position,
    Value<DateTime>? updatedAt,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      coverStyle: coverStyle ?? this.coverStyle,
      position: position ?? this.position,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TagsTable.$converterkind.toSql(kind.value),
      );
    }
    if (coverStyle.present) {
      map['cover_style'] = Variable<String>(
        $TagsTable.$convertercoverStyle.toSql(coverStyle.value),
      );
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('coverStyle: $coverStyle, ')
          ..write('position: $position, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MeasureUnitsTable extends MeasureUnits
    with TableInfo<$MeasureUnitsTable, UnitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasureUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UnitKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UnitKind>($MeasureUnitsTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<UnitScope, String> scope =
      GeneratedColumn<String>(
        'scope',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UnitScope>($MeasureUnitsTable.$converterscope);
  static const VerificationMeta _toBaseMeta = const VerificationMeta('toBase');
  @override
  late final GeneratedColumn<double> toBase = GeneratedColumn<double>(
    'to_base',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    code,
    label,
    kind,
    scope,
    toBase,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measure_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('to_base')) {
      context.handle(
        _toBaseMeta,
        toBase.isAcceptableOrUnknown(data['to_base']!, _toBaseMeta),
      );
    } else if (isInserting) {
      context.missing(_toBaseMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  UnitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitRow(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: $MeasureUnitsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      scope: $MeasureUnitsTable.$converterscope.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}scope'],
        )!,
      ),
      toBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_base'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MeasureUnitsTable createAlias(String alias) {
    return $MeasureUnitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UnitKind, String, String> $converterkind =
      const EnumNameConverter<UnitKind>(UnitKind.values);
  static JsonTypeConverter2<UnitScope, String, String> $converterscope =
      const EnumNameConverter<UnitScope>(UnitScope.values);
}

class UnitRow extends DataClass implements Insertable<UnitRow> {
  final String code;
  final String label;
  final UnitKind kind;
  final UnitScope scope;
  final double toBase;
  final DateTime updatedAt;
  const UnitRow({
    required this.code,
    required this.label,
    required this.kind,
    required this.scope,
    required this.toBase,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['label'] = Variable<String>(label);
    {
      map['kind'] = Variable<String>(
        $MeasureUnitsTable.$converterkind.toSql(kind),
      );
    }
    {
      map['scope'] = Variable<String>(
        $MeasureUnitsTable.$converterscope.toSql(scope),
      );
    }
    map['to_base'] = Variable<double>(toBase);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MeasureUnitsCompanion toCompanion(bool nullToAbsent) {
    return MeasureUnitsCompanion(
      code: Value(code),
      label: Value(label),
      kind: Value(kind),
      scope: Value(scope),
      toBase: Value(toBase),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitRow(
      code: serializer.fromJson<String>(json['code']),
      label: serializer.fromJson<String>(json['label']),
      kind: $MeasureUnitsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      scope: $MeasureUnitsTable.$converterscope.fromJson(
        serializer.fromJson<String>(json['scope']),
      ),
      toBase: serializer.fromJson<double>(json['toBase']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(
        $MeasureUnitsTable.$converterkind.toJson(kind),
      ),
      'scope': serializer.toJson<String>(
        $MeasureUnitsTable.$converterscope.toJson(scope),
      ),
      'toBase': serializer.toJson<double>(toBase),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnitRow copyWith({
    String? code,
    String? label,
    UnitKind? kind,
    UnitScope? scope,
    double? toBase,
    DateTime? updatedAt,
  }) => UnitRow(
    code: code ?? this.code,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    scope: scope ?? this.scope,
    toBase: toBase ?? this.toBase,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UnitRow copyWithCompanion(MeasureUnitsCompanion data) {
    return UnitRow(
      code: data.code.present ? data.code.value : this.code,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      scope: data.scope.present ? data.scope.value : this.scope,
      toBase: data.toBase.present ? data.toBase.value : this.toBase,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitRow(')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('scope: $scope, ')
          ..write('toBase: $toBase, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, label, kind, scope, toBase, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitRow &&
          other.code == this.code &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.scope == this.scope &&
          other.toBase == this.toBase &&
          other.updatedAt == this.updatedAt);
}

class MeasureUnitsCompanion extends UpdateCompanion<UnitRow> {
  final Value<String> code;
  final Value<String> label;
  final Value<UnitKind> kind;
  final Value<UnitScope> scope;
  final Value<double> toBase;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MeasureUnitsCompanion({
    this.code = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.scope = const Value.absent(),
    this.toBase = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasureUnitsCompanion.insert({
    required String code,
    required String label,
    required UnitKind kind,
    required UnitScope scope,
    required double toBase,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       label = Value(label),
       kind = Value(kind),
       scope = Value(scope),
       toBase = Value(toBase),
       updatedAt = Value(updatedAt);
  static Insertable<UnitRow> custom({
    Expression<String>? code,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<String>? scope,
    Expression<double>? toBase,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (scope != null) 'scope': scope,
      if (toBase != null) 'to_base': toBase,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasureUnitsCompanion copyWith({
    Value<String>? code,
    Value<String>? label,
    Value<UnitKind>? kind,
    Value<UnitScope>? scope,
    Value<double>? toBase,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MeasureUnitsCompanion(
      code: code ?? this.code,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      scope: scope ?? this.scope,
      toBase: toBase ?? this.toBase,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $MeasureUnitsTable.$converterkind.toSql(kind.value),
      );
    }
    if (scope.present) {
      map['scope'] = Variable<String>(
        $MeasureUnitsTable.$converterscope.toSql(scope.value),
      );
    }
    if (toBase.present) {
      map['to_base'] = Variable<double>(toBase.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasureUnitsCompanion(')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('scope: $scope, ')
          ..write('toBase: $toBase, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, FoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> aliases =
      GeneratedColumn<String>(
        'aliases',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($FoodsTable.$converteraliases);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kcal100gMeta = const VerificationMeta(
    'kcal100g',
  );
  @override
  late final GeneratedColumn<double> kcal100g = GeneratedColumn<double>(
    'kcal100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _protein100gMeta = const VerificationMeta(
    'protein100g',
  );
  @override
  late final GeneratedColumn<double> protein100g = GeneratedColumn<double>(
    'protein100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbs100gMeta = const VerificationMeta(
    'carbs100g',
  );
  @override
  late final GeneratedColumn<double> carbs100g = GeneratedColumn<double>(
    'carbs100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fat100gMeta = const VerificationMeta(
    'fat100g',
  );
  @override
  late final GeneratedColumn<double> fat100g = GeneratedColumn<double>(
    'fat100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fibre100gMeta = const VerificationMeta(
    'fibre100g',
  );
  @override
  late final GeneratedColumn<double> fibre100g = GeneratedColumn<double>(
    'fibre100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sugar100gMeta = const VerificationMeta(
    'sugar100g',
  );
  @override
  late final GeneratedColumn<double> sugar100g = GeneratedColumn<double>(
    'sugar100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sodiumMg100gMeta = const VerificationMeta(
    'sodiumMg100g',
  );
  @override
  late final GeneratedColumn<double> sodiumMg100g = GeneratedColumn<double>(
    'sodium_mg100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _densityGMlMeta = const VerificationMeta(
    'densityGMl',
  );
  @override
  late final GeneratedColumn<double> densityGMl = GeneratedColumn<double>(
    'density_g_ml',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    aliases,
    category,
    kcal100g,
    protein100g,
    carbs100g,
    fat100g,
    fibre100g,
    sugar100g,
    sodiumMg100g,
    densityGMl,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodRow> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('kcal100g')) {
      context.handle(
        _kcal100gMeta,
        kcal100g.isAcceptableOrUnknown(data['kcal100g']!, _kcal100gMeta),
      );
    }
    if (data.containsKey('protein100g')) {
      context.handle(
        _protein100gMeta,
        protein100g.isAcceptableOrUnknown(
          data['protein100g']!,
          _protein100gMeta,
        ),
      );
    }
    if (data.containsKey('carbs100g')) {
      context.handle(
        _carbs100gMeta,
        carbs100g.isAcceptableOrUnknown(data['carbs100g']!, _carbs100gMeta),
      );
    }
    if (data.containsKey('fat100g')) {
      context.handle(
        _fat100gMeta,
        fat100g.isAcceptableOrUnknown(data['fat100g']!, _fat100gMeta),
      );
    }
    if (data.containsKey('fibre100g')) {
      context.handle(
        _fibre100gMeta,
        fibre100g.isAcceptableOrUnknown(data['fibre100g']!, _fibre100gMeta),
      );
    }
    if (data.containsKey('sugar100g')) {
      context.handle(
        _sugar100gMeta,
        sugar100g.isAcceptableOrUnknown(data['sugar100g']!, _sugar100gMeta),
      );
    }
    if (data.containsKey('sodium_mg100g')) {
      context.handle(
        _sodiumMg100gMeta,
        sodiumMg100g.isAcceptableOrUnknown(
          data['sodium_mg100g']!,
          _sodiumMg100gMeta,
        ),
      );
    }
    if (data.containsKey('density_g_ml')) {
      context.handle(
        _densityGMlMeta,
        densityGMl.isAcceptableOrUnknown(
          data['density_g_ml']!,
          _densityGMlMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      aliases: $FoodsTable.$converteraliases.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}aliases'],
        )!,
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      kcal100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal100g'],
      )!,
      protein100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein100g'],
      )!,
      carbs100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs100g'],
      )!,
      fat100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat100g'],
      )!,
      fibre100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre100g'],
      )!,
      sugar100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar100g'],
      ),
      sodiumMg100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sodium_mg100g'],
      ),
      densityGMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}density_g_ml'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteraliases =
      const StringListConverter();
}

class FoodRow extends DataClass implements Insertable<FoodRow> {
  final String id;
  final String name;
  final List<String> aliases;
  final String? category;
  final double kcal100g;
  final double protein100g;
  final double carbs100g;
  final double fat100g;
  final double fibre100g;
  final double? sugar100g;
  final double? sodiumMg100g;
  final double? densityGMl;
  final DateTime updatedAt;
  const FoodRow({
    required this.id,
    required this.name,
    required this.aliases,
    this.category,
    required this.kcal100g,
    required this.protein100g,
    required this.carbs100g,
    required this.fat100g,
    required this.fibre100g,
    this.sugar100g,
    this.sodiumMg100g,
    this.densityGMl,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['aliases'] = Variable<String>(
        $FoodsTable.$converteraliases.toSql(aliases),
      );
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['kcal100g'] = Variable<double>(kcal100g);
    map['protein100g'] = Variable<double>(protein100g);
    map['carbs100g'] = Variable<double>(carbs100g);
    map['fat100g'] = Variable<double>(fat100g);
    map['fibre100g'] = Variable<double>(fibre100g);
    if (!nullToAbsent || sugar100g != null) {
      map['sugar100g'] = Variable<double>(sugar100g);
    }
    if (!nullToAbsent || sodiumMg100g != null) {
      map['sodium_mg100g'] = Variable<double>(sodiumMg100g);
    }
    if (!nullToAbsent || densityGMl != null) {
      map['density_g_ml'] = Variable<double>(densityGMl);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      aliases: Value(aliases),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      kcal100g: Value(kcal100g),
      protein100g: Value(protein100g),
      carbs100g: Value(carbs100g),
      fat100g: Value(fat100g),
      fibre100g: Value(fibre100g),
      sugar100g: sugar100g == null && nullToAbsent
          ? const Value.absent()
          : Value(sugar100g),
      sodiumMg100g: sodiumMg100g == null && nullToAbsent
          ? const Value.absent()
          : Value(sodiumMg100g),
      densityGMl: densityGMl == null && nullToAbsent
          ? const Value.absent()
          : Value(densityGMl),
      updatedAt: Value(updatedAt),
    );
  }

  factory FoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      aliases: serializer.fromJson<List<String>>(json['aliases']),
      category: serializer.fromJson<String?>(json['category']),
      kcal100g: serializer.fromJson<double>(json['kcal100g']),
      protein100g: serializer.fromJson<double>(json['protein100g']),
      carbs100g: serializer.fromJson<double>(json['carbs100g']),
      fat100g: serializer.fromJson<double>(json['fat100g']),
      fibre100g: serializer.fromJson<double>(json['fibre100g']),
      sugar100g: serializer.fromJson<double?>(json['sugar100g']),
      sodiumMg100g: serializer.fromJson<double?>(json['sodiumMg100g']),
      densityGMl: serializer.fromJson<double?>(json['densityGMl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'aliases': serializer.toJson<List<String>>(aliases),
      'category': serializer.toJson<String?>(category),
      'kcal100g': serializer.toJson<double>(kcal100g),
      'protein100g': serializer.toJson<double>(protein100g),
      'carbs100g': serializer.toJson<double>(carbs100g),
      'fat100g': serializer.toJson<double>(fat100g),
      'fibre100g': serializer.toJson<double>(fibre100g),
      'sugar100g': serializer.toJson<double?>(sugar100g),
      'sodiumMg100g': serializer.toJson<double?>(sodiumMg100g),
      'densityGMl': serializer.toJson<double?>(densityGMl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FoodRow copyWith({
    String? id,
    String? name,
    List<String>? aliases,
    Value<String?> category = const Value.absent(),
    double? kcal100g,
    double? protein100g,
    double? carbs100g,
    double? fat100g,
    double? fibre100g,
    Value<double?> sugar100g = const Value.absent(),
    Value<double?> sodiumMg100g = const Value.absent(),
    Value<double?> densityGMl = const Value.absent(),
    DateTime? updatedAt,
  }) => FoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    aliases: aliases ?? this.aliases,
    category: category.present ? category.value : this.category,
    kcal100g: kcal100g ?? this.kcal100g,
    protein100g: protein100g ?? this.protein100g,
    carbs100g: carbs100g ?? this.carbs100g,
    fat100g: fat100g ?? this.fat100g,
    fibre100g: fibre100g ?? this.fibre100g,
    sugar100g: sugar100g.present ? sugar100g.value : this.sugar100g,
    sodiumMg100g: sodiumMg100g.present ? sodiumMg100g.value : this.sodiumMg100g,
    densityGMl: densityGMl.present ? densityGMl.value : this.densityGMl,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FoodRow copyWithCompanion(FoodsCompanion data) {
    return FoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
      category: data.category.present ? data.category.value : this.category,
      kcal100g: data.kcal100g.present ? data.kcal100g.value : this.kcal100g,
      protein100g: data.protein100g.present
          ? data.protein100g.value
          : this.protein100g,
      carbs100g: data.carbs100g.present ? data.carbs100g.value : this.carbs100g,
      fat100g: data.fat100g.present ? data.fat100g.value : this.fat100g,
      fibre100g: data.fibre100g.present ? data.fibre100g.value : this.fibre100g,
      sugar100g: data.sugar100g.present ? data.sugar100g.value : this.sugar100g,
      sodiumMg100g: data.sodiumMg100g.present
          ? data.sodiumMg100g.value
          : this.sodiumMg100g,
      densityGMl: data.densityGMl.present
          ? data.densityGMl.value
          : this.densityGMl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('aliases: $aliases, ')
          ..write('category: $category, ')
          ..write('kcal100g: $kcal100g, ')
          ..write('protein100g: $protein100g, ')
          ..write('carbs100g: $carbs100g, ')
          ..write('fat100g: $fat100g, ')
          ..write('fibre100g: $fibre100g, ')
          ..write('sugar100g: $sugar100g, ')
          ..write('sodiumMg100g: $sodiumMg100g, ')
          ..write('densityGMl: $densityGMl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    aliases,
    category,
    kcal100g,
    protein100g,
    carbs100g,
    fat100g,
    fibre100g,
    sugar100g,
    sodiumMg100g,
    densityGMl,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.aliases == this.aliases &&
          other.category == this.category &&
          other.kcal100g == this.kcal100g &&
          other.protein100g == this.protein100g &&
          other.carbs100g == this.carbs100g &&
          other.fat100g == this.fat100g &&
          other.fibre100g == this.fibre100g &&
          other.sugar100g == this.sugar100g &&
          other.sodiumMg100g == this.sodiumMg100g &&
          other.densityGMl == this.densityGMl &&
          other.updatedAt == this.updatedAt);
}

class FoodsCompanion extends UpdateCompanion<FoodRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<List<String>> aliases;
  final Value<String?> category;
  final Value<double> kcal100g;
  final Value<double> protein100g;
  final Value<double> carbs100g;
  final Value<double> fat100g;
  final Value<double> fibre100g;
  final Value<double?> sugar100g;
  final Value<double?> sodiumMg100g;
  final Value<double?> densityGMl;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.aliases = const Value.absent(),
    this.category = const Value.absent(),
    this.kcal100g = const Value.absent(),
    this.protein100g = const Value.absent(),
    this.carbs100g = const Value.absent(),
    this.fat100g = const Value.absent(),
    this.fibre100g = const Value.absent(),
    this.sugar100g = const Value.absent(),
    this.sodiumMg100g = const Value.absent(),
    this.densityGMl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodsCompanion.insert({
    required String id,
    required String name,
    this.aliases = const Value.absent(),
    this.category = const Value.absent(),
    this.kcal100g = const Value.absent(),
    this.protein100g = const Value.absent(),
    this.carbs100g = const Value.absent(),
    this.fat100g = const Value.absent(),
    this.fibre100g = const Value.absent(),
    this.sugar100g = const Value.absent(),
    this.sodiumMg100g = const Value.absent(),
    this.densityGMl = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<FoodRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? aliases,
    Expression<String>? category,
    Expression<double>? kcal100g,
    Expression<double>? protein100g,
    Expression<double>? carbs100g,
    Expression<double>? fat100g,
    Expression<double>? fibre100g,
    Expression<double>? sugar100g,
    Expression<double>? sodiumMg100g,
    Expression<double>? densityGMl,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (aliases != null) 'aliases': aliases,
      if (category != null) 'category': category,
      if (kcal100g != null) 'kcal100g': kcal100g,
      if (protein100g != null) 'protein100g': protein100g,
      if (carbs100g != null) 'carbs100g': carbs100g,
      if (fat100g != null) 'fat100g': fat100g,
      if (fibre100g != null) 'fibre100g': fibre100g,
      if (sugar100g != null) 'sugar100g': sugar100g,
      if (sodiumMg100g != null) 'sodium_mg100g': sodiumMg100g,
      if (densityGMl != null) 'density_g_ml': densityGMl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<List<String>>? aliases,
    Value<String?>? category,
    Value<double>? kcal100g,
    Value<double>? protein100g,
    Value<double>? carbs100g,
    Value<double>? fat100g,
    Value<double>? fibre100g,
    Value<double?>? sugar100g,
    Value<double?>? sodiumMg100g,
    Value<double?>? densityGMl,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      aliases: aliases ?? this.aliases,
      category: category ?? this.category,
      kcal100g: kcal100g ?? this.kcal100g,
      protein100g: protein100g ?? this.protein100g,
      carbs100g: carbs100g ?? this.carbs100g,
      fat100g: fat100g ?? this.fat100g,
      fibre100g: fibre100g ?? this.fibre100g,
      sugar100g: sugar100g ?? this.sugar100g,
      sodiumMg100g: sodiumMg100g ?? this.sodiumMg100g,
      densityGMl: densityGMl ?? this.densityGMl,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (aliases.present) {
      map['aliases'] = Variable<String>(
        $FoodsTable.$converteraliases.toSql(aliases.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (kcal100g.present) {
      map['kcal100g'] = Variable<double>(kcal100g.value);
    }
    if (protein100g.present) {
      map['protein100g'] = Variable<double>(protein100g.value);
    }
    if (carbs100g.present) {
      map['carbs100g'] = Variable<double>(carbs100g.value);
    }
    if (fat100g.present) {
      map['fat100g'] = Variable<double>(fat100g.value);
    }
    if (fibre100g.present) {
      map['fibre100g'] = Variable<double>(fibre100g.value);
    }
    if (sugar100g.present) {
      map['sugar100g'] = Variable<double>(sugar100g.value);
    }
    if (sodiumMg100g.present) {
      map['sodium_mg100g'] = Variable<double>(sodiumMg100g.value);
    }
    if (densityGMl.present) {
      map['density_g_ml'] = Variable<double>(densityGMl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('aliases: $aliases, ')
          ..write('category: $category, ')
          ..write('kcal100g: $kcal100g, ')
          ..write('protein100g: $protein100g, ')
          ..write('carbs100g: $carbs100g, ')
          ..write('fat100g: $fat100g, ')
          ..write('fibre100g: $fibre100g, ')
          ..write('sugar100g: $sugar100g, ')
          ..write('sodiumMg100g: $sodiumMg100g, ')
          ..write('densityGMl: $densityGMl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodPortionsTable extends FoodPortions
    with TableInfo<$FoodPortionsTable, FoodPortionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodPortionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    foodId,
    label,
    grams,
    isDefault,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_portions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodPortionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {foodId, label};
  @override
  FoodPortionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodPortionRow(
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FoodPortionsTable createAlias(String alias) {
    return $FoodPortionsTable(attachedDatabase, alias);
  }
}

class FoodPortionRow extends DataClass implements Insertable<FoodPortionRow> {
  final String foodId;
  final String label;
  final double grams;
  final bool isDefault;
  final DateTime updatedAt;
  const FoodPortionRow({
    required this.foodId,
    required this.label,
    required this.grams,
    required this.isDefault,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['food_id'] = Variable<String>(foodId);
    map['label'] = Variable<String>(label);
    map['grams'] = Variable<double>(grams);
    map['is_default'] = Variable<bool>(isDefault);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FoodPortionsCompanion toCompanion(bool nullToAbsent) {
    return FoodPortionsCompanion(
      foodId: Value(foodId),
      label: Value(label),
      grams: Value(grams),
      isDefault: Value(isDefault),
      updatedAt: Value(updatedAt),
    );
  }

  factory FoodPortionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodPortionRow(
      foodId: serializer.fromJson<String>(json['foodId']),
      label: serializer.fromJson<String>(json['label']),
      grams: serializer.fromJson<double>(json['grams']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'foodId': serializer.toJson<String>(foodId),
      'label': serializer.toJson<String>(label),
      'grams': serializer.toJson<double>(grams),
      'isDefault': serializer.toJson<bool>(isDefault),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FoodPortionRow copyWith({
    String? foodId,
    String? label,
    double? grams,
    bool? isDefault,
    DateTime? updatedAt,
  }) => FoodPortionRow(
    foodId: foodId ?? this.foodId,
    label: label ?? this.label,
    grams: grams ?? this.grams,
    isDefault: isDefault ?? this.isDefault,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FoodPortionRow copyWithCompanion(FoodPortionsCompanion data) {
    return FoodPortionRow(
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      label: data.label.present ? data.label.value : this.label,
      grams: data.grams.present ? data.grams.value : this.grams,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodPortionRow(')
          ..write('foodId: $foodId, ')
          ..write('label: $label, ')
          ..write('grams: $grams, ')
          ..write('isDefault: $isDefault, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(foodId, label, grams, isDefault, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodPortionRow &&
          other.foodId == this.foodId &&
          other.label == this.label &&
          other.grams == this.grams &&
          other.isDefault == this.isDefault &&
          other.updatedAt == this.updatedAt);
}

class FoodPortionsCompanion extends UpdateCompanion<FoodPortionRow> {
  final Value<String> foodId;
  final Value<String> label;
  final Value<double> grams;
  final Value<bool> isDefault;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FoodPortionsCompanion({
    this.foodId = const Value.absent(),
    this.label = const Value.absent(),
    this.grams = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodPortionsCompanion.insert({
    required String foodId,
    required String label,
    required double grams,
    this.isDefault = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : foodId = Value(foodId),
       label = Value(label),
       grams = Value(grams),
       updatedAt = Value(updatedAt);
  static Insertable<FoodPortionRow> custom({
    Expression<String>? foodId,
    Expression<String>? label,
    Expression<double>? grams,
    Expression<bool>? isDefault,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (foodId != null) 'food_id': foodId,
      if (label != null) 'label': label,
      if (grams != null) 'grams': grams,
      if (isDefault != null) 'is_default': isDefault,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodPortionsCompanion copyWith({
    Value<String>? foodId,
    Value<String>? label,
    Value<double>? grams,
    Value<bool>? isDefault,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FoodPortionsCompanion(
      foodId: foodId ?? this.foodId,
      label: label ?? this.label,
      grams: grams ?? this.grams,
      isDefault: isDefault ?? this.isDefault,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodPortionsCompanion(')
          ..write('foodId: $foodId, ')
          ..write('label: $label, ')
          ..write('grams: $grams, ')
          ..write('isDefault: $isDefault, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UnitSystem, String> units =
      GeneratedColumn<String>(
        'units',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UnitSystem>($ProfilesTable.$converterunits);
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ZAR'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecipeVisibility, String>
  defaultVisibility = GeneratedColumn<String>(
    'default_visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RecipeVisibility>($ProfilesTable.$converterdefaultVisibility);
  static const VerificationMeta _keepScreenOnMeta = const VerificationMeta(
    'keepScreenOn',
  );
  @override
  late final GeneratedColumn<bool> keepScreenOn = GeneratedColumn<bool>(
    'keep_screen_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("keep_screen_on" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifySavesMeta = const VerificationMeta(
    'notifySaves',
  );
  @override
  late final GeneratedColumn<bool> notifySaves = GeneratedColumn<bool>(
    'notify_saves',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_saves" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyCooksMeta = const VerificationMeta(
    'notifyCooks',
  );
  @override
  late final GeneratedColumn<bool> notifyCooks = GeneratedColumn<bool>(
    'notify_cooks',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_cooks" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyFriendsMeta = const VerificationMeta(
    'notifyFriends',
  );
  @override
  late final GeneratedColumn<bool> notifyFriends = GeneratedColumn<bool>(
    'notify_friends',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_friends" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _weeklyRoundupMeta = const VerificationMeta(
    'weeklyRoundup',
  );
  @override
  late final GeneratedColumn<bool> weeklyRoundup = GeneratedColumn<bool>(
    'weekly_roundup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weekly_roundup" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardedAtMeta = const VerificationMeta(
    'onboardedAt',
  );
  @override
  late final GeneratedColumn<DateTime> onboardedAt = GeneratedColumn<DateTime>(
    'onboarded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    displayName,
    avatarPath,
    bio,
    city,
    units,
    currency,
    defaultVisibility,
    keepScreenOn,
    notifySaves,
    notifyCooks,
    notifyFriends,
    weeklyRoundup,
    onboardedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('keep_screen_on')) {
      context.handle(
        _keepScreenOnMeta,
        keepScreenOn.isAcceptableOrUnknown(
          data['keep_screen_on']!,
          _keepScreenOnMeta,
        ),
      );
    }
    if (data.containsKey('notify_saves')) {
      context.handle(
        _notifySavesMeta,
        notifySaves.isAcceptableOrUnknown(
          data['notify_saves']!,
          _notifySavesMeta,
        ),
      );
    }
    if (data.containsKey('notify_cooks')) {
      context.handle(
        _notifyCooksMeta,
        notifyCooks.isAcceptableOrUnknown(
          data['notify_cooks']!,
          _notifyCooksMeta,
        ),
      );
    }
    if (data.containsKey('notify_friends')) {
      context.handle(
        _notifyFriendsMeta,
        notifyFriends.isAcceptableOrUnknown(
          data['notify_friends']!,
          _notifyFriendsMeta,
        ),
      );
    }
    if (data.containsKey('weekly_roundup')) {
      context.handle(
        _weeklyRoundupMeta,
        weeklyRoundup.isAcceptableOrUnknown(
          data['weekly_roundup']!,
          _weeklyRoundupMeta,
        ),
      );
    }
    if (data.containsKey('onboarded_at')) {
      context.handle(
        _onboardedAtMeta,
        onboardedAt.isAcceptableOrUnknown(
          data['onboarded_at']!,
          _onboardedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      units: $ProfilesTable.$converterunits.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}units'],
        )!,
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      defaultVisibility: $ProfilesTable.$converterdefaultVisibility.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_visibility'],
        )!,
      ),
      keepScreenOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}keep_screen_on'],
      )!,
      notifySaves: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_saves'],
      )!,
      notifyCooks: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_cooks'],
      )!,
      notifyFriends: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_friends'],
      )!,
      weeklyRoundup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weekly_roundup'],
      )!,
      onboardedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}onboarded_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UnitSystem, String, String> $converterunits =
      const EnumNameConverter<UnitSystem>(UnitSystem.values);
  static JsonTypeConverter2<RecipeVisibility, String, String>
  $converterdefaultVisibility = const EnumNameConverter<RecipeVisibility>(
    RecipeVisibility.values,
  );
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final String username;
  final String displayName;
  final String? avatarPath;
  final String? bio;
  final String? city;
  final UnitSystem units;
  final String currency;
  final RecipeVisibility defaultVisibility;
  final bool keepScreenOn;
  final bool notifySaves;
  final bool notifyCooks;
  final bool notifyFriends;
  final bool weeklyRoundup;
  final DateTime? onboardedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProfileRow({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarPath,
    this.bio,
    this.city,
    required this.units,
    required this.currency,
    required this.defaultVisibility,
    required this.keepScreenOn,
    required this.notifySaves,
    required this.notifyCooks,
    required this.notifyFriends,
    required this.weeklyRoundup,
    this.onboardedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    {
      map['units'] = Variable<String>(
        $ProfilesTable.$converterunits.toSql(units),
      );
    }
    map['currency'] = Variable<String>(currency);
    {
      map['default_visibility'] = Variable<String>(
        $ProfilesTable.$converterdefaultVisibility.toSql(defaultVisibility),
      );
    }
    map['keep_screen_on'] = Variable<bool>(keepScreenOn);
    map['notify_saves'] = Variable<bool>(notifySaves);
    map['notify_cooks'] = Variable<bool>(notifyCooks);
    map['notify_friends'] = Variable<bool>(notifyFriends);
    map['weekly_roundup'] = Variable<bool>(weeklyRoundup);
    if (!nullToAbsent || onboardedAt != null) {
      map['onboarded_at'] = Variable<DateTime>(onboardedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      username: Value(username),
      displayName: Value(displayName),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      units: Value(units),
      currency: Value(currency),
      defaultVisibility: Value(defaultVisibility),
      keepScreenOn: Value(keepScreenOn),
      notifySaves: Value(notifySaves),
      notifyCooks: Value(notifyCooks),
      notifyFriends: Value(notifyFriends),
      weeklyRoundup: Value(weeklyRoundup),
      onboardedAt: onboardedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      bio: serializer.fromJson<String?>(json['bio']),
      city: serializer.fromJson<String?>(json['city']),
      units: $ProfilesTable.$converterunits.fromJson(
        serializer.fromJson<String>(json['units']),
      ),
      currency: serializer.fromJson<String>(json['currency']),
      defaultVisibility: $ProfilesTable.$converterdefaultVisibility.fromJson(
        serializer.fromJson<String>(json['defaultVisibility']),
      ),
      keepScreenOn: serializer.fromJson<bool>(json['keepScreenOn']),
      notifySaves: serializer.fromJson<bool>(json['notifySaves']),
      notifyCooks: serializer.fromJson<bool>(json['notifyCooks']),
      notifyFriends: serializer.fromJson<bool>(json['notifyFriends']),
      weeklyRoundup: serializer.fromJson<bool>(json['weeklyRoundup']),
      onboardedAt: serializer.fromJson<DateTime?>(json['onboardedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'bio': serializer.toJson<String?>(bio),
      'city': serializer.toJson<String?>(city),
      'units': serializer.toJson<String>(
        $ProfilesTable.$converterunits.toJson(units),
      ),
      'currency': serializer.toJson<String>(currency),
      'defaultVisibility': serializer.toJson<String>(
        $ProfilesTable.$converterdefaultVisibility.toJson(defaultVisibility),
      ),
      'keepScreenOn': serializer.toJson<bool>(keepScreenOn),
      'notifySaves': serializer.toJson<bool>(notifySaves),
      'notifyCooks': serializer.toJson<bool>(notifyCooks),
      'notifyFriends': serializer.toJson<bool>(notifyFriends),
      'weeklyRoundup': serializer.toJson<bool>(weeklyRoundup),
      'onboardedAt': serializer.toJson<DateTime?>(onboardedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? username,
    String? displayName,
    Value<String?> avatarPath = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<String?> city = const Value.absent(),
    UnitSystem? units,
    String? currency,
    RecipeVisibility? defaultVisibility,
    bool? keepScreenOn,
    bool? notifySaves,
    bool? notifyCooks,
    bool? notifyFriends,
    bool? weeklyRoundup,
    Value<DateTime?> onboardedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    username: username ?? this.username,
    displayName: displayName ?? this.displayName,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    bio: bio.present ? bio.value : this.bio,
    city: city.present ? city.value : this.city,
    units: units ?? this.units,
    currency: currency ?? this.currency,
    defaultVisibility: defaultVisibility ?? this.defaultVisibility,
    keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    notifySaves: notifySaves ?? this.notifySaves,
    notifyCooks: notifyCooks ?? this.notifyCooks,
    notifyFriends: notifyFriends ?? this.notifyFriends,
    weeklyRoundup: weeklyRoundup ?? this.weeklyRoundup,
    onboardedAt: onboardedAt.present ? onboardedAt.value : this.onboardedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      bio: data.bio.present ? data.bio.value : this.bio,
      city: data.city.present ? data.city.value : this.city,
      units: data.units.present ? data.units.value : this.units,
      currency: data.currency.present ? data.currency.value : this.currency,
      defaultVisibility: data.defaultVisibility.present
          ? data.defaultVisibility.value
          : this.defaultVisibility,
      keepScreenOn: data.keepScreenOn.present
          ? data.keepScreenOn.value
          : this.keepScreenOn,
      notifySaves: data.notifySaves.present
          ? data.notifySaves.value
          : this.notifySaves,
      notifyCooks: data.notifyCooks.present
          ? data.notifyCooks.value
          : this.notifyCooks,
      notifyFriends: data.notifyFriends.present
          ? data.notifyFriends.value
          : this.notifyFriends,
      weeklyRoundup: data.weeklyRoundup.present
          ? data.weeklyRoundup.value
          : this.weeklyRoundup,
      onboardedAt: data.onboardedAt.present
          ? data.onboardedAt.value
          : this.onboardedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('bio: $bio, ')
          ..write('city: $city, ')
          ..write('units: $units, ')
          ..write('currency: $currency, ')
          ..write('defaultVisibility: $defaultVisibility, ')
          ..write('keepScreenOn: $keepScreenOn, ')
          ..write('notifySaves: $notifySaves, ')
          ..write('notifyCooks: $notifyCooks, ')
          ..write('notifyFriends: $notifyFriends, ')
          ..write('weeklyRoundup: $weeklyRoundup, ')
          ..write('onboardedAt: $onboardedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    displayName,
    avatarPath,
    bio,
    city,
    units,
    currency,
    defaultVisibility,
    keepScreenOn,
    notifySaves,
    notifyCooks,
    notifyFriends,
    weeklyRoundup,
    onboardedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.avatarPath == this.avatarPath &&
          other.bio == this.bio &&
          other.city == this.city &&
          other.units == this.units &&
          other.currency == this.currency &&
          other.defaultVisibility == this.defaultVisibility &&
          other.keepScreenOn == this.keepScreenOn &&
          other.notifySaves == this.notifySaves &&
          other.notifyCooks == this.notifyCooks &&
          other.notifyFriends == this.notifyFriends &&
          other.weeklyRoundup == this.weeklyRoundup &&
          other.onboardedAt == this.onboardedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String?> avatarPath;
  final Value<String?> bio;
  final Value<String?> city;
  final Value<UnitSystem> units;
  final Value<String> currency;
  final Value<RecipeVisibility> defaultVisibility;
  final Value<bool> keepScreenOn;
  final Value<bool> notifySaves;
  final Value<bool> notifyCooks;
  final Value<bool> notifyFriends;
  final Value<bool> weeklyRoundup;
  final Value<DateTime?> onboardedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.bio = const Value.absent(),
    this.city = const Value.absent(),
    this.units = const Value.absent(),
    this.currency = const Value.absent(),
    this.defaultVisibility = const Value.absent(),
    this.keepScreenOn = const Value.absent(),
    this.notifySaves = const Value.absent(),
    this.notifyCooks = const Value.absent(),
    this.notifyFriends = const Value.absent(),
    this.weeklyRoundup = const Value.absent(),
    this.onboardedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String username,
    required String displayName,
    this.avatarPath = const Value.absent(),
    this.bio = const Value.absent(),
    this.city = const Value.absent(),
    required UnitSystem units,
    this.currency = const Value.absent(),
    required RecipeVisibility defaultVisibility,
    this.keepScreenOn = const Value.absent(),
    this.notifySaves = const Value.absent(),
    this.notifyCooks = const Value.absent(),
    this.notifyFriends = const Value.absent(),
    this.weeklyRoundup = const Value.absent(),
    this.onboardedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       username = Value(username),
       displayName = Value(displayName),
       units = Value(units),
       defaultVisibility = Value(defaultVisibility),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? avatarPath,
    Expression<String>? bio,
    Expression<String>? city,
    Expression<String>? units,
    Expression<String>? currency,
    Expression<String>? defaultVisibility,
    Expression<bool>? keepScreenOn,
    Expression<bool>? notifySaves,
    Expression<bool>? notifyCooks,
    Expression<bool>? notifyFriends,
    Expression<bool>? weeklyRoundup,
    Expression<DateTime>? onboardedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (bio != null) 'bio': bio,
      if (city != null) 'city': city,
      if (units != null) 'units': units,
      if (currency != null) 'currency': currency,
      if (defaultVisibility != null) 'default_visibility': defaultVisibility,
      if (keepScreenOn != null) 'keep_screen_on': keepScreenOn,
      if (notifySaves != null) 'notify_saves': notifySaves,
      if (notifyCooks != null) 'notify_cooks': notifyCooks,
      if (notifyFriends != null) 'notify_friends': notifyFriends,
      if (weeklyRoundup != null) 'weekly_roundup': weeklyRoundup,
      if (onboardedAt != null) 'onboarded_at': onboardedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String>? displayName,
    Value<String?>? avatarPath,
    Value<String?>? bio,
    Value<String?>? city,
    Value<UnitSystem>? units,
    Value<String>? currency,
    Value<RecipeVisibility>? defaultVisibility,
    Value<bool>? keepScreenOn,
    Value<bool>? notifySaves,
    Value<bool>? notifyCooks,
    Value<bool>? notifyFriends,
    Value<bool>? weeklyRoundup,
    Value<DateTime?>? onboardedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarPath: avatarPath ?? this.avatarPath,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      units: units ?? this.units,
      currency: currency ?? this.currency,
      defaultVisibility: defaultVisibility ?? this.defaultVisibility,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      notifySaves: notifySaves ?? this.notifySaves,
      notifyCooks: notifyCooks ?? this.notifyCooks,
      notifyFriends: notifyFriends ?? this.notifyFriends,
      weeklyRoundup: weeklyRoundup ?? this.weeklyRoundup,
      onboardedAt: onboardedAt ?? this.onboardedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (units.present) {
      map['units'] = Variable<String>(
        $ProfilesTable.$converterunits.toSql(units.value),
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (defaultVisibility.present) {
      map['default_visibility'] = Variable<String>(
        $ProfilesTable.$converterdefaultVisibility.toSql(
          defaultVisibility.value,
        ),
      );
    }
    if (keepScreenOn.present) {
      map['keep_screen_on'] = Variable<bool>(keepScreenOn.value);
    }
    if (notifySaves.present) {
      map['notify_saves'] = Variable<bool>(notifySaves.value);
    }
    if (notifyCooks.present) {
      map['notify_cooks'] = Variable<bool>(notifyCooks.value);
    }
    if (notifyFriends.present) {
      map['notify_friends'] = Variable<bool>(notifyFriends.value);
    }
    if (weeklyRoundup.present) {
      map['weekly_roundup'] = Variable<bool>(weeklyRoundup.value);
    }
    if (onboardedAt.present) {
      map['onboarded_at'] = Variable<DateTime>(onboardedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('bio: $bio, ')
          ..write('city: $city, ')
          ..write('units: $units, ')
          ..write('currency: $currency, ')
          ..write('defaultVisibility: $defaultVisibility, ')
          ..write('keepScreenOn: $keepScreenOn, ')
          ..write('notifySaves: $notifySaves, ')
          ..write('notifyCooks: $notifyCooks, ')
          ..write('notifyFriends: $notifyFriends, ')
          ..write('weeklyRoundup: $weeklyRoundup, ')
          ..write('onboardedAt: $onboardedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfileTastesTable extends ProfileTastes
    with TableInfo<$ProfileTastesTable, ProfileTasteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileTastesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_tastes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileTasteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, tagId};
  @override
  ProfileTasteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileTasteRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $ProfileTastesTable createAlias(String alias) {
    return $ProfileTastesTable(attachedDatabase, alias);
  }
}

class ProfileTasteRow extends DataClass implements Insertable<ProfileTasteRow> {
  final String userId;
  final int tagId;
  const ProfileTasteRow({required this.userId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  ProfileTastesCompanion toCompanion(bool nullToAbsent) {
    return ProfileTastesCompanion(userId: Value(userId), tagId: Value(tagId));
  }

  factory ProfileTasteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileTasteRow(
      userId: serializer.fromJson<String>(json['userId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  ProfileTasteRow copyWith({String? userId, int? tagId}) => ProfileTasteRow(
    userId: userId ?? this.userId,
    tagId: tagId ?? this.tagId,
  );
  ProfileTasteRow copyWithCompanion(ProfileTastesCompanion data) {
    return ProfileTasteRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileTasteRow(')
          ..write('userId: $userId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileTasteRow &&
          other.userId == this.userId &&
          other.tagId == this.tagId);
}

class ProfileTastesCompanion extends UpdateCompanion<ProfileTasteRow> {
  final Value<String> userId;
  final Value<int> tagId;
  final Value<int> rowid;
  const ProfileTastesCompanion({
    this.userId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileTastesCompanion.insert({
    required String userId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       tagId = Value(tagId);
  static Insertable<ProfileTasteRow> custom({
    Expression<String>? userId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileTastesCompanion copyWith({
    Value<String>? userId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return ProfileTastesCompanion(
      userId: userId ?? this.userId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileTastesCompanion(')
          ..write('userId: $userId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _forkedFromIdMeta = const VerificationMeta(
    'forkedFromId',
  );
  @override
  late final GeneratedColumn<String> forkedFromId = GeneratedColumn<String>(
    'forked_from_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localCoverPathMeta = const VerificationMeta(
    'localCoverPath',
  );
  @override
  late final GeneratedColumn<String> localCoverPath = GeneratedColumn<String>(
    'local_cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CoverStyle, String> coverStyle =
      GeneratedColumn<String>(
        'cover_style',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CoverStyle>($RecipesTable.$convertercoverStyle);
  static const VerificationMeta _baseServingsMeta = const VerificationMeta(
    'baseServings',
  );
  @override
  late final GeneratedColumn<int> baseServings = GeneratedColumn<int>(
    'base_servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecipeVisibility, String>
  visibility = GeneratedColumn<String>(
    'visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RecipeVisibility>($RecipesTable.$convertervisibility);
  @override
  late final GeneratedColumnWithTypeConverter<RecipeStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecipeStatus>($RecipesTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<RecipeSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecipeSource>($RecipesTable.$convertersource);
  static const VerificationMeta _sourceTextMeta = const VerificationMeta(
    'sourceText',
  );
  @override
  late final GeneratedColumn<String> sourceText = GeneratedColumn<String>(
    'source_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kcalPerServingMeta = const VerificationMeta(
    'kcalPerServing',
  );
  @override
  late final GeneratedColumn<double> kcalPerServing = GeneratedColumn<double>(
    'kcal_per_serving',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fibreGMeta = const VerificationMeta('fibreG');
  @override
  late final GeneratedColumn<double> fibreG = GeneratedColumn<double>(
    'fibre_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ingredientCountMeta = const VerificationMeta(
    'ingredientCount',
  );
  @override
  late final GeneratedColumn<int> ingredientCount = GeneratedColumn<int>(
    'ingredient_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _matchedLinesMeta = const VerificationMeta(
    'matchedLines',
  );
  @override
  late final GeneratedColumn<int> matchedLines = GeneratedColumn<int>(
    'matched_lines',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _costCentsMeta = const VerificationMeta(
    'costCents',
  );
  @override
  late final GeneratedColumn<int> costCents = GeneratedColumn<int>(
    'cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCurrencyMeta = const VerificationMeta(
    'costCurrency',
  );
  @override
  late final GeneratedColumn<String> costCurrency = GeneratedColumn<String>(
    'cost_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ZAR'),
  );
  static const VerificationMeta _likeCountMeta = const VerificationMeta(
    'likeCount',
  );
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
    'like_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _saveCountMeta = const VerificationMeta(
    'saveCount',
  );
  @override
  late final GeneratedColumn<int> saveCount = GeneratedColumn<int>(
    'save_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cookCountMeta = const VerificationMeta(
    'cookCount',
  );
  @override
  late final GeneratedColumn<int> cookCount = GeneratedColumn<int>(
    'cook_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorAvatarMeta = const VerificationMeta(
    'authorAvatar',
  );
  @override
  late final GeneratedColumn<String> authorAvatar = GeneratedColumn<String>(
    'author_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorId,
    forkedFromId,
    title,
    note,
    coverPath,
    localCoverPath,
    coverStyle,
    baseServings,
    totalMinutes,
    visibility,
    status,
    source,
    sourceText,
    kcalPerServing,
    proteinG,
    carbsG,
    fatG,
    fibreG,
    ingredientCount,
    matchedLines,
    costCents,
    costCurrency,
    likeCount,
    saveCount,
    cookCount,
    authorName,
    authorUsername,
    authorAvatar,
    publishedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('forked_from_id')) {
      context.handle(
        _forkedFromIdMeta,
        forkedFromId.isAcceptableOrUnknown(
          data['forked_from_id']!,
          _forkedFromIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('local_cover_path')) {
      context.handle(
        _localCoverPathMeta,
        localCoverPath.isAcceptableOrUnknown(
          data['local_cover_path']!,
          _localCoverPathMeta,
        ),
      );
    }
    if (data.containsKey('base_servings')) {
      context.handle(
        _baseServingsMeta,
        baseServings.isAcceptableOrUnknown(
          data['base_servings']!,
          _baseServingsMeta,
        ),
      );
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('source_text')) {
      context.handle(
        _sourceTextMeta,
        sourceText.isAcceptableOrUnknown(data['source_text']!, _sourceTextMeta),
      );
    }
    if (data.containsKey('kcal_per_serving')) {
      context.handle(
        _kcalPerServingMeta,
        kcalPerServing.isAcceptableOrUnknown(
          data['kcal_per_serving']!,
          _kcalPerServingMeta,
        ),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('fibre_g')) {
      context.handle(
        _fibreGMeta,
        fibreG.isAcceptableOrUnknown(data['fibre_g']!, _fibreGMeta),
      );
    }
    if (data.containsKey('ingredient_count')) {
      context.handle(
        _ingredientCountMeta,
        ingredientCount.isAcceptableOrUnknown(
          data['ingredient_count']!,
          _ingredientCountMeta,
        ),
      );
    }
    if (data.containsKey('matched_lines')) {
      context.handle(
        _matchedLinesMeta,
        matchedLines.isAcceptableOrUnknown(
          data['matched_lines']!,
          _matchedLinesMeta,
        ),
      );
    }
    if (data.containsKey('cost_cents')) {
      context.handle(
        _costCentsMeta,
        costCents.isAcceptableOrUnknown(data['cost_cents']!, _costCentsMeta),
      );
    }
    if (data.containsKey('cost_currency')) {
      context.handle(
        _costCurrencyMeta,
        costCurrency.isAcceptableOrUnknown(
          data['cost_currency']!,
          _costCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('like_count')) {
      context.handle(
        _likeCountMeta,
        likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta),
      );
    }
    if (data.containsKey('save_count')) {
      context.handle(
        _saveCountMeta,
        saveCount.isAcceptableOrUnknown(data['save_count']!, _saveCountMeta),
      );
    }
    if (data.containsKey('cook_count')) {
      context.handle(
        _cookCountMeta,
        cookCount.isAcceptableOrUnknown(data['cook_count']!, _cookCountMeta),
      );
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
        _authorAvatarMeta,
        authorAvatar.isAcceptableOrUnknown(
          data['author_avatar']!,
          _authorAvatarMeta,
        ),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      forkedFromId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forked_from_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      localCoverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_cover_path'],
      ),
      coverStyle: $RecipesTable.$convertercoverStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cover_style'],
        )!,
      ),
      baseServings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_servings'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      ),
      visibility: $RecipesTable.$convertervisibility.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}visibility'],
        )!,
      ),
      status: $RecipesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      source: $RecipesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      sourceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text'],
      ),
      kcalPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal_per_serving'],
      ),
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      ),
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      ),
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      ),
      fibreG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre_g'],
      ),
      ingredientCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_count'],
      )!,
      matchedLines: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}matched_lines'],
      )!,
      costCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cents'],
      ),
      costCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost_currency'],
      )!,
      likeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}like_count'],
      )!,
      saveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}save_count'],
      )!,
      cookCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_count'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      ),
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      ),
      authorAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_avatar'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CoverStyle, String, String> $convertercoverStyle =
      const EnumNameConverter<CoverStyle>(CoverStyle.values);
  static JsonTypeConverter2<RecipeVisibility, String, String>
  $convertervisibility = const EnumNameConverter<RecipeVisibility>(
    RecipeVisibility.values,
  );
  static JsonTypeConverter2<RecipeStatus, String, String> $converterstatus =
      const EnumNameConverter<RecipeStatus>(RecipeStatus.values);
  static JsonTypeConverter2<RecipeSource, String, String> $convertersource =
      const EnumNameConverter<RecipeSource>(RecipeSource.values);
}

class RecipeRow extends DataClass implements Insertable<RecipeRow> {
  final String id;
  final String authorId;
  final String? forkedFromId;
  final String title;
  final String? note;
  final String? coverPath;
  final String? localCoverPath;
  final CoverStyle coverStyle;
  final int baseServings;
  final int? totalMinutes;
  final RecipeVisibility visibility;
  final RecipeStatus status;
  final RecipeSource source;
  final String? sourceText;
  final double? kcalPerServing;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final double? fibreG;
  final int ingredientCount;
  final int matchedLines;
  final int? costCents;
  final String costCurrency;
  final int likeCount;
  final int saveCount;
  final int cookCount;
  final String? authorName;
  final String? authorUsername;
  final String? authorAvatar;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const RecipeRow({
    required this.id,
    required this.authorId,
    this.forkedFromId,
    required this.title,
    this.note,
    this.coverPath,
    this.localCoverPath,
    required this.coverStyle,
    required this.baseServings,
    this.totalMinutes,
    required this.visibility,
    required this.status,
    required this.source,
    this.sourceText,
    this.kcalPerServing,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.fibreG,
    required this.ingredientCount,
    required this.matchedLines,
    this.costCents,
    required this.costCurrency,
    required this.likeCount,
    required this.saveCount,
    required this.cookCount,
    this.authorName,
    this.authorUsername,
    this.authorAvatar,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || forkedFromId != null) {
      map['forked_from_id'] = Variable<String>(forkedFromId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    if (!nullToAbsent || localCoverPath != null) {
      map['local_cover_path'] = Variable<String>(localCoverPath);
    }
    {
      map['cover_style'] = Variable<String>(
        $RecipesTable.$convertercoverStyle.toSql(coverStyle),
      );
    }
    map['base_servings'] = Variable<int>(baseServings);
    if (!nullToAbsent || totalMinutes != null) {
      map['total_minutes'] = Variable<int>(totalMinutes);
    }
    {
      map['visibility'] = Variable<String>(
        $RecipesTable.$convertervisibility.toSql(visibility),
      );
    }
    {
      map['status'] = Variable<String>(
        $RecipesTable.$converterstatus.toSql(status),
      );
    }
    {
      map['source'] = Variable<String>(
        $RecipesTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || sourceText != null) {
      map['source_text'] = Variable<String>(sourceText);
    }
    if (!nullToAbsent || kcalPerServing != null) {
      map['kcal_per_serving'] = Variable<double>(kcalPerServing);
    }
    if (!nullToAbsent || proteinG != null) {
      map['protein_g'] = Variable<double>(proteinG);
    }
    if (!nullToAbsent || carbsG != null) {
      map['carbs_g'] = Variable<double>(carbsG);
    }
    if (!nullToAbsent || fatG != null) {
      map['fat_g'] = Variable<double>(fatG);
    }
    if (!nullToAbsent || fibreG != null) {
      map['fibre_g'] = Variable<double>(fibreG);
    }
    map['ingredient_count'] = Variable<int>(ingredientCount);
    map['matched_lines'] = Variable<int>(matchedLines);
    if (!nullToAbsent || costCents != null) {
      map['cost_cents'] = Variable<int>(costCents);
    }
    map['cost_currency'] = Variable<String>(costCurrency);
    map['like_count'] = Variable<int>(likeCount);
    map['save_count'] = Variable<int>(saveCount);
    map['cook_count'] = Variable<int>(cookCount);
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    if (!nullToAbsent || authorUsername != null) {
      map['author_username'] = Variable<String>(authorUsername);
    }
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      authorId: Value(authorId),
      forkedFromId: forkedFromId == null && nullToAbsent
          ? const Value.absent()
          : Value(forkedFromId),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      localCoverPath: localCoverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localCoverPath),
      coverStyle: Value(coverStyle),
      baseServings: Value(baseServings),
      totalMinutes: totalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalMinutes),
      visibility: Value(visibility),
      status: Value(status),
      source: Value(source),
      sourceText: sourceText == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceText),
      kcalPerServing: kcalPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(kcalPerServing),
      proteinG: proteinG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinG),
      carbsG: carbsG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsG),
      fatG: fatG == null && nullToAbsent ? const Value.absent() : Value(fatG),
      fibreG: fibreG == null && nullToAbsent
          ? const Value.absent()
          : Value(fibreG),
      ingredientCount: Value(ingredientCount),
      matchedLines: Value(matchedLines),
      costCents: costCents == null && nullToAbsent
          ? const Value.absent()
          : Value(costCents),
      costCurrency: Value(costCurrency),
      likeCount: Value(likeCount),
      saveCount: Value(saveCount),
      cookCount: Value(cookCount),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      authorUsername: authorUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(authorUsername),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory RecipeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeRow(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String>(json['authorId']),
      forkedFromId: serializer.fromJson<String?>(json['forkedFromId']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      localCoverPath: serializer.fromJson<String?>(json['localCoverPath']),
      coverStyle: $RecipesTable.$convertercoverStyle.fromJson(
        serializer.fromJson<String>(json['coverStyle']),
      ),
      baseServings: serializer.fromJson<int>(json['baseServings']),
      totalMinutes: serializer.fromJson<int?>(json['totalMinutes']),
      visibility: $RecipesTable.$convertervisibility.fromJson(
        serializer.fromJson<String>(json['visibility']),
      ),
      status: $RecipesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      source: $RecipesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      sourceText: serializer.fromJson<String?>(json['sourceText']),
      kcalPerServing: serializer.fromJson<double?>(json['kcalPerServing']),
      proteinG: serializer.fromJson<double?>(json['proteinG']),
      carbsG: serializer.fromJson<double?>(json['carbsG']),
      fatG: serializer.fromJson<double?>(json['fatG']),
      fibreG: serializer.fromJson<double?>(json['fibreG']),
      ingredientCount: serializer.fromJson<int>(json['ingredientCount']),
      matchedLines: serializer.fromJson<int>(json['matchedLines']),
      costCents: serializer.fromJson<int?>(json['costCents']),
      costCurrency: serializer.fromJson<String>(json['costCurrency']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      saveCount: serializer.fromJson<int>(json['saveCount']),
      cookCount: serializer.fromJson<int>(json['cookCount']),
      authorName: serializer.fromJson<String?>(json['authorName']),
      authorUsername: serializer.fromJson<String?>(json['authorUsername']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String>(authorId),
      'forkedFromId': serializer.toJson<String?>(forkedFromId),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'coverPath': serializer.toJson<String?>(coverPath),
      'localCoverPath': serializer.toJson<String?>(localCoverPath),
      'coverStyle': serializer.toJson<String>(
        $RecipesTable.$convertercoverStyle.toJson(coverStyle),
      ),
      'baseServings': serializer.toJson<int>(baseServings),
      'totalMinutes': serializer.toJson<int?>(totalMinutes),
      'visibility': serializer.toJson<String>(
        $RecipesTable.$convertervisibility.toJson(visibility),
      ),
      'status': serializer.toJson<String>(
        $RecipesTable.$converterstatus.toJson(status),
      ),
      'source': serializer.toJson<String>(
        $RecipesTable.$convertersource.toJson(source),
      ),
      'sourceText': serializer.toJson<String?>(sourceText),
      'kcalPerServing': serializer.toJson<double?>(kcalPerServing),
      'proteinG': serializer.toJson<double?>(proteinG),
      'carbsG': serializer.toJson<double?>(carbsG),
      'fatG': serializer.toJson<double?>(fatG),
      'fibreG': serializer.toJson<double?>(fibreG),
      'ingredientCount': serializer.toJson<int>(ingredientCount),
      'matchedLines': serializer.toJson<int>(matchedLines),
      'costCents': serializer.toJson<int?>(costCents),
      'costCurrency': serializer.toJson<String>(costCurrency),
      'likeCount': serializer.toJson<int>(likeCount),
      'saveCount': serializer.toJson<int>(saveCount),
      'cookCount': serializer.toJson<int>(cookCount),
      'authorName': serializer.toJson<String?>(authorName),
      'authorUsername': serializer.toJson<String?>(authorUsername),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  RecipeRow copyWith({
    String? id,
    String? authorId,
    Value<String?> forkedFromId = const Value.absent(),
    String? title,
    Value<String?> note = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    Value<String?> localCoverPath = const Value.absent(),
    CoverStyle? coverStyle,
    int? baseServings,
    Value<int?> totalMinutes = const Value.absent(),
    RecipeVisibility? visibility,
    RecipeStatus? status,
    RecipeSource? source,
    Value<String?> sourceText = const Value.absent(),
    Value<double?> kcalPerServing = const Value.absent(),
    Value<double?> proteinG = const Value.absent(),
    Value<double?> carbsG = const Value.absent(),
    Value<double?> fatG = const Value.absent(),
    Value<double?> fibreG = const Value.absent(),
    int? ingredientCount,
    int? matchedLines,
    Value<int?> costCents = const Value.absent(),
    String? costCurrency,
    int? likeCount,
    int? saveCount,
    int? cookCount,
    Value<String?> authorName = const Value.absent(),
    Value<String?> authorUsername = const Value.absent(),
    Value<String?> authorAvatar = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => RecipeRow(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    forkedFromId: forkedFromId.present ? forkedFromId.value : this.forkedFromId,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    localCoverPath: localCoverPath.present
        ? localCoverPath.value
        : this.localCoverPath,
    coverStyle: coverStyle ?? this.coverStyle,
    baseServings: baseServings ?? this.baseServings,
    totalMinutes: totalMinutes.present ? totalMinutes.value : this.totalMinutes,
    visibility: visibility ?? this.visibility,
    status: status ?? this.status,
    source: source ?? this.source,
    sourceText: sourceText.present ? sourceText.value : this.sourceText,
    kcalPerServing: kcalPerServing.present
        ? kcalPerServing.value
        : this.kcalPerServing,
    proteinG: proteinG.present ? proteinG.value : this.proteinG,
    carbsG: carbsG.present ? carbsG.value : this.carbsG,
    fatG: fatG.present ? fatG.value : this.fatG,
    fibreG: fibreG.present ? fibreG.value : this.fibreG,
    ingredientCount: ingredientCount ?? this.ingredientCount,
    matchedLines: matchedLines ?? this.matchedLines,
    costCents: costCents.present ? costCents.value : this.costCents,
    costCurrency: costCurrency ?? this.costCurrency,
    likeCount: likeCount ?? this.likeCount,
    saveCount: saveCount ?? this.saveCount,
    cookCount: cookCount ?? this.cookCount,
    authorName: authorName.present ? authorName.value : this.authorName,
    authorUsername: authorUsername.present
        ? authorUsername.value
        : this.authorUsername,
    authorAvatar: authorAvatar.present ? authorAvatar.value : this.authorAvatar,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  RecipeRow copyWithCompanion(RecipesCompanion data) {
    return RecipeRow(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      forkedFromId: data.forkedFromId.present
          ? data.forkedFromId.value
          : this.forkedFromId,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      localCoverPath: data.localCoverPath.present
          ? data.localCoverPath.value
          : this.localCoverPath,
      coverStyle: data.coverStyle.present
          ? data.coverStyle.value
          : this.coverStyle,
      baseServings: data.baseServings.present
          ? data.baseServings.value
          : this.baseServings,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      visibility: data.visibility.present
          ? data.visibility.value
          : this.visibility,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      sourceText: data.sourceText.present
          ? data.sourceText.value
          : this.sourceText,
      kcalPerServing: data.kcalPerServing.present
          ? data.kcalPerServing.value
          : this.kcalPerServing,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      fibreG: data.fibreG.present ? data.fibreG.value : this.fibreG,
      ingredientCount: data.ingredientCount.present
          ? data.ingredientCount.value
          : this.ingredientCount,
      matchedLines: data.matchedLines.present
          ? data.matchedLines.value
          : this.matchedLines,
      costCents: data.costCents.present ? data.costCents.value : this.costCents,
      costCurrency: data.costCurrency.present
          ? data.costCurrency.value
          : this.costCurrency,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      saveCount: data.saveCount.present ? data.saveCount.value : this.saveCount,
      cookCount: data.cookCount.present ? data.cookCount.value : this.cookCount,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeRow(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('forkedFromId: $forkedFromId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('coverPath: $coverPath, ')
          ..write('localCoverPath: $localCoverPath, ')
          ..write('coverStyle: $coverStyle, ')
          ..write('baseServings: $baseServings, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('visibility: $visibility, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('sourceText: $sourceText, ')
          ..write('kcalPerServing: $kcalPerServing, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('ingredientCount: $ingredientCount, ')
          ..write('matchedLines: $matchedLines, ')
          ..write('costCents: $costCents, ')
          ..write('costCurrency: $costCurrency, ')
          ..write('likeCount: $likeCount, ')
          ..write('saveCount: $saveCount, ')
          ..write('cookCount: $cookCount, ')
          ..write('authorName: $authorName, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    authorId,
    forkedFromId,
    title,
    note,
    coverPath,
    localCoverPath,
    coverStyle,
    baseServings,
    totalMinutes,
    visibility,
    status,
    source,
    sourceText,
    kcalPerServing,
    proteinG,
    carbsG,
    fatG,
    fibreG,
    ingredientCount,
    matchedLines,
    costCents,
    costCurrency,
    likeCount,
    saveCount,
    cookCount,
    authorName,
    authorUsername,
    authorAvatar,
    publishedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeRow &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.forkedFromId == this.forkedFromId &&
          other.title == this.title &&
          other.note == this.note &&
          other.coverPath == this.coverPath &&
          other.localCoverPath == this.localCoverPath &&
          other.coverStyle == this.coverStyle &&
          other.baseServings == this.baseServings &&
          other.totalMinutes == this.totalMinutes &&
          other.visibility == this.visibility &&
          other.status == this.status &&
          other.source == this.source &&
          other.sourceText == this.sourceText &&
          other.kcalPerServing == this.kcalPerServing &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.fibreG == this.fibreG &&
          other.ingredientCount == this.ingredientCount &&
          other.matchedLines == this.matchedLines &&
          other.costCents == this.costCents &&
          other.costCurrency == this.costCurrency &&
          other.likeCount == this.likeCount &&
          other.saveCount == this.saveCount &&
          other.cookCount == this.cookCount &&
          other.authorName == this.authorName &&
          other.authorUsername == this.authorUsername &&
          other.authorAvatar == this.authorAvatar &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class RecipesCompanion extends UpdateCompanion<RecipeRow> {
  final Value<String> id;
  final Value<String> authorId;
  final Value<String?> forkedFromId;
  final Value<String> title;
  final Value<String?> note;
  final Value<String?> coverPath;
  final Value<String?> localCoverPath;
  final Value<CoverStyle> coverStyle;
  final Value<int> baseServings;
  final Value<int?> totalMinutes;
  final Value<RecipeVisibility> visibility;
  final Value<RecipeStatus> status;
  final Value<RecipeSource> source;
  final Value<String?> sourceText;
  final Value<double?> kcalPerServing;
  final Value<double?> proteinG;
  final Value<double?> carbsG;
  final Value<double?> fatG;
  final Value<double?> fibreG;
  final Value<int> ingredientCount;
  final Value<int> matchedLines;
  final Value<int?> costCents;
  final Value<String> costCurrency;
  final Value<int> likeCount;
  final Value<int> saveCount;
  final Value<int> cookCount;
  final Value<String?> authorName;
  final Value<String?> authorUsername;
  final Value<String?> authorAvatar;
  final Value<DateTime?> publishedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.forkedFromId = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.localCoverPath = const Value.absent(),
    this.coverStyle = const Value.absent(),
    this.baseServings = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.visibility = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceText = const Value.absent(),
    this.kcalPerServing = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.ingredientCount = const Value.absent(),
    this.matchedLines = const Value.absent(),
    this.costCents = const Value.absent(),
    this.costCurrency = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.saveCount = const Value.absent(),
    this.cookCount = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String authorId,
    this.forkedFromId = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.localCoverPath = const Value.absent(),
    required CoverStyle coverStyle,
    this.baseServings = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    required RecipeVisibility visibility,
    required RecipeStatus status,
    required RecipeSource source,
    this.sourceText = const Value.absent(),
    this.kcalPerServing = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.ingredientCount = const Value.absent(),
    this.matchedLines = const Value.absent(),
    this.costCents = const Value.absent(),
    this.costCurrency = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.saveCount = const Value.absent(),
    this.cookCount = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.publishedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorId = Value(authorId),
       coverStyle = Value(coverStyle),
       visibility = Value(visibility),
       status = Value(status),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecipeRow> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? forkedFromId,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? coverPath,
    Expression<String>? localCoverPath,
    Expression<String>? coverStyle,
    Expression<int>? baseServings,
    Expression<int>? totalMinutes,
    Expression<String>? visibility,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? sourceText,
    Expression<double>? kcalPerServing,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<double>? fibreG,
    Expression<int>? ingredientCount,
    Expression<int>? matchedLines,
    Expression<int>? costCents,
    Expression<String>? costCurrency,
    Expression<int>? likeCount,
    Expression<int>? saveCount,
    Expression<int>? cookCount,
    Expression<String>? authorName,
    Expression<String>? authorUsername,
    Expression<String>? authorAvatar,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (forkedFromId != null) 'forked_from_id': forkedFromId,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (coverPath != null) 'cover_path': coverPath,
      if (localCoverPath != null) 'local_cover_path': localCoverPath,
      if (coverStyle != null) 'cover_style': coverStyle,
      if (baseServings != null) 'base_servings': baseServings,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (visibility != null) 'visibility': visibility,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (sourceText != null) 'source_text': sourceText,
      if (kcalPerServing != null) 'kcal_per_serving': kcalPerServing,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (fibreG != null) 'fibre_g': fibreG,
      if (ingredientCount != null) 'ingredient_count': ingredientCount,
      if (matchedLines != null) 'matched_lines': matchedLines,
      if (costCents != null) 'cost_cents': costCents,
      if (costCurrency != null) 'cost_currency': costCurrency,
      if (likeCount != null) 'like_count': likeCount,
      if (saveCount != null) 'save_count': saveCount,
      if (cookCount != null) 'cook_count': cookCount,
      if (authorName != null) 'author_name': authorName,
      if (authorUsername != null) 'author_username': authorUsername,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? authorId,
    Value<String?>? forkedFromId,
    Value<String>? title,
    Value<String?>? note,
    Value<String?>? coverPath,
    Value<String?>? localCoverPath,
    Value<CoverStyle>? coverStyle,
    Value<int>? baseServings,
    Value<int?>? totalMinutes,
    Value<RecipeVisibility>? visibility,
    Value<RecipeStatus>? status,
    Value<RecipeSource>? source,
    Value<String?>? sourceText,
    Value<double?>? kcalPerServing,
    Value<double?>? proteinG,
    Value<double?>? carbsG,
    Value<double?>? fatG,
    Value<double?>? fibreG,
    Value<int>? ingredientCount,
    Value<int>? matchedLines,
    Value<int?>? costCents,
    Value<String>? costCurrency,
    Value<int>? likeCount,
    Value<int>? saveCount,
    Value<int>? cookCount,
    Value<String?>? authorName,
    Value<String?>? authorUsername,
    Value<String?>? authorAvatar,
    Value<DateTime?>? publishedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      forkedFromId: forkedFromId ?? this.forkedFromId,
      title: title ?? this.title,
      note: note ?? this.note,
      coverPath: coverPath ?? this.coverPath,
      localCoverPath: localCoverPath ?? this.localCoverPath,
      coverStyle: coverStyle ?? this.coverStyle,
      baseServings: baseServings ?? this.baseServings,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      source: source ?? this.source,
      sourceText: sourceText ?? this.sourceText,
      kcalPerServing: kcalPerServing ?? this.kcalPerServing,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      fibreG: fibreG ?? this.fibreG,
      ingredientCount: ingredientCount ?? this.ingredientCount,
      matchedLines: matchedLines ?? this.matchedLines,
      costCents: costCents ?? this.costCents,
      costCurrency: costCurrency ?? this.costCurrency,
      likeCount: likeCount ?? this.likeCount,
      saveCount: saveCount ?? this.saveCount,
      cookCount: cookCount ?? this.cookCount,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (forkedFromId.present) {
      map['forked_from_id'] = Variable<String>(forkedFromId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (localCoverPath.present) {
      map['local_cover_path'] = Variable<String>(localCoverPath.value);
    }
    if (coverStyle.present) {
      map['cover_style'] = Variable<String>(
        $RecipesTable.$convertercoverStyle.toSql(coverStyle.value),
      );
    }
    if (baseServings.present) {
      map['base_servings'] = Variable<int>(baseServings.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<String>(
        $RecipesTable.$convertervisibility.toSql(visibility.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $RecipesTable.$converterstatus.toSql(status.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $RecipesTable.$convertersource.toSql(source.value),
      );
    }
    if (sourceText.present) {
      map['source_text'] = Variable<String>(sourceText.value);
    }
    if (kcalPerServing.present) {
      map['kcal_per_serving'] = Variable<double>(kcalPerServing.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (fibreG.present) {
      map['fibre_g'] = Variable<double>(fibreG.value);
    }
    if (ingredientCount.present) {
      map['ingredient_count'] = Variable<int>(ingredientCount.value);
    }
    if (matchedLines.present) {
      map['matched_lines'] = Variable<int>(matchedLines.value);
    }
    if (costCents.present) {
      map['cost_cents'] = Variable<int>(costCents.value);
    }
    if (costCurrency.present) {
      map['cost_currency'] = Variable<String>(costCurrency.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (saveCount.present) {
      map['save_count'] = Variable<int>(saveCount.value);
    }
    if (cookCount.present) {
      map['cook_count'] = Variable<int>(cookCount.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('forkedFromId: $forkedFromId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('coverPath: $coverPath, ')
          ..write('localCoverPath: $localCoverPath, ')
          ..write('coverStyle: $coverStyle, ')
          ..write('baseServings: $baseServings, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('visibility: $visibility, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('sourceText: $sourceText, ')
          ..write('kcalPerServing: $kcalPerServing, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('ingredientCount: $ingredientCount, ')
          ..write('matchedLines: $matchedLines, ')
          ..write('costCents: $costCents, ')
          ..write('costCurrency: $costCurrency, ')
          ..write('likeCount: $likeCount, ')
          ..write('saveCount: $saveCount, ')
          ..write('cookCount: $cookCount, ')
          ..write('authorName: $authorName, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, IngredientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionMeta = const VerificationMeta(
    'section',
  );
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _portionLabelMeta = const VerificationMeta(
    'portionLabel',
  );
  @override
  late final GeneratedColumn<String> portionLabel = GeneratedColumn<String>(
    'portion_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prepNoteMeta = const VerificationMeta(
    'prepNote',
  );
  @override
  late final GeneratedColumn<String> prepNote = GeneratedColumn<String>(
    'prep_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCentsMeta = const VerificationMeta(
    'costCents',
  );
  @override
  late final GeneratedColumn<int> costCents = GeneratedColumn<int>(
    'cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _optionalMeta = const VerificationMeta(
    'optional',
  );
  @override
  late final GeneratedColumn<bool> optional = GeneratedColumn<bool>(
    'optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    position,
    section,
    rawText,
    quantity,
    unit,
    portionLabel,
    foodId,
    prepNote,
    grams,
    costCents,
    optional,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('section')) {
      context.handle(
        _sectionMeta,
        section.isAcceptableOrUnknown(data['section']!, _sectionMeta),
      );
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('portion_label')) {
      context.handle(
        _portionLabelMeta,
        portionLabel.isAcceptableOrUnknown(
          data['portion_label']!,
          _portionLabelMeta,
        ),
      );
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('prep_note')) {
      context.handle(
        _prepNoteMeta,
        prepNote.isAcceptableOrUnknown(data['prep_note']!, _prepNoteMeta),
      );
    }
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    }
    if (data.containsKey('cost_cents')) {
      context.handle(
        _costCentsMeta,
        costCents.isAcceptableOrUnknown(data['cost_cents']!, _costCentsMeta),
      );
    }
    if (data.containsKey('optional')) {
      context.handle(
        _optionalMeta,
        optional.isAcceptableOrUnknown(data['optional']!, _optionalMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      ),
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      portionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_label'],
      ),
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      prepNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prep_note'],
      ),
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      ),
      costCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cents'],
      ),
      optional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optional'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }
}

class IngredientRow extends DataClass implements Insertable<IngredientRow> {
  final String id;
  final String recipeId;
  final int position;
  final String? section;
  final String rawText;
  final double? quantity;
  final String? unit;
  final String? portionLabel;
  final String? foodId;
  final String? prepNote;
  final double? grams;
  final int? costCents;
  final bool optional;
  final DateTime updatedAt;
  const IngredientRow({
    required this.id,
    required this.recipeId,
    required this.position,
    this.section,
    required this.rawText,
    this.quantity,
    this.unit,
    this.portionLabel,
    this.foodId,
    this.prepNote,
    this.grams,
    this.costCents,
    required this.optional,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || section != null) {
      map['section'] = Variable<String>(section);
    }
    map['raw_text'] = Variable<String>(rawText);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || portionLabel != null) {
      map['portion_label'] = Variable<String>(portionLabel);
    }
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    if (!nullToAbsent || prepNote != null) {
      map['prep_note'] = Variable<String>(prepNote);
    }
    if (!nullToAbsent || grams != null) {
      map['grams'] = Variable<double>(grams);
    }
    if (!nullToAbsent || costCents != null) {
      map['cost_cents'] = Variable<int>(costCents);
    }
    map['optional'] = Variable<bool>(optional);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      section: section == null && nullToAbsent
          ? const Value.absent()
          : Value(section),
      rawText: Value(rawText),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      portionLabel: portionLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(portionLabel),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      prepNote: prepNote == null && nullToAbsent
          ? const Value.absent()
          : Value(prepNote),
      grams: grams == null && nullToAbsent
          ? const Value.absent()
          : Value(grams),
      costCents: costCents == null && nullToAbsent
          ? const Value.absent()
          : Value(costCents),
      optional: Value(optional),
      updatedAt: Value(updatedAt),
    );
  }

  factory IngredientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientRow(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      section: serializer.fromJson<String?>(json['section']),
      rawText: serializer.fromJson<String>(json['rawText']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      portionLabel: serializer.fromJson<String?>(json['portionLabel']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      prepNote: serializer.fromJson<String?>(json['prepNote']),
      grams: serializer.fromJson<double?>(json['grams']),
      costCents: serializer.fromJson<int?>(json['costCents']),
      optional: serializer.fromJson<bool>(json['optional']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'position': serializer.toJson<int>(position),
      'section': serializer.toJson<String?>(section),
      'rawText': serializer.toJson<String>(rawText),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'portionLabel': serializer.toJson<String?>(portionLabel),
      'foodId': serializer.toJson<String?>(foodId),
      'prepNote': serializer.toJson<String?>(prepNote),
      'grams': serializer.toJson<double?>(grams),
      'costCents': serializer.toJson<int?>(costCents),
      'optional': serializer.toJson<bool>(optional),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IngredientRow copyWith({
    String? id,
    String? recipeId,
    int? position,
    Value<String?> section = const Value.absent(),
    String? rawText,
    Value<double?> quantity = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> portionLabel = const Value.absent(),
    Value<String?> foodId = const Value.absent(),
    Value<String?> prepNote = const Value.absent(),
    Value<double?> grams = const Value.absent(),
    Value<int?> costCents = const Value.absent(),
    bool? optional,
    DateTime? updatedAt,
  }) => IngredientRow(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    position: position ?? this.position,
    section: section.present ? section.value : this.section,
    rawText: rawText ?? this.rawText,
    quantity: quantity.present ? quantity.value : this.quantity,
    unit: unit.present ? unit.value : this.unit,
    portionLabel: portionLabel.present ? portionLabel.value : this.portionLabel,
    foodId: foodId.present ? foodId.value : this.foodId,
    prepNote: prepNote.present ? prepNote.value : this.prepNote,
    grams: grams.present ? grams.value : this.grams,
    costCents: costCents.present ? costCents.value : this.costCents,
    optional: optional ?? this.optional,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IngredientRow copyWithCompanion(RecipeIngredientsCompanion data) {
    return IngredientRow(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      section: data.section.present ? data.section.value : this.section,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      portionLabel: data.portionLabel.present
          ? data.portionLabel.value
          : this.portionLabel,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      prepNote: data.prepNote.present ? data.prepNote.value : this.prepNote,
      grams: data.grams.present ? data.grams.value : this.grams,
      costCents: data.costCents.present ? data.costCents.value : this.costCents,
      optional: data.optional.present ? data.optional.value : this.optional,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientRow(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('section: $section, ')
          ..write('rawText: $rawText, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('portionLabel: $portionLabel, ')
          ..write('foodId: $foodId, ')
          ..write('prepNote: $prepNote, ')
          ..write('grams: $grams, ')
          ..write('costCents: $costCents, ')
          ..write('optional: $optional, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    position,
    section,
    rawText,
    quantity,
    unit,
    portionLabel,
    foodId,
    prepNote,
    grams,
    costCents,
    optional,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientRow &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.section == this.section &&
          other.rawText == this.rawText &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.portionLabel == this.portionLabel &&
          other.foodId == this.foodId &&
          other.prepNote == this.prepNote &&
          other.grams == this.grams &&
          other.costCents == this.costCents &&
          other.optional == this.optional &&
          other.updatedAt == this.updatedAt);
}

class RecipeIngredientsCompanion extends UpdateCompanion<IngredientRow> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<int> position;
  final Value<String?> section;
  final Value<String> rawText;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<String?> portionLabel;
  final Value<String?> foodId;
  final Value<String?> prepNote;
  final Value<double?> grams;
  final Value<int?> costCents;
  final Value<bool> optional;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.section = const Value.absent(),
    this.rawText = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.portionLabel = const Value.absent(),
    this.foodId = const Value.absent(),
    this.prepNote = const Value.absent(),
    this.grams = const Value.absent(),
    this.costCents = const Value.absent(),
    this.optional = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required String id,
    required String recipeId,
    required int position,
    this.section = const Value.absent(),
    required String rawText,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.portionLabel = const Value.absent(),
    this.foodId = const Value.absent(),
    this.prepNote = const Value.absent(),
    this.grams = const Value.absent(),
    this.costCents = const Value.absent(),
    this.optional = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       position = Value(position),
       rawText = Value(rawText),
       updatedAt = Value(updatedAt);
  static Insertable<IngredientRow> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<int>? position,
    Expression<String>? section,
    Expression<String>? rawText,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? portionLabel,
    Expression<String>? foodId,
    Expression<String>? prepNote,
    Expression<double>? grams,
    Expression<int>? costCents,
    Expression<bool>? optional,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (section != null) 'section': section,
      if (rawText != null) 'raw_text': rawText,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (portionLabel != null) 'portion_label': portionLabel,
      if (foodId != null) 'food_id': foodId,
      if (prepNote != null) 'prep_note': prepNote,
      if (grams != null) 'grams': grams,
      if (costCents != null) 'cost_cents': costCents,
      if (optional != null) 'optional': optional,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<int>? position,
    Value<String?>? section,
    Value<String>? rawText,
    Value<double?>? quantity,
    Value<String?>? unit,
    Value<String?>? portionLabel,
    Value<String?>? foodId,
    Value<String?>? prepNote,
    Value<double?>? grams,
    Value<int?>? costCents,
    Value<bool>? optional,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecipeIngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      section: section ?? this.section,
      rawText: rawText ?? this.rawText,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      portionLabel: portionLabel ?? this.portionLabel,
      foodId: foodId ?? this.foodId,
      prepNote: prepNote ?? this.prepNote,
      grams: grams ?? this.grams,
      costCents: costCents ?? this.costCents,
      optional: optional ?? this.optional,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (portionLabel.present) {
      map['portion_label'] = Variable<String>(portionLabel.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (prepNote.present) {
      map['prep_note'] = Variable<String>(prepNote.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (costCents.present) {
      map['cost_cents'] = Variable<int>(costCents.value);
    }
    if (optional.present) {
      map['optional'] = Variable<bool>(optional.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('section: $section, ')
          ..write('rawText: $rawText, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('portionLabel: $portionLabel, ')
          ..write('foodId: $foodId, ')
          ..write('prepNote: $prepNote, ')
          ..write('grams: $grams, ')
          ..write('costCents: $costCents, ')
          ..write('optional: $optional, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, StepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timerSecondsMeta = const VerificationMeta(
    'timerSeconds',
  );
  @override
  late final GeneratedColumn<int> timerSeconds = GeneratedColumn<int>(
    'timer_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    position,
    body,
    timerSeconds,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timer_seconds')) {
      context.handle(
        _timerSecondsMeta,
        timerSeconds.isAcceptableOrUnknown(
          data['timer_seconds']!,
          _timerSecondsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timerSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_seconds'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class StepRow extends DataClass implements Insertable<StepRow> {
  final String id;
  final String recipeId;
  final int position;
  final String body;
  final int? timerSeconds;
  final DateTime updatedAt;
  const StepRow({
    required this.id,
    required this.recipeId,
    required this.position,
    required this.body,
    this.timerSeconds,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['position'] = Variable<int>(position);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || timerSeconds != null) {
      map['timer_seconds'] = Variable<int>(timerSeconds);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      body: Value(body),
      timerSeconds: timerSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timerSeconds),
      updatedAt: Value(updatedAt),
    );
  }

  factory StepRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepRow(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      body: serializer.fromJson<String>(json['body']),
      timerSeconds: serializer.fromJson<int?>(json['timerSeconds']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'position': serializer.toJson<int>(position),
      'body': serializer.toJson<String>(body),
      'timerSeconds': serializer.toJson<int?>(timerSeconds),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StepRow copyWith({
    String? id,
    String? recipeId,
    int? position,
    String? body,
    Value<int?> timerSeconds = const Value.absent(),
    DateTime? updatedAt,
  }) => StepRow(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    position: position ?? this.position,
    body: body ?? this.body,
    timerSeconds: timerSeconds.present ? timerSeconds.value : this.timerSeconds,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StepRow copyWithCompanion(RecipeStepsCompanion data) {
    return StepRow(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      body: data.body.present ? data.body.value : this.body,
      timerSeconds: data.timerSeconds.present
          ? data.timerSeconds.value
          : this.timerSeconds,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepRow(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('body: $body, ')
          ..write('timerSeconds: $timerSeconds, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, position, body, timerSeconds, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepRow &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.body == this.body &&
          other.timerSeconds == this.timerSeconds &&
          other.updatedAt == this.updatedAt);
}

class RecipeStepsCompanion extends UpdateCompanion<StepRow> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<int> position;
  final Value<String> body;
  final Value<int?> timerSeconds;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.body = const Value.absent(),
    this.timerSeconds = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    required String id,
    required String recipeId,
    required int position,
    required String body,
    this.timerSeconds = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       position = Value(position),
       body = Value(body),
       updatedAt = Value(updatedAt);
  static Insertable<StepRow> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<int>? position,
    Expression<String>? body,
    Expression<int>? timerSeconds,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (body != null) 'body': body,
      if (timerSeconds != null) 'timer_seconds': timerSeconds,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeStepsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<int>? position,
    Value<String>? body,
    Value<int?>? timerSeconds,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      body: body ?? this.body,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timerSeconds.present) {
      map['timer_seconds'] = Variable<int>(timerSeconds.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('body: $body, ')
          ..write('timerSeconds: $timerSeconds, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StepIngredientsTable extends StepIngredients
    with TableInfo<$StepIngredientsTable, StepIngredientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stepIdMeta = const VerificationMeta('stepId');
  @override
  late final GeneratedColumn<String> stepId = GeneratedColumn<String>(
    'step_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [stepId, ingredientId, recipeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'step_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepIngredientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('step_id')) {
      context.handle(
        _stepIdMeta,
        stepId.isAcceptableOrUnknown(data['step_id']!, _stepIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stepIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stepId, ingredientId};
  @override
  StepIngredientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepIngredientRow(
      stepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
    );
  }

  @override
  $StepIngredientsTable createAlias(String alias) {
    return $StepIngredientsTable(attachedDatabase, alias);
  }
}

class StepIngredientRow extends DataClass
    implements Insertable<StepIngredientRow> {
  final String stepId;
  final String ingredientId;
  final String recipeId;
  const StepIngredientRow({
    required this.stepId,
    required this.ingredientId,
    required this.recipeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['step_id'] = Variable<String>(stepId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['recipe_id'] = Variable<String>(recipeId);
    return map;
  }

  StepIngredientsCompanion toCompanion(bool nullToAbsent) {
    return StepIngredientsCompanion(
      stepId: Value(stepId),
      ingredientId: Value(ingredientId),
      recipeId: Value(recipeId),
    );
  }

  factory StepIngredientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepIngredientRow(
      stepId: serializer.fromJson<String>(json['stepId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stepId': serializer.toJson<String>(stepId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'recipeId': serializer.toJson<String>(recipeId),
    };
  }

  StepIngredientRow copyWith({
    String? stepId,
    String? ingredientId,
    String? recipeId,
  }) => StepIngredientRow(
    stepId: stepId ?? this.stepId,
    ingredientId: ingredientId ?? this.ingredientId,
    recipeId: recipeId ?? this.recipeId,
  );
  StepIngredientRow copyWithCompanion(StepIngredientsCompanion data) {
    return StepIngredientRow(
      stepId: data.stepId.present ? data.stepId.value : this.stepId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepIngredientRow(')
          ..write('stepId: $stepId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stepId, ingredientId, recipeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepIngredientRow &&
          other.stepId == this.stepId &&
          other.ingredientId == this.ingredientId &&
          other.recipeId == this.recipeId);
}

class StepIngredientsCompanion extends UpdateCompanion<StepIngredientRow> {
  final Value<String> stepId;
  final Value<String> ingredientId;
  final Value<String> recipeId;
  final Value<int> rowid;
  const StepIngredientsCompanion({
    this.stepId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StepIngredientsCompanion.insert({
    required String stepId,
    required String ingredientId,
    required String recipeId,
    this.rowid = const Value.absent(),
  }) : stepId = Value(stepId),
       ingredientId = Value(ingredientId),
       recipeId = Value(recipeId);
  static Insertable<StepIngredientRow> custom({
    Expression<String>? stepId,
    Expression<String>? ingredientId,
    Expression<String>? recipeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stepId != null) 'step_id': stepId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StepIngredientsCompanion copyWith({
    Value<String>? stepId,
    Value<String>? ingredientId,
    Value<String>? recipeId,
    Value<int>? rowid,
  }) {
    return StepIngredientsCompanion(
      stepId: stepId ?? this.stepId,
      ingredientId: ingredientId ?? this.ingredientId,
      recipeId: recipeId ?? this.recipeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stepId.present) {
      map['step_id'] = Variable<String>(stepId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepIngredientsCompanion(')
          ..write('stepId: $stepId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('recipeId: $recipeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeTagsTable extends RecipeTags
    with TableInfo<$RecipeTagsTable, RecipeTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [recipeId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, tagId};
  @override
  RecipeTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeTagRow(
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $RecipeTagsTable createAlias(String alias) {
    return $RecipeTagsTable(attachedDatabase, alias);
  }
}

class RecipeTagRow extends DataClass implements Insertable<RecipeTagRow> {
  final String recipeId;
  final int tagId;
  const RecipeTagRow({required this.recipeId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<String>(recipeId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  RecipeTagsCompanion toCompanion(bool nullToAbsent) {
    return RecipeTagsCompanion(recipeId: Value(recipeId), tagId: Value(tagId));
  }

  factory RecipeTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeTagRow(
      recipeId: serializer.fromJson<String>(json['recipeId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<String>(recipeId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  RecipeTagRow copyWith({String? recipeId, int? tagId}) => RecipeTagRow(
    recipeId: recipeId ?? this.recipeId,
    tagId: tagId ?? this.tagId,
  );
  RecipeTagRow copyWithCompanion(RecipeTagsCompanion data) {
    return RecipeTagRow(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeTagRow(')
          ..write('recipeId: $recipeId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recipeId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeTagRow &&
          other.recipeId == this.recipeId &&
          other.tagId == this.tagId);
}

class RecipeTagsCompanion extends UpdateCompanion<RecipeTagRow> {
  final Value<String> recipeId;
  final Value<int> tagId;
  final Value<int> rowid;
  const RecipeTagsCompanion({
    this.recipeId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeTagsCompanion.insert({
    required String recipeId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : recipeId = Value(recipeId),
       tagId = Value(tagId);
  static Insertable<RecipeTagRow> custom({
    Expression<String>? recipeId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeTagsCompanion copyWith({
    Value<String>? recipeId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return RecipeTagsCompanion(
      recipeId: recipeId ?? this.recipeId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeTagsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LikesTable extends Likes with TableInfo<$LikesTable, LikeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LikesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
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
  List<GeneratedColumn> get $columns => [userId, recipeId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'likes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LikeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {userId, recipeId};
  @override
  LikeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LikeRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LikesTable createAlias(String alias) {
    return $LikesTable(attachedDatabase, alias);
  }
}

class LikeRow extends DataClass implements Insertable<LikeRow> {
  final String userId;
  final String recipeId;
  final DateTime createdAt;
  const LikeRow({
    required this.userId,
    required this.recipeId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LikesCompanion toCompanion(bool nullToAbsent) {
    return LikesCompanion(
      userId: Value(userId),
      recipeId: Value(recipeId),
      createdAt: Value(createdAt),
    );
  }

  factory LikeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LikeRow(
      userId: serializer.fromJson<String>(json['userId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'recipeId': serializer.toJson<String>(recipeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LikeRow copyWith({String? userId, String? recipeId, DateTime? createdAt}) =>
      LikeRow(
        userId: userId ?? this.userId,
        recipeId: recipeId ?? this.recipeId,
        createdAt: createdAt ?? this.createdAt,
      );
  LikeRow copyWithCompanion(LikesCompanion data) {
    return LikeRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LikeRow(')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, recipeId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LikeRow &&
          other.userId == this.userId &&
          other.recipeId == this.recipeId &&
          other.createdAt == this.createdAt);
}

class LikesCompanion extends UpdateCompanion<LikeRow> {
  final Value<String> userId;
  final Value<String> recipeId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LikesCompanion({
    this.userId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LikesCompanion.insert({
    required String userId,
    required String recipeId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       recipeId = Value(recipeId),
       createdAt = Value(createdAt);
  static Insertable<LikeRow> custom({
    Expression<String>? userId,
    Expression<String>? recipeId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LikesCompanion copyWith({
    Value<String>? userId,
    Value<String>? recipeId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LikesCompanion(
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
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
    return (StringBuffer('LikesCompanion(')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavesTable extends Saves with TableInfo<$SavesTable, SaveRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
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
  List<GeneratedColumn> get $columns => [userId, recipeId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saves';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaveRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {userId, recipeId};
  @override
  SaveRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaveRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavesTable createAlias(String alias) {
    return $SavesTable(attachedDatabase, alias);
  }
}

class SaveRow extends DataClass implements Insertable<SaveRow> {
  final String userId;
  final String recipeId;
  final DateTime createdAt;
  const SaveRow({
    required this.userId,
    required this.recipeId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavesCompanion toCompanion(bool nullToAbsent) {
    return SavesCompanion(
      userId: Value(userId),
      recipeId: Value(recipeId),
      createdAt: Value(createdAt),
    );
  }

  factory SaveRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaveRow(
      userId: serializer.fromJson<String>(json['userId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'recipeId': serializer.toJson<String>(recipeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SaveRow copyWith({String? userId, String? recipeId, DateTime? createdAt}) =>
      SaveRow(
        userId: userId ?? this.userId,
        recipeId: recipeId ?? this.recipeId,
        createdAt: createdAt ?? this.createdAt,
      );
  SaveRow copyWithCompanion(SavesCompanion data) {
    return SaveRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaveRow(')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, recipeId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaveRow &&
          other.userId == this.userId &&
          other.recipeId == this.recipeId &&
          other.createdAt == this.createdAt);
}

class SavesCompanion extends UpdateCompanion<SaveRow> {
  final Value<String> userId;
  final Value<String> recipeId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SavesCompanion({
    this.userId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavesCompanion.insert({
    required String userId,
    required String recipeId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       recipeId = Value(recipeId),
       createdAt = Value(createdAt);
  static Insertable<SaveRow> custom({
    Expression<String>? userId,
    Expression<String>? recipeId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavesCompanion copyWith({
    Value<String>? userId,
    Value<String>? recipeId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SavesCompanion(
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
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
    return (StringBuffer('SavesCompanion(')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CooksTable extends Cooks with TableInfo<$CooksTable, CookRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toldCreatorMeta = const VerificationMeta(
    'toldCreator',
  );
  @override
  late final GeneratedColumn<bool> toldCreator = GeneratedColumn<bool>(
    'told_creator',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("told_creator" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cookedAtMeta = const VerificationMeta(
    'cookedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cookedAt = GeneratedColumn<DateTime>(
    'cooked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recipeId,
    servings,
    toldCreator,
    cookedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CookRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('told_creator')) {
      context.handle(
        _toldCreatorMeta,
        toldCreator.isAcceptableOrUnknown(
          data['told_creator']!,
          _toldCreatorMeta,
        ),
      );
    }
    if (data.containsKey('cooked_at')) {
      context.handle(
        _cookedAtMeta,
        cookedAt.isAcceptableOrUnknown(data['cooked_at']!, _cookedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cookedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      ),
      toldCreator: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}told_creator'],
      )!,
      cookedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cooked_at'],
      )!,
    );
  }

  @override
  $CooksTable createAlias(String alias) {
    return $CooksTable(attachedDatabase, alias);
  }
}

class CookRow extends DataClass implements Insertable<CookRow> {
  final String id;
  final String userId;
  final String recipeId;
  final int? servings;
  final bool toldCreator;
  final DateTime cookedAt;
  const CookRow({
    required this.id,
    required this.userId,
    required this.recipeId,
    this.servings,
    required this.toldCreator,
    required this.cookedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    map['told_creator'] = Variable<bool>(toldCreator);
    map['cooked_at'] = Variable<DateTime>(cookedAt);
    return map;
  }

  CooksCompanion toCompanion(bool nullToAbsent) {
    return CooksCompanion(
      id: Value(id),
      userId: Value(userId),
      recipeId: Value(recipeId),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      toldCreator: Value(toldCreator),
      cookedAt: Value(cookedAt),
    );
  }

  factory CookRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      servings: serializer.fromJson<int?>(json['servings']),
      toldCreator: serializer.fromJson<bool>(json['toldCreator']),
      cookedAt: serializer.fromJson<DateTime>(json['cookedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'recipeId': serializer.toJson<String>(recipeId),
      'servings': serializer.toJson<int?>(servings),
      'toldCreator': serializer.toJson<bool>(toldCreator),
      'cookedAt': serializer.toJson<DateTime>(cookedAt),
    };
  }

  CookRow copyWith({
    String? id,
    String? userId,
    String? recipeId,
    Value<int?> servings = const Value.absent(),
    bool? toldCreator,
    DateTime? cookedAt,
  }) => CookRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recipeId: recipeId ?? this.recipeId,
    servings: servings.present ? servings.value : this.servings,
    toldCreator: toldCreator ?? this.toldCreator,
    cookedAt: cookedAt ?? this.cookedAt,
  );
  CookRow copyWithCompanion(CooksCompanion data) {
    return CookRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      servings: data.servings.present ? data.servings.value : this.servings,
      toldCreator: data.toldCreator.present
          ? data.toldCreator.value
          : this.toldCreator,
      cookedAt: data.cookedAt.present ? data.cookedAt.value : this.cookedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('servings: $servings, ')
          ..write('toldCreator: $toldCreator, ')
          ..write('cookedAt: $cookedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, recipeId, servings, toldCreator, cookedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recipeId == this.recipeId &&
          other.servings == this.servings &&
          other.toldCreator == this.toldCreator &&
          other.cookedAt == this.cookedAt);
}

class CooksCompanion extends UpdateCompanion<CookRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> recipeId;
  final Value<int?> servings;
  final Value<bool> toldCreator;
  final Value<DateTime> cookedAt;
  final Value<int> rowid;
  const CooksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.servings = const Value.absent(),
    this.toldCreator = const Value.absent(),
    this.cookedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CooksCompanion.insert({
    required String id,
    required String userId,
    required String recipeId,
    this.servings = const Value.absent(),
    this.toldCreator = const Value.absent(),
    required DateTime cookedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       recipeId = Value(recipeId),
       cookedAt = Value(cookedAt);
  static Insertable<CookRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? recipeId,
    Expression<int>? servings,
    Expression<bool>? toldCreator,
    Expression<DateTime>? cookedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (servings != null) 'servings': servings,
      if (toldCreator != null) 'told_creator': toldCreator,
      if (cookedAt != null) 'cooked_at': cookedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CooksCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? recipeId,
    Value<int?>? servings,
    Value<bool>? toldCreator,
    Value<DateTime>? cookedAt,
    Value<int>? rowid,
  }) {
    return CooksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      servings: servings ?? this.servings,
      toldCreator: toldCreator ?? this.toldCreator,
      cookedAt: cookedAt ?? this.cookedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (toldCreator.present) {
      map['told_creator'] = Variable<bool>(toldCreator.value);
    }
    if (cookedAt.present) {
      map['cooked_at'] = Variable<DateTime>(cookedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CooksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('servings: $servings, ')
          ..write('toldCreator: $toldCreator, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingTicksTable extends ShoppingTicks
    with TableInfo<$ShoppingTicksTable, ShoppingTickRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingTicksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tickedAtMeta = const VerificationMeta(
    'tickedAt',
  );
  @override
  late final GeneratedColumn<DateTime> tickedAt = GeneratedColumn<DateTime>(
    'ticked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    ingredientId,
    recipeId,
    tickedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_ticks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingTickRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ticked_at')) {
      context.handle(
        _tickedAtMeta,
        tickedAt.isAcceptableOrUnknown(data['ticked_at']!, _tickedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_tickedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, ingredientId};
  @override
  ShoppingTickRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingTickRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      tickedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ticked_at'],
      )!,
    );
  }

  @override
  $ShoppingTicksTable createAlias(String alias) {
    return $ShoppingTicksTable(attachedDatabase, alias);
  }
}

class ShoppingTickRow extends DataClass implements Insertable<ShoppingTickRow> {
  final String userId;
  final String ingredientId;
  final String recipeId;
  final DateTime tickedAt;
  const ShoppingTickRow({
    required this.userId,
    required this.ingredientId,
    required this.recipeId,
    required this.tickedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['ticked_at'] = Variable<DateTime>(tickedAt);
    return map;
  }

  ShoppingTicksCompanion toCompanion(bool nullToAbsent) {
    return ShoppingTicksCompanion(
      userId: Value(userId),
      ingredientId: Value(ingredientId),
      recipeId: Value(recipeId),
      tickedAt: Value(tickedAt),
    );
  }

  factory ShoppingTickRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingTickRow(
      userId: serializer.fromJson<String>(json['userId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      tickedAt: serializer.fromJson<DateTime>(json['tickedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'recipeId': serializer.toJson<String>(recipeId),
      'tickedAt': serializer.toJson<DateTime>(tickedAt),
    };
  }

  ShoppingTickRow copyWith({
    String? userId,
    String? ingredientId,
    String? recipeId,
    DateTime? tickedAt,
  }) => ShoppingTickRow(
    userId: userId ?? this.userId,
    ingredientId: ingredientId ?? this.ingredientId,
    recipeId: recipeId ?? this.recipeId,
    tickedAt: tickedAt ?? this.tickedAt,
  );
  ShoppingTickRow copyWithCompanion(ShoppingTicksCompanion data) {
    return ShoppingTickRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      tickedAt: data.tickedAt.present ? data.tickedAt.value : this.tickedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingTickRow(')
          ..write('userId: $userId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('recipeId: $recipeId, ')
          ..write('tickedAt: $tickedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, ingredientId, recipeId, tickedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingTickRow &&
          other.userId == this.userId &&
          other.ingredientId == this.ingredientId &&
          other.recipeId == this.recipeId &&
          other.tickedAt == this.tickedAt);
}

class ShoppingTicksCompanion extends UpdateCompanion<ShoppingTickRow> {
  final Value<String> userId;
  final Value<String> ingredientId;
  final Value<String> recipeId;
  final Value<DateTime> tickedAt;
  final Value<int> rowid;
  const ShoppingTicksCompanion({
    this.userId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.tickedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingTicksCompanion.insert({
    required String userId,
    required String ingredientId,
    required String recipeId,
    required DateTime tickedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       ingredientId = Value(ingredientId),
       recipeId = Value(recipeId),
       tickedAt = Value(tickedAt);
  static Insertable<ShoppingTickRow> custom({
    Expression<String>? userId,
    Expression<String>? ingredientId,
    Expression<String>? recipeId,
    Expression<DateTime>? tickedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (tickedAt != null) 'ticked_at': tickedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingTicksCompanion copyWith({
    Value<String>? userId,
    Value<String>? ingredientId,
    Value<String>? recipeId,
    Value<DateTime>? tickedAt,
    Value<int>? rowid,
  }) {
    return ShoppingTicksCompanion(
      userId: userId ?? this.userId,
      ingredientId: ingredientId ?? this.ingredientId,
      recipeId: recipeId ?? this.recipeId,
      tickedAt: tickedAt ?? this.tickedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (tickedAt.present) {
      map['ticked_at'] = Variable<DateTime>(tickedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingTicksCompanion(')
          ..write('userId: $userId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('recipeId: $recipeId, ')
          ..write('tickedAt: $tickedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentlyViewedTable extends RecentlyViewed
    with TableInfo<$RecentlyViewedTable, RecentlyViewedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentlyViewedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewedAtMeta = const VerificationMeta(
    'viewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> viewedAt = GeneratedColumn<DateTime>(
    'viewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, recipeId, viewedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recently_viewed';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentlyViewedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('viewed_at')) {
      context.handle(
        _viewedAtMeta,
        viewedAt.isAcceptableOrUnknown(data['viewed_at']!, _viewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_viewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, recipeId};
  @override
  RecentlyViewedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentlyViewedRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      viewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}viewed_at'],
      )!,
    );
  }

  @override
  $RecentlyViewedTable createAlias(String alias) {
    return $RecentlyViewedTable(attachedDatabase, alias);
  }
}

class RecentlyViewedRow extends DataClass
    implements Insertable<RecentlyViewedRow> {
  final String userId;
  final String recipeId;
  final DateTime viewedAt;
  const RecentlyViewedRow({
    required this.userId,
    required this.recipeId,
    required this.viewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['viewed_at'] = Variable<DateTime>(viewedAt);
    return map;
  }

  RecentlyViewedCompanion toCompanion(bool nullToAbsent) {
    return RecentlyViewedCompanion(
      userId: Value(userId),
      recipeId: Value(recipeId),
      viewedAt: Value(viewedAt),
    );
  }

  factory RecentlyViewedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentlyViewedRow(
      userId: serializer.fromJson<String>(json['userId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      viewedAt: serializer.fromJson<DateTime>(json['viewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'recipeId': serializer.toJson<String>(recipeId),
      'viewedAt': serializer.toJson<DateTime>(viewedAt),
    };
  }

  RecentlyViewedRow copyWith({
    String? userId,
    String? recipeId,
    DateTime? viewedAt,
  }) => RecentlyViewedRow(
    userId: userId ?? this.userId,
    recipeId: recipeId ?? this.recipeId,
    viewedAt: viewedAt ?? this.viewedAt,
  );
  RecentlyViewedRow copyWithCompanion(RecentlyViewedCompanion data) {
    return RecentlyViewedRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      viewedAt: data.viewedAt.present ? data.viewedAt.value : this.viewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentlyViewedRow(')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('viewedAt: $viewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, recipeId, viewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentlyViewedRow &&
          other.userId == this.userId &&
          other.recipeId == this.recipeId &&
          other.viewedAt == this.viewedAt);
}

class RecentlyViewedCompanion extends UpdateCompanion<RecentlyViewedRow> {
  final Value<String> userId;
  final Value<String> recipeId;
  final Value<DateTime> viewedAt;
  final Value<int> rowid;
  const RecentlyViewedCompanion({
    this.userId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.viewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentlyViewedCompanion.insert({
    required String userId,
    required String recipeId,
    required DateTime viewedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       recipeId = Value(recipeId),
       viewedAt = Value(viewedAt);
  static Insertable<RecentlyViewedRow> custom({
    Expression<String>? userId,
    Expression<String>? recipeId,
    Expression<DateTime>? viewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (viewedAt != null) 'viewed_at': viewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentlyViewedCompanion copyWith({
    Value<String>? userId,
    Value<String>? recipeId,
    Value<DateTime>? viewedAt,
    Value<int>? rowid,
  }) {
    return RecentlyViewedCompanion(
      userId: userId ?? this.userId,
      recipeId: recipeId ?? this.recipeId,
      viewedAt: viewedAt ?? this.viewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (viewedAt.present) {
      map['viewed_at'] = Variable<DateTime>(viewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentlyViewedCompanion(')
          ..write('userId: $userId, ')
          ..write('recipeId: $recipeId, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OutboxKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OutboxKind>($OutboxTable.$converterkind);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onConflictMeta = const VerificationMeta(
    'onConflict',
  );
  @override
  late final GeneratedColumn<String> onConflict = GeneratedColumn<String>(
    'on_conflict',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dedupeKeyMeta = const VerificationMeta(
    'dedupeKey',
  );
  @override
  late final GeneratedColumn<String> dedupeKey = GeneratedColumn<String>(
    'dedupe_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _failedMeta = const VerificationMeta('failed');
  @override
  late final GeneratedColumn<bool> failed = GeneratedColumn<bool>(
    'failed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("failed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    target,
    payload,
    onConflict,
    dedupeKey,
    attempts,
    lastError,
    failed,
    createdAt,
    nextAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('on_conflict')) {
      context.handle(
        _onConflictMeta,
        onConflict.isAcceptableOrUnknown(data['on_conflict']!, _onConflictMeta),
      );
    }
    if (data.containsKey('dedupe_key')) {
      context.handle(
        _dedupeKeyMeta,
        dedupeKey.isAcceptableOrUnknown(data['dedupe_key']!, _dedupeKeyMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('failed')) {
      context.handle(
        _failedMeta,
        failed.isAcceptableOrUnknown(data['failed']!, _failedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $OutboxTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      onConflict: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}on_conflict'],
      ),
      dedupeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_key'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      failed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}failed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OutboxKind, String, String> $converterkind =
      const EnumNameConverter<OutboxKind>(OutboxKind.values);
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;
  final OutboxKind kind;
  final String target;
  final String payload;
  final String? onConflict;
  final String? dedupeKey;
  final int attempts;
  final String? lastError;
  final bool failed;
  final DateTime createdAt;
  final DateTime? nextAttemptAt;
  const OutboxEntry({
    required this.id,
    required this.kind,
    required this.target,
    required this.payload,
    this.onConflict,
    this.dedupeKey,
    required this.attempts,
    this.lastError,
    required this.failed,
    required this.createdAt,
    this.nextAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>($OutboxTable.$converterkind.toSql(kind));
    }
    map['target'] = Variable<String>(target);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || onConflict != null) {
      map['on_conflict'] = Variable<String>(onConflict);
    }
    if (!nullToAbsent || dedupeKey != null) {
      map['dedupe_key'] = Variable<String>(dedupeKey);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['failed'] = Variable<bool>(failed);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      kind: Value(kind),
      target: Value(target),
      payload: Value(payload),
      onConflict: onConflict == null && nullToAbsent
          ? const Value.absent()
          : Value(onConflict),
      dedupeKey: dedupeKey == null && nullToAbsent
          ? const Value.absent()
          : Value(dedupeKey),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      failed: Value(failed),
      createdAt: Value(createdAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      kind: $OutboxTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      target: serializer.fromJson<String>(json['target']),
      payload: serializer.fromJson<String>(json['payload']),
      onConflict: serializer.fromJson<String?>(json['onConflict']),
      dedupeKey: serializer.fromJson<String?>(json['dedupeKey']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      failed: serializer.fromJson<bool>(json['failed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $OutboxTable.$converterkind.toJson(kind),
      ),
      'target': serializer.toJson<String>(target),
      'payload': serializer.toJson<String>(payload),
      'onConflict': serializer.toJson<String?>(onConflict),
      'dedupeKey': serializer.toJson<String?>(dedupeKey),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'failed': serializer.toJson<bool>(failed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
    };
  }

  OutboxEntry copyWith({
    int? id,
    OutboxKind? kind,
    String? target,
    String? payload,
    Value<String?> onConflict = const Value.absent(),
    Value<String?> dedupeKey = const Value.absent(),
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    bool? failed,
    DateTime? createdAt,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    target: target ?? this.target,
    payload: payload ?? this.payload,
    onConflict: onConflict.present ? onConflict.value : this.onConflict,
    dedupeKey: dedupeKey.present ? dedupeKey.value : this.dedupeKey,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    failed: failed ?? this.failed,
    createdAt: createdAt ?? this.createdAt,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
  );
  OutboxEntry copyWithCompanion(OutboxCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      target: data.target.present ? data.target.value : this.target,
      payload: data.payload.present ? data.payload.value : this.payload,
      onConflict: data.onConflict.present
          ? data.onConflict.value
          : this.onConflict,
      dedupeKey: data.dedupeKey.present ? data.dedupeKey.value : this.dedupeKey,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      failed: data.failed.present ? data.failed.value : this.failed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('target: $target, ')
          ..write('payload: $payload, ')
          ..write('onConflict: $onConflict, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('failed: $failed, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    target,
    payload,
    onConflict,
    dedupeKey,
    attempts,
    lastError,
    failed,
    createdAt,
    nextAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.target == this.target &&
          other.payload == this.payload &&
          other.onConflict == this.onConflict &&
          other.dedupeKey == this.dedupeKey &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.failed == this.failed &&
          other.createdAt == this.createdAt &&
          other.nextAttemptAt == this.nextAttemptAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<OutboxKind> kind;
  final Value<String> target;
  final Value<String> payload;
  final Value<String?> onConflict;
  final Value<String?> dedupeKey;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<bool> failed;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextAttemptAt;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.target = const Value.absent(),
    this.payload = const Value.absent(),
    this.onConflict = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.failed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required OutboxKind kind,
    required String target,
    required String payload,
    this.onConflict = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.failed = const Value.absent(),
    required DateTime createdAt,
    this.nextAttemptAt = const Value.absent(),
  }) : kind = Value(kind),
       target = Value(target),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? target,
    Expression<String>? payload,
    Expression<String>? onConflict,
    Expression<String>? dedupeKey,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<bool>? failed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextAttemptAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (target != null) 'target': target,
      if (payload != null) 'payload': payload,
      if (onConflict != null) 'on_conflict': onConflict,
      if (dedupeKey != null) 'dedupe_key': dedupeKey,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (failed != null) 'failed': failed,
      if (createdAt != null) 'created_at': createdAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<OutboxKind>? kind,
    Value<String>? target,
    Value<String>? payload,
    Value<String?>? onConflict,
    Value<String?>? dedupeKey,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<bool>? failed,
    Value<DateTime>? createdAt,
    Value<DateTime?>? nextAttemptAt,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      target: target ?? this.target,
      payload: payload ?? this.payload,
      onConflict: onConflict ?? this.onConflict,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      failed: failed ?? this.failed,
      createdAt: createdAt ?? this.createdAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $OutboxTable.$converterkind.toSql(kind.value),
      );
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (onConflict.present) {
      map['on_conflict'] = Variable<String>(onConflict.value);
    }
    if (dedupeKey.present) {
      map['dedupe_key'] = Variable<String>(dedupeKey.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (failed.present) {
      map['failed'] = Variable<bool>(failed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('target: $target, ')
          ..write('payload: $payload, ')
          ..write('onConflict: $onConflict, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('failed: $failed, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<DateTime> cursor = GeneratedColumn<DateTime>(
    'cursor',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [scope, cursor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    } else if (isInserting) {
      context.missing(_cursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scope};
  @override
  SyncCursorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursorRow(
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cursor'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursorRow extends DataClass implements Insertable<SyncCursorRow> {
  final String scope;
  final DateTime cursor;
  const SyncCursorRow({required this.scope, required this.cursor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope'] = Variable<String>(scope);
    map['cursor'] = Variable<DateTime>(cursor);
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(scope: Value(scope), cursor: Value(cursor));
  }

  factory SyncCursorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursorRow(
      scope: serializer.fromJson<String>(json['scope']),
      cursor: serializer.fromJson<DateTime>(json['cursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scope': serializer.toJson<String>(scope),
      'cursor': serializer.toJson<DateTime>(cursor),
    };
  }

  SyncCursorRow copyWith({String? scope, DateTime? cursor}) =>
      SyncCursorRow(scope: scope ?? this.scope, cursor: cursor ?? this.cursor);
  SyncCursorRow copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursorRow(
      scope: data.scope.present ? data.scope.value : this.scope,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorRow(')
          ..write('scope: $scope, ')
          ..write('cursor: $cursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scope, cursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursorRow &&
          other.scope == this.scope &&
          other.cursor == this.cursor);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursorRow> {
  final Value<String> scope;
  final Value<DateTime> cursor;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.scope = const Value.absent(),
    this.cursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String scope,
    required DateTime cursor,
    this.rowid = const Value.absent(),
  }) : scope = Value(scope),
       cursor = Value(cursor);
  static Insertable<SyncCursorRow> custom({
    Expression<String>? scope,
    Expression<DateTime>? cursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scope != null) 'scope': scope,
      if (cursor != null) 'cursor': cursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? scope,
    Value<DateTime>? cursor,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      scope: scope ?? this.scope,
      cursor: cursor ?? this.cursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<DateTime>(cursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('scope: $scope, ')
          ..write('cursor: $cursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $MeasureUnitsTable measureUnits = $MeasureUnitsTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodPortionsTable foodPortions = $FoodPortionsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $ProfileTastesTable profileTastes = $ProfileTastesTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $StepIngredientsTable stepIngredients = $StepIngredientsTable(
    this,
  );
  late final $RecipeTagsTable recipeTags = $RecipeTagsTable(this);
  late final $LikesTable likes = $LikesTable(this);
  late final $SavesTable saves = $SavesTable(this);
  late final $CooksTable cooks = $CooksTable(this);
  late final $ShoppingTicksTable shoppingTicks = $ShoppingTicksTable(this);
  late final $RecentlyViewedTable recentlyViewed = $RecentlyViewedTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tags,
    measureUnits,
    foods,
    foodPortions,
    profiles,
    profileTastes,
    recipes,
    recipeIngredients,
    recipeSteps,
    stepIngredients,
    recipeTags,
    likes,
    saves,
    cooks,
    shoppingTicks,
    recentlyViewed,
    outbox,
    syncCursors,
  ];
}

typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String slug,
  required String label,
  required TagKind kind,
  required CoverStyle coverStyle,
  Value<int> position,
  required DateTime updatedAt,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> slug,
  Value<String> label,
  Value<TagKind> kind,
  Value<CoverStyle> coverStyle,
  Value<int> position,
  Value<DateTime> updatedAt,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
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

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TagKind, TagKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<CoverStyle, CoverStyle, String>
  get coverStyle => $composableBuilder(
    column: $table.coverStyle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
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

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverStyle => $composableBuilder(
    column: $table.coverStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TagKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CoverStyle, String> get coverStyle =>
      $composableBuilder(
        column: $table.coverStyle,
        builder: (column) => column,
      );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          TagRow,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagRow, BaseReferences<_$AppDatabase, $TagsTable, TagRow>),
          TagRow,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<TagKind> kind = const Value.absent(),
                Value<CoverStyle> coverStyle = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                slug: slug,
                label: label,
                kind: kind,
                coverStyle: coverStyle,
                position: position,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slug,
                required String label,
                required TagKind kind,
                required CoverStyle coverStyle,
                Value<int> position = const Value.absent(),
                required DateTime updatedAt,
              }) => TagsCompanion.insert(
                id: id,
                slug: slug,
                label: label,
                kind: kind,
                coverStyle: coverStyle,
                position: position,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, TagRow>(table),
                  BaseReferences<_$AppDatabase, $TagsTable, TagRow>(
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

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      TagRow,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagRow, BaseReferences<_$AppDatabase, $TagsTable, TagRow>),
      TagRow,
      PrefetchHooks Function()
    >;
typedef $$MeasureUnitsTableCreateCompanionBuilder =
    MeasureUnitsCompanion Function({
      required String code,
      required String label,
      required UnitKind kind,
      required UnitScope scope,
      required double toBase,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MeasureUnitsTableUpdateCompanionBuilder =
    MeasureUnitsCompanion Function({
      Value<String> code,
      Value<String> label,
      Value<UnitKind> kind,
      Value<UnitScope> scope,
      Value<double> toBase,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MeasureUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasureUnitsTable> {
  $$MeasureUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UnitKind, UnitKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<UnitScope, UnitScope, String> get scope =>
      $composableBuilder(
        column: $table.scope,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get toBase => $composableBuilder(
    column: $table.toBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeasureUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasureUnitsTable> {
  $$MeasureUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toBase => $composableBuilder(
    column: $table.toBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasureUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasureUnitsTable> {
  $$MeasureUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UnitKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UnitScope, String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<double> get toBase =>
      $composableBuilder(column: $table.toBase, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MeasureUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasureUnitsTable,
          UnitRow,
          $$MeasureUnitsTableFilterComposer,
          $$MeasureUnitsTableOrderingComposer,
          $$MeasureUnitsTableAnnotationComposer,
          $$MeasureUnitsTableCreateCompanionBuilder,
          $$MeasureUnitsTableUpdateCompanionBuilder,
          (UnitRow, BaseReferences<_$AppDatabase, $MeasureUnitsTable, UnitRow>),
          UnitRow,
          PrefetchHooks Function()
        > {
  $$MeasureUnitsTableTableManager(_$AppDatabase db, $MeasureUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasureUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasureUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasureUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<UnitKind> kind = const Value.absent(),
                Value<UnitScope> scope = const Value.absent(),
                Value<double> toBase = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasureUnitsCompanion(
                code: code,
                label: label,
                kind: kind,
                scope: scope,
                toBase: toBase,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String label,
                required UnitKind kind,
                required UnitScope scope,
                required double toBase,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MeasureUnitsCompanion.insert(
                code: code,
                label: label,
                kind: kind,
                scope: scope,
                toBase: toBase,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MeasureUnitsTable, UnitRow>(table),
                  BaseReferences<_$AppDatabase, $MeasureUnitsTable, UnitRow>(
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

typedef $$MeasureUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasureUnitsTable,
      UnitRow,
      $$MeasureUnitsTableFilterComposer,
      $$MeasureUnitsTableOrderingComposer,
      $$MeasureUnitsTableAnnotationComposer,
      $$MeasureUnitsTableCreateCompanionBuilder,
      $$MeasureUnitsTableUpdateCompanionBuilder,
      (UnitRow, BaseReferences<_$AppDatabase, $MeasureUnitsTable, UnitRow>),
      UnitRow,
      PrefetchHooks Function()
    >;
typedef $$FoodsTableCreateCompanionBuilder = FoodsCompanion Function({
  required String id,
  required String name,
  Value<List<String>> aliases,
  Value<String?> category,
  Value<double> kcal100g,
  Value<double> protein100g,
  Value<double> carbs100g,
  Value<double> fat100g,
  Value<double> fibre100g,
  Value<double?> sugar100g,
  Value<double?> sodiumMg100g,
  Value<double?> densityGMl,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FoodsTableUpdateCompanionBuilder = FoodsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<List<String>> aliases,
  Value<String?> category,
  Value<double> kcal100g,
  Value<double> protein100g,
  Value<double> carbs100g,
  Value<double> fat100g,
  Value<double> fibre100g,
  Value<double?> sugar100g,
  Value<double?> sodiumMg100g,
  Value<double?> densityGMl,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal100g => $composableBuilder(
    column: $table.kcal100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein100g => $composableBuilder(
    column: $table.protein100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs100g => $composableBuilder(
    column: $table.carbs100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat100g => $composableBuilder(
    column: $table.fat100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibre100g => $composableBuilder(
    column: $table.fibre100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar100g => $composableBuilder(
    column: $table.sugar100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sodiumMg100g => $composableBuilder(
    column: $table.sodiumMg100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get densityGMl => $composableBuilder(
    column: $table.densityGMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
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

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal100g => $composableBuilder(
    column: $table.kcal100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein100g => $composableBuilder(
    column: $table.protein100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs100g => $composableBuilder(
    column: $table.carbs100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat100g => $composableBuilder(
    column: $table.fat100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibre100g => $composableBuilder(
    column: $table.fibre100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar100g => $composableBuilder(
    column: $table.sugar100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sodiumMg100g => $composableBuilder(
    column: $table.sodiumMg100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get densityGMl => $composableBuilder(
    column: $table.densityGMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<List<String>, String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get kcal100g =>
      $composableBuilder(column: $table.kcal100g, builder: (column) => column);

  GeneratedColumn<double> get protein100g => $composableBuilder(
    column: $table.protein100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbs100g =>
      $composableBuilder(column: $table.carbs100g, builder: (column) => column);

  GeneratedColumn<double> get fat100g =>
      $composableBuilder(column: $table.fat100g, builder: (column) => column);

  GeneratedColumn<double> get fibre100g =>
      $composableBuilder(column: $table.fibre100g, builder: (column) => column);

  GeneratedColumn<double> get sugar100g =>
      $composableBuilder(column: $table.sugar100g, builder: (column) => column);

  GeneratedColumn<double> get sodiumMg100g => $composableBuilder(
    column: $table.sodiumMg100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get densityGMl => $composableBuilder(
    column: $table.densityGMl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          FoodRow,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (FoodRow, BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>),
          FoodRow,
          PrefetchHooks Function()
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<List<String>> aliases = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double> kcal100g = const Value.absent(),
                Value<double> protein100g = const Value.absent(),
                Value<double> carbs100g = const Value.absent(),
                Value<double> fat100g = const Value.absent(),
                Value<double> fibre100g = const Value.absent(),
                Value<double?> sugar100g = const Value.absent(),
                Value<double?> sodiumMg100g = const Value.absent(),
                Value<double?> densityGMl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                aliases: aliases,
                category: category,
                kcal100g: kcal100g,
                protein100g: protein100g,
                carbs100g: carbs100g,
                fat100g: fat100g,
                fibre100g: fibre100g,
                sugar100g: sugar100g,
                sodiumMg100g: sodiumMg100g,
                densityGMl: densityGMl,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<List<String>> aliases = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double> kcal100g = const Value.absent(),
                Value<double> protein100g = const Value.absent(),
                Value<double> carbs100g = const Value.absent(),
                Value<double> fat100g = const Value.absent(),
                Value<double> fibre100g = const Value.absent(),
                Value<double?> sugar100g = const Value.absent(),
                Value<double?> sodiumMg100g = const Value.absent(),
                Value<double?> densityGMl = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                aliases: aliases,
                category: category,
                kcal100g: kcal100g,
                protein100g: protein100g,
                carbs100g: carbs100g,
                fat100g: fat100g,
                fibre100g: fibre100g,
                sugar100g: sugar100g,
                sodiumMg100g: sodiumMg100g,
                densityGMl: densityGMl,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodsTable, FoodRow>(table),
                  BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>(
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

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      FoodRow,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (FoodRow, BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>),
      FoodRow,
      PrefetchHooks Function()
    >;
typedef $$FoodPortionsTableCreateCompanionBuilder =
    FoodPortionsCompanion Function({
      required String foodId,
      required String label,
      required double grams,
      Value<bool> isDefault,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FoodPortionsTableUpdateCompanionBuilder =
    FoodPortionsCompanion Function({
      Value<String> foodId,
      Value<String> label,
      Value<double> grams,
      Value<bool> isDefault,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FoodPortionsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodPortionsTable> {
  $$FoodPortionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodPortionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodPortionsTable> {
  $$FoodPortionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodPortionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodPortionsTable> {
  $$FoodPortionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FoodPortionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodPortionsTable,
          FoodPortionRow,
          $$FoodPortionsTableFilterComposer,
          $$FoodPortionsTableOrderingComposer,
          $$FoodPortionsTableAnnotationComposer,
          $$FoodPortionsTableCreateCompanionBuilder,
          $$FoodPortionsTableUpdateCompanionBuilder,
          (
            FoodPortionRow,
            BaseReferences<_$AppDatabase, $FoodPortionsTable, FoodPortionRow>,
          ),
          FoodPortionRow,
          PrefetchHooks Function()
        > {
  $$FoodPortionsTableTableManager(_$AppDatabase db, $FoodPortionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodPortionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodPortionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodPortionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> foodId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodPortionsCompanion(
                foodId: foodId,
                label: label,
                grams: grams,
                isDefault: isDefault,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String foodId,
                required String label,
                required double grams,
                Value<bool> isDefault = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FoodPortionsCompanion.insert(
                foodId: foodId,
                label: label,
                grams: grams,
                isDefault: isDefault,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodPortionsTable, FoodPortionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FoodPortionsTable,
                    FoodPortionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodPortionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodPortionsTable,
      FoodPortionRow,
      $$FoodPortionsTableFilterComposer,
      $$FoodPortionsTableOrderingComposer,
      $$FoodPortionsTableAnnotationComposer,
      $$FoodPortionsTableCreateCompanionBuilder,
      $$FoodPortionsTableUpdateCompanionBuilder,
      (
        FoodPortionRow,
        BaseReferences<_$AppDatabase, $FoodPortionsTable, FoodPortionRow>,
      ),
      FoodPortionRow,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String username,
  required String displayName,
  Value<String?> avatarPath,
  Value<String?> bio,
  Value<String?> city,
  required UnitSystem units,
  Value<String> currency,
  required RecipeVisibility defaultVisibility,
  Value<bool> keepScreenOn,
  Value<bool> notifySaves,
  Value<bool> notifyCooks,
  Value<bool> notifyFriends,
  Value<bool> weeklyRoundup,
  Value<DateTime?> onboardedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> displayName,
  Value<String?> avatarPath,
  Value<String?> bio,
  Value<String?> city,
  Value<UnitSystem> units,
  Value<String> currency,
  Value<RecipeVisibility> defaultVisibility,
  Value<bool> keepScreenOn,
  Value<bool> notifySaves,
  Value<bool> notifyCooks,
  Value<bool> notifyFriends,
  Value<bool> weeklyRoundup,
  Value<DateTime?> onboardedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UnitSystem, UnitSystem, String> get units =>
      $composableBuilder(
        column: $table.units,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecipeVisibility, RecipeVisibility, String>
  get defaultVisibility => $composableBuilder(
    column: $table.defaultVisibility,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get keepScreenOn => $composableBuilder(
    column: $table.keepScreenOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifySaves => $composableBuilder(
    column: $table.notifySaves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyCooks => $composableBuilder(
    column: $table.notifyCooks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyFriends => $composableBuilder(
    column: $table.notifyFriends,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weeklyRoundup => $composableBuilder(
    column: $table.weeklyRoundup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get onboardedAt => $composableBuilder(
    column: $table.onboardedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultVisibility => $composableBuilder(
    column: $table.defaultVisibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get keepScreenOn => $composableBuilder(
    column: $table.keepScreenOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifySaves => $composableBuilder(
    column: $table.notifySaves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyCooks => $composableBuilder(
    column: $table.notifyCooks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyFriends => $composableBuilder(
    column: $table.notifyFriends,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weeklyRoundup => $composableBuilder(
    column: $table.weeklyRoundup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get onboardedAt => $composableBuilder(
    column: $table.onboardedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UnitSystem, String> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecipeVisibility, String>
  get defaultVisibility => $composableBuilder(
    column: $table.defaultVisibility,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get keepScreenOn => $composableBuilder(
    column: $table.keepScreenOn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifySaves => $composableBuilder(
    column: $table.notifySaves,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyCooks => $composableBuilder(
    column: $table.notifyCooks,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyFriends => $composableBuilder(
    column: $table.notifyFriends,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weeklyRoundup => $composableBuilder(
    column: $table.weeklyRoundup,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get onboardedAt => $composableBuilder(
    column: $table.onboardedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<UnitSystem> units = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<RecipeVisibility> defaultVisibility =
                    const Value.absent(),
                Value<bool> keepScreenOn = const Value.absent(),
                Value<bool> notifySaves = const Value.absent(),
                Value<bool> notifyCooks = const Value.absent(),
                Value<bool> notifyFriends = const Value.absent(),
                Value<bool> weeklyRoundup = const Value.absent(),
                Value<DateTime?> onboardedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                username: username,
                displayName: displayName,
                avatarPath: avatarPath,
                bio: bio,
                city: city,
                units: units,
                currency: currency,
                defaultVisibility: defaultVisibility,
                keepScreenOn: keepScreenOn,
                notifySaves: notifySaves,
                notifyCooks: notifyCooks,
                notifyFriends: notifyFriends,
                weeklyRoundup: weeklyRoundup,
                onboardedAt: onboardedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String username,
                required String displayName,
                Value<String?> avatarPath = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> city = const Value.absent(),
                required UnitSystem units,
                Value<String> currency = const Value.absent(),
                required RecipeVisibility defaultVisibility,
                Value<bool> keepScreenOn = const Value.absent(),
                Value<bool> notifySaves = const Value.absent(),
                Value<bool> notifyCooks = const Value.absent(),
                Value<bool> notifyFriends = const Value.absent(),
                Value<bool> weeklyRoundup = const Value.absent(),
                Value<DateTime?> onboardedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                username: username,
                displayName: displayName,
                avatarPath: avatarPath,
                bio: bio,
                city: city,
                units: units,
                currency: currency,
                defaultVisibility: defaultVisibility,
                keepScreenOn: keepScreenOn,
                notifySaves: notifySaves,
                notifyCooks: notifyCooks,
                notifyFriends: notifyFriends,
                weeklyRoundup: weeklyRoundup,
                onboardedAt: onboardedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>(
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

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$ProfileTastesTableCreateCompanionBuilder =
    ProfileTastesCompanion Function({
      required String userId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$ProfileTastesTableUpdateCompanionBuilder =
    ProfileTastesCompanion Function({
      Value<String> userId,
      Value<int> tagId,
      Value<int> rowid,
    });

class $$ProfileTastesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileTastesTable> {
  $$ProfileTastesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfileTastesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileTastesTable> {
  $$ProfileTastesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileTastesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileTastesTable> {
  $$ProfileTastesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);
}

class $$ProfileTastesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileTastesTable,
          ProfileTasteRow,
          $$ProfileTastesTableFilterComposer,
          $$ProfileTastesTableOrderingComposer,
          $$ProfileTastesTableAnnotationComposer,
          $$ProfileTastesTableCreateCompanionBuilder,
          $$ProfileTastesTableUpdateCompanionBuilder,
          (
            ProfileTasteRow,
            BaseReferences<_$AppDatabase, $ProfileTastesTable, ProfileTasteRow>,
          ),
          ProfileTasteRow,
          PrefetchHooks Function()
        > {
  $$ProfileTastesTableTableManager(_$AppDatabase db, $ProfileTastesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileTastesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileTastesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileTastesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfileTastesCompanion(
                userId: userId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => ProfileTastesCompanion.insert(
                userId: userId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileTastesTable, ProfileTasteRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProfileTastesTable,
                    ProfileTasteRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileTastesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileTastesTable,
      ProfileTasteRow,
      $$ProfileTastesTableFilterComposer,
      $$ProfileTastesTableOrderingComposer,
      $$ProfileTastesTableAnnotationComposer,
      $$ProfileTastesTableCreateCompanionBuilder,
      $$ProfileTastesTableUpdateCompanionBuilder,
      (
        ProfileTasteRow,
        BaseReferences<_$AppDatabase, $ProfileTastesTable, ProfileTasteRow>,
      ),
      ProfileTasteRow,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  required String id,
  required String authorId,
  Value<String?> forkedFromId,
  Value<String> title,
  Value<String?> note,
  Value<String?> coverPath,
  Value<String?> localCoverPath,
  required CoverStyle coverStyle,
  Value<int> baseServings,
  Value<int?> totalMinutes,
  required RecipeVisibility visibility,
  required RecipeStatus status,
  required RecipeSource source,
  Value<String?> sourceText,
  Value<double?> kcalPerServing,
  Value<double?> proteinG,
  Value<double?> carbsG,
  Value<double?> fatG,
  Value<double?> fibreG,
  Value<int> ingredientCount,
  Value<int> matchedLines,
  Value<int?> costCents,
  Value<String> costCurrency,
  Value<int> likeCount,
  Value<int> saveCount,
  Value<int> cookCount,
  Value<String?> authorName,
  Value<String?> authorUsername,
  Value<String?> authorAvatar,
  Value<DateTime?> publishedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<String> authorId,
  Value<String?> forkedFromId,
  Value<String> title,
  Value<String?> note,
  Value<String?> coverPath,
  Value<String?> localCoverPath,
  Value<CoverStyle> coverStyle,
  Value<int> baseServings,
  Value<int?> totalMinutes,
  Value<RecipeVisibility> visibility,
  Value<RecipeStatus> status,
  Value<RecipeSource> source,
  Value<String?> sourceText,
  Value<double?> kcalPerServing,
  Value<double?> proteinG,
  Value<double?> carbsG,
  Value<double?> fatG,
  Value<double?> fibreG,
  Value<int> ingredientCount,
  Value<int> matchedLines,
  Value<int?> costCents,
  Value<String> costCurrency,
  Value<int> likeCount,
  Value<int> saveCount,
  Value<int> cookCount,
  Value<String?> authorName,
  Value<String?> authorUsername,
  Value<String?> authorAvatar,
  Value<DateTime?> publishedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
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

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forkedFromId => $composableBuilder(
    column: $table.forkedFromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localCoverPath => $composableBuilder(
    column: $table.localCoverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CoverStyle, CoverStyle, String>
  get coverStyle => $composableBuilder(
    column: $table.coverStyle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecipeVisibility, RecipeVisibility, String>
  get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<RecipeStatus, RecipeStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<RecipeSource, RecipeSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcalPerServing => $composableBuilder(
    column: $table.kcalPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ingredientCount => $composableBuilder(
    column: $table.ingredientCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchedLines => $composableBuilder(
    column: $table.matchedLines,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCents => $composableBuilder(
    column: $table.costCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get costCurrency => $composableBuilder(
    column: $table.costCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saveCount => $composableBuilder(
    column: $table.saveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookCount => $composableBuilder(
    column: $table.cookCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
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

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forkedFromId => $composableBuilder(
    column: $table.forkedFromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localCoverPath => $composableBuilder(
    column: $table.localCoverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverStyle => $composableBuilder(
    column: $table.coverStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcalPerServing => $composableBuilder(
    column: $table.kcalPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ingredientCount => $composableBuilder(
    column: $table.ingredientCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchedLines => $composableBuilder(
    column: $table.matchedLines,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCents => $composableBuilder(
    column: $table.costCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costCurrency => $composableBuilder(
    column: $table.costCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saveCount => $composableBuilder(
    column: $table.saveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookCount => $composableBuilder(
    column: $table.cookCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get forkedFromId => $composableBuilder(
    column: $table.forkedFromId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get localCoverPath => $composableBuilder(
    column: $table.localCoverPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CoverStyle, String> get coverStyle =>
      $composableBuilder(
        column: $table.coverStyle,
        builder: (column) => column,
      );

  GeneratedColumn<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RecipeVisibility, String> get visibility =>
      $composableBuilder(
        column: $table.visibility,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<RecipeStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecipeSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kcalPerServing => $composableBuilder(
    column: $table.kcalPerServing,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<double> get fibreG =>
      $composableBuilder(column: $table.fibreG, builder: (column) => column);

  GeneratedColumn<int> get ingredientCount => $composableBuilder(
    column: $table.ingredientCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get matchedLines => $composableBuilder(
    column: $table.matchedLines,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costCents =>
      $composableBuilder(column: $table.costCents, builder: (column) => column);

  GeneratedColumn<String> get costCurrency => $composableBuilder(
    column: $table.costCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<int> get saveCount =>
      $composableBuilder(column: $table.saveCount, builder: (column) => column);

  GeneratedColumn<int> get cookCount =>
      $composableBuilder(column: $table.cookCount, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
    column: $table.authorAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          RecipeRow,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (RecipeRow, BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow>),
          RecipeRow,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String?> forkedFromId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String?> localCoverPath = const Value.absent(),
                Value<CoverStyle> coverStyle = const Value.absent(),
                Value<int> baseServings = const Value.absent(),
                Value<int?> totalMinutes = const Value.absent(),
                Value<RecipeVisibility> visibility = const Value.absent(),
                Value<RecipeStatus> status = const Value.absent(),
                Value<RecipeSource> source = const Value.absent(),
                Value<String?> sourceText = const Value.absent(),
                Value<double?> kcalPerServing = const Value.absent(),
                Value<double?> proteinG = const Value.absent(),
                Value<double?> carbsG = const Value.absent(),
                Value<double?> fatG = const Value.absent(),
                Value<double?> fibreG = const Value.absent(),
                Value<int> ingredientCount = const Value.absent(),
                Value<int> matchedLines = const Value.absent(),
                Value<int?> costCents = const Value.absent(),
                Value<String> costCurrency = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<int> saveCount = const Value.absent(),
                Value<int> cookCount = const Value.absent(),
                Value<String?> authorName = const Value.absent(),
                Value<String?> authorUsername = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                authorId: authorId,
                forkedFromId: forkedFromId,
                title: title,
                note: note,
                coverPath: coverPath,
                localCoverPath: localCoverPath,
                coverStyle: coverStyle,
                baseServings: baseServings,
                totalMinutes: totalMinutes,
                visibility: visibility,
                status: status,
                source: source,
                sourceText: sourceText,
                kcalPerServing: kcalPerServing,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                fibreG: fibreG,
                ingredientCount: ingredientCount,
                matchedLines: matchedLines,
                costCents: costCents,
                costCurrency: costCurrency,
                likeCount: likeCount,
                saveCount: saveCount,
                cookCount: cookCount,
                authorName: authorName,
                authorUsername: authorUsername,
                authorAvatar: authorAvatar,
                publishedAt: publishedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorId,
                Value<String?> forkedFromId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String?> localCoverPath = const Value.absent(),
                required CoverStyle coverStyle,
                Value<int> baseServings = const Value.absent(),
                Value<int?> totalMinutes = const Value.absent(),
                required RecipeVisibility visibility,
                required RecipeStatus status,
                required RecipeSource source,
                Value<String?> sourceText = const Value.absent(),
                Value<double?> kcalPerServing = const Value.absent(),
                Value<double?> proteinG = const Value.absent(),
                Value<double?> carbsG = const Value.absent(),
                Value<double?> fatG = const Value.absent(),
                Value<double?> fibreG = const Value.absent(),
                Value<int> ingredientCount = const Value.absent(),
                Value<int> matchedLines = const Value.absent(),
                Value<int?> costCents = const Value.absent(),
                Value<String> costCurrency = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<int> saveCount = const Value.absent(),
                Value<int> cookCount = const Value.absent(),
                Value<String?> authorName = const Value.absent(),
                Value<String?> authorUsername = const Value.absent(),
                Value<String?> authorAvatar = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                authorId: authorId,
                forkedFromId: forkedFromId,
                title: title,
                note: note,
                coverPath: coverPath,
                localCoverPath: localCoverPath,
                coverStyle: coverStyle,
                baseServings: baseServings,
                totalMinutes: totalMinutes,
                visibility: visibility,
                status: status,
                source: source,
                sourceText: sourceText,
                kcalPerServing: kcalPerServing,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                fibreG: fibreG,
                ingredientCount: ingredientCount,
                matchedLines: matchedLines,
                costCents: costCents,
                costCurrency: costCurrency,
                likeCount: likeCount,
                saveCount: saveCount,
                cookCount: cookCount,
                authorName: authorName,
                authorUsername: authorUsername,
                authorAvatar: authorAvatar,
                publishedAt: publishedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, RecipeRow>(table),
                  BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow>(
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

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      RecipeRow,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (RecipeRow, BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow>),
      RecipeRow,
      PrefetchHooks Function()
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      required String id,
      required String recipeId,
      required int position,
      Value<String?> section,
      required String rawText,
      Value<double?> quantity,
      Value<String?> unit,
      Value<String?> portionLabel,
      Value<String?> foodId,
      Value<String?> prepNote,
      Value<double?> grams,
      Value<int?> costCents,
      Value<bool> optional,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<int> position,
      Value<String?> section,
      Value<String> rawText,
      Value<double?> quantity,
      Value<String?> unit,
      Value<String?> portionLabel,
      Value<String?> foodId,
      Value<String?> prepNote,
      Value<double?> grams,
      Value<int?> costCents,
      Value<bool> optional,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
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

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionLabel => $composableBuilder(
    column: $table.portionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prepNote => $composableBuilder(
    column: $table.prepNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCents => $composableBuilder(
    column: $table.costCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
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

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionLabel => $composableBuilder(
    column: $table.portionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prepNote => $composableBuilder(
    column: $table.prepNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCents => $composableBuilder(
    column: $table.costCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get portionLabel => $composableBuilder(
    column: $table.portionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get prepNote =>
      $composableBuilder(column: $table.prepNote, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<int> get costCents =>
      $composableBuilder(column: $table.costCents, builder: (column) => column);

  GeneratedColumn<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          IngredientRow,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (
            IngredientRow,
            BaseReferences<
              _$AppDatabase,
              $RecipeIngredientsTable,
              IngredientRow
            >,
          ),
          IngredientRow,
          PrefetchHooks Function()
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> section = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> portionLabel = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> prepNote = const Value.absent(),
                Value<double?> grams = const Value.absent(),
                Value<int?> costCents = const Value.absent(),
                Value<bool> optional = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                section: section,
                rawText: rawText,
                quantity: quantity,
                unit: unit,
                portionLabel: portionLabel,
                foodId: foodId,
                prepNote: prepNote,
                grams: grams,
                costCents: costCents,
                optional: optional,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required int position,
                Value<String?> section = const Value.absent(),
                required String rawText,
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> portionLabel = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> prepNote = const Value.absent(),
                Value<double?> grams = const Value.absent(),
                Value<int?> costCents = const Value.absent(),
                Value<bool> optional = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                section: section,
                rawText: rawText,
                quantity: quantity,
                unit: unit,
                portionLabel: portionLabel,
                foodId: foodId,
                prepNote: prepNote,
                grams: grams,
                costCents: costCents,
                optional: optional,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeIngredientsTable, IngredientRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipeIngredientsTable,
                    IngredientRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      IngredientRow,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (
        IngredientRow,
        BaseReferences<_$AppDatabase, $RecipeIngredientsTable, IngredientRow>,
      ),
      IngredientRow,
      PrefetchHooks Function()
    >;
typedef $$RecipeStepsTableCreateCompanionBuilder =
    RecipeStepsCompanion Function({
      required String id,
      required String recipeId,
      required int position,
      required String body,
      Value<int?> timerSeconds,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecipeStepsTableUpdateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<int> position,
      Value<String> body,
      Value<int?> timerSeconds,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
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

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
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

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecipeStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeStepsTable,
          StepRow,
          $$RecipeStepsTableFilterComposer,
          $$RecipeStepsTableOrderingComposer,
          $$RecipeStepsTableAnnotationComposer,
          $$RecipeStepsTableCreateCompanionBuilder,
          $$RecipeStepsTableUpdateCompanionBuilder,
          (StepRow, BaseReferences<_$AppDatabase, $RecipeStepsTable, StepRow>),
          StepRow,
          PrefetchHooks Function()
        > {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int?> timerSeconds = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeStepsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                body: body,
                timerSeconds: timerSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required int position,
                required String body,
                Value<int?> timerSeconds = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipeStepsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                body: body,
                timerSeconds: timerSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeStepsTable, StepRow>(table),
                  BaseReferences<_$AppDatabase, $RecipeStepsTable, StepRow>(
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

typedef $$RecipeStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeStepsTable,
      StepRow,
      $$RecipeStepsTableFilterComposer,
      $$RecipeStepsTableOrderingComposer,
      $$RecipeStepsTableAnnotationComposer,
      $$RecipeStepsTableCreateCompanionBuilder,
      $$RecipeStepsTableUpdateCompanionBuilder,
      (StepRow, BaseReferences<_$AppDatabase, $RecipeStepsTable, StepRow>),
      StepRow,
      PrefetchHooks Function()
    >;
typedef $$StepIngredientsTableCreateCompanionBuilder =
    StepIngredientsCompanion Function({
      required String stepId,
      required String ingredientId,
      required String recipeId,
      Value<int> rowid,
    });
typedef $$StepIngredientsTableUpdateCompanionBuilder =
    StepIngredientsCompanion Function({
      Value<String> stepId,
      Value<String> ingredientId,
      Value<String> recipeId,
      Value<int> rowid,
    });

class $$StepIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $StepIngredientsTable> {
  $$StepIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stepId => $composableBuilder(
    column: $table.stepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StepIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $StepIngredientsTable> {
  $$StepIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stepId => $composableBuilder(
    column: $table.stepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StepIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StepIngredientsTable> {
  $$StepIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stepId =>
      $composableBuilder(column: $table.stepId, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);
}

class $$StepIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepIngredientsTable,
          StepIngredientRow,
          $$StepIngredientsTableFilterComposer,
          $$StepIngredientsTableOrderingComposer,
          $$StepIngredientsTableAnnotationComposer,
          $$StepIngredientsTableCreateCompanionBuilder,
          $$StepIngredientsTableUpdateCompanionBuilder,
          (
            StepIngredientRow,
            BaseReferences<
              _$AppDatabase,
              $StepIngredientsTable,
              StepIngredientRow
            >,
          ),
          StepIngredientRow,
          PrefetchHooks Function()
        > {
  $$StepIngredientsTableTableManager(
    _$AppDatabase db,
    $StepIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepIngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> stepId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StepIngredientsCompanion(
                stepId: stepId,
                ingredientId: ingredientId,
                recipeId: recipeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stepId,
                required String ingredientId,
                required String recipeId,
                Value<int> rowid = const Value.absent(),
              }) => StepIngredientsCompanion.insert(
                stepId: stepId,
                ingredientId: ingredientId,
                recipeId: recipeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StepIngredientsTable, StepIngredientRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StepIngredientsTable,
                    StepIngredientRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepIngredientsTable,
      StepIngredientRow,
      $$StepIngredientsTableFilterComposer,
      $$StepIngredientsTableOrderingComposer,
      $$StepIngredientsTableAnnotationComposer,
      $$StepIngredientsTableCreateCompanionBuilder,
      $$StepIngredientsTableUpdateCompanionBuilder,
      (
        StepIngredientRow,
        BaseReferences<_$AppDatabase, $StepIngredientsTable, StepIngredientRow>,
      ),
      StepIngredientRow,
      PrefetchHooks Function()
    >;
typedef $$RecipeTagsTableCreateCompanionBuilder = RecipeTagsCompanion Function({
  required String recipeId,
  required int tagId,
  Value<int> rowid,
});
typedef $$RecipeTagsTableUpdateCompanionBuilder = RecipeTagsCompanion Function({
  Value<String> recipeId,
  Value<int> tagId,
  Value<int> rowid,
});

class $$RecipeTagsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeTagsTable> {
  $$RecipeTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeTagsTable> {
  $$RecipeTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeTagsTable> {
  $$RecipeTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);
}

class $$RecipeTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeTagsTable,
          RecipeTagRow,
          $$RecipeTagsTableFilterComposer,
          $$RecipeTagsTableOrderingComposer,
          $$RecipeTagsTableAnnotationComposer,
          $$RecipeTagsTableCreateCompanionBuilder,
          $$RecipeTagsTableUpdateCompanionBuilder,
          (
            RecipeTagRow,
            BaseReferences<_$AppDatabase, $RecipeTagsTable, RecipeTagRow>,
          ),
          RecipeTagRow,
          PrefetchHooks Function()
        > {
  $$RecipeTagsTableTableManager(_$AppDatabase db, $RecipeTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> recipeId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeTagsCompanion(
                recipeId: recipeId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recipeId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => RecipeTagsCompanion.insert(
                recipeId: recipeId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeTagsTable, RecipeTagRow>(table),
                  BaseReferences<_$AppDatabase, $RecipeTagsTable, RecipeTagRow>(
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

typedef $$RecipeTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeTagsTable,
      RecipeTagRow,
      $$RecipeTagsTableFilterComposer,
      $$RecipeTagsTableOrderingComposer,
      $$RecipeTagsTableAnnotationComposer,
      $$RecipeTagsTableCreateCompanionBuilder,
      $$RecipeTagsTableUpdateCompanionBuilder,
      (
        RecipeTagRow,
        BaseReferences<_$AppDatabase, $RecipeTagsTable, RecipeTagRow>,
      ),
      RecipeTagRow,
      PrefetchHooks Function()
    >;
typedef $$LikesTableCreateCompanionBuilder = LikesCompanion Function({
  required String userId,
  required String recipeId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$LikesTableUpdateCompanionBuilder = LikesCompanion Function({
  Value<String> userId,
  Value<String> recipeId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$LikesTableFilterComposer extends Composer<_$AppDatabase, $LikesTable> {
  $$LikesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LikesTableOrderingComposer
    extends Composer<_$AppDatabase, $LikesTable> {
  $$LikesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LikesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LikesTable> {
  $$LikesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LikesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LikesTable,
          LikeRow,
          $$LikesTableFilterComposer,
          $$LikesTableOrderingComposer,
          $$LikesTableAnnotationComposer,
          $$LikesTableCreateCompanionBuilder,
          $$LikesTableUpdateCompanionBuilder,
          (LikeRow, BaseReferences<_$AppDatabase, $LikesTable, LikeRow>),
          LikeRow,
          PrefetchHooks Function()
        > {
  $$LikesTableTableManager(_$AppDatabase db, $LikesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LikesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LikesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LikesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LikesCompanion(
                userId: userId,
                recipeId: recipeId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String recipeId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LikesCompanion.insert(
                userId: userId,
                recipeId: recipeId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LikesTable, LikeRow>(table),
                  BaseReferences<_$AppDatabase, $LikesTable, LikeRow>(
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

typedef $$LikesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LikesTable,
      LikeRow,
      $$LikesTableFilterComposer,
      $$LikesTableOrderingComposer,
      $$LikesTableAnnotationComposer,
      $$LikesTableCreateCompanionBuilder,
      $$LikesTableUpdateCompanionBuilder,
      (LikeRow, BaseReferences<_$AppDatabase, $LikesTable, LikeRow>),
      LikeRow,
      PrefetchHooks Function()
    >;
typedef $$SavesTableCreateCompanionBuilder = SavesCompanion Function({
  required String userId,
  required String recipeId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SavesTableUpdateCompanionBuilder = SavesCompanion Function({
  Value<String> userId,
  Value<String> recipeId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SavesTableFilterComposer extends Composer<_$AppDatabase, $SavesTable> {
  $$SavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavesTable> {
  $$SavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavesTable> {
  $$SavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavesTable,
          SaveRow,
          $$SavesTableFilterComposer,
          $$SavesTableOrderingComposer,
          $$SavesTableAnnotationComposer,
          $$SavesTableCreateCompanionBuilder,
          $$SavesTableUpdateCompanionBuilder,
          (SaveRow, BaseReferences<_$AppDatabase, $SavesTable, SaveRow>),
          SaveRow,
          PrefetchHooks Function()
        > {
  $$SavesTableTableManager(_$AppDatabase db, $SavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavesCompanion(
                userId: userId,
                recipeId: recipeId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String recipeId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SavesCompanion.insert(
                userId: userId,
                recipeId: recipeId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavesTable, SaveRow>(table),
                  BaseReferences<_$AppDatabase, $SavesTable, SaveRow>(
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

typedef $$SavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavesTable,
      SaveRow,
      $$SavesTableFilterComposer,
      $$SavesTableOrderingComposer,
      $$SavesTableAnnotationComposer,
      $$SavesTableCreateCompanionBuilder,
      $$SavesTableUpdateCompanionBuilder,
      (SaveRow, BaseReferences<_$AppDatabase, $SavesTable, SaveRow>),
      SaveRow,
      PrefetchHooks Function()
    >;
typedef $$CooksTableCreateCompanionBuilder = CooksCompanion Function({
  required String id,
  required String userId,
  required String recipeId,
  Value<int?> servings,
  Value<bool> toldCreator,
  required DateTime cookedAt,
  Value<int> rowid,
});
typedef $$CooksTableUpdateCompanionBuilder = CooksCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> recipeId,
  Value<int?> servings,
  Value<bool> toldCreator,
  Value<DateTime> cookedAt,
  Value<int> rowid,
});

class $$CooksTableFilterComposer extends Composer<_$AppDatabase, $CooksTable> {
  $$CooksTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toldCreator => $composableBuilder(
    column: $table.toldCreator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cookedAt => $composableBuilder(
    column: $table.cookedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CooksTableOrderingComposer
    extends Composer<_$AppDatabase, $CooksTable> {
  $$CooksTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toldCreator => $composableBuilder(
    column: $table.toldCreator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cookedAt => $composableBuilder(
    column: $table.cookedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CooksTable> {
  $$CooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<bool> get toldCreator => $composableBuilder(
    column: $table.toldCreator,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cookedAt =>
      $composableBuilder(column: $table.cookedAt, builder: (column) => column);
}

class $$CooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CooksTable,
          CookRow,
          $$CooksTableFilterComposer,
          $$CooksTableOrderingComposer,
          $$CooksTableAnnotationComposer,
          $$CooksTableCreateCompanionBuilder,
          $$CooksTableUpdateCompanionBuilder,
          (CookRow, BaseReferences<_$AppDatabase, $CooksTable, CookRow>),
          CookRow,
          PrefetchHooks Function()
        > {
  $$CooksTableTableManager(_$AppDatabase db, $CooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int?> servings = const Value.absent(),
                Value<bool> toldCreator = const Value.absent(),
                Value<DateTime> cookedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CooksCompanion(
                id: id,
                userId: userId,
                recipeId: recipeId,
                servings: servings,
                toldCreator: toldCreator,
                cookedAt: cookedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String recipeId,
                Value<int?> servings = const Value.absent(),
                Value<bool> toldCreator = const Value.absent(),
                required DateTime cookedAt,
                Value<int> rowid = const Value.absent(),
              }) => CooksCompanion.insert(
                id: id,
                userId: userId,
                recipeId: recipeId,
                servings: servings,
                toldCreator: toldCreator,
                cookedAt: cookedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CooksTable, CookRow>(table),
                  BaseReferences<_$AppDatabase, $CooksTable, CookRow>(
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

typedef $$CooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CooksTable,
      CookRow,
      $$CooksTableFilterComposer,
      $$CooksTableOrderingComposer,
      $$CooksTableAnnotationComposer,
      $$CooksTableCreateCompanionBuilder,
      $$CooksTableUpdateCompanionBuilder,
      (CookRow, BaseReferences<_$AppDatabase, $CooksTable, CookRow>),
      CookRow,
      PrefetchHooks Function()
    >;
typedef $$ShoppingTicksTableCreateCompanionBuilder =
    ShoppingTicksCompanion Function({
      required String userId,
      required String ingredientId,
      required String recipeId,
      required DateTime tickedAt,
      Value<int> rowid,
    });
typedef $$ShoppingTicksTableUpdateCompanionBuilder =
    ShoppingTicksCompanion Function({
      Value<String> userId,
      Value<String> ingredientId,
      Value<String> recipeId,
      Value<DateTime> tickedAt,
      Value<int> rowid,
    });

class $$ShoppingTicksTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingTicksTable> {
  $$ShoppingTicksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tickedAt => $composableBuilder(
    column: $table.tickedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingTicksTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingTicksTable> {
  $$ShoppingTicksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tickedAt => $composableBuilder(
    column: $table.tickedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingTicksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingTicksTable> {
  $$ShoppingTicksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get tickedAt =>
      $composableBuilder(column: $table.tickedAt, builder: (column) => column);
}

class $$ShoppingTicksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingTicksTable,
          ShoppingTickRow,
          $$ShoppingTicksTableFilterComposer,
          $$ShoppingTicksTableOrderingComposer,
          $$ShoppingTicksTableAnnotationComposer,
          $$ShoppingTicksTableCreateCompanionBuilder,
          $$ShoppingTicksTableUpdateCompanionBuilder,
          (
            ShoppingTickRow,
            BaseReferences<_$AppDatabase, $ShoppingTicksTable, ShoppingTickRow>,
          ),
          ShoppingTickRow,
          PrefetchHooks Function()
        > {
  $$ShoppingTicksTableTableManager(_$AppDatabase db, $ShoppingTicksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingTicksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingTicksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingTicksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<DateTime> tickedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingTicksCompanion(
                userId: userId,
                ingredientId: ingredientId,
                recipeId: recipeId,
                tickedAt: tickedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String ingredientId,
                required String recipeId,
                required DateTime tickedAt,
                Value<int> rowid = const Value.absent(),
              }) => ShoppingTicksCompanion.insert(
                userId: userId,
                ingredientId: ingredientId,
                recipeId: recipeId,
                tickedAt: tickedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingTicksTable, ShoppingTickRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ShoppingTicksTable,
                    ShoppingTickRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingTicksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingTicksTable,
      ShoppingTickRow,
      $$ShoppingTicksTableFilterComposer,
      $$ShoppingTicksTableOrderingComposer,
      $$ShoppingTicksTableAnnotationComposer,
      $$ShoppingTicksTableCreateCompanionBuilder,
      $$ShoppingTicksTableUpdateCompanionBuilder,
      (
        ShoppingTickRow,
        BaseReferences<_$AppDatabase, $ShoppingTicksTable, ShoppingTickRow>,
      ),
      ShoppingTickRow,
      PrefetchHooks Function()
    >;
typedef $$RecentlyViewedTableCreateCompanionBuilder =
    RecentlyViewedCompanion Function({
      required String userId,
      required String recipeId,
      required DateTime viewedAt,
      Value<int> rowid,
    });
typedef $$RecentlyViewedTableUpdateCompanionBuilder =
    RecentlyViewedCompanion Function({
      Value<String> userId,
      Value<String> recipeId,
      Value<DateTime> viewedAt,
      Value<int> rowid,
    });

class $$RecentlyViewedTableFilterComposer
    extends Composer<_$AppDatabase, $RecentlyViewedTable> {
  $$RecentlyViewedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentlyViewedTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentlyViewedTable> {
  $$RecentlyViewedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get viewedAt => $composableBuilder(
    column: $table.viewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentlyViewedTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentlyViewedTable> {
  $$RecentlyViewedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);
}

class $$RecentlyViewedTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentlyViewedTable,
          RecentlyViewedRow,
          $$RecentlyViewedTableFilterComposer,
          $$RecentlyViewedTableOrderingComposer,
          $$RecentlyViewedTableAnnotationComposer,
          $$RecentlyViewedTableCreateCompanionBuilder,
          $$RecentlyViewedTableUpdateCompanionBuilder,
          (
            RecentlyViewedRow,
            BaseReferences<
              _$AppDatabase,
              $RecentlyViewedTable,
              RecentlyViewedRow
            >,
          ),
          RecentlyViewedRow,
          PrefetchHooks Function()
        > {
  $$RecentlyViewedTableTableManager(
    _$AppDatabase db,
    $RecentlyViewedTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentlyViewedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentlyViewedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentlyViewedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<DateTime> viewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentlyViewedCompanion(
                userId: userId,
                recipeId: recipeId,
                viewedAt: viewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String recipeId,
                required DateTime viewedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecentlyViewedCompanion.insert(
                userId: userId,
                recipeId: recipeId,
                viewedAt: viewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecentlyViewedTable, RecentlyViewedRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecentlyViewedTable,
                    RecentlyViewedRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentlyViewedTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentlyViewedTable,
      RecentlyViewedRow,
      $$RecentlyViewedTableFilterComposer,
      $$RecentlyViewedTableOrderingComposer,
      $$RecentlyViewedTableAnnotationComposer,
      $$RecentlyViewedTableCreateCompanionBuilder,
      $$RecentlyViewedTableUpdateCompanionBuilder,
      (
        RecentlyViewedRow,
        BaseReferences<_$AppDatabase, $RecentlyViewedTable, RecentlyViewedRow>,
      ),
      RecentlyViewedRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  required OutboxKind kind,
  required String target,
  required String payload,
  Value<String?> onConflict,
  Value<String?> dedupeKey,
  Value<int> attempts,
  Value<String?> lastError,
  Value<bool> failed,
  required DateTime createdAt,
  Value<DateTime?> nextAttemptAt,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  Value<OutboxKind> kind,
  Value<String> target,
  Value<String> payload,
  Value<String?> onConflict,
  Value<String?> dedupeKey,
  Value<int> attempts,
  Value<String?> lastError,
  Value<bool> failed,
  Value<DateTime> createdAt,
  Value<DateTime?> nextAttemptAt,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
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

  ColumnWithTypeConverterFilters<OutboxKind, OutboxKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onConflict => $composableBuilder(
    column: $table.onConflict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get failed => $composableBuilder(
    column: $table.failed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onConflict => $composableBuilder(
    column: $table.onConflict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get failed => $composableBuilder(
    column: $table.failed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OutboxKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get onConflict => $composableBuilder(
    column: $table.onConflict,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dedupeKey =>
      $composableBuilder(column: $table.dedupeKey, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<bool> get failed =>
      $composableBuilder(column: $table.failed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxEntry,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<OutboxKind> kind = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> onConflict = const Value.absent(),
                Value<String?> dedupeKey = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<bool> failed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                kind: kind,
                target: target,
                payload: payload,
                onConflict: onConflict,
                dedupeKey: dedupeKey,
                attempts: attempts,
                lastError: lastError,
                failed: failed,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required OutboxKind kind,
                required String target,
                required String payload,
                Value<String?> onConflict = const Value.absent(),
                Value<String?> dedupeKey = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<bool> failed = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> nextAttemptAt = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                kind: kind,
                target: target,
                payload: payload,
                onConflict: onConflict,
                dedupeKey: dedupeKey,
                attempts: attempts,
                lastError: lastError,
                failed: failed,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxEntry>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxEntry>(
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

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxEntry,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxEntry, BaseReferences<_$AppDatabase, $OutboxTable, OutboxEntry>),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String scope,
      required DateTime cursor,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> scope,
      Value<DateTime> cursor,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<DateTime> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursorRow,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursorRow,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursorRow>,
          ),
          SyncCursorRow,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> scope = const Value.absent(),
                Value<DateTime> cursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                scope: scope,
                cursor: cursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String scope,
                required DateTime cursor,
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                scope: scope,
                cursor: cursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncCursorsTable, SyncCursorRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncCursorsTable,
                    SyncCursorRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursorRow,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursorRow,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursorRow>,
      ),
      SyncCursorRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$MeasureUnitsTableTableManager get measureUnits =>
      $$MeasureUnitsTableTableManager(_db, _db.measureUnits);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$FoodPortionsTableTableManager get foodPortions =>
      $$FoodPortionsTableTableManager(_db, _db.foodPortions);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$ProfileTastesTableTableManager get profileTastes =>
      $$ProfileTastesTableTableManager(_db, _db.profileTastes);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$StepIngredientsTableTableManager get stepIngredients =>
      $$StepIngredientsTableTableManager(_db, _db.stepIngredients);
  $$RecipeTagsTableTableManager get recipeTags =>
      $$RecipeTagsTableTableManager(_db, _db.recipeTags);
  $$LikesTableTableManager get likes =>
      $$LikesTableTableManager(_db, _db.likes);
  $$SavesTableTableManager get saves =>
      $$SavesTableTableManager(_db, _db.saves);
  $$CooksTableTableManager get cooks =>
      $$CooksTableTableManager(_db, _db.cooks);
  $$ShoppingTicksTableTableManager get shoppingTicks =>
      $$ShoppingTicksTableTableManager(_db, _db.shoppingTicks);
  $$RecentlyViewedTableTableManager get recentlyViewed =>
      $$RecentlyViewedTableTableManager(_db, _db.recentlyViewed);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
}
