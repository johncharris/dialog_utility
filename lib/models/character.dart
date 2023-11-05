import 'package:json_annotation/json_annotation.dart';

import 'character_picture.dart';

part 'character.g.dart';

@JsonSerializable(explicitToJson: true)
class Character {
  String? id;

  String name;

  String handle;

  List<CharacterPicture> pictures;

  String? defaultPictureId;

  int? color;

  Character({this.id, required this.name, required this.handle, required this.pictures});

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
