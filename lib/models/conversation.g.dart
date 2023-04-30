// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      name: json['name'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => ConversationLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..id = json['id'] as String?;

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lines': instance.lines.map((e) => e.toJson()).toList(),
    };
