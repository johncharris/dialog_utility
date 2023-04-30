import 'package:json_annotation/json_annotation.dart';

part 'conversation_line.g.dart';

@JsonSerializable(explicitToJson: true)
class ConversationLine {
  String text;

  int sortOrder = 0;

  bool isRichText = false;

  String? characterId;
  String? characterName;

  String? characterPicId;

  ConversationLine(this.text, {this.characterId, this.characterName});

  factory ConversationLine.fromJson(Map<String, dynamic> json) => _$ConversationLineFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationLineToJson(this);
}
