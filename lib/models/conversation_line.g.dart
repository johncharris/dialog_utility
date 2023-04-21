// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_line.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConversationLineCollection on Isar {
  IsarCollection<ConversationLine> get conversationLines => this.collection();
}

const ConversationLineSchema = CollectionSchema(
  name: r'ConversationLine',
  id: -7378804225375363544,
  properties: {
    r'characterName': PropertySchema(
      id: 0,
      name: r'characterName',
      type: IsarType.string,
    ),
    r'isRichText': PropertySchema(
      id: 1,
      name: r'isRichText',
      type: IsarType.bool,
    ),
    r'sortOrder': PropertySchema(
      id: 2,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 3,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _conversationLineEstimateSize,
  serialize: _conversationLineSerialize,
  deserialize: _conversationLineDeserialize,
  deserializeProp: _conversationLineDeserializeProp,
  idName: r'id',
  indexes: {
    r'sortOrder': IndexSchema(
      id: -1119549396205841918,
      name: r'sortOrder',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sortOrder',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'character': LinkSchema(
      id: -5246554263675245235,
      name: r'character',
      target: r'Character',
      single: true,
    ),
    r'characterPic': LinkSchema(
      id: 1861342109896053040,
      name: r'characterPic',
      target: r'CharacterPic',
      single: true,
    ),
    r'conversation': LinkSchema(
      id: 6797113032749801419,
      name: r'conversation',
      target: r'Conversation',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _conversationLineGetId,
  getLinks: _conversationLineGetLinks,
  attach: _conversationLineAttach,
  version: '3.1.0',
);

int _conversationLineEstimateSize(
  ConversationLine object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.characterName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _conversationLineSerialize(
  ConversationLine object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.characterName);
  writer.writeBool(offsets[1], object.isRichText);
  writer.writeLong(offsets[2], object.sortOrder);
  writer.writeString(offsets[3], object.text);
}

ConversationLine _conversationLineDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ConversationLine(
    reader.readString(offsets[3]),
    characterName: reader.readStringOrNull(offsets[0]),
  );
  object.id = id;
  object.isRichText = reader.readBool(offsets[1]);
  object.sortOrder = reader.readLong(offsets[2]);
  return object;
}

P _conversationLineDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _conversationLineGetId(ConversationLine object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _conversationLineGetLinks(ConversationLine object) {
  return [object.character, object.characterPic, object.conversation];
}

void _conversationLineAttach(
    IsarCollection<dynamic> col, Id id, ConversationLine object) {
  object.id = id;
  object.character
      .attach(col, col.isar.collection<Character>(), r'character', id);
  object.characterPic
      .attach(col, col.isar.collection<CharacterPic>(), r'characterPic', id);
  object.conversation
      .attach(col, col.isar.collection<Conversation>(), r'conversation', id);
}

extension ConversationLineQueryWhereSort
    on QueryBuilder<ConversationLine, ConversationLine, QWhere> {
  QueryBuilder<ConversationLine, ConversationLine, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhere> anySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sortOrder'),
      );
    });
  }
}

extension ConversationLineQueryWhere
    on QueryBuilder<ConversationLine, ConversationLine, QWhereClause> {
  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
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

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause> idBetween(
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

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      sortOrderEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sortOrder',
        value: [sortOrder],
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      sortOrderNotEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [],
              upper: [sortOrder],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [sortOrder],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [sortOrder],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [],
              upper: [sortOrder],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      sortOrderGreaterThan(
    int sortOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sortOrder',
        lower: [sortOrder],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      sortOrderLessThan(
    int sortOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sortOrder',
        lower: [],
        upper: [sortOrder],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterWhereClause>
      sortOrderBetween(
    int lowerSortOrder,
    int upperSortOrder, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sortOrder',
        lower: [lowerSortOrder],
        includeLower: includeLower,
        upper: [upperSortOrder],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ConversationLineQueryFilter
    on QueryBuilder<ConversationLine, ConversationLine, QFilterCondition> {
  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'characterName',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'characterName',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'characterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'characterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'characterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'characterName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'characterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'characterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'characterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'characterName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'characterName',
        value: '',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'characterName',
        value: '',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      idLessThan(
    Id? value, {
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

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      isRichTextEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRichText',
        value: value,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      sortOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      sortOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sortOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension ConversationLineQueryObject
    on QueryBuilder<ConversationLine, ConversationLine, QFilterCondition> {}

extension ConversationLineQueryLinks
    on QueryBuilder<ConversationLine, ConversationLine, QFilterCondition> {
  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      character(FilterQuery<Character> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'character');
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'character', 0, true, 0, true);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterPic(FilterQuery<CharacterPic> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'characterPic');
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      characterPicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'characterPic', 0, true, 0, true);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      conversation(FilterQuery<Conversation> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'conversation');
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterFilterCondition>
      conversationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'conversation', 0, true, 0, true);
    });
  }
}

extension ConversationLineQuerySortBy
    on QueryBuilder<ConversationLine, ConversationLine, QSortBy> {
  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortByCharacterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'characterName', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortByCharacterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'characterName', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortByIsRichText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRichText', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortByIsRichTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRichText', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension ConversationLineQuerySortThenBy
    on QueryBuilder<ConversationLine, ConversationLine, QSortThenBy> {
  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenByCharacterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'characterName', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenByCharacterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'characterName', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenByIsRichText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRichText', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenByIsRichTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRichText', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QAfterSortBy>
      thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension ConversationLineQueryWhereDistinct
    on QueryBuilder<ConversationLine, ConversationLine, QDistinct> {
  QueryBuilder<ConversationLine, ConversationLine, QDistinct>
      distinctByCharacterName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'characterName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QDistinct>
      distinctByIsRichText() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRichText');
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QDistinct>
      distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<ConversationLine, ConversationLine, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension ConversationLineQueryProperty
    on QueryBuilder<ConversationLine, ConversationLine, QQueryProperty> {
  QueryBuilder<ConversationLine, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ConversationLine, String?, QQueryOperations>
      characterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'characterName');
    });
  }

  QueryBuilder<ConversationLine, bool, QQueryOperations> isRichTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRichText');
    });
  }

  QueryBuilder<ConversationLine, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<ConversationLine, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
