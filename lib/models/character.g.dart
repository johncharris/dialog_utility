// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['id'] as String?,
      name: json['name'] as String,
      handle: json['handle'] as String,
      pictures: (json['pictures'] as List<dynamic>)
          .map((e) => CharacterPicture.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..defaultPictureId = json['defaultPictureId'] as String?;

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'handle': instance.handle,
      'pictures': instance.pictures.map((e) => e.toJson()).toList(),
      'defaultPictureId': instance.defaultPictureId,
    };
