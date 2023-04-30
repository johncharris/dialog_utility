// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterPicture _$CharacterPictureFromJson(Map<String, dynamic> json) =>
    CharacterPicture(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CharacterPictureToJson(CharacterPicture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
    };
