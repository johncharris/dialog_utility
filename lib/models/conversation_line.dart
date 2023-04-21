import 'package:dialog_utility/models/character_pic.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:isar/isar.dart';

import 'character.dart';

part 'conversation_line.g.dart';

@Collection()
class ConversationLine {
  Id? id;
  String text;

  @Index()
  int sortOrder = 0;

  bool isRichText = false;

  final character = IsarLink<Character>();

  String? characterName;

  final characterPic = IsarLink<CharacterPic>();

  final conversation = IsarLink<Conversation>();

  ConversationLine(this.text, {this.characterName});
}
