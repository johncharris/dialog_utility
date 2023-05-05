import 'package:json_annotation/json_annotation.dart';

part 'character_picture.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterPicture {
  String id;
  String imageUrl;
  String description;

  CharacterPicture({required this.id, required this.imageUrl, required this.description});

  factory CharacterPicture.fromJson(Map<String, dynamic> json) => _$CharacterPictureFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterPictureToJson(this);
}
