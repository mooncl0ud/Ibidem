// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_settings_schema.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingSettingsCollection on Isar {
  IsarCollection<ReadingSettings> get readingSettings => this.collection();
}

const ReadingSettingsSchema = CollectionSchema(
  name: r'ReadingSettings',
  id: 8803043927951883048,
  properties: {
    r'autoIndent': PropertySchema(
      id: 0,
      name: r'autoIndent',
      type: IsarType.bool,
    ),
    r'brightness': PropertySchema(
      id: 1,
      name: r'brightness',
      type: IsarType.double,
    ),
    r'customBgColor': PropertySchema(
      id: 2,
      name: r'customBgColor',
      type: IsarType.string,
    ),
    r'customTextColor': PropertySchema(
      id: 3,
      name: r'customTextColor',
      type: IsarType.string,
    ),
    r'fontFamily': PropertySchema(
      id: 4,
      name: r'fontFamily',
      type: IsarType.string,
    ),
    r'fontSize': PropertySchema(
      id: 5,
      name: r'fontSize',
      type: IsarType.double,
    ),
    r'hideStatusBar': PropertySchema(
      id: 6,
      name: r'hideStatusBar',
      type: IsarType.bool,
    ),
    r'letterSpacing': PropertySchema(
      id: 7,
      name: r'letterSpacing',
      type: IsarType.double,
    ),
    r'lineHeight': PropertySchema(
      id: 8,
      name: r'lineHeight',
      type: IsarType.double,
    ),
    r'orientationLock': PropertySchema(
      id: 9,
      name: r'orientationLock',
      type: IsarType.string,
    ),
    r'pageTransition': PropertySchema(
      id: 10,
      name: r'pageTransition',
      type: IsarType.string,
    ),
    r'paragraphSpacing': PropertySchema(
      id: 11,
      name: r'paragraphSpacing',
      type: IsarType.bool,
    ),
    r'showClock': PropertySchema(
      id: 12,
      name: r'showClock',
      type: IsarType.bool,
    ),
    r'showPageNumber': PropertySchema(
      id: 13,
      name: r'showPageNumber',
      type: IsarType.bool,
    ),
    r'showProgressBar': PropertySchema(
      id: 14,
      name: r'showProgressBar',
      type: IsarType.bool,
    ),
    r'tapZoneMode': PropertySchema(
      id: 15,
      name: r'tapZoneMode',
      type: IsarType.string,
    ),
    r'textAlign': PropertySchema(
      id: 16,
      name: r'textAlign',
      type: IsarType.string,
    ),
    r'theme': PropertySchema(
      id: 17,
      name: r'theme',
      type: IsarType.string,
    ),
    r'touchZoneSize': PropertySchema(
      id: 18,
      name: r'touchZoneSize',
      type: IsarType.double,
    ),
    r'twoPageView': PropertySchema(
      id: 19,
      name: r'twoPageView',
      type: IsarType.bool,
    ),
    r'volumeKeyNavEnabled': PropertySchema(
      id: 20,
      name: r'volumeKeyNavEnabled',
      type: IsarType.bool,
    ),
    r'wordScale': PropertySchema(
      id: 21,
      name: r'wordScale',
      type: IsarType.double,
    )
  },
  estimateSize: _readingSettingsEstimateSize,
  serialize: _readingSettingsSerialize,
  deserialize: _readingSettingsDeserialize,
  deserializeProp: _readingSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _readingSettingsGetId,
  getLinks: _readingSettingsGetLinks,
  attach: _readingSettingsAttach,
  version: '3.1.0+1',
);

int _readingSettingsEstimateSize(
  ReadingSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customBgColor.length * 3;
  bytesCount += 3 + object.customTextColor.length * 3;
  bytesCount += 3 + object.fontFamily.length * 3;
  bytesCount += 3 + object.orientationLock.length * 3;
  bytesCount += 3 + object.pageTransition.length * 3;
  bytesCount += 3 + object.tapZoneMode.length * 3;
  bytesCount += 3 + object.textAlign.length * 3;
  bytesCount += 3 + object.theme.length * 3;
  return bytesCount;
}

void _readingSettingsSerialize(
  ReadingSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoIndent);
  writer.writeDouble(offsets[1], object.brightness);
  writer.writeString(offsets[2], object.customBgColor);
  writer.writeString(offsets[3], object.customTextColor);
  writer.writeString(offsets[4], object.fontFamily);
  writer.writeDouble(offsets[5], object.fontSize);
  writer.writeBool(offsets[6], object.hideStatusBar);
  writer.writeDouble(offsets[7], object.letterSpacing);
  writer.writeDouble(offsets[8], object.lineHeight);
  writer.writeString(offsets[9], object.orientationLock);
  writer.writeString(offsets[10], object.pageTransition);
  writer.writeBool(offsets[11], object.paragraphSpacing);
  writer.writeBool(offsets[12], object.showClock);
  writer.writeBool(offsets[13], object.showPageNumber);
  writer.writeBool(offsets[14], object.showProgressBar);
  writer.writeString(offsets[15], object.tapZoneMode);
  writer.writeString(offsets[16], object.textAlign);
  writer.writeString(offsets[17], object.theme);
  writer.writeDouble(offsets[18], object.touchZoneSize);
  writer.writeBool(offsets[19], object.twoPageView);
  writer.writeBool(offsets[20], object.volumeKeyNavEnabled);
  writer.writeDouble(offsets[21], object.wordScale);
}

ReadingSettings _readingSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingSettings();
  object.autoIndent = reader.readBool(offsets[0]);
  object.brightness = reader.readDouble(offsets[1]);
  object.customBgColor = reader.readString(offsets[2]);
  object.customTextColor = reader.readString(offsets[3]);
  object.fontFamily = reader.readString(offsets[4]);
  object.fontSize = reader.readDouble(offsets[5]);
  object.hideStatusBar = reader.readBool(offsets[6]);
  object.id = id;
  object.letterSpacing = reader.readDouble(offsets[7]);
  object.lineHeight = reader.readDouble(offsets[8]);
  object.orientationLock = reader.readString(offsets[9]);
  object.pageTransition = reader.readString(offsets[10]);
  object.paragraphSpacing = reader.readBool(offsets[11]);
  object.showClock = reader.readBool(offsets[12]);
  object.showPageNumber = reader.readBool(offsets[13]);
  object.showProgressBar = reader.readBool(offsets[14]);
  object.tapZoneMode = reader.readString(offsets[15]);
  object.textAlign = reader.readString(offsets[16]);
  object.theme = reader.readString(offsets[17]);
  object.touchZoneSize = reader.readDouble(offsets[18]);
  object.twoPageView = reader.readBool(offsets[19]);
  object.volumeKeyNavEnabled = reader.readBool(offsets[20]);
  object.wordScale = reader.readDouble(offsets[21]);
  return object;
}

P _readingSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readBool(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _readingSettingsGetId(ReadingSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingSettingsGetLinks(ReadingSettings object) {
  return [];
}

void _readingSettingsAttach(
    IsarCollection<dynamic> col, Id id, ReadingSettings object) {
  object.id = id;
}

extension ReadingSettingsQueryWhereSort
    on QueryBuilder<ReadingSettings, ReadingSettings, QWhere> {
  QueryBuilder<ReadingSettings, ReadingSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReadingSettingsQueryWhere
    on QueryBuilder<ReadingSettings, ReadingSettings, QWhereClause> {
  QueryBuilder<ReadingSettings, ReadingSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingSettingsQueryFilter
    on QueryBuilder<ReadingSettings, ReadingSettings, QFilterCondition> {
  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      autoIndentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoIndent',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      brightnessEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brightness',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      brightnessGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'brightness',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      brightnessLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'brightness',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      brightnessBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'brightness',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customBgColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customBgColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customBgColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customBgColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customBgColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customBgColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customBgColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customBgColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customBgColor',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customBgColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customBgColor',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customTextColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customTextColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customTextColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customTextColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customTextColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customTextColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customTextColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customTextColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customTextColor',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      customTextColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customTextColor',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontFamily',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fontFamily',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      fontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      hideStatusBarEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hideStatusBar',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      letterSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letterSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      letterSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letterSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      letterSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letterSpacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      letterSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letterSpacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      lineHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lineHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      lineHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lineHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      lineHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lineHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      lineHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lineHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orientationLock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orientationLock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orientationLock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orientationLock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orientationLock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orientationLock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orientationLock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orientationLock',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orientationLock',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      orientationLockIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orientationLock',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageTransition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageTransition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageTransition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageTransition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pageTransition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pageTransition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pageTransition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pageTransition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageTransition',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      pageTransitionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pageTransition',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      paragraphSpacingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paragraphSpacing',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      showClockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showClock',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      showPageNumberEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showPageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      showProgressBarEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showProgressBar',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tapZoneMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tapZoneMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tapZoneMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tapZoneMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tapZoneMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tapZoneMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tapZoneMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tapZoneMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tapZoneMode',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      tapZoneModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tapZoneMode',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textAlign',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textAlign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textAlign',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textAlign',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      textAlignIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textAlign',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      touchZoneSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'touchZoneSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      touchZoneSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'touchZoneSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      touchZoneSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'touchZoneSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      touchZoneSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'touchZoneSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      twoPageViewEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'twoPageView',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      volumeKeyNavEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volumeKeyNavEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      wordScaleEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordScale',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      wordScaleGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordScale',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      wordScaleLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordScale',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterFilterCondition>
      wordScaleBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordScale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ReadingSettingsQueryObject
    on QueryBuilder<ReadingSettings, ReadingSettings, QFilterCondition> {}

extension ReadingSettingsQueryLinks
    on QueryBuilder<ReadingSettings, ReadingSettings, QFilterCondition> {}

extension ReadingSettingsQuerySortBy
    on QueryBuilder<ReadingSettings, ReadingSettings, QSortBy> {
  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByAutoIndent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoIndent', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByAutoIndentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoIndent', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByBrightness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByBrightnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByCustomBgColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBgColor', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByCustomBgColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBgColor', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByCustomTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTextColor', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByCustomTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTextColor', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByHideStatusBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideStatusBar', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByHideStatusBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideStatusBar', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterSpacing', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterSpacing', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByLineHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByOrientationLock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orientationLock', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByOrientationLockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orientationLock', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByPageTransition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageTransition', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByPageTransitionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageTransition', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByParagraphSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByShowClock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showClock', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByShowClockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showClock', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByShowPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPageNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByShowPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPageNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByShowProgressBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProgressBar', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByShowProgressBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProgressBar', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTapZoneMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZoneMode', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTapZoneModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZoneMode', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textAlign', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTextAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textAlign', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTouchZoneSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'touchZoneSize', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTouchZoneSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'touchZoneSize', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTwoPageView() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'twoPageView', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByTwoPageViewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'twoPageView', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByVolumeKeyNavEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeKeyNavEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByVolumeKeyNavEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeKeyNavEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByWordScale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordScale', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      sortByWordScaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordScale', Sort.desc);
    });
  }
}

extension ReadingSettingsQuerySortThenBy
    on QueryBuilder<ReadingSettings, ReadingSettings, QSortThenBy> {
  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByAutoIndent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoIndent', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByAutoIndentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoIndent', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByBrightness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByBrightnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brightness', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByCustomBgColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBgColor', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByCustomBgColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customBgColor', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByCustomTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTextColor', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByCustomTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTextColor', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontSize', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByHideStatusBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideStatusBar', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByHideStatusBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideStatusBar', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterSpacing', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letterSpacing', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByLineHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineHeight', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByOrientationLock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orientationLock', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByOrientationLockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orientationLock', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByPageTransition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageTransition', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByPageTransitionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageTransition', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByParagraphSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paragraphSpacing', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByShowClock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showClock', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByShowClockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showClock', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByShowPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPageNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByShowPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPageNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByShowProgressBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProgressBar', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByShowProgressBarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showProgressBar', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTapZoneMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZoneMode', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTapZoneModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapZoneMode', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textAlign', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTextAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textAlign', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTouchZoneSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'touchZoneSize', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTouchZoneSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'touchZoneSize', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTwoPageView() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'twoPageView', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByTwoPageViewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'twoPageView', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByVolumeKeyNavEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeKeyNavEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByVolumeKeyNavEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeKeyNavEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByWordScale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordScale', Sort.asc);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QAfterSortBy>
      thenByWordScaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordScale', Sort.desc);
    });
  }
}

extension ReadingSettingsQueryWhereDistinct
    on QueryBuilder<ReadingSettings, ReadingSettings, QDistinct> {
  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByAutoIndent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoIndent');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByBrightness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brightness');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByCustomBgColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customBgColor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByCustomTextColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customTextColor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByFontFamily({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontFamily', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontSize');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByHideStatusBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideStatusBar');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letterSpacing');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByLineHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lineHeight');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByOrientationLock({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orientationLock',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByPageTransition({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageTransition',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByParagraphSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paragraphSpacing');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByShowClock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showClock');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByShowPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showPageNumber');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByShowProgressBar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showProgressBar');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByTapZoneMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tapZoneMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct> distinctByTextAlign(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textAlign', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct> distinctByTheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByTouchZoneSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'touchZoneSize');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByTwoPageView() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'twoPageView');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByVolumeKeyNavEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volumeKeyNavEnabled');
    });
  }

  QueryBuilder<ReadingSettings, ReadingSettings, QDistinct>
      distinctByWordScale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordScale');
    });
  }
}

extension ReadingSettingsQueryProperty
    on QueryBuilder<ReadingSettings, ReadingSettings, QQueryProperty> {
  QueryBuilder<ReadingSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations> autoIndentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoIndent');
    });
  }

  QueryBuilder<ReadingSettings, double, QQueryOperations> brightnessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brightness');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations>
      customBgColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customBgColor');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations>
      customTextColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customTextColor');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations> fontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontFamily');
    });
  }

  QueryBuilder<ReadingSettings, double, QQueryOperations> fontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontSize');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations>
      hideStatusBarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideStatusBar');
    });
  }

  QueryBuilder<ReadingSettings, double, QQueryOperations>
      letterSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letterSpacing');
    });
  }

  QueryBuilder<ReadingSettings, double, QQueryOperations> lineHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lineHeight');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations>
      orientationLockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orientationLock');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations>
      pageTransitionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageTransition');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations>
      paragraphSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paragraphSpacing');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations> showClockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showClock');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations>
      showPageNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showPageNumber');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations>
      showProgressBarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showProgressBar');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations>
      tapZoneModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tapZoneMode');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations> textAlignProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textAlign');
    });
  }

  QueryBuilder<ReadingSettings, String, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }

  QueryBuilder<ReadingSettings, double, QQueryOperations>
      touchZoneSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'touchZoneSize');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations> twoPageViewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'twoPageView');
    });
  }

  QueryBuilder<ReadingSettings, bool, QQueryOperations>
      volumeKeyNavEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volumeKeyNavEnabled');
    });
  }

  QueryBuilder<ReadingSettings, double, QQueryOperations> wordScaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordScale');
    });
  }
}
