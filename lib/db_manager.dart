import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_pic.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbManager {
  static DbManager instance = DbManager();

  late Box<Character> characters;
  late Box<CharacterPic> characterPics;
  late Box<Conversation> conversations;
  late Box<ConversationLine> conversationLines;

  init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(CharacterAdapter());
      Hive.registerAdapter(CharacterPicAdapter());
      Hive.registerAdapter(ConversationAdapter());
      Hive.registerAdapter(ConversationLineAdapter());

      conversationLines = await Hive.openBox<ConversationLine>("conversationLines");
      characterPics = await Hive.openBox<CharacterPic>("characterPics");
      characters = await Hive.openBox<Character>("characters");
      conversations = await Hive.openBox<Conversation>("conversations");
      print(conversations);
    } catch (ex) {
      print(ex);
    }
  }
}
