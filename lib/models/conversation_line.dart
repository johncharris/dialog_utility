import 'package:dialog_utility/models/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_line.g.dart';

@JsonSerializable(explicitToJson: true)
class ConversationLine {
  String text;

  int sortOrder = 0;

  bool isRichText = false;

  String? leftCharacterId;
  String? leftCharacterName;
  String? leftCharacterPicId;
  String? rightCharacterId;
  String? rightCharacterName;
  String? rightCharacterPicId;
  CharacterPosition speakerPosition;

  ConversationLine(this.text, {this.speakerPosition = CharacterPosition.none});

  factory ConversationLine.fromJson(Map<String, dynamic> json) => _$ConversationLineFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationLineToJson(this);
}
