// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationLine _$ConversationLineFromJson(Map<String, dynamic> json) =>
    ConversationLine(
      json['text'] as String,
      speakerPosition: $enumDecodeNullable(
              _$CharacterPositionEnumMap, json['speakerPosition']) ??
          CharacterPosition.none,
    )
      ..sortOrder = json['sortOrder'] as int
      ..isRichText = json['isRichText'] as bool
      ..leftCharacterId = json['leftCharacterId'] as String?
      ..leftCharacterName = json['leftCharacterName'] as String?
      ..leftCharacterPicId = json['leftCharacterPicId'] as String?
      ..rightCharacterId = json['rightCharacterId'] as String?
      ..rightCharacterName = json['rightCharacterName'] as String?
      ..rightCharacterPicId = json['rightCharacterPicId'] as String?;

Map<String, dynamic> _$ConversationLineToJson(ConversationLine instance) =>
    <String, dynamic>{
      'text': instance.text,
      'sortOrder': instance.sortOrder,
      'isRichText': instance.isRichText,
      'leftCharacterId': instance.leftCharacterId,
      'leftCharacterName': instance.leftCharacterName,
      'leftCharacterPicId': instance.leftCharacterPicId,
      'rightCharacterId': instance.rightCharacterId,
      'rightCharacterName': instance.rightCharacterName,
      'rightCharacterPicId': instance.rightCharacterPicId,
      'speakerPosition': _$CharacterPositionEnumMap[instance.speakerPosition]!,
    };

const _$CharacterPositionEnumMap = {
  CharacterPosition.left: 'left',
  CharacterPosition.right: 'right',
  CharacterPosition.none: 'none',
};
