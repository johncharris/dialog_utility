import 'package:dialog_utility/models/character_pic.dart';
import 'package:hive/hive.dart';

import 'character.dart';

part 'conversation_line.g.dart';

@HiveType(typeId: 3)
class ConversationLine extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isRichText = false;

  @HiveField(2)
  Character? character;

  @HiveField(3)
  String? characterName;

  @HiveField(4)
  CharacterPic? characterPic;

  ConversationLine(this.text, {this.character, this.characterName, this.characterPic});
}
