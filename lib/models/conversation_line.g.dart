// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationLine _$ConversationLineFromJson(Map<String, dynamic> json) =>
    ConversationLine(
      json['text'] as String,
      characterId: json['characterId'] as String?,
      characterName: json['characterName'] as String?,
    )
      ..sortOrder = json['sortOrder'] as int
      ..isRichText = json['isRichText'] as bool
      ..characterPicId = json['characterPicId'] as String?;

Map<String, dynamic> _$ConversationLineToJson(ConversationLine instance) =>
    <String, dynamic>{
      'text': instance.text,
      'sortOrder': instance.sortOrder,
      'isRichText': instance.isRichText,
      'characterId': instance.characterId,
      'characterName': instance.characterName,
      'characterPicId': instance.characterPicId,
    };
